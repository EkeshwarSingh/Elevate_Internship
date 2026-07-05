-- =====================================================================
-- SQL DATA ANALYSIS ASSIGNMENT
-- Retail Order Management Database (Customers | Orders | Order Details | Products)
--
-- Author        : Ekeshwar Singh
-- Dialect        : MySQL syntax (verified compatible with PostgreSQL & SQLite;
--                   dialect-specific notes are called out inline where they apply)
-- Tested engine  : SQLite 3.45 (used to generate every "Expected Output" table
--                   in the accompanying report, since results are dialect-agnostic
--                   for the SELECT statements used throughout this file)
--
-- HOW TO RUN
--   MySQL      : mysql -u <user> -p <database> < master_assignment.sql
--   PostgreSQL : psql -U <user> -d <database> -f master_assignment.sql
--   SQLite     : sqlite3 assignment.db < master_assignment.sql
--
-- This file runs top-to-bottom without modification: it drops/recreates the
-- four tables, loads the data, then runs every required query, view and index.
-- =====================================================================



-- =====================================================================
-- STEP 2: SCHEMA CREATION (see schema.sql for the standalone version)
-- =====================================================================

-- =====================================================================
-- STEP 2: DATABASE SCHEMA (DDL)
-- Retail Order Management Database
-- Tables: customers, products, orders, order_details
-- =====================================================================

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ---------------------------------------------------------------------
-- Table: customers
-- Primary Key : customer_id
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT           NOT NULL,
    name        VARCHAR(50)   NOT NULL,
    email       VARCHAR(50)   NOT NULL,
    address     VARCHAR(100)  NOT NULL,
    city        VARCHAR(50)   NOT NULL,
    province    VARCHAR(50)   NOT NULL,
    phone       VARCHAR(15)   NOT NULL,
    PRIMARY KEY (customer_id),
    UNIQUE (email)
);

-- ---------------------------------------------------------------------
-- Table: products
-- Primary Key : product_id
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id   INT           NOT NULL,
    product_name VARCHAR(50)   NOT NULL,
    category     VARCHAR(20)   NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    stock        INT           NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id)
);

-- ---------------------------------------------------------------------
-- Table: orders
-- Primary Key : order_id
-- Foreign Key : customer_id -> customers(customer_id)
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id    INT           NOT NULL,
    customer_id INT           NOT NULL,
    date        DATE          NOT NULL,
    total       DECIMAL(12,2) NOT NULL,
    status      VARCHAR(15)   NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CHECK (status IN ('completed', 'shipped', 'paid', 'cancelled'))
);

-- ---------------------------------------------------------------------
-- Table: order_details
-- Primary Key : detail_id
-- Foreign Keys: order_id   -> orders(order_id)
--               product_id -> products(product_id)
-- ---------------------------------------------------------------------
CREATE TABLE order_details (
    detail_id  INT           NOT NULL,
    order_id   INT           NOT NULL,
    product_id INT           NOT NULL,
    quantity   INT           NOT NULL,
    subtotal   DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (detail_id),
    FOREIGN KEY (order_id)   REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);


-- =====================================================================
-- STEP 3: DATA IMPORT
-- =====================================================================
-- The data below was generated directly from the provided CSV files
-- (customers.csv, products.csv, orders.csv, order_details.csv) so every
-- value below is the real dataset, not sample/placeholder data.
--
-- MySQL alternative (if the CSV files are available on the server / client):
--   LOAD DATA LOCAL INFILE 'customers.csv'
--   INTO TABLE customers
--   FIELDS TERMINATED BY ',' ENCLOSED BY '"'
--   LINES TERMINATED BY '\n'
--   IGNORE 1 ROWS;
--   -- (repeat for products.csv -> products, orders.csv -> orders,
--   --  order_details.csv -> order_details)
-- =====================================================================


