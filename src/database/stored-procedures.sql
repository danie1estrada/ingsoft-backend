USE db;

DELIMITER //

/**
 * @author Daniel Estrada
 * @description Inserts a new user to the database
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
    `email` VARCHAR(45),
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
    
    SELECT
		`id` as 'id',
        `nControl` as 'nControl',
        `name` as 'name',
        `lastName` as 'lastName',
        `email` as 'email',
        `role` as 'role'
	FROM
		`users`
    WHERE
		`users`.`id` = LAST_INSERT_ID();
END //

/**
 * @author Daniel Estrada
 * @description Get an user from the database using its email and password as credentials
 * @param email
 * @param password
 */
CREATE PROCEDURE `get_user` (
	`userEmail` VARCHAR(30),
    `userPassword` VARCHAR(32)
)
BEGIN
	SELECT
		`id`,
        `nControl`,
        `name`,
        `lastName`,
        `email`,
        `role`
	FROM
		`users`
    WHERE
		`users`.`email` = userEmail
	AND
        `users`.`password` = userPassword;
END //

CREATE PROCEDURE `insert_product` (
	`name` VARCHAR(45),
    `description` TEXT,
    `price` DECIMAL(6, 2),
    `vendorID`INT(8),
    `categoryID` INT(8),
    `image` VARCHAR(50) 
)
BEGIN
	INSERT INTO `products` (
		`name`,
		`description`,
		`price`,
        `vendorID`,
		`categoryID`,
        `image`
    )
    VALUES (
		`name`,
		`description`,
		`price`,
        `vendorID`,
		`categoryID`,
        `image`
    );
    
    SELECT LAST_INSERT_ID() AS 'insertedID';
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