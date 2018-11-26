DROP DATABASE IF EXISTS db;
CREATE DATABASE IF NOT EXISTS db;
USE db;

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
