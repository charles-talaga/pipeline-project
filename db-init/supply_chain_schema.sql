-- Abstract: Postgres schema for source supply chain database


-- Extension for generating UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Products table
CREATE TABLE IF NOT EXISTS products (
    id              SERIAL          PRIMARY KEY, -- Unique identifier for each product, auto-incremented
    name            VARCHAR(100)    NOT NULL,    -- Name of the product
    category        VARCHAR(100)    NOT NULL,    -- Product category name
    price           REAL            NOT NULL     -- Price of the product
);

-- Suppliers table
CREATE TABLE IF NOT EXISTS suppliers (
    id              SERIAL          PRIMARY KEY, -- Unique identifier for each supplier, auto-incremented
    name            VARCHAR(100)    NOT NULL,    -- Name of the supplier
    address         VARCHAR(255)    NOT NULL     -- Address of the supplier
);

-- Supplier Products table: represents the many-to-many relationship between suppliers and products
CREATE TABLE IF NOT EXISTS supplier_products (
    supplier_id     INTEGER         NOT NULL, -- Foreign key to suppliers table
    product_id      INTEGER         NOT NULL, -- Foreign key to products table
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- Warehouses table
CREATE TABLE IF NOT EXISTS warehouses (
    id              SERIAL          PRIMARY KEY,     -- Unique identifier for each warehouse, auto-incremented
    name            VARCHAR(100)    NOT NULL UNIQUE, -- Name of the warehouse
    address         VARCHAR(255)    NOT NULL         -- Address of the warehouse 
);

-- Inventory table: represents the many-to-many relationship between products and warehouses
CREATE TABLE IF NOT EXISTS inventory (
    warehouse_id    INTEGER         NOT NULL, -- Warehouse where product is stored
    product_id      INTEGER         NOT NULL, -- Identifier of the product
    quantity        INTEGER         NOT NULL, -- Quantity of the product in the warehouse
    PRIMARY KEY (product_id, warehouse_id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id)
);

-- Procurement table: stores orders placed by warehouses to suppliers
CREATE TABLE IF NOT EXISTS procurement (
    order_id        UUID            DEFAULT uuid_generate_v4() PRIMARY KEY, -- UUID auto-generated for each order
    warehouse_id    INTEGER         NOT NULL, -- Warehouse placing the order
    supplier_id     INTEGER         NOT NULL, -- Supplier fulfilling the order
    product_id      INTEGER         NOT NULL, -- Product being ordered
    quantity        INTEGER         NOT NULL, -- Quantity of the product being ordered
    status          VARCHAR(10)     DEFAULT 'PENDING' NOT NULL, -- Order status: PENDING, SHIPPED, DELIVERED
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    CHECK (status IN ('PENDING', 'SHIPPED', 'DELIVERED'))
);


-- Function for updating inventory when orders are delivered
CREATE OR REPLACE FUNCTION update_inventory()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'DELIVERED' THEN
        UPDATE inventory
        SET quantity = quantity + NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger that calls update_inventory() after an order is updated
CREATE TRIGGER update_inventory_trigger
AFTER UPDATE ON procurement 
FOR EACH ROW
EXECUTE FUNCTION update_inventory();