-- Source: customers.csv
INSERT INTO customers (customer_id, name, email, address, city, province, phone) VALUES
(1, 'Ahmad Fauzi', 'ahmad.fauzi@email.com', 'St. Merdeka No. 23', 'Central Jakarta', 'Special Capital Region of Jakarta', '081234567890'),
(2, 'Siti Nurhaliza', 'siti.nurhaliza@email.com', 'St. Sudirman No. 15', 'Bandung', 'West Java', '082134567891'),
(3, 'Budi Santoso', 'budi.santoso@email.com', 'St. Diponegoro No. 88', 'Surabaya', 'East Java', '081345678902'),
(4, 'Dewi Lestari', 'dewi.lestari@email.com', 'St. Gatot Subroto No. 45', 'Medan', 'North Sumatra', '085678901234'),
(5, 'Rizky Ramadhan', 'rizky.ramadhan@email.com', 'St. Veteran No. 12', 'Yogyakarta', 'Special Region of Yogyakarta', '081234509876'),
(6, 'Putri Wulandari', 'putri.wulandari@email.com', 'St. Cendana No. 34', 'Semarang', 'Central Java', '082234567890'),
(7, 'Andi Pratama', 'andi.pratama@email.com', 'St. Pahlawan No. 67', 'Makassar', 'South Sulawesi', '081345670987'),
(8, 'Lina Marlina', 'lina.marlina@email.com', 'St. Ahmad Yani No. 21', 'Palembang', 'South Sumatra', '085345678901'),
(9, 'Dimas Aditya', 'dimas.aditya@email.com', 'St. Raya Bogor Km. 28', 'Bogor', 'West Java', '081456789012'),
(10, 'Nadia Putri', 'nadia.putri@email.com', 'St. Kenanga No. 9', 'Denpasar', 'Bali', '082345678901'),
(11, 'Eko Prasetyo', 'eko.prasetyo@email.com', 'St. Hayam Wuruk No. 56', 'West Jakarta', 'Special Capital Region of Jakarta', '081567890123'),
(12, 'Rina Agustina', 'rina.agustina@email.com', 'St. Imam Bonjol No. 77', 'Padang', 'West Sumatra', '082456789012'),
(13, 'Hendra Wijaya', 'hendra.wijaya@email.com', 'St. Asia Afrika No. 33', 'Bandung', 'West Java', '081678901234'),
(14, 'Maya Sari', 'maya.sari@email.com', 'St. Kartini No. 41', 'Malang', 'East Java', '085789012345'),
(15, 'Agus Firmansyah', 'agus.firmansyah@email.com', 'St. Rajawali No. 19', 'Banjarmasin', 'South Kalimantan', '081789012345'),
(16, 'Sari Indah', 'sari.indah@email.com', 'St. Pattimura No. 63', 'Manado', 'North Sulawesi', '082890123456'),
(17, 'Fajar Nugroho', 'fajar.nugroho@email.com', 'St. Teuku Umar No. 27', 'Aceh Besar', 'Aceh', '081890123456'),
(18, 'Dian Permata', 'dian.permata@email.com', 'St. Sultan Agung No. 11', 'Tangerang', 'Banten', '085901234567'),
(19, 'Rudi Hartono', 'rudi.hartono@email.com', 'St. Jend. Sudirman No. 89', 'Pekanbaru', 'Riau', '081901234567'),
(20, 'Lia Kurniawati', 'lia.kurniawati@email.com', 'St. Antasari No. 52', 'Pontianak', 'West Kalimantan', '082012345678'),
(21, 'Yusuf Maulana', 'yusuf.maulana@email.com', 'St. Cut Nyak Dhien No. 38', 'Banda Aceh', 'Aceh', '081012345678'),
(22, 'Anita Sari', 'anita.sari@email.com', 'St. WR Supratman No. 74', 'Cirebon', 'West Java', '082123456789'),
(23, 'Bayu Setiawan', 'bayu.setiawan@email.com', 'St. Pemuda No. 90', 'Balikpapan', 'East Kalimantan', '081123456789'),
(24, 'Fitri Handayani', 'fitri.handayani@email.com', 'St. Gajah Mada No. 14', 'Samarinda', 'East Kalimantan', '085234567890'),
(25, 'Irfan Hakim', 'irfan.hakim@email.com', 'St. K.H. Mas Mansyur No. 25', 'South Jakarta', 'Special Capital Region of Jakarta', '081234567801'),
(26, 'Riska Amalia', 'riska.amalia@email.com', 'St. Thamrin No. 6', 'Central Jakarta', 'Special Capital Region of Jakarta', '082345678912'),
(27, 'Taufik Hidayat', 'taufik.hidayat@email.com', 'St. Mangga Besar No. 31', 'West Jakarta', 'Special Capital Region of Jakarta', '081345678912'),
(28, 'Nurul Huda', 'nurul.huda@email.com', 'St. Pangeran Diponegoro No. 7', 'Bandung', 'West Java', '085456789023'),
(29, 'Wahyu Saputra', 'wahyu.saputra@email.com', 'St. Ir. H. Juanda No. 55', 'Surabaya', 'East Java', '081456789023'),
(30, 'Siska Dewi', 'siska.dewi@email.com', 'St. Basuki Rahmat No. 42', 'Surabaya', 'East Java', '082567890134'),
(31, 'Aditya Pratama', 'aditya.pratama@email.com', 'St. Ahmad Dahlan No. 18', 'Yogyakarta', 'Special Region of Yogyakarta', '081567890134'),
(32, 'Rina Wijayanti', 'rina.wijayanti@email.com', 'St. Monginsidi No. 69', 'Makassar', 'South Sulawesi', '085678901245'),
(33, 'Hadi Sutrisno', 'hadi.sutrisno@email.com', 'St. Pemuda No. 3', 'Semarang', 'Central Java', '081678901245'),
(34, 'Linda Sari', 'linda.sari@email.com', 'St. Sudirman No. 82', 'Palembang', 'South Sumatra', '082789012356'),
(35, 'Rizal Fadillah', 'rizal.fadillah@email.com', 'St. Merdeka No. 4', 'Pekanbaru', 'Riau', '081789012356'),
(36, 'Dewi Puspita', 'dewi.puspita@email.com', 'St. Sultan Iskandar Muda No. 29', 'Banda Aceh', 'Aceh', '085890123467'),
(37, 'Arief Budiman', 'arief.budiman@email.com', 'St. Veteran No. 16', 'Malang', 'East Java', '081890123467'),
(38, 'Siska Anggraini', 'siska.anggraini@email.com', 'St. Cik Di Tiro No. 51', 'Yogyakarta', 'Special Region of Yogyakarta', '082901234578'),
(39, 'Indra Wijaya', 'indra.wijaya@email.com', 'St. Sam Ratulangi No. 73', 'Manado', 'North Sulawesi', '081901234578'),
(40, 'Maya Lestari', 'maya.lestari@email.com', 'St. Imam Bonjol No. 99', 'Padang', 'West Sumatra', '085012345689'),
(41, 'Dani Prasetyo', 'dani.prasetyo@email.com', 'St. Diponegoro No. 62', 'Semarang', 'Central Java', '081012345689'),
(42, 'Rina Fitriani', 'rina.fitriani@email.com', 'St. A. Yani No. 35', 'Banjarmasin', 'South Kalimantan', '082123456790'),
(43, 'Anton Wijaya', 'anton.wijaya@email.com', 'St. Gatot Subroto No. 70', 'Denpasar', 'Bali', '081123456790'),
(44, 'Siti Aminah', 'siti.aminah@email.com', 'St. Pattimura No. 20', 'Ambon', 'Maluku', '085234567801'),
(45, 'Bambang Triyono', 'bambang.triyono@email.com', 'St. Sultan Agung No. 44', 'Tegal', 'Central Java', '081234567812'),
(46, 'Dinda Ayu', 'dinda.ayu@email.com', 'St. Veteran No. 13', 'Solo', 'Central Java', '082345678923'),
(47, 'Ferry Irawan', 'ferry.irawan@email.com', 'St. Diponegoro No. 91', 'Kediri', 'East Java', '081345678923'),
(48, 'Lina Sari', 'lina.sari@email.com', 'St. Sudirman No. 58', 'Jambi', 'Jambi', '085456789034'),
(49, 'Hendri Gunawan', 'hendri.gunawan@email.com', 'St. Ahmad Yani No. 87', 'Bandar Lampung', 'Lampung', '081456789034'),
(50, 'Nina Wijaya', 'nina.wijaya@email.com', 'St. Teuku Umar No. 22', 'Banda Aceh', 'Aceh', '082567890145'),
(51, 'Raka Pratama', 'raka.pratama@email.com', 'St. Pemuda No. 17', 'Pontianak', 'West Kalimantan', '081567890145'),
(52, 'Dewi Kusuma', 'dewi.kusuma@email.com', 'St. Sultan Hasanuddin No. 36', 'Makassar', 'South Sulawesi', '085678901256'),
(53, 'Agus Wijaya', 'agus.wijaya@email.com', 'St. Pattimura No. 50', 'Manado', 'North Sulawesi', '081678901256'),
(54, 'Siska Putri', 'siska.putri@email.com', 'St. Jend. Sudirman No. 75', 'Pekanbaru', 'Riau', '082789012367'),
(55, 'Rudi Setiawan', 'rudi.setiawan@email.com', 'St. Diponegoro No. 93', 'Semarang', 'Central Java', '081789012367'),
(56, 'Lia Permata', 'lia.permata@email.com', 'St. Merdeka No. 10', 'Palu', 'Central Sulawesi', '085890123478'),
(57, 'Toni Prasetyo', 'toni.prasetyo@email.com', 'St. A. Yani No. 61', 'Banjarmasin', 'South Kalimantan', '081890123478'),
(58, 'Maya Sari', 'maya.sari2@email.com', 'St. Gatot Subroto No. 28', 'Medan', 'North Sumatra', '082901234589'),
(59, 'Adi Nugroho', 'adi.nugroho@email.com', 'St. Cendana No. 47', 'Denpasar', 'Bali', '081901234589'),
(60, 'Rina Marlina', 'rina.marlina@email.com', 'St. Hayam Wuruk No. 84', 'West Jakarta', 'Special Capital Region of Jakarta', '085012345690'),
(61, 'Budi Pratama', 'budi.pratama@email.com', 'St. Asia Afrika No. 39', 'Bandung', 'West Java', '081012345690'),
(62, 'Siti Rahayu', 'siti.rahayu@email.com', 'St. Pahlawan No. 80', 'Makassar', 'South Sulawesi', '082123456701'),
(63, 'Dian Sari', 'dian.sari@email.com', 'St. Imam Bonjol No. 66', 'Padang', 'West Sumatra', '081123456701'),
(64, 'Agus Santoso', 'agus.santoso@email.com', 'St. Sudirman No. 95', 'Bandung', 'West Java', '085234567812'),
(65, 'Lina Wijayanti', 'lina.wijayanti@email.com', 'St. Kartini No. 26', 'Malang', 'East Java', '081234567823'),
(66, 'Fajar Wijaya', 'fajar.wijaya@email.com', 'St. Rajawali No. 5', 'Banjarmasin', 'South Kalimantan', '082345678934'),
(67, 'Nadia Sari', 'nadia.sari@email.com', 'St. Pattimura No. 72', 'Manado', 'North Sulawesi', '081345678934'),
(68, 'Eko Wijaya', 'eko.wijaya@email.com', 'St. Teuku Umar No. 30', 'Aceh Besar', 'Aceh', '085456789045'),
(69, 'Riska Sari', 'riska.sari@email.com', 'St. Sultan Agung No. 15', 'Tangerang', 'Banten', '081456789045'),
(70, 'Yusuf Santoso', 'yusuf.santoso@email.com', 'St. WR Supratman No. 60', 'Cirebon', 'West Java', '082567890156'),
(71, 'Anita Wijaya', 'anita.wijaya@email.com', 'St. Pemuda No. 9', 'Balikpapan', 'East Kalimantan', '081567890156'),
(72, 'Bayu Prasetyo', 'bayu.prasetyo@email.com', 'St. Gajah Mada No. 23', 'Samarinda', 'East Kalimantan', '085678901267'),
(73, 'Fitri Sari', 'fitri.sari@email.com', 'St. K.H. Mas Mansyur No. 33', 'South Jakarta', 'Special Capital Region of Jakarta', '081678901267'),
(74, 'Irfan Wijaya', 'irfan.wijaya@email.com', 'St. Thamrin No. 12', 'Central Jakarta', 'Special Capital Region of Jakarta', '082789012378'),
(75, 'Rina Agustina', 'rina.agustina2@email.com', 'St. Monginsidi No. 88', 'Makassar', 'South Sulawesi', '081789012378'),
(76, 'Hadi Prasetyo', 'hadi.prasetyo@email.com', 'St. Pemuda No. 4', 'Semarang', 'Central Java', '085890123489'),
(77, 'Linda Wijaya', 'linda.wijaya@email.com', 'St. Sudirman No. 9', 'Palembang', 'South Sumatra', '081890123489'),
(78, 'Rizal Wijaya', 'rizal.wijaya@email.com', 'St. Merdeka No. 2', 'Pekanbaru', 'Riau', '082901234590'),
(79, 'Dewi Anggraini', 'dewi.anggraini@email.com', 'St. Sultan Iskandar Muda No. 40', 'Banda Aceh', 'Aceh', '081901234590'),
(80, 'Arief Prasetyo', 'arief.prasetyo@email.com', 'St. Veteran No. 7', 'Malang', 'East Java', '085012345601'),
(81, 'Siska Marlina', 'siska.marlina@email.com', 'St. Cik Di Tiro No. 64', 'Yogyakarta', 'Special Region of Yogyakarta', '081012345601'),
(82, 'Indra Prasetyo', 'indra.prasetyo@email.com', 'St. Sam Ratulangi No. 85', 'Manado', 'North Sulawesi', '082123456712'),
(83, 'Maya Putri', 'maya.putri@email.com', 'St. Imam Bonjol No. 101', 'Padang', 'West Sumatra', '081123456712'),
(84, 'Dani Wijaya', 'dani.wijaya@email.com', 'St. Diponegoro No. 76', 'Semarang', 'Central Java', '085234567823'),
(85, 'Rina Dewi', 'rina.dewi@email.com', 'St. A. Yani No. 49', 'Banjarmasin', 'South Kalimantan', '081234567834'),
(86, 'Anton Prasetyo', 'anton.prasetyo@email.com', 'St. Gatot Subroto No. 83', 'Denpasar', 'Bali', '082345678945'),
(87, 'Siti Lestari', 'siti.lestari@email.com', 'St. Pattimura No. 33', 'Ambon', 'Maluku', '081345678945'),
(88, 'Bambang Wijaya', 'bambang.wijaya@email.com', 'St. Sultan Agung No. 57', 'Tegal', 'Central Java', '085456789056'),
(89, 'Dinda Sari', 'dinda.sari@email.com', 'St. Veteran No. 25', 'Solo', 'Central Java', '081456789056'),
(90, 'Ferry Wijaya', 'ferry.wijaya@email.com', 'St. Diponegoro No. 102', 'Kediri', 'East Java', '082567890167'),
(91, 'Lina Putri', 'lina.putri@email.com', 'St. Sudirman No. 71', 'Jambi', 'Jambi', '081567890167'),
(92, 'Hendri Wijaya', 'hendri.wijaya@email.com', 'St. Ahmad Yani No. 96', 'Bandar Lampung', 'Lampung', '085678901278'),
(93, 'Nina Sari', 'nina.sari@email.com', 'St. Teuku Umar No. 34', 'Banda Aceh', 'Aceh', '081678901278'),
(94, 'Raka Wijaya', 'raka.wijaya@email.com', 'St. Pemuda No. 28', 'Pontianak', 'West Kalimantan', '082789012389'),
(95, 'Dewi Sari', 'dewi.sari@email.com', 'St. Sultan Hasanuddin No. 48', 'Makassar', 'South Sulawesi', '081789012389'),
(96, 'Agus Prasetyo', 'agus.prasetyo@email.com', 'St. Pattimura No. 65', 'Manado', 'North Sulawesi', '085890123490'),
(97, 'Siska Wijaya', 'siska.wijaya@email.com', 'St. Jend. Sudirman No. 86', 'Pekanbaru', 'Riau', '081890123490'),
(98, 'Rudi Wijaya', 'rudi.wijaya@email.com', 'St. Diponegoro No. 104', 'Semarang', 'Central Java', '082901234501'),
(99, 'Lia Sari', 'lia.sari@email.com', 'St. Merdeka No. 21', 'Palu', 'Central Sulawesi', '081901234501'),
(100, 'Toni Wijaya', 'toni.wijaya@email.com', 'St. A. Yani No. 73', 'Banjarmasin', 'South Kalimantan', '085012345612'),
(101, 'Maya Wijaya', 'maya.wijaya@email.com', 'St. Gatot Subroto No. 39', 'Medan', 'North Sumatra', '081012345612'),
(102, 'Adi Wijaya', 'adi.wijaya@email.com', 'St. Cendana No. 58', 'Denpasar', 'Bali', '082123456723'),
(103, 'Rina Sari', 'rina.sari@email.com', 'St. Hayam Wuruk No. 95', 'West Jakarta', 'Special Capital Region of Jakarta', '081123456723'),
(104, 'Budi Wijaya', 'budi.wijaya@email.com', 'St. Asia Afrika No. 50', 'Bandung', 'West Java', '085234567834'),
(105, 'Siti Marlina', 'siti.marlina@email.com', 'St. Pahlawan No. 91', 'Makassar', 'South Sulawesi', '081234567845');


