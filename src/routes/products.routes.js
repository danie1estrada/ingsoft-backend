const connection = require('../database/connection');
const nodemailer = require('nodemailer');
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
        if (results[0].length == 0) return res.status(404).send({ Error: '404 Not found' });
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
    if (!req.files) {
        return res.status(400).json({
            ok: false,
            status: 400,
            message: 'No files were uploaded'
        });
    }
    
    let allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    let image = req.files.image;
    let name = image.name.split('.');
    let extension = name[name.length - 1].toLowerCase();
    let filename = `${new Date().toISOString().replace(/:/g, '-').replace('.', '-')}.${extension}`;

    if (!allowedExtensions.includes(extension)) {
        return res.status(400).json({
            ok: false,
            status: 400,
            message: `Invalid file extension: .${extension}`
        });
    }

    image.mv(`public/images/${filename}`, err => {
        if (err) return res.status(500).json(err);

        let query = 'CALL insert_product(?, ?, ?, ?, ?, ?)';
        let values = [
            req.body.name,
            req.body.description,
            req.body.price,
            req.body.vendorID,
            req.body.categoryID,
            filename
        ]

        connection.query(query, values, (err, results) => {
            if (err) {
                return res.status(500).json({
                    ok: false,
                    status: 500,
                    err
                });
            }
            res.status(200).json(results[0][0]);
        });
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
        if (err) return res.status(500).json(err);
        res.status(200).json(results);
    });
});

router.post('/purchase', (req, res) => {
    let query = 'CALL purchase(?)';

    let product = req.body.product;
    let vendorEmail = req.body.vendorEmail;
    let purchaserEmail = req.body.purchaserEmail;

    let transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'itl.bazar.tec@gmail.com',
            pass: '8caracteres'
        }
    });
    
    let mailOptions = {
        from: '"BazarTec" <itl.bazar.tec@gmail.com>',
        to: vendorEmail,
        subject: `Ha aparecido un comprador para tu artículo '${product}'`,
        text: `Hola, te informamos que ha aparecido un comprador para tu artículo '${product}'. Comunícate con el comprador al correo: ${purchaserEmail}`
    };
    
    connection.query(query, [req.body.purchaserID], (err, results) => {
        if (err) return res.status(500).json(err);

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) return res.status(500).json(error);
            res.status(200).json({ ok: true, info });
        });
    });
});

module.exports = router;