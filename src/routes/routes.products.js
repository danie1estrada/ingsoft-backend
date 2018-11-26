const connection = require('../database/db');
const express    = require('express');
const router     = express.Router();

router.get('/', (req, res) => {
    let query = 'SELECT * FROM vw_products';

    connection.query(query, (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).json(results);
    });
});

router.get('/categories', (req, res) => {
    let query = 'SELECT * FROM categories';

    connection.query(query, (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).json(results);
    });
});

router.post('/shopping-cart', (req, res) => {
    let query = 'CALL get_cart(?)';

    connection.query(query, [req.body.userID], (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).json(results[0]);
    });
});

router.get('/:id', (req, res) => {
    let query = 'CALL get_product_by_id(?)';

    connection.query(query, [req.params.id], (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).json(results[0]);
    });
});

router.get('/categories/:id', (req, res) => {
    let query = 'CALL get_products_by_category(?)';

    connection.query(query, [req.params.id], (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).json(results[0]);
    });
});

router.post('/', (req, res) => {
    let query = 'CALL insert_product(?, ?, ?, ?, ?, ?)';
    let values = [
        req.body.name,
        req.body.description,
        req.body.price,
        req.body.vendorID,
        req.body.categoryID,
        null
    ]

    connection.query(query, values, (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).json(results[0][0]);
    });
});

router.post('/add-to-cart', (req, res) => {
    let query = 'CALL add_to_cart(?, ?, ?)';
    let values = [
        req.body.purchaserID,
        req.body.productID,
        req.body.quantity
    ];

    connection.query(query, values, (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).json(results);
    });
});

module.exports = router;