-- Source: products.csv
INSERT INTO products (product_id, product_name, category, price, stock) VALUES
(1, 'Indomie Fried Noodles', 'Food', 2500.00, 500),
(2, 'Sari Roti Chocolate Bread', 'Food', 8500.00, 300),
(3, 'Rojolele Rice 5kg', 'Food', 65000.00, 200),
(4, 'Bimoli Cooking Oil 1L', 'Food', 28000.00, 150),
(5, 'Gulaku Granulated Sugar 1kg', 'Food', 15000.00, 400),
(6, 'Sariwangi Tea', 'Beverages', 12000.00, 600),
(7, 'Kapal Api Coffee', 'Beverages', 18000.00, 350),
(8, 'Aqua Bottled Water 600ml', 'Beverages', 3000.00, 1000),
(9, 'Indomilk Milk 200ml', 'Beverages', 4500.00, 700),
(10, 'Lemon Squash', 'Beverages', 5500.00, 250),
(11, 'Lifebuoy Soap', 'Personal Care', 6000.00, 500),
(12, 'Sunsilk Shampoo', 'Personal Care', 12000.00, 400),
(13, 'Pepsodent Toothpaste', 'Personal Care', 9000.00, 450),
(14, 'Kotex Sanitary Pads', 'Personal Care', 25000.00, 300),
(15, 'Rexona Deodorant', 'Personal Care', 16000.00, 200),
(16, 'MamyPoko Diapers', 'Baby', 85000.00, 150),
(17, 'SGM 1+ Milk Formula 400g', 'Baby', 55000.00, 250),
(18, 'Zwitsal Baby Oil', 'Baby', 22000.00, 300),
(19, 'Mitu Baby Wipes', 'Baby', 18000.00, 400),
(20, 'Cerelac Baby Porridge', 'Baby', 28000.00, 200),
(21, 'Sampoerna Mild (Cigarettes)', 'Tobacco', 28000.00, 100),
(22, 'Gudang Garam Surya (Cigarettes)', 'Tobacco', 26000.00, 120),
(23, 'Djarum Super (Cigarettes)', 'Tobacco', 24000.00, 180),
(24, 'LA Light (Cigarettes)', 'Tobacco', 23000.00, 150),
(25, 'Surya Pro Mild (Cigarettes)', 'Tobacco', 30000.00, 90),
(26, 'Sidu Notebook', 'Stationery', 4000.00, 500),
(27, 'Pilot Pen', 'Stationery', 6000.00, 600),
(28, 'Faber Castell Pencil', 'Stationery', 3500.00, 700),
(29, 'Kenko Eraser', 'Stationery', 2000.00, 800),
(30, 'Ruler 30cm', 'Stationery', 5000.00, 400),
(31, 'Sania Rice 5kg', 'Food', 68000.00, 180),
(32, 'Free-Range Chicken Eggs', 'Food', 3500.00, 1000),
(33, 'Broiler Chicken/kg', 'Food', 38000.00, 200),
(34, 'Catfish/kg', 'Food', 32000.00, 150),
(35, 'Tiger Prawn/kg', 'Food', 120000.00, 80),
(36, 'Bango Soy Sauce', 'Food', 14000.00, 400),
(37, 'ABC Chili Sauce', 'Food', 9000.00, 500),
(38, 'Soto Seasoning Mix', 'Food', 7000.00, 300),
(39, 'Segitiga Wheat Flour', 'Food', 12000.00, 250),
(40, 'Blue Band Margarine', 'Food', 16000.00, 200),
(41, 'Sosro Bottled Tea', 'Beverages', 5000.00, 900),
(42, 'Fruit Tea', 'Beverages', 5500.00, 850),
(43, 'Pocari Sweat', 'Beverages', 8000.00, 600),
(44, 'Le Minerale Water', 'Beverages', 3500.00, 1200),
(45, 'Yakult', 'Beverages', 8500.00, 300),
(46, 'Clear Shampoo', 'Personal Care', 13000.00, 350),
(47, 'Giv Soap', 'Personal Care', 5500.00, 450),
(48, 'Wardah Lipstick', 'Personal Care', 32000.00, 150),
(49, 'Scarlett Face Wash', 'Personal Care', 28000.00, 200),
(50, 'Wardah Face Mask', 'Personal Care', 22000.00, 180),
(51, 'Merries Diapers', 'Baby', 92000.00, 120),
(52, 'Frisian Flag 1-2-3 Milk Formula', 'Baby', 62000.00, 220),
(53, 'Huggies Baby Diapers', 'Baby', 88000.00, 130),
(54, 'Sleek Wet Wipes', 'Baby', 16000.00, 420),
(55, 'Milna Baby Biscuits', 'Baby', 25000.00, 210),
(56, 'Sampoerna Kretek (Cigarettes)', 'Tobacco', 25000.00, 110),
(57, 'Class Mild (Cigarettes)', 'Tobacco', 27000.00, 100),
(58, 'Class Mild Menthol (Cigarettes)', 'Tobacco', 27500.00, 95),
(59, 'Gudang Garam Signature (Cigarettes)', 'Tobacco', 29000.00, 80),
(60, 'U Mild (Cigarettes)', 'Tobacco', 22000.00, 140),
(61, 'Cardboard Drawing Book', 'Stationery', 12000.00, 300),
(62, 'Snowman Marker', 'Stationery', 8000.00, 400),
(63, 'Stabilo Highlighter', 'Stationery', 10000.00, 350),
(64, 'Uhu Glue', 'Stationery', 15000.00, 250),
(65, 'Fiskars Scissors', 'Stationery', 28000.00, 180),
(66, 'Pandan Wangi Rice 5kg', 'Food', 72000.00, 160),
(67, 'Beef/kg', 'Food', 120000.00, 100),
(68, 'Regular Chicken Eggs', 'Food', 2800.00, 1200),
(69, 'White Tofu/pcs', 'Food', 2000.00, 800),
(70, 'Tempeh (1 block)', 'Food', 5000.00, 600),
(71, 'ABC Soy Sauce', 'Food', 13000.00, 420),
(72, 'Del Monte Tomato Sauce', 'Food', 12000.00, 380),
(73, 'Rendang Seasoning Mix', 'Food', 8000.00, 280),
(74, 'Cornstarch', 'Food', 10000.00, 300),
(75, 'Palmia Margarine', 'Food', 15000.00, 230),
(76, 'Nescafe Classic', 'Beverages', 16000.00, 550),
(77, 'Teh Kotak (Boxed Tea)', 'Beverages', 4500.00, 950),
(78, 'Zamzam Water 250ml', 'Beverages', 7000.00, 200),
(79, 'Coca-Cola 240ml', 'Beverages', 6000.00, 700),
(80, 'Sprite 240ml', 'Beverages', 6000.00, 700),
(81, 'Dove Shampoo', 'Personal Care', 14000.00, 330),
(82, 'Cussons Baby Soap', 'Personal Care', 7000.00, 480),
(83, 'Wardah Loose Powder', 'Personal Care', 35000.00, 170),
(84, 'Somethinc Micellar Water', 'Personal Care', 45000.00, 120),
(85, 'Emina Sheet Mask', 'Personal Care', 12000.00, 250),
(86, 'Lovies Diapers', 'Baby', 80000.00, 140),
(87, 'Dancow 1+ Milk Formula 400g', 'Baby', 58000.00, 240),
(88, 'Cap Lang Telon Oil', 'Baby', 25000.00, 280),
(89, 'Cussons Baby Cream', 'Baby', 20000.00, 310),
(90, 'Nestle Baby Porridge', 'Baby', 30000.00, 190),
(91, 'Sampoerna Hijau (Cigarettes)', 'Tobacco', 24000.00, 130),
(92, 'Gudang Garam Filter (Cigarettes)', 'Tobacco', 25500.00, 105),
(93, 'Djarum Coklat (Cigarettes)', 'Tobacco', 23000.00, 160),
(94, 'A Mild White (Cigarettes)', 'Tobacco', 26000.00, 90),
(95, 'Starmild Blue (Cigarettes)', 'Tobacco', 23500.00, 125),
(96, 'Kiky Notebook', 'Stationery', 3500.00, 550),
(97, 'Epson Printer Ink', 'Stationery', 85000.00, 80),
(98, '3M Sticky Notes', 'Stationery', 18000.00, 220),
(99, 'HVS Paper (1 ream)', 'Stationery', 50000.00, 300),
(100, 'Kiky Plastic Folder', 'Stationery', 7000.00, 420),
(101, 'Teh Pucuk Harum (Bottled Tea)', 'Beverages', 4000.00, 1000),
(102, 'Kuku Bima Ginseng (Energy Drink)', 'Beverages', 6500.00, 400),
(103, 'Bear Brand (Sterilized Milk)', 'Beverages', 10000.00, 350),
(104, 'Ultra Milk (Pure Milk)', 'Beverages', 12000.00, 500),
(105, 'Cimory Yoghurt', 'Beverages', 15000.00, 280),
(106, 'Head & Shoulders Shampoo', 'Personal Care', 15000.00, 320),
(107, 'Emina Facial Wash', 'Personal Care', 24000.00, 200),
(108, 'Acnes Moisturizer', 'Personal Care', 18000.00, 230),
(109, 'Scarlett Toner', 'Personal Care', 32000.00, 180),
(110, 'Wardah Sunscreen', 'Personal Care', 42000.00, 150),
(111, 'Drypers Diapers', 'Baby', 82000.00, 160),
(112, 'Bebelac Gold Milk Formula', 'Baby', 180000.00, 100),
(113, 'Mitu Baby Cotton', 'Baby', 15000.00, 380),
(114, 'Pure Baby Oil', 'Baby', 21000.00, 290),
(115, 'Zee Biscuits', 'Baby', 27000.00, 195);


