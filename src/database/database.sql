/*******************************************************************************
                                BASE DE DATOS
*******************************************************************************/
DROP DATABASE IF EXISTS bazar_tec;
CREATE DATABASE IF NOT EXISTS bazar_tec;
USE bazar_tec;

CREATE TABLE `users` (
    `id` INT(8) NOT NULL AUTO_INCREMENT,
    `nControl` INT(8) NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    `lastName` VARCHAR(30) NOT NULL,
    `email` VARCHAR(45) NOT NULL,
    `password` VARCHAR(32) NOT NULL,
    `role` VARCHAR(5) DEFAULT 'user',
    UNIQUE(`nControl`),
    UNIQUE(`email`),
    PRIMARY KEY (`id`)
);

CREATE TABLE `categories` (
    `id` INT(8) NOT NULL AUTO_INCREMENT,
    `categoryName` VARCHAR(35) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `products` (
    `id` INT(8) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `description` TEXT NOT NULL,
    `price` DECIMAL(6, 2) NOT NULL,
    `image` VARCHAR(50) DEFAULT 'default-image',
    `vendorID` INT(8) NOT NULL,
    `categoryID` INT(8) NOT NULL,
    `status` CHAR(1) DEFAULT 'a',
    PRIMARY KEY (`id`),
    FOREIGN KEY (`vendorID`) REFERENCES `users` (`id`),
    FOREIGN KEY (`categoryID`) REFERENCES `categories` (`id`)
);

CREATE TABLE `shopping_cart` (
    `vendorID` INT(8) NOT NULL,
    `purchaserID` INT(8) NOT NULL,
    `productID` INT(8) NOT NULL,
    `quantity` TINYINT NOT NULL,
    PRIMARY KEY (`purchaserID`, `productID`),
    FOREIGN KEY (`vendorID`) REFERENCES `users` (`id`),
    FOREIGN KEY (`purchaserID`) REFERENCES `users` (`id`),
    FOREIGN KEY (`productID`) REFERENCES `products` (`id`)
);

CREATE TABLE `sales` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `vendorID` INT(8) NOT NULL,
    `purchaserID` INT(8) NOT NULL,
    `productID` INT(8) NOT NULL,
    `quantity` TINYINT NOT NULL,
    `date` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`vendorID`) REFERENCES `users` (`id`),
    FOREIGN KEY (`purchaserID`) REFERENCES `users` (`id`),
    FOREIGN KEY (`productID`) REFERENCES `products` (`id`)
);

/*******************************************************************************
                                   VISTAS
*******************************************************************************/

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
	p.`vendorID` = u.`id`
WHERE
	`status` = 'a';
    
CREATE VIEW `vw_shopping_cart`
AS
SELECT
		sc.`purchaserID`,
		p.`id` AS `productID`,
		p.`name`,
		p.`description`,
		p.`price`,
        u.`email` as `vendorEmail`,
		sc.`quantity`,
		sc.`quantity` * p.`price` AS 'amount'
	FROM
		`shopping_cart` sc INNER JOIN
		`products` p INNER JOIN
        `users` u
	ON
		sc.`productID` = p.`id`
	AND
		p.`vendorID` = u.`id`;
        
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
	
/*******************************************************************************
                         PROCEDIMIENTOS ALMACENADOS
*******************************************************************************/

DELIMITER //

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
        
	UPDATE
		`products`
	INNER JOIN
		`shopping_cart`
    ON
		`products`.`id` = `shopping_cart`.`productID`
	SET
		`status` = 's'
	WHERE
		`shopping_cart`.`purchaserID` = `purchaserID`;
	
	DELETE FROM
		`shopping_cart`
    WHERE
		`shopping_cart`.`purchaserID`= `purchaserID`;
END //

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
        `amount`,
        `vendorEmail`
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

/*******************************************************************************
                                  REGISTROS
*******************************************************************************/
INSERT INTO `categories` (`categoryName`) VALUES ('Libros');
INSERT INTO `categories` (`categoryName`) VALUES ('Componentes Electrónicos');
INSERT INTO `categories` (`categoryName`) VALUES ('Oficina y Papelería');
INSERT INTO `categories` (`categoryName`) VALUES ('Cómputo');
INSERT INTO `categories` (`categoryName`) VALUES ('Celulares y Accesorios');
INSERT INTO `categories` (`categoryName`) VALUES ('Instrumentos Musicales');
INSERT INTO `categories` (`categoryName`) VALUES ('Software y Videojuegos');
INSERT INTO `categories` (`categoryName`) VALUES ('Deportes');
INSERT INTO `categories` (`categoryName`) VALUES ('Varios');

-- CALL insert_user(nControl, name, lastName, email, password)
CALL insert_user(16241162, 'Josepha', 'Tostado', 'tostadoskate96@gmail.com', '16241162');
CALL insert_user(16240919, 'Daniel', 'Estrada', 'dannesr97@gmail.com', 'cthulhu');
CALL insert_user(16240370, 'Andrés', 'Moreno', 'a.deus.ex.machina@outlook.com', 'Angelsdie');

-- CALL insert_product(name, description, price, id_vendor, id_category, image)
CALL insert_product('Protoboard',          'Nuevo', 60,   2, 2, null);
CALL insert_product('Cálculo Diferencial', 'G. Zill 8va edición',  150,  2, 1, null);
CALL insert_product('Arduino',             'Nuevo',                280,  2, 2, null);
CALL insert_product('Laptop',              '14" Core i5, 8 RAM',   8000, 2, 4, null);
CALL insert_product('Java Cómo Programar', 'Deitel 4ta edición',   200,  2, 1, null);
-- CALL insert_product('', '', 0, 0, 0, null);

-- CALL add_to_cart(id_purchaser, id_product, quantity)
CALL add_to_cart(1, 3, 2);
CALL add_to_cart(1, 1, 2);
CALL add_to_cart(1, 5, 1);
CALL add_to_cart(3, 2, 1);