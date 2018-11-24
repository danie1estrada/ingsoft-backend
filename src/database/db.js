const mysql = require('mysql')

const connection = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: 'admin',
    database: 'db'
})

connection.connect(err => {
    if (err) {
        console.log(err)
        return
    }
    console.log('Successfully connected!')
})

module.exports = connection