-- Source: orders.csv
INSERT INTO orders (order_id, customer_id, date, total, status) VALUES
(1, 1, '2024-01-15', 50000.00, 'completed'),
(2, 2, '2024-01-18', 120000.00, 'shipped'),
(3, 3, '2024-01-20', 85000.00, 'completed'),
(4, 4, '2024-01-22', 67000.00, 'paid'),
(5, 5, '2024-01-25', 95000.00, 'completed'),
(6, 6, '2024-01-28', 43000.00, 'cancelled'),
(7, 7, '2024-02-01', 110000.00, 'shipped'),
(8, 8, '2024-02-05', 75000.00, 'completed'),
(9, 9, '2024-02-10', 200000.00, 'paid'),
(10, 10, '2024-02-12', 62000.00, 'completed'),
(11, 11, '2024-02-15', 88000.00, 'shipped'),
(12, 12, '2024-02-18', 54000.00, 'completed'),
(13, 13, '2024-02-20', 101000.00, 'paid'),
(14, 14, '2024-02-22', 37000.00, 'cancelled'),
(15, 15, '2024-02-25', 125000.00, 'completed'),
(16, 16, '2024-02-28', 90000.00, 'shipped'),
(17, 17, '2024-03-02', 77000.00, 'completed'),
(18, 18, '2024-03-05', 64000.00, 'paid'),
(19, 19, '2024-03-08', 138000.00, 'completed'),
(20, 20, '2024-03-10', 55000.00, 'cancelled'),
(21, 21, '2024-03-12', 92000.00, 'shipped'),
(22, 22, '2024-03-15', 83000.00, 'completed'),
(23, 23, '2024-03-18', 115000.00, 'paid'),
(24, 24, '2024-03-20', 69000.00, 'completed'),
(25, 25, '2024-03-23', 46000.00, 'cancelled'),
(26, 26, '2024-03-26', 105000.00, 'shipped'),
(27, 27, '2024-03-28', 79000.00, 'completed'),
(28, 28, '2024-03-30', 132000.00, 'paid'),
(29, 29, '2024-04-02', 58000.00, 'completed'),
(30, 30, '2024-04-05', 96000.00, 'cancelled'),
(31, 31, '2024-04-08', 118000.00, 'shipped'),
(32, 32, '2024-04-10', 71000.00, 'completed'),
(33, 33, '2024-04-13', 85000.00, 'paid'),
(34, 34, '2024-04-16', 62000.00, 'completed'),
(35, 35, '2024-04-19', 47000.00, 'cancelled'),
(36, 36, '2024-04-22', 109000.00, 'shipped'),
(37, 37, '2024-04-25', 82000.00, 'completed'),
(38, 38, '2024-04-28', 95000.00, 'paid'),
(39, 39, '2024-05-01', 63000.00, 'completed'),
(40, 40, '2024-05-04', 54000.00, 'cancelled'),
(41, 41, '2024-05-07', 126000.00, 'shipped'),
(42, 42, '2024-05-10', 89000.00, 'completed'),
(43, 43, '2024-05-13', 76000.00, 'paid'),
(44, 44, '2024-05-16', 110000.00, 'completed'),
(45, 45, '2024-05-19', 38000.00, 'cancelled'),
(46, 46, '2024-05-22', 94000.00, 'shipped'),
(47, 47, '2024-05-25', 102000.00, 'completed'),
(48, 48, '2024-05-28', 67000.00, 'paid'),
(49, 49, '2024-06-01', 73000.00, 'completed'),
(50, 50, '2024-06-04', 115000.00, 'cancelled'),
(51, 51, '2024-06-07', 88000.00, 'shipped'),
(52, 52, '2024-06-10', 79000.00, 'completed'),
(53, 53, '2024-06-13', 128000.00, 'paid'),
(54, 54, '2024-06-16', 55000.00, 'completed'),
(55, 55, '2024-06-19', 68000.00, 'cancelled'),
(56, 56, '2024-06-22', 97000.00, 'shipped'),
(57, 57, '2024-06-25', 84000.00, 'completed'),
(58, 58, '2024-06-28', 112000.00, 'paid'),
(59, 59, '2024-07-01', 59000.00, 'completed'),
(60, 60, '2024-07-04', 74000.00, 'cancelled'),
(61, 61, '2024-07-07', 106000.00, 'shipped'),
(62, 62, '2024-07-10', 81000.00, 'completed'),
(63, 63, '2024-07-13', 94000.00, 'paid'),
(64, 64, '2024-07-16', 66000.00, 'completed'),
(65, 65, '2024-07-19', 45000.00, 'cancelled'),
(66, 66, '2024-07-22', 119000.00, 'shipped'),
(67, 67, '2024-07-25', 87000.00, 'completed'),
(68, 68, '2024-07-28', 73000.00, 'paid'),
(69, 69, '2024-08-01', 105000.00, 'completed'),
(70, 70, '2024-08-04', 58000.00, 'cancelled'),
(71, 71, '2024-08-07', 92000.00, 'shipped'),
(72, 72, '2024-08-10', 84000.00, 'completed'),
(73, 73, '2024-08-13', 116000.00, 'paid'),
(74, 74, '2024-08-16', 62000.00, 'completed'),
(75, 75, '2024-08-19', 77000.00, 'cancelled'),
(76, 76, '2024-08-22', 108000.00, 'shipped'),
(77, 77, '2024-08-25', 89000.00, 'completed'),
(78, 78, '2024-08-28', 96000.00, 'paid'),
(79, 79, '2024-09-01', 54000.00, 'completed'),
(80, 80, '2024-09-04', 68000.00, 'cancelled'),
(81, 81, '2024-09-07', 121000.00, 'shipped'),
(82, 82, '2024-09-10', 83000.00, 'completed'),
(83, 83, '2024-09-13', 75000.00, 'paid'),
(84, 84, '2024-09-16', 109000.00, 'completed'),
(85, 85, '2024-09-19', 39000.00, 'cancelled'),
(86, 86, '2024-09-22', 93000.00, 'shipped'),
(87, 87, '2024-09-25', 101000.00, 'completed'),
(88, 88, '2024-09-28', 66000.00, 'paid'),
(89, 89, '2024-10-01', 72000.00, 'completed'),
(90, 90, '2024-10-04', 114000.00, 'cancelled'),
(91, 91, '2024-10-07', 87000.00, 'shipped'),
(92, 92, '2024-10-10', 78000.00, 'completed'),
(93, 93, '2024-10-13', 127000.00, 'paid'),
(94, 94, '2024-10-16', 54000.00, 'completed'),
(95, 95, '2024-10-19', 67000.00, 'cancelled'),
(96, 96, '2024-10-22', 96000.00, 'shipped'),
(97, 97, '2024-10-25', 83000.00, 'completed'),
(98, 98, '2024-10-28', 111000.00, 'paid'),
(99, 99, '2024-11-01', 58000.00, 'completed'),
(100, 100, '2024-11-04', 73000.00, 'cancelled'),
(101, 101, '2024-11-07', 105000.00, 'shipped'),
(102, 102, '2024-11-10', 80000.00, 'completed'),
(103, 103, '2024-11-13', 93000.00, 'paid'),
(104, 104, '2024-11-16', 65000.00, 'completed'),
(105, 105, '2024-11-19', 44000.00, 'cancelled'),
(106, 1, '2024-12-02', 98000.00, 'shipped'),
(107, 2, '2024-12-05', 86000.00, 'completed'),
(108, 3, '2024-12-08', 119000.00, 'paid'),
(109, 4, '2024-12-11', 59000.00, 'completed'),
(110, 5, '2024-12-14', 74000.00, 'cancelled'),
(111, 6, '2024-12-17', 107000.00, 'shipped'),
(112, 7, '2024-12-20', 89000.00, 'completed'),
(113, 8, '2024-12-23', 76000.00, 'paid'),
(114, 9, '2024-12-26', 110000.00, 'completed'),
(115, 10, '2024-12-29', 37000.00, 'cancelled'),
(116, 11, '2025-01-02', 95000.00, 'shipped'),
(117, 12, '2025-01-05', 82000.00, 'completed'),
(118, 13, '2025-01-08', 128000.00, 'paid'),
(119, 14, '2025-01-11', 63000.00, 'completed'),
(120, 15, '2025-01-14', 78000.00, 'cancelled'),
(121, 16, '2025-01-17', 111000.00, 'shipped'),
(122, 17, '2025-01-20', 94000.00, 'completed'),
(123, 18, '2025-01-23', 81000.00, 'paid'),
(124, 19, '2025-01-26', 105000.00, 'completed'),
(125, 20, '2025-01-29', 44000.00, 'cancelled'),
(126, 21, '2025-02-01', 97000.00, 'shipped'),
(127, 22, '2025-02-04', 85000.00, 'completed'),
(128, 23, '2025-02-07', 118000.00, 'paid'),
(129, 24, '2025-02-10', 68000.00, 'completed'),
(130, 25, '2025-02-13', 73000.00, 'cancelled'),
(131, 26, '2025-02-16', 102000.00, 'shipped'),
(132, 27, '2025-02-19', 87000.00, 'completed'),
(133, 28, '2025-02-22', 94000.00, 'paid'),
(134, 29, '2025-02-25', 58000.00, 'completed'),
(135, 30, '2025-02-28', 72000.00, 'cancelled'),
(136, 31, '2025-03-03', 116000.00, 'shipped'),
(137, 32, '2025-03-06', 83000.00, 'completed'),
(138, 33, '2025-03-09', 96000.00, 'paid'),
(139, 34, '2025-03-12', 69000.00, 'completed'),
(140, 35, '2025-03-15', 45000.00, 'cancelled'),
(141, 36, '2025-03-18', 108000.00, 'shipped'),
(142, 37, '2025-03-21', 89000.00, 'completed'),
(143, 38, '2025-03-24', 77000.00, 'paid'),
(144, 39, '2025-03-27', 111000.00, 'completed'),
(145, 40, '2025-03-30', 38000.00, 'cancelled'),
(146, 41, '2025-04-02', 94000.00, 'shipped'),
(147, 42, '2025-04-05', 86000.00, 'completed'),
(148, 43, '2025-04-08', 119000.00, 'paid'),
(149, 44, '2025-04-11', 64000.00, 'completed'),
(150, 45, '2025-04-14', 69000.00, 'cancelled'),
(151, 46, '2025-04-17', 103000.00, 'shipped'),
(152, 47, '2025-04-20', 91000.00, 'completed'),
(153, 48, '2025-04-23', 78000.00, 'paid'),
(154, 49, '2025-04-26', 95000.00, 'completed'),
(155, 50, '2025-04-29', 46000.00, 'cancelled'),
(156, 51, '2025-05-02', 107000.00, 'shipped'),
(157, 52, '2025-05-05', 84000.00, 'completed'),
(158, 53, '2025-05-08', 120000.00, 'paid'),
(159, 54, '2025-05-11', 67000.00, 'completed'),
(160, 55, '2025-05-14', 71000.00, 'cancelled'),
(161, 56, '2025-05-17', 98000.00, 'shipped'),
(162, 57, '2025-05-20', 85000.00, 'completed'),
(163, 58, '2025-05-23', 113000.00, 'paid'),
(164, 59, '2025-05-26', 59000.00, 'completed'),
(165, 60, '2025-05-29', 74000.00, 'cancelled'),
(166, 61, '2025-06-01', 105000.00, 'shipped'),
(167, 62, '2025-06-04', 82000.00, 'completed'),
(168, 63, '2025-06-07', 95000.00, 'paid'),
(169, 64, '2025-06-10', 66000.00, 'completed'),
(170, 65, '2025-06-13', 43000.00, 'cancelled'),
(171, 66, '2025-06-16', 117000.00, 'shipped'),
(172, 67, '2025-06-19', 88000.00, 'completed'),
(173, 68, '2025-06-22', 74000.00, 'paid'),
(174, 69, '2025-06-25', 106000.00, 'completed'),
(175, 70, '2025-06-28', 57000.00, 'cancelled'),
(176, 71, '2025-07-01', 92000.00, 'shipped'),
(177, 72, '2025-07-04', 83000.00, 'completed'),
(178, 73, '2025-07-07', 115000.00, 'paid'),
(179, 74, '2025-07-10', 61000.00, 'completed'),
(180, 75, '2025-07-13', 76000.00, 'cancelled'),
(181, 76, '2025-07-16', 108000.00, 'shipped'),
(182, 77, '2025-07-19', 89000.00, 'completed'),
(183, 78, '2025-07-22', 95000.00, 'paid'),
(184, 79, '2025-07-25', 53000.00, 'completed'),
(185, 80, '2025-07-28', 68000.00, 'cancelled'),
(186, 81, '2025-08-01', 120000.00, 'shipped'),
(187, 82, '2025-08-04', 83000.00, 'completed'),
(188, 83, '2025-08-07', 74000.00, 'paid'),
(189, 84, '2025-08-10', 108000.00, 'completed'),
(190, 85, '2025-08-13', 37000.00, 'cancelled'),
(191, 86, '2025-08-16', 92000.00, 'shipped'),
(192, 87, '2025-08-19', 100000.00, 'completed'),
(193, 88, '2025-08-22', 65000.00, 'paid'),
(194, 89, '2025-08-25', 71000.00, 'completed'),
(195, 90, '2025-08-28', 113000.00, 'cancelled'),
(196, 91, '2025-09-01', 86000.00, 'shipped'),
(197, 92, '2025-09-04', 77000.00, 'completed'),
(198, 93, '2025-09-07', 126000.00, 'paid'),
(199, 94, '2025-09-10', 53000.00, 'completed'),
(200, 95, '2025-09-13', 66000.00, 'cancelled'),
(201, 96, '2025-09-16', 95000.00, 'shipped'),
(202, 97, '2025-09-19', 82000.00, 'completed'),
(203, 98, '2025-09-22', 110000.00, 'paid'),
(204, 99, '2025-09-25', 57000.00, 'completed'),
(205, 100, '2025-09-28', 72000.00, 'cancelled'),
(206, 101, '2025-10-01', 104000.00, 'shipped'),
(207, 102, '2025-10-04', 79000.00, 'completed'),
(208, 103, '2025-10-07', 92000.00, 'paid'),
(209, 104, '2025-10-10', 64000.00, 'completed'),
(210, 105, '2025-10-13', 42000.00, 'cancelled'),
(211, 1, '2025-10-16', 97000.00, 'shipped'),
(212, 2, '2025-10-19', 84000.00, 'completed'),
(213, 3, '2025-10-22', 117000.00, 'paid'),
(214, 4, '2025-10-25', 58000.00, 'completed'),
(215, 5, '2025-10-28', 73000.00, 'cancelled'),
(216, 6, '2025-10-31', 106000.00, 'shipped'),
(217, 7, '2025-11-03', 88000.00, 'completed'),
(218, 8, '2025-11-06', 75000.00, 'paid'),
(219, 9, '2025-11-09', 109000.00, 'completed'),
(220, 10, '2025-11-12', 36000.00, 'cancelled'),
(221, 11, '2025-11-15', 94000.00, 'shipped'),
(222, 12, '2025-11-18', 81000.00, 'completed'),
(223, 13, '2025-11-21', 125000.00, 'paid'),
(224, 14, '2025-11-24', 62000.00, 'completed'),
(225, 15, '2025-11-27', 77000.00, 'cancelled'),
(226, 16, '2025-11-30', 110000.00, 'shipped');


