const bodyParser = require('body-parser')
const express    = require('express')
const router     = express.Router()

router.use(bodyParser.urlencoded({ extended: false }))
router.use(bodyParser.json())

router.use('/users', require('./routes.users'))
router.use('/products', require('./routes.products'))

module.exports = router

