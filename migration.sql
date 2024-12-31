-- Example 1: Range Partitioning by Date
-- Create a partitioned table for sales data
CREATE TABLE sales (
    sale_id SERIAL,
    sale_date DATE NOT NULL,
    customer_id INTEGER,
    amount DECIMAL(10,2),
    product_id INTEGER
) PARTITION BY RANGE (sale_date);

-- Create partitions for different date ranges
CREATE TABLE sales_2023_q1 PARTITION OF sales
    FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

CREATE TABLE sales_2023_q2 PARTITION OF sales
    FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

CREATE TABLE sales_2023_q3 PARTITION OF sales
    FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');

CREATE TABLE sales_2023_q4 PARTITION OF sales
    FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

-- Insert sample data
INSERT INTO sales (sale_date, customer_id, amount, product_id) VALUES
    ('2023-01-15', 1, 199.99, 101),
    ('2023-02-20', 2, 299.99, 102),
    ('2023-04-10', 3, 399.99, 103),
    ('2023-07-05', 4, 499.99, 104),
    ('2023-10-25', 5, 599.99, 105);

-- Example 2: List Partitioning by Region
-- Create a partitioned table for customer data
CREATE TABLE customers (
    customer_id SERIAL,
    name VARCHAR(100),
    region VARCHAR(50),
    email VARCHAR(255),
    created_at TIMESTAMP
) PARTITION BY LIST (region);

-- Create partitions for different regions
CREATE TABLE customers_north PARTITION OF customers
    FOR VALUES IN ('North', 'Northwest', 'Northeast');

CREATE TABLE customers_south PARTITION OF customers
    FOR VALUES IN ('South', 'Southwest', 'Southeast');

CREATE TABLE customers_central PARTITION OF customers
    FOR VALUES IN ('Central', 'Midwest');

-- Insert sample data
INSERT INTO customers (name, region, email, created_at) VALUES
    ('John Doe', 'North', 'john@example.com', NOW()),
    ('Jane Smith', 'South', 'jane@example.com', NOW()),
    ('Bob Johnson', 'Central', 'bob@example.com', NOW());

-- Example 3: Hash Partitioning by ID
-- Create a partitioned table for orders
CREATE TABLE orders (
    order_id SERIAL,
    customer_id INTEGER,
    order_date TIMESTAMP,
    status VARCHAR(50),
    total_amount DECIMAL(10,2)
) PARTITION BY HASH (order_id);

-- Create 4 hash partitions
CREATE TABLE orders_p0 PARTITION OF orders
    FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE orders_p1 PARTITION OF orders
    FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE orders_p2 PARTITION OF orders
    FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE orders_p3 PARTITION OF orders
    FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Insert sample data
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
    (1, NOW(), 'Completed', 299.99),
    (2, NOW(), 'Processing', 399.99),
    (3, NOW(), 'Shipped', 499.99),
    (4, NOW(), 'Pending', 599.99);

-- Queries to verify partitioning
-- Check which partition contains specific data
EXPLAIN (ANALYZE, VERBOSE)
SELECT * FROM sales WHERE sale_date = '2023-01-15';

-- Count records in each customer region
SELECT region, COUNT(*) 
FROM customers 
GROUP BY region;

-- Check order distribution across hash partitions
SELECT tableoid::regclass, COUNT(*) 
FROM orders 
GROUP BY tableoid;

-- Create indexes on partitioned tables
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_customers_region ON customers(region);
CREATE INDEX idx_orders_id ON orders(order_id);

-- Example of partition pruning in action
EXPLAIN (ANALYZE, VERBOSE)
SELECT * FROM sales 
WHERE sale_date BETWEEN '2023-04-01' AND '2023-06-30';