-- Source: order_details.csv
INSERT INTO order_details (detail_id, order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 2, 5000.00),
(2, 1, 10, 1, 45000.00),
(3, 2, 5, 2, 30000.00),
(4, 2, 26, 3, 90000.00),
(5, 3, 3, 1, 65000.00),
(6, 3, 22, 1, 20000.00),
(7, 4, 15, 1, 16000.00),
(8, 4, 30, 1, 51000.00),
(9, 5, 2, 2, 17000.00),
(10, 5, 35, 1, 78000.00),
(11, 6, 40, 2, 11000.00),
(12, 6, 45, 1, 32000.00),
(13, 7, 50, 2, 64000.00),
(14, 7, 60, 1, 46000.00),
(15, 8, 28, 1, 9000.00),
(16, 8, 33, 3, 66000.00),
(17, 9, 32, 2, 16000.00),
(18, 9, 65, 4, 184000.00),
(19, 10, 11, 1, 6000.00),
(20, 10, 48, 2, 56000.00),
(21, 11, 12, 1, 12000.00),
(22, 11, 75, 2, 76000.00),
(23, 12, 13, 2, 18000.00),
(24, 12, 55, 1, 36000.00),
(25, 13, 14, 1, 25000.00),
(26, 13, 38, 2, 44000.00),
(27, 14, 42, 1, 37000.00),
(28, 14, 1, 1, 2500.00),
(29, 15, 3, 1, 68000.00),
(30, 15, 46, 1, 57000.00),
(31, 16, 6, 2, 24000.00),
(32, 16, 51, 2, 66000.00),
(33, 17, 8, 3, 9000.00),
(34, 17, 70, 1, 68000.00),
(35, 18, 9, 2, 9000.00),
(36, 18, 56, 2, 55000.00),
(37, 19, 36, 1, 14000.00),
(38, 19, 61, 3, 124000.00),
(39, 20, 41, 1, 55000.00),
(40, 20, 5, 1, 8500.00),
(41, 21, 16, 1, 25000.00),
(42, 21, 66, 2, 67000.00),
(43, 22, 17, 2, 110000.00),
(44, 22, 57, 1, 17000.00),
(45, 23, 18, 1, 22000.00),
(46, 23, 62, 2, 93000.00),
(47, 24, 19, 2, 36000.00),
(48, 24, 58, 1, 33000.00),
(49, 25, 20, 1, 28000.00),
(50, 25, 43, 1, 18000.00),
(51, 26, 21, 2, 56000.00),
(52, 26, 67, 2, 49000.00),
(53, 27, 23, 1, 38000.00),
(54, 27, 59, 2, 41000.00),
(55, 28, 24, 1, 120000.00),
(56, 28, 71, 2, 12000.00),
(57, 29, 25, 2, 11600.00),
(58, 29, 49, 3, 46400.00),
(59, 30, 27, 1, 100000.00),
(60, 30, 2, 1, 8500.00),
(61, 31, 29, 1, 5000.00),
(62, 31, 72, 5, 113000.00),
(63, 32, 31, 2, 24000.00),
(64, 32, 52, 2, 47000.00),
(65, 33, 34, 1, 12000.00),
(66, 33, 68, 2, 73000.00),
(67, 34, 37, 2, 19000.00),
(68, 34, 53, 1, 43000.00),
(69, 35, 39, 1, 47000.00),
(70, 35, 6, 1, 12000.00),
(71, 36, 44, 1, 22000.00),
(72, 36, 69, 3, 87000.00),
(73, 37, 47, 2, 184000.00),
(74, 37, 54, 1, 17000.00),
(75, 38, 73, 2, 220000.00),
(76, 38, 11, 1, 6000.00),
(77, 39, 74, 3, 63000.00),
(78, 39, 13, 1, 9000.00),
(79, 40, 76, 2, 54000.00),
(80, 40, 8, 1, 3000.00),
(81, 41, 77, 1, 126000.00),
(82, 41, 3, 1, 72000.00),
(83, 42, 78, 1, 89000.00),
(84, 42, 9, 1, 4500.00),
(85, 43, 79, 2, 76000.00),
(86, 43, 14, 1, 25000.00),
(87, 44, 80, 2, 110000.00),
(88, 44, 15, 1, 16000.00),
(89, 45, 81, 1, 38000.00),
(90, 45, 16, 1, 25000.00),
(91, 46, 82, 1, 94000.00),
(92, 46, 17, 1, 55000.00),
(93, 47, 83, 2, 102000.00),
(94, 47, 18, 1, 22000.00),
(95, 48, 84, 1, 67000.00),
(96, 48, 19, 1, 18000.00),
(97, 49, 85, 2, 73000.00),
(98, 49, 20, 1, 28000.00),
(99, 50, 86, 2, 115000.00),
(100, 50, 21, 1, 28000.00),
(101, 51, 87, 1, 88000.00),
(102, 51, 22, 1, 20000.00),
(103, 52, 88, 1, 85000.00),
(104, 52, 23, 1, 38000.00),
(105, 53, 89, 1, 128000.00),
(106, 53, 24, 1, 120000.00),
(107, 54, 90, 1, 55000.00),
(108, 54, 25, 1, 5800.00),
(109, 55, 91, 2, 68000.00),
(110, 55, 26, 1, 30000.00),
(111, 56, 92, 1, 97000.00),
(112, 56, 27, 1, 100000.00),
(113, 57, 93, 1, 84000.00),
(114, 57, 28, 1, 9000.00),
(115, 58, 94, 1, 112000.00),
(116, 58, 29, 1, 5000.00),
(117, 59, 95, 2, 59000.00),
(118, 59, 30, 1, 51000.00),
(119, 60, 96, 2, 74000.00),
(120, 60, 31, 1, 12000.00),
(121, 61, 97, 1, 106000.00),
(122, 61, 32, 1, 8000.00),
(123, 62, 98, 1, 81000.00),
(124, 62, 33, 1, 22000.00),
(125, 63, 99, 1, 94000.00),
(126, 63, 34, 1, 12000.00),
(127, 64, 100, 1, 66000.00),
(128, 64, 35, 1, 78000.00),
(129, 65, 101, 1, 44000.00),
(130, 65, 36, 1, 14000.00),
(131, 66, 102, 1, 119000.00),
(132, 66, 37, 1, 9500.00),
(133, 67, 103, 1, 87000.00),
(134, 67, 38, 1, 22000.00),
(135, 68, 104, 1, 74000.00),
(136, 68, 39, 1, 47000.00),
(137, 69, 105, 1, 105000.00),
(138, 69, 40, 1, 5500.00),
(139, 70, 1, 3, 7500.00),
(140, 70, 2, 1, 8500.00),
(141, 71, 5, 1, 15000.00),
(142, 71, 10, 2, 90000.00),
(143, 72, 15, 2, 32000.00),
(144, 72, 20, 2, 56000.00),
(145, 73, 25, 1, 5800.00),
(146, 73, 30, 2, 102000.00),
(147, 74, 35, 1, 78000.00),
(148, 74, 40, 1, 5500.00),
(149, 75, 45, 1, 32000.00),
(150, 75, 50, 1, 32000.00),
(151, 76, 55, 1, 36000.00),
(152, 76, 60, 2, 92000.00),
(153, 77, 65, 2, 92000.00),
(154, 77, 70, 1, 15000.00),
(155, 78, 75, 1, 38000.00),
(156, 78, 80, 1, 58000.00),
(157, 79, 85, 1, 38000.00),
(158, 79, 90, 1, 16000.00),
(159, 80, 95, 1, 74000.00),
(160, 80, 1, 1, 2500.00),
(161, 81, 1, 1, 2500.00),
(162, 81, 100, 1, 118500.00),
(163, 82, 5, 3, 45000.00),
(164, 82, 90, 1, 38000.00),
(165, 83, 10, 1, 45000.00),
(166, 83, 75, 1, 30000.00),
(167, 84, 20, 2, 56000.00),
(168, 84, 85, 1, 53000.00),
(169, 85, 42, 1, 39000.00),
(170, 85, 2, 1, 8500.00),
(171, 86, 30, 1, 51000.00),
(172, 86, 56, 1, 42000.00),
(173, 87, 46, 1, 57000.00),
(174, 87, 41, 1, 44000.00),
(175, 88, 51, 1, 33000.00),
(176, 88, 38, 1, 33000.00),
(177, 89, 61, 2, 124000.00),
(178, 89, 3, 1, 72000.00),
(179, 90, 66, 1, 93000.00),
(180, 90, 23, 1, 21000.00),
(181, 91, 71, 1, 6000.00),
(182, 91, 76, 2, 81000.00),
(183, 92, 77, 1, 87000.00),
(184, 92, 4, 1, 28000.00),
(185, 93, 78, 1, 78000.00),
(186, 93, 83, 1, 49000.00),
(187, 94, 88, 1, 54000.00),
(188, 94, 5, 1, 15000.00),
(189, 95, 93, 1, 67000.00),
(190, 95, 6, 1, 12000.00),
(191, 96, 98, 2, 80000.00),
(192, 96, 103, 1, 16000.00),
(193, 97, 2, 2, 17000.00),
(194, 97, 100, 1, 66000.00),
(195, 98, 5, 1, 15000.00),
(196, 98, 32, 3, 48000.00),
(197, 99, 10, 2, 90000.00),
(198, 99, 15, 1, 16000.00),
(199, 100, 20, 1, 28000.00),
(200, 100, 25, 1, 18000.00),
(201, 101, 30, 1, 51000.00),
(202, 101, 35, 1, 78000.00),
(203, 102, 40, 1, 5500.00),
(204, 102, 45, 2, 64000.00),
(205, 103, 50, 1, 32000.00),
(206, 103, 55, 1, 36000.00),
(207, 104, 60, 1, 46000.00),
(208, 104, 65, 1, 46000.00),
(209, 105, 70, 1, 15000.00),
(210, 105, 75, 1, 29000.00),
(211, 106, 80, 1, 58000.00),
(212, 106, 85, 1, 40000.00),
(213, 107, 90, 1, 38000.00),
(214, 107, 95, 1, 48000.00),
(215, 108, 1, 2, 5000.00),
(216, 108, 100, 1, 81000.00),
(217, 109, 5, 2, 30000.00),
(218, 109, 26, 2, 60000.00),
(219, 110, 3, 1, 65000.00),
(220, 110, 22, 2, 40000.00),
(221, 111, 15, 1, 16000.00),
(222, 111, 30, 1, 51000.00),
(223, 112, 2, 1, 8500.00),
(224, 112, 35, 1, 78000.00),
(225, 113, 40, 1, 5500.00),
(226, 113, 45, 1, 32000.00),
(227, 114, 50, 1, 32000.00),
(228, 114, 60, 1, 46000.00),
(229, 115, 28, 1, 9000.00),
(230, 115, 33, 2, 44000.00),
(231, 116, 32, 1, 8000.00),
(232, 116, 65, 3, 138000.00),
(233, 117, 11, 2, 12000.00),
(234, 117, 48, 1, 28000.00),
(235, 118, 12, 2, 24000.00),
(236, 118, 75, 1, 38000.00),
(237, 119, 13, 1, 9000.00),
(238, 119, 55, 2, 72000.00),
(239, 120, 14, 1, 25000.00),
(240, 120, 38, 1, 22000.00),
(241, 121, 3, 1, 68000.00),
(242, 121, 46, 1, 57000.00),
(243, 122, 6, 1, 12000.00),
(244, 122, 51, 2, 66000.00),
(245, 123, 8, 2, 6000.00),
(246, 123, 70, 1, 68000.00),
(247, 124, 9, 1, 4500.00),
(248, 124, 56, 2, 55000.00),
(249, 125, 36, 2, 28000.00),
(250, 125, 61, 2, 124000.00),
(251, 126, 41, 1, 55000.00),
(252, 126, 7, 1, 10000.00),
(253, 127, 16, 1, 25000.00),
(254, 127, 66, 1, 33500.00),
(255, 128, 17, 2, 110000.00),
(256, 128, 57, 1, 17000.00),
(257, 129, 18, 2, 44000.00),
(258, 129, 62, 1, 46500.00),
(259, 130, 19, 1, 18000.00),
(260, 130, 58, 2, 66000.00),
(261, 131, 20, 2, 56000.00),
(262, 131, 43, 1, 18000.00),
(263, 132, 21, 1, 28000.00),
(264, 132, 67, 2, 49000.00),
(265, 133, 23, 1, 38000.00),
(266, 133, 59, 1, 20500.00),
(267, 134, 24, 1, 120000.00),
(268, 134, 71, 1, 6000.00),
(269, 135, 25, 1, 5800.00),
(270, 135, 49, 3, 46400.00),
(271, 136, 27, 1, 100000.00),
(272, 136, 1, 1, 2500.00),
(273, 137, 29, 1, 5000.00),
(274, 137, 72, 4, 90400.00),
(275, 138, 31, 1, 12000.00),
(276, 138, 52, 2, 47000.00),
(277, 139, 34, 2, 24000.00),
(278, 139, 68, 1, 36500.00),
(279, 140, 37, 1, 9500.00),
(280, 140, 53, 1, 43000.00),
(281, 141, 39, 1, 47000.00),
(282, 141, 2, 1, 8500.00),
(283, 142, 44, 2, 44000.00),
(284, 142, 69, 2, 58000.00),
(285, 143, 47, 1, 92000.00),
(286, 143, 54, 1, 17000.00),
(287, 144, 73, 1, 95000.00),
(288, 144, 11, 1, 6000.00),
(289, 145, 74, 2, 42000.00),
(290, 145, 12, 1, 12000.00),
(291, 146, 76, 1, 27000.00),
(292, 146, 13, 1, 9000.00),
(293, 147, 77, 1, 94000.00),
(294, 147, 3, 1, 72000.00),
(295, 148, 78, 1, 86000.00),
(296, 148, 4, 1, 28000.00),
(297, 149, 79, 1, 119000.00),
(298, 149, 5, 1, 15000.00),
(299, 150, 80, 1, 64000.00),
(300, 150, 6, 1, 12000.00),
(301, 151, 81, 1, 69000.00),
(302, 151, 7, 1, 10000.00),
(303, 152, 82, 1, 103000.00),
(304, 152, 8, 1, 3000.00),
(305, 153, 83, 1, 81000.00),
(306, 153, 9, 1, 4500.00),
(307, 154, 84, 1, 78000.00),
(308, 154, 10, 1, 45000.00),
(309, 155, 85, 1, 95000.00),
(310, 155, 11, 1, 6000.00),
(311, 156, 86, 1, 46000.00),
(312, 156, 12, 1, 12000.00),
(313, 157, 87, 1, 107000.00),
(314, 157, 13, 1, 9000.00),
(315, 158, 88, 1, 84000.00),
(316, 158, 14, 1, 25000.00),
(317, 159, 89, 1, 120000.00),
(318, 159, 15, 1, 16000.00),
(319, 160, 90, 1, 67000.00),
(320, 160, 16, 1, 25000.00),
(321, 161, 91, 1, 71000.00),
(322, 161, 17, 1, 55000.00),
(323, 162, 92, 1, 98000.00),
(324, 162, 18, 1, 22000.00),
(325, 163, 93, 1, 85000.00),
(326, 163, 19, 1, 18000.00),
(327, 164, 94, 1, 38000.00),
(328, 164, 99, 1, 28000.00),
(329, 165, 101, 1, 43000.00),
(330, 165, 20, 1, 28000.00),
(331, 166, 102, 1, 117000.00),
(332, 166, 21, 1, 28000.00),
(333, 167, 103, 1, 88000.00),
(334, 167, 22, 1, 20000.00),
(335, 168, 104, 1, 74000.00),
(336, 168, 23, 1, 38000.00),
(337, 169, 105, 1, 106000.00),
(338, 169, 24, 1, 120000.00),
(339, 170, 1, 2, 5000.00),
(340, 170, 2, 1, 8500.00),
(341, 171, 5, 1, 15000.00),
(342, 171, 10, 2, 90000.00),
(343, 172, 15, 1, 16000.00),
(344, 172, 20, 2, 56000.00),
(345, 173, 25, 1, 5800.00),
(346, 173, 30, 1, 51000.00),
(347, 174, 35, 2, 156000.00),
(348, 174, 40, 1, 5500.00),
(349, 175, 45, 2, 64000.00),
(350, 175, 50, 1, 32000.00),
(351, 176, 55, 1, 36000.00),
(352, 176, 60, 1, 46000.00),
(353, 177, 65, 1, 46000.00),
(354, 177, 70, 1, 15000.00),
(355, 178, 75, 2, 76000.00),
(356, 178, 80, 1, 58000.00),
(357, 179, 85, 2, 76000.00),
(358, 179, 90, 1, 38000.00),
(359, 180, 95, 1, 74000.00),
(360, 180, 1, 1, 2500.00),
(361, 181, 1, 1, 2500.00),
(362, 181, 100, 1, 117500.00),
(363, 182, 5, 2, 30000.00),
(364, 182, 90, 1, 38000.00),
(365, 183, 10, 2, 90000.00),
(366, 183, 75, 1, 30000.00),
(367, 184, 20, 1, 28000.00),
(368, 184, 85, 1, 53000.00),
(369, 185, 42, 1, 37000.00),
(370, 185, 2, 1, 8500.00),
(371, 186, 30, 2, 102000.00),
(372, 186, 56, 1, 42000.00),
(373, 187, 46, 1, 57000.00),
(374, 187, 41, 1, 44000.00),
(375, 188, 51, 2, 66000.00),
(376, 188, 38, 1, 33000.00),
(377, 189, 61, 1, 62000.00),
(378, 189, 3, 1, 72000.00),
(379, 190, 66, 1, 92000.00),
(380, 190, 23, 1, 21000.00),
(381, 191, 71, 2, 12000.00),
(382, 191, 76, 1, 40500.00),
(383, 192, 77, 1, 86000.00),
(384, 192, 4, 1, 28000.00),
(385, 193, 78, 1, 77000.00),
(386, 193, 83, 1, 49000.00),
(387, 194, 88, 1, 53000.00),
(388, 194, 5, 1, 15000.00),
(389, 195, 93, 1, 66000.00),
(390, 195, 6, 1, 12000.00),
(391, 196, 98, 1, 40000.00),
(392, 196, 103, 2, 32000.00),
(393, 197, 2, 1, 8500.00),
(394, 197, 100, 1, 66000.00),
(395, 198, 5, 2, 30000.00),
(396, 198, 32, 2, 32000.00),
(397, 199, 10, 1, 45000.00),
(398, 199, 15, 2, 32000.00),
(399, 200, 20, 2, 56000.00),
(400, 200, 25, 1, 18000.00),
(401, 201, 30, 1, 51000.00),
(402, 201, 35, 1, 78000.00),
(403, 202, 40, 2, 11000.00),
(404, 202, 45, 1, 32000.00),
(405, 203, 50, 2, 64000.00),
(406, 203, 55, 1, 36000.00),
(407, 204, 60, 1, 46000.00),
(408, 204, 65, 1, 46000.00),
(409, 205, 70, 1, 15000.00),
(410, 205, 75, 1, 29000.00),
(411, 206, 80, 1, 58000.00),
(412, 206, 85, 1, 40000.00),
(413, 207, 90, 1, 38000.00),
(414, 207, 95, 1, 48000.00),
(415, 208, 1, 1, 2500.00),
(416, 208, 100, 1, 94500.00),
(417, 209, 5, 1, 15000.00),
(418, 209, 26, 2, 60000.00),
(419, 210, 3, 1, 65000.00),
(420, 210, 22, 1, 20000.00);



