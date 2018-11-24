USE db;

DELIMITER //

/**
 * @author Daniel Estrada
 * @description Insert a new user to the database
 * @param n_control
 * @param name
 * @param last_name
 * @param email
 * @param password
 */
CREATE PROCEDURE `insert_user` (
    `nControl` INT(8),
    `name` VARCHAR(30),
    `lastName` VARCHAR(30),
    `email` VARCHAR(30),
    `password` VARCHAR(32)
)
BEGIN
    INSERT INTO `users` (
        `nControl`,
        `name`,
        `lastName`,
        `email`,
        `password`
    )
    VALUES (
        `nControl`,
        `name`,
        `lastName`,
        `email`,
        `password`
    );
END //

/**
 * @author Daniel Estrada
 * @description Get an user from the database using its email and password as credentials
 * @param email
 * @param password
 */
CREATE PROCEDURE `get_user` (
	`emailv` VARCHAR(30),
    `password` VARCHAR(32)
)
BEGIN
	SELECT
		`id`,
        `nControl`,
        `name`,
        `lastName`,
        `email`,
        `role`
	FROM `users`
    WHERE
		`users`.`email` = `emailv`
	AND
        `users`.`password` = `password`;
END //

CREATE PROCEDURE `insert_product` (
	`name` VARCHAR(25),
    `description` TEXT,
    `price` DECIMAL(6, 2),
    `vendorID`INT(8),
    `categoryID` INT(8)
)
BEGIN
	INSERT INTO `products` (
		`name`,
		`description`,
		`price`,
        `vendorID`,
		`categoryID`
    )
    VALUES (
		`name`,
		`description`,
		`price`,
        `vendorID`,
		`categoryID`
    );
END //

CREATE PROCEDURE get_product_by_id (
	`productID` INT(8)
)
BEGIN
	SELECT * FROM
		`vw_products`
    WHERE
		`id` = `productID`;
END //

CREATE PROCEDURE get_products_by_category (
	`id` INT(8)
)
BEGIN
	SELECT * FROM
		`vw_products`
	WHERE
		`categoryID` = `id`;
END //

/**
 * @author Daniel Estrada
 * @description Add a product to the cart
 * @param id_purchaser
 * @param id_product
 * @param quantity
 */
CREATE PROCEDURE `add_to_cart` (
	`purchaserID` INT(8),
    `productID`INT(8),
    `quantity` TINYINT
)
BEGIN
	INSERT INTO `shopping_cart` (
		`purchaserID`,
		`productID`,
		`quantity`,
        `vendorID`
    )
    VALUES (
		`purchaserID`,
		`productID`,
		`quantity`,
        (SELECT `vendorID`
			FROM `products`
			WHERE `products`.`id` = `productID`)
    );
END //

CREATE PROCEDURE `purchase` (
	`purchaserID` INT(8)
)
BEGIN
	INSERT INTO `sales` (
		`vendorID`,
		`purchaserID`,
        `productID`,
        `quantity`
    )
    SELECT * FROM
		`shopping_cart`
    WHERE
		`shopping_cart`.`purchaserID` = `purchaserID`;
	
	DELETE FROM
		`shopping_cart`
    WHERE
		`shopping_cart`.`purchaserID`= `purchaserID`;
END //

/**
 * @author Daniel Estrada
 * @description Get the cart from a specific user
 * @param id_user
 */
CREATE PROCEDURE `get_cart` (
	`userID` INT(8)
)
BEGIN
	SELECT
		`productID`,
		`name`,
		`description`,
		`price`,
		`quantity`,
        `amount`
	FROM
		`vw_shopping_cart`
	WHERE
		`purchaserID` = `userID`;
END //

DROP PROCEDURE `purchases_by_user`;
DELIMITER //
CREATE PROCEDURE `purchases_by_user` (
	id INT(8)
)
BEGIN
	SELECT
		`id`,
		`name`,
		`price`,
		`date`
	FROM
		`vw_purchases`
	WHERE
		`purchaserID` = `id`;
END //

DELIMITER ;

CALL purchases_by_user(1);

INSERT INTO `categories` (`categoryName`) VALUES ('Libros');
INSERT INTO `categories` (`categoryName`) VALUES ('Electrónica');
INSERT INTO `categories` (`categoryName`) VALUES ('Papelería');
INSERT INTO `categories` (`categoryName`) VALUES ('Cómputo');
INSERT INTO `categories` (`categoryName`) VALUES ('Varios');

-- CALL insert_user(n_control, name, last_name, email, password)
CALL insert_user(16240919, 'Daniel', 'Estrada', 'dannesr97@gmail.com', 'cthulhu');
-- SELECT * FROM users;

-- CALL get_user(email, password)

-- CALL insert_product(name, description, price, id_vendor, id_category)
CALL insert_product('Protoboard',          'Semi nuevo, continuo', 60,   2, 2);
CALL insert_product('Cálculo Diferencial', 'G. Zill 8va edición',  150,  2, 1);
CALL insert_product('Arduino Uno',         'Nuevo',                280,  2, 2);
CALL insert_product('Laptop',              '14" Core i5, 8 RAM',   8000, 2, 4);
CALL insert_product('Java Cómo Programar', 'Deitel 4ta edición',   200,  2, 1);
-- SELECT * FROM products;

-- CALL add_to_cart(id_purchaser, id_product, quantity)
CALL add_to_cart(1, 3, 2);
CALL add_to_cart(1, 1, 2);
CALL add_to_cart(1, 5, 1);
CALL add_to_cart(1, 2, 1);

-- CALL purchase(id_purchaser)
CALL purchase(1);
-- CALL get_cart(1);
-- SELECT * FROM sales;

CALL get_cart(1);



