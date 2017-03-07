-- [Problem 5]
DROP TABLE IF EXISTS purchase_items;
DROP TABLE IF EXISTS sales_items;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS club_members;
DROP TABLE IF EXISTS stores;
DROP FUNCTION IF EXISTS check_membership;
DROP VIEW IF EXISTS store_revenues;
DROP VIEW IF EXISTS frequent_visitors;

-- [Problem 1]
CREATE TABLE club_members (
  member_id           CHAR(10) NOT NULL,
  member_name         VARCHAR(50) NOT NULL,
  member_address      VARCHAR(75) NOT NULL,
  member_city         VARCHAR(50) NOT NULL,
  member_state        VARCHAR(2) NOT NULL,
  member_zipcode      CHAR(5) NOT NULL,
  member_phone_number CHAR(10) NOT NULL,
  join_date           TIMESTAMP NOT NULL,
  PRIMARY KEY (member_id));
  
CREATE TABLE stores (
  store_id            CHAR(10) NOT NULL,
  store_address       VARCHAR(75) NOT NULL,
  store_city          VARCHAR(50) NOT NULL,
  store_state         VARCHAR(2) NOT NULL,
  store_zipcode       CHAR(5) NOT NULL,
  store_phone_number  CHAR(10) NOT NULL,
  PRIMARY KEY (store_id));
  
CREATE TABLE sales_items (
  item_sku            CHAR(10) NOT NULL,
  item_name           VARCHAR(50) NOT NULL,
  item_category       VARCHAR(50) NOT NULL,
  standard_price      NUMERIC(4,2) NOT NULL,
  club_price          NUMERIC(4,2) NOT NULL,
  PRIMARY KEY (item_sku));
  
CREATE TABLE purchases (
  purchase_id         CHAR(12) NOT NULL,
  store_id            CHAR(10) NOT NULL,
  sale_timestamp      TIMESTAMP NOT NULL,
  register_number     CHAR(5) NOT NULL,
  purchase_total      NUMERIC(6,2) NOT NULL,
  member_id           CHAR(10),
  PRIMARY KEY (purchase_id),
  FOREIGN KEY (store_id) REFERENCES stores (store_id),
  FOREIGN KEY (member_id) REFERENCES club_members (member_id));
  
CREATE TABLE purchase_items (
  item_id             INTEGER NOT NULL AUTO_INCREMENT,
  purchase_id         CHAR(12) NOT NULL,
  item_sku            CHAR(10) NOT NULL,
  item_price          NUMERIC(4,2),
  other_discounts     NUMERIC(4,2),
  PRIMARY KEY (item_id),
  FOREIGN KEY (purchase_id) REFERENCES purchases (purchase_id),
  FOREIGN KEY (item_sku)  REFERENCES sales_items (item_sku));

-- [Problem 2]
DELIMITER !
/* This Function sets the price of an item to either the club_price
 * or the standard_price depending on whether the purchaser of the
 * item is a club_member or not
 */
CREATE FUNCTION check_membership (member_id CHAR(10), item_sku CHAR(10))
  RETURNS NUMERIC(4,2)
BEGIN

  DECLARE item_price NUMERIC(4,2);
  
/* If the item_sku is not recognized in the sales_item
 * table, then we don't know how much the item should
 * be worth, so we return NULL.
 */
  IF item_sku NOT IN (SELECT item_sku FROM sales_items) THEN
    RETURN NULL;
  END IF;
  
-- The following sets the item_price based on club membership.
  IF member_id IS NOT NULL AND
    member_id IN (SELECT member_id FROM club_members) THEN
      SET item_price = (SELECT club_price FROM sales_items
        WHERE sales_items.item_sku = item_sku);
  ELSE
    SET item_price = (SELECT standard_price FROM sales_items
      WHERE sales_items.item_sku = item_sku);
  END IF;
  
  return item_price;
END !

DELIMITER ;

-- [Problem 3]
CREATE VIEW store_revenues AS
  SELECT store_id,
         store_address,
         store_city,
         store_state,
         store_zipcode,
         SUM(purchase_total) AS total_sales
         FROM stores NATURAL LEFT JOIN purchases GROUP BY store_id
    ORDER BY total_sales DESC;
    
-- [Problem 4]
/* The following view selects the certain attributes of a customer(s)
 * who have the most amount of purchases at each specific store
 */
CREATE VIEW frequent_visitors AS
  SELECT store_id, member_id, member_name, join_date,
  MAX(num_purchases) AS num_purchases FROM(
    SELECT store_id,
           member_id,
           member_name,
           join_date,
           COUNT(purchase_id) AS num_purchases
           FROM purchases NATURAL JOIN club_members
           GROUP BY store_id,member_id
      ORDER BY store_id, num_purchases DESC)
    AS freq_vis GROUP BY store_id, member_id;