const connection = require('../database/db');
const express    = require('express');
const router     = express.Router();

router.post('/login', (req, res) => {
    let query = 'CALL get_user(?, ?)';
    let email = req.body.email;
    let password = req.body.password;

    connection.query(query, [email, password], (err, results) => {
        if (err) {
            console.log(err);
            return
        }
        res.json(results[0][0]);
    });
});

router.post('/register', (req, res) => {
    let query = 'CALL insert_user(?, ?, ?, ?, ?)';
    let values = [
        req.body.nControl,
        req.body.name,
        req.body.lastName,
        req.body.email,
        req.body.password
    ];

    connection.query(query, values, (err, results) => {
        if (err) return res.status(500).send(err);
        return res.status(200).send(results[0][0]);
    });
});

module.exports = router