-- =====================================================================
-- STEP 4: SQL ANALYSIS QUERIES
-- Sections A - M as required by the assignment brief
-- =====================================================================


-- =====================================================================
-- SECTION A. SELECT
-- =====================================================================

-- ---------------------------------------------------------------------
-- [A1] Simple SELECT - all customer records
-- Purpose : Retrieve every column and every row from the customers table.
-- ---------------------------------------------------------------------
SELECT * FROM customers;

-- ---------------------------------------------------------------------
-- [A2] SELECT specific columns
-- Purpose : Fetch only the customer's name, city and province.
-- ---------------------------------------------------------------------
SELECT name, city, province
FROM customers;

-- ---------------------------------------------------------------------
-- [A3] SELECT * on products
-- Purpose : Display the full product catalogue.
-- ---------------------------------------------------------------------
SELECT * FROM products;


-- =====================================================================
-- SECTION B. WHERE
-- =====================================================================

-- ---------------------------------------------------------------------
-- [B1] Equality operator (=)
-- Purpose : List every order whose status is exactly 'completed'.
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, date, total, status
FROM orders
WHERE status = 'completed';

-- ---------------------------------------------------------------------
-- [B2] Greater-than operator (>)
-- Purpose : Find premium products priced above Rp 50,000.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, category, price
FROM products
WHERE price > 50000;

