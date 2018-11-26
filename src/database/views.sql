USE db;

CREATE VIEW `vw_products`
AS
SELECT
	p.`id`,
	p.`name`,
	p.`description`,
    p.`price`,
    p.`image`,
    p.`categoryID`,
    c.`categoryName`,
    p.`vendorID`,
    concat(u.`name`, ' ', u.`lastName`) AS `vendor`
FROM
	`products` p INNER JOIN
    `categories` c INNER JOIN
    `users` u
ON
	p.`categoryID` = c.`id`
AND
	p.`vendorID` = u.`id`;
    
CREATE VIEW `vw_shopping_cart`
AS
SELECT
		sc.`purchaserID`,
		p.`id` AS `productID`,
		p.`name`,
		p.`description`,
		p.`price`,
		sc.`quantity`,
		sc.`quantity` * p.`price` AS 'amount'
	FROM
		`shopping_cart` sc INNER JOIN
		`products` p
	ON
		sc.`productID` = p.`id`;
        
CREATE VIEW `vw_purchases`
AS
SELECT
	p.`id`,
	p.`name`,
    p.`price`,
    s.`date`,
    s.`purchaserID`
FROM
	`sales` s INNER JOIN
    `users` u INNER JOIN
    `products` p
ON
	s.`productID` = p.`id` AND
    s.`purchaserID`= u.`id`;
	

-- mandarle a esau el curso y libro
