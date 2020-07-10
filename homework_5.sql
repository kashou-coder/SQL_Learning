
-- обновил тип данны поля телефон
ALTER TABLE vk_social.users MODIFY COLUMN phone VARCHAR(255) NULL;

-- добавил стольцы имя и фамилия
ALTER TABLE vk_social.users ADD name varchar(100) NOT NULL;
ALTER TABLE vk_social.users ADD surname varchar(100) NOT NULL;

-- добавил столбцы с неверным типом данных
ALTER TABLE vk_social.users ADD created_at varchar(100) NOT NULL;
ALTER TABLE vk_social.users ADD updated_at varchar(100) NOT NULL;


-- удалил столбцы с неверным типом данных
ALTER TABLE vk_social.users DROP COLUMN created_at;
ALTER TABLE vk_social.users DROP COLUMN updated_at;

-- создал столбцы с текущей датой
ALTER TABLE vk_social.users ADD created_at TIMESTAMP NOT NULL;
ALTER TABLE vk_social.users ADD updated_at TIMESTAMP NOT NULL;

ALTER TABLE vk_social.users MODIFY COLUMN updated_at DATETIME DEFAULT NOW() NOT NULL;



-- 2. Магазин инструментов


use shop_1;
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Processors'),
  (NULL, 'Motherboards'),
  (NULL, 'video card'),
  (NULL, 'hard drive'),
  (NULL, 'RAM');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'user name',
  birthday_at DATE COMMENT 'user birthday',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'customers';

INSERT INTO users (name, birthday_at) VALUES
  ('Gennadiy', '1990-10-05'),
  ('Nataly', '1984-11-12'),
  ('Alex', '1985-05-20'),
  ('Sergey', '1988-02-14'),
  ('Ivan', '1998-01-12'),
  ('Mary', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Goods positions';

INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'processors for the desktop pcs.', 7890.00, 1),
  ('Intel Core i5-7400', 'processors for the desktop pcs on the platform Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'processors for the desktop pcs on the platform AMD.', 4780.00, 1),
  ('AMD FX-8320', 'processors for the desktop pcs on the platform AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Motherboard ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Motherboard Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Motherboard MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Orders';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Amount orders',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Order structure';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Discount from 0.0 to 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Discounts';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Title',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Warehouses';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Inventory of a product item in a warehouse',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Inventory in stock';


-- Сортировка

select * from storehouses_products order by value desc; 

-- Подсчитайте средний возраст пользователей в таблице users

SELECT
  birthday_at,
  (
    (YEAR(CURRENT_DATE) - YEAR(birthday_at)) -                             /* step 1 */
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday_at, '%m%d')) /* step 2 */
  ) AS age
FROM users order by age;

