-- [Problem 1]
SELECT * FROM club_members
  WHERE DATE_SUB(CURDATE(),INTERVAL 14 DAY) <= join_date;


-- [Problem 2]
SELECT club_members.* FROM club_members NATURAL JOIN purchases
  WHERE DATE_SUB(CURDATE(),INTERVAL 3 MONTH) <= join_date GROUP BY member_id
  HAVING SUM(purchase_total) <= 10.00;


-- [Problem 3]
DELETE FROM purchase_items WHERE purchase_id IN
  (SELECT purchase_id FROM purchases WHERE member_id = 535210);

DELETE FROM purchases WHERE member_id = 535210;

DELETE FROM club_members WHERE member_id = 535210;

-- [Problem 4]
/* This UPDATE sets the club_price of an item that often has
 * other discounts used on it - such that the average price
 * of the object is less than 60% of the standard price - to
 * the standard_price
 */
UPDATE sales_items
  SET club_price = standard_price
  WHERE item_sku IN(
    SELECT item_sku FROM(
    SELECT item_sku, AVG(item_price - other_discounts) / standard_price
    AS discrepancy
    FROM sales_items NATURAL JOIN purchase_items GROUP BY item_sku) AS tester
    WHERE discrepancy <= 0.6);


-- [Problem 5]
/* This query returns the members who have had purchases where
 * they have purchased an item from every category the store has
 * it also returns the number of times they have done this.
 */
SELECT member_id, COUNT(*) AS num_complete_purchases FROM(
  SELECT *, COUNT(DISTINCT item_category) AS category
  FROM purchases NATURAL JOIN purchase_items NATURAL JOIN sales_items
  GROUP BY purchase_id) AS purchase_table
    WHERE category =
     (SELECT COUNT(item_category) FROM sales_items);
