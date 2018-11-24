const routes  = require('./routes/routes.index')
const express = require('express')
const app     = express()

// routes
app.use('/api', routes)

app.listen(3000, () => {
    console.log('Server running...')
})