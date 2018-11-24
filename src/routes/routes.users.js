const connection = require('../database/db')
const express    = require('express')
const router     = express.Router()

router.post('/login', (req, res) => {
    let query = 'CALL get_user(?, ?)'
    let email = req.body.email
    let password = req.body.password

    connection.query(query, [email, password], (err, results, fields) => {
        if (err) {
            console.log(err)
            return
        }
        res.json(results[0][0])
    })
})

module.exports = router