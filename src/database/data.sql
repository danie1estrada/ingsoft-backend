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
CALL insert_user(18241962, 'Peter',   'Parker', 'peter.parker@dailybugle.com',           'spiderman');
CALL insert_user(16241939, 'Bruce',   'Wayne',  'bruce_wayne@wayneenterprises.com',      'imbatman');
CALL insert_user(15241938, 'Clark',   'Kent',   'clark_kent@dailyplanet.com',            'superman');
CALL insert_user(15241963, 'Anthony', 'Stark',  'tony.stark@starkindustries.com',        'ironman');
CALL insert_user(16242001, 'Jessica', 'Jones',  'jessica.jones@aliasinvestigations.com', 'jewel');
CALL insert_user(17241941, 'Diana',   'Prince', 'diana_prince@gmail.com',                'wonderwoman');

-- CALL insert_product(name, description, price, id_vendor, id_category, image)
CALL insert_product('Protoboard',          'Nuevo', 60,   2, 2, null);
CALL insert_product('Cálculo Diferencial', 'G. Zill 8va edición',  150,  2, 1, null);
CALL insert_product('Arduino',             'Nuevo',                280,  2, 2, null);
CALL insert_product('Laptop',              '14" Core i5, 8 RAM',   8000, 2, 4, null);
CALL insert_product('Java Cómo Programar', 'Deitel 4ta edición',   200,  2, 1, null);
-- CALL insert_product('', '', 0, 0, 0, null);
-- CALL insert_product('', '', 0, 0, 0, null);
-- CALL insert_product('', '', 0, 0, 0, null);
-- CALL insert_product('', '', 0, 0, 0, null);

-- CALL add_to_cart(id_purchaser, id_product, quantity)
CALL add_to_cart(1, 3, 2);
CALL add_to_cart(1, 1, 2);
CALL add_to_cart(1, 5, 1);
CALL add_to_cart(1, 2, 1);