-- ---------------------------------------------------------------------
-- [B3] BETWEEN operator
-- Purpose : Show mid-range orders with a total between Rp 50,000 and Rp 100,000 (inclusive).
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, date, total, status
FROM orders
WHERE total BETWEEN 50000 AND 100000;

-- ---------------------------------------------------------------------
-- [B4] IN operator
-- Purpose : Retrieve customers who live in one of three specific cities.
-- ---------------------------------------------------------------------
SELECT customer_id, name, city, province
FROM customers
WHERE city IN ('Bandung', 'Surabaya', 'Medan');

-- ---------------------------------------------------------------------
-- [B5] LIKE operator (pattern matching)
-- Purpose : Find every product whose name contains the word 'Rice'.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, category, price
FROM products
WHERE product_name LIKE '%Rice%';

-- ---------------------------------------------------------------------
-- [B6] AND operator (combining conditions)
-- Purpose : List Food category products priced above Rp 20,000.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, category, price
FROM products
WHERE category = 'Food' AND price > 20000;

-- ---------------------------------------------------------------------
-- [B7] OR operator (either condition)
-- Purpose : Find orders that are either cancelled or shipped.
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, date, total, status
FROM orders
WHERE status = 'cancelled' OR status = 'shipped';

-- ---------------------------------------------------------------------
-- [B8] NOT operator (negation)
-- Purpose : Show products that do NOT belong to the Food or Beverages categories.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, category, price
FROM products
WHERE category NOT IN ('Food', 'Beverages');


-- =====================================================================
-- SECTION C. ORDER BY
-- =====================================================================

-- ---------------------------------------------------------------------
-- [C1] Ascending order
-- Purpose : List products from cheapest to most expensive.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, price
FROM products
ORDER BY price ASC;

-- ---------------------------------------------------------------------
-- [C2] Descending order
-- Purpose : List products from most expensive to cheapest.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, price
FROM products
ORDER BY price DESC;

-- ---------------------------------------------------------------------
-- [C3] Multiple-column ORDER BY
-- Purpose : Group orders by status alphabetically, and within each status show the highest-value orders first.
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, date, total, status
FROM orders
ORDER BY status ASC, total DESC;


-- =====================================================================
-- SECTION D. GROUP BY
-- =====================================================================

-- ---------------------------------------------------------------------
-- [D1] GROUP BY with COUNT
-- Purpose : Count how many orders each customer has placed.
-- ---------------------------------------------------------------------
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;

-- ---------------------------------------------------------------------
-- [D2] GROUP BY with SUM
-- Purpose : Show the total order value for every order status.
-- ---------------------------------------------------------------------
SELECT status, SUM(total) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- ---------------------------------------------------------------------
-- [D3] GROUP BY with AVG
-- Purpose : Compute the average product price per category.
-- ---------------------------------------------------------------------
SELECT category, ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- ---------------------------------------------------------------------
-- [D4] GROUP BY with MIN
-- Purpose : Find the cheapest product price within each category.
-- ---------------------------------------------------------------------
SELECT category, MIN(price) AS cheapest_price
FROM products
GROUP BY category
ORDER BY cheapest_price ASC;

-- ---------------------------------------------------------------------
-- [D5] GROUP BY with MAX
-- Purpose : Find the most expensive product price within each category.
-- ---------------------------------------------------------------------
SELECT category, MAX(price) AS most_expensive_price
FROM products
GROUP BY category
ORDER BY most_expensive_price DESC;


-- =====================================================================
-- SECTION E. Aggregate Functions
-- =====================================================================

-- ---------------------------------------------------------------------
-- [E1] COUNT() - total number of orders
-- Purpose : Count the total number of orders ever placed.
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS total_orders
FROM orders;

-- ---------------------------------------------------------------------
-- [E2] SUM() - total revenue
-- Purpose : Calculate the combined value of every order in the system.
-- ---------------------------------------------------------------------
SELECT SUM(total) AS total_revenue
FROM orders;

