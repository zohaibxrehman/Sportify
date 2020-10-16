var admin = require('firebase-admin');
const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('I am the sportify server.')
})

app.get('/login', (req, res) => {
  res.sendStatus(200);
})

app.listen(port, () => {
  console.log(`Sportify server listening at http://localhost:${port}`)
})

var serviceAccount = require("/Users/bhavikkothari/Desktop/Sportify/server/sportify-8d62e-firebase-adminsdk-sgz9l-882a9b2759.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://sportify-8d62e.firebaseio.com"
});
