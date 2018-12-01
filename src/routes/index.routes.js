const bodyParser = require('body-parser');
const express    = require('express');
const router     = express.Router();

router.use(bodyParser.urlencoded({ extended: false }));
router.use(bodyParser.json());

router.use('/users', require('./users.routes'));
router.use('/products', require('./products.routes'));

module.exports = router;

