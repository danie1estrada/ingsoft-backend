const connection = require('../database/db')
const express    = require('express')
const router     = express.Router()

router.get('/', (req, res) => {
    let query = 'SELECT * FROM vw_products';

    connection.query(query, (err, results) => {
        if (err) return res.status(500).send('Server error');
        res.status(200).json(results);
    })
})

router.get('/:id', (req, res) => {
    let query = 'CALL get_product_by_id(?)'

    connection.query(query, [req.params.id], (err, results) => {
        if (err) return res.status(500).send('Server error');
        res.status(200).json(results[0]);
    })
})

router.get('/categories/:id', (req, res) => {
    let query = 'CALL get_products_by_category(?)'

    connection.query(query, [req.params.id], (err, results) => {
        if (err) return res.status(500).send('Server error');
        res.status(200).json(results[0]);
    })
})

module.exports = router