const routes  = require('./routes/routes.index');
const express = require('express');
const app     = express();

// middlewares
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', '*');
    res.header('Access-Control-Allow-Headers', '*');
    next();
})

// routes
app.use('/api', routes);

app.listen(3000, () => {
    console.log('Server running...');
});