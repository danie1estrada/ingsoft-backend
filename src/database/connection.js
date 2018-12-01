const mysql = require('mysql');

const connection = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: 'admin',
    database: 'bazar_tec'
});

connection.connect(err => {
    if (err) {
        console.error('An error has ocurred while connecting to the database.');
        return;
    }
    console.log('Successfully connected!');
});

module.exports = connection;