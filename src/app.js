const fileUpload = require('express-fileupload');
const routes     = require('./routes/index.routes');
const express    = require('express');
const path       = require('path');
const app        = express();

const port = process.env.PORT || 3000;

// middlewares
app.use(fileUpload());

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', '*');
    res.header('Access-Control-Allow-Headers', '*');
    next();
});

// routes
app.use('/public', express.static(path.join(__dirname, '..', 'public')));
app.use('/api', routes);

app.listen(port, () => {
    console.log(`Server running on port ${port}.`);
});