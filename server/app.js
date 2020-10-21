const firebase = require('firebase-admin');
const express = require('express')
const app = express()
const bodyParser = require('body-parser')
const port = 3000

app.use(bodyParser.json());

const serviceAccount = require("./sportify-8d62e-firebase-adminsdk-sgz9l-882a9b2759.json");

const config = {
  apiKey: "AIzaSyC57XIbeDE6hgHYLulW7Pcyy-OHvnKEnu4",
  credential: firebase.credential.cert(serviceAccount),
  authDomain: "sportify-8d62e.firebaseapp.com",
  databaseURL: "https://sportify-8d62e.firebaseio.com",
  storageBucket: "sportify-8d62e.appspot.com"
};
firebase.initializeApp(config);

const database = firebase.database();

app.get('/', (req, res) => {
  res.send('I am the sportify server.');
})

app.get('/login', (req, res) => {
  res.sendStatus(200);
})

app.post('/user/profile', (req, res) => {
  const {utorid, firstName, lastName, birthdate, bio, sportsInterests, favoriteTeam} = req.body;

  if (!(utorid && firstName && lastName && birthdate && bio && sportsInterests && favoriteTeam)) {
    console.log(utorid, firstName, lastName, birthdate, bio, sportsInterests, favoriteTeam);
    return res.sendStatus(400);
  }

  const postData = {
    utorid : utorid,
    firstName: firstName,
    lastName: lastName,
    birthdate: birthdate,
    bio: bio,
    sportsInterests: sportsInterests,
    favoriteTeam: favoriteTeam,
  };

  var updates = {};
  updates['/users/' + postData.utorid] = postData;
  firebase.database().ref().update(updates);

  return res.sendStatus(200);
})

app.listen(port, () => {
  console.log(`Sportify server listening at http://localhost:${port}`)
})