-- ---------------------------------------------------------------------
-- [E3] AVG() - average order value
-- Purpose : Determine the average value of a single order.
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(total), 2) AS average_order_value
FROM orders;

-- ---------------------------------------------------------------------
-- [E4] MIN() - cheapest product price
-- Purpose : Find the lowest product price in the entire catalogue.
-- ---------------------------------------------------------------------
SELECT MIN(price) AS cheapest_product_price
FROM products;

-- ---------------------------------------------------------------------
-- [E5] MAX() - most expensive product price
-- Purpose : Find the highest product price in the entire catalogue.
-- ---------------------------------------------------------------------
SELECT MAX(price) AS highest_product_price
FROM products;


-- =====================================================================
-- SECTION F. INNER JOIN
-- =====================================================================

-- ---------------------------------------------------------------------
-- [F1] Customers with their Orders
-- Purpose : Combine every order with the name of the customer who placed it.
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.name, o.order_id, o.date, o.total, o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- ---------------------------------------------------------------------
-- [F2] Orders with Products (through order_details)
-- Purpose : Show which products were bought in every order.
-- ---------------------------------------------------------------------
SELECT o.order_id, o.date, p.product_name, od.quantity, p.price
FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id;

-- ---------------------------------------------------------------------
-- [F3] Order Details with Products
-- Purpose : Enrich each line item with the product's name, category and unit price.
-- ---------------------------------------------------------------------
SELECT od.detail_id, p.product_name, p.category, od.quantity, p.price, od.subtotal
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
ORDER BY od.detail_id;


-- =====================================================================
-- SECTION G. LEFT JOIN
-- =====================================================================

-- ---------------------------------------------------------------------
-- [G1] All customers, with or without orders
-- Purpose : List every customer, showing their orders when they exist and NULLs when they have never ordered.
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.name, o.order_id, o.date, o.total
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


-- =====================================================================
-- SECTION H. RIGHT JOIN
-- =====================================================================

-- ---------------------------------------------------------------------
-- [H1] All products, with or without order_details
-- Purpose : List every product, showing order-line data when the product has been sold and NULLs for products that have never been ordered.
-- Note   : MySQL and PostgreSQL fully support RIGHT JOIN. SQLite only added RIGHT/FULL OUTER JOIN support from version 3.39.0 (2022) onward - on older SQLite builds this query must be rewritten as a LEFT JOIN with the FROM/JOIN tables swapped: `SELECT ... FROM products p LEFT JOIN order_details od ON od.product_id = p.product_id`.
-- ---------------------------------------------------------------------
SELECT p.product_id, p.product_name, od.detail_id, od.order_id, od.quantity
FROM order_details od
RIGHT JOIN products p ON od.product_id = p.product_id
ORDER BY p.product_id;


-- =====================================================================
-- SECTION I. Multiple Table JOIN
-- =====================================================================

-- ---------------------------------------------------------------------
-- [I1] Full 4-table join: Customer, Order, Product, Quantity, Price, Total
-- Purpose : Produce one flattened, human-readable row per purchased line item across all four tables at once.
-- ---------------------------------------------------------------------
SELECT
    c.name          AS customer_name,
    o.date          AS order_date,
    p.product_name  AS product_name,
    od.quantity     AS quantity,
    p.price         AS price,
    od.subtotal     AS total_amount
FROM customers c
INNER JOIN orders o        ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id   = od.order_id
INNER JOIN products p       ON od.product_id = p.product_id
ORDER BY o.order_id;


-- =====================================================================
-- SECTION J. Subqueries
-- =====================================================================

-- ---------------------------------------------------------------------
-- [J1] Products priced above the average price
-- Purpose : Identify premium products that cost more than the catalogue average.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, category, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- ---------------------------------------------------------------------
-- [J2] Customer with the highest total purchase amount
-- Purpose : Find the single customer who has spent the most money overall.
-- ---------------------------------------------------------------------
SELECT customer_id, name
FROM customers
WHERE customer_id = (
    SELECT o.customer_id
    FROM orders o
    GROUP BY o.customer_id
    ORDER BY SUM(o.total) DESC
    LIMIT 1
);

-- ---------------------------------------------------------------------
-- [J3] Orders with a total above the average order amount
-- Purpose : List orders that are larger than a typical order.
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, date, total
FROM orders
WHERE total > (SELECT AVG(total) FROM orders)
ORDER BY total DESC;

-- ---------------------------------------------------------------------
-- [J4] The single most expensive product
-- Purpose : Identify the top-priced product in the catalogue.
-- ---------------------------------------------------------------------
SELECT product_id, product_name, category, price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- ---------------------------------------------------------------------
-- [J5] Customers who have never placed an order
-- Purpose : Find inactive customers who registered but never checked out.
-- ---------------------------------------------------------------------
SELECT customer_id, name, city, province
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
);


-- =====================================================================
-- SECTION K. Views
-- =====================================================================

-- ---------------------------------------------------------------------
-- [K1_create] Create view: Customer_Order_Summary
-- Purpose : Create a reusable view summarising every customer's order count and lifetime spend.
-- ---------------------------------------------------------------------
CREATE VIEW Customer_Order_Summary AS
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id)        AS total_orders,
    COALESCE(SUM(o.total),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ---------------------------------------------------------------------
-- [K1_select] Query the Customer_Order_Summary view
-- Purpose : Show the per-customer summary produced by the view.
-- ---------------------------------------------------------------------
SELECT * FROM Customer_Order_Summary
ORDER BY total_spent DESC;

-- ---------------------------------------------------------------------
-- [K2_create] Create view: Product_Sales
-- Purpose : Create a view showing how many units of each product have sold and the revenue generated.
-- ---------------------------------------------------------------------
CREATE VIEW Product_Sales AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COALESCE(SUM(od.quantity), 0) AS units_sold,
    COALESCE(SUM(od.subtotal), 0) AS revenue
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category;

-- ---------------------------------------------------------------------
-- [K2_select] Query the Product_Sales view
-- Purpose : Rank products by revenue using the view.
-- ---------------------------------------------------------------------
SELECT * FROM Product_Sales
ORDER BY revenue DESC;

-- ---------------------------------------------------------------------
-- [K3_create] Create view: Revenue_Report
-- Purpose : Create a view that reports order volume and revenue per calendar month.
-- ---------------------------------------------------------------------
CREATE VIEW Revenue_Report AS
SELECT
    SUBSTR(o.date, 1, 7)      AS sales_month,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(o.total)               AS monthly_revenue
FROM orders o
GROUP BY SUBSTR(o.date, 1, 7);

-- ---------------------------------------------------------------------
-- [K3_select] Query the Revenue_Report view
-- Purpose : Display the monthly revenue trend using the view.
-- ---------------------------------------------------------------------
SELECT * FROM Revenue_Report
ORDER BY sales_month;


-- =====================================================================
-- SECTION L. Indexes
-- =====================================================================

-- ---------------------------------------------------------------------
-- [L1] Index on orders.customer_id
-- Purpose : Speed up lookups and joins that filter or join on customer_id.
-- ---------------------------------------------------------------------
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

-- ---------------------------------------------------------------------
-- [L2] Index on order_details.order_id
-- Purpose : Speed up joining order_details back to orders.
-- ---------------------------------------------------------------------
CREATE INDEX idx_orderdetails_order_id ON order_details (order_id);

-- ---------------------------------------------------------------------
-- [L3] Index on order_details.product_id
-- Purpose : Speed up joining order_details to products and computing per-product sales.
-- ---------------------------------------------------------------------
CREATE INDEX idx_orderdetails_product_id ON order_details (product_id);

-- ---------------------------------------------------------------------
-- [L4] Index on products.category
-- Purpose : Speed up category-based filters and GROUP BY category reports.
-- ---------------------------------------------------------------------
CREATE INDEX idx_products_category ON products (category);


-- =====================================================================
-- SECTION M. Business Analysis
-- =====================================================================

-- ---------------------------------------------------------------------
-- [M1] Top 10 selling products (by quantity sold)
-- Purpose : Identify the 10 products selling the highest number of units.
-- ---------------------------------------------------------------------
SELECT p.product_id, p.product_name, SUM(od.quantity) AS units_sold
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 10;

-- ---------------------------------------------------------------------
-- [M2] Highest revenue-generating products
-- Purpose : Identify which products earn the most money, not just sell the most units.
-- ---------------------------------------------------------------------
SELECT p.product_id, p.product_name, SUM(od.subtotal) AS revenue
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- ---------------------------------------------------------------------
-- [M3] Monthly sales trend
-- Purpose : Track how order volume and revenue change month over month.
-- ---------------------------------------------------------------------
SELECT SUBSTR(o.date, 1, 7) AS sales_month,
       COUNT(DISTINCT o.order_id) AS orders_count,
       SUM(o.total) AS monthly_revenue
FROM orders o
GROUP BY SUBSTR(o.date, 1, 7)
ORDER BY sales_month;

-- ---------------------------------------------------------------------
-- [M4] Customer-wise total spending
-- Purpose : Rank every customer by how much they have spent in total.
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.name, COALESCE(SUM(o.total),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- ---------------------------------------------------------------------
-- [M5] Average order value (overall)
-- Purpose : Report the typical amount a customer spends per order.
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(total), 2) AS average_order_value
FROM orders;

-- ---------------------------------------------------------------------
-- [M6] Best customer (highest total spend)
-- Purpose : Single out the single highest-value customer for loyalty recognition.
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.name, SUM(o.total) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1;

-- ---------------------------------------------------------------------
-- [M7] Least selling products (bottom 10 by quantity)
-- Purpose : Flag underperforming products that may need promotion or delisting.
-- ---------------------------------------------------------------------
SELECT p.product_id, p.product_name, COALESCE(SUM(od.quantity),0) AS units_sold
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold ASC
LIMIT 10;

-- ---------------------------------------------------------------------
-- [M8] Most ordered product category
-- Purpose : Determine which product category customers buy the most.
-- ---------------------------------------------------------------------
SELECT p.category, SUM(od.quantity) AS units_sold
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY units_sold DESC
LIMIT 1;


-- =====================================================================
-- END OF FILE
-- =====================================================================
