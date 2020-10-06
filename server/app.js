const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('I am the sportify server.')
})

app.listen(port, () => {
  console.log(`Sportify server listening at http://localhost:${port}`)
})