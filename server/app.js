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

app.post('/user/new', (req, res) => {
  const {utorid, firstName, lastName, birthdate, bio, sportsInterests, favoriteTeam} = req.body;

  if (!(utorid && firstName && lastName && birthdate && bio && sportsInterests && favoriteTeam)) {
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
    events: false
  };

  let updates = {};
  updates['/users/' + postData.utorid] = postData;
  firebase.database().ref().update(updates);

  return res.sendStatus(200);
})

app.get('/users/:id', (req, res) => {
  const userRef = firebase.database().ref('/users/' + req.params.id);
  userRef.once('value').then(function(snapshot) {
    return res.send(snapshot.val());
  }).catch(function(error) {
    return res.sendStatus(404);
  });
})

app.post('/event/new', (req, res) => {
  const {utorid, title, description, location} = req.body;

  if (!(utorid && title && description && location)) {
    return res.sendStatus(400);
  }

  const users = {};
  users[utorid] = true;

  const postData = {
    owner: utorid, 
    users: users,
    title: title,
    description: description,
    location: location,
  };

  let eventUpdates = {};
  const newEventId = firebase.database().ref().child('events').push().key;
  eventUpdates['/events/' + newEventId] = postData;
  firebase.database().ref().update(eventUpdates);

  let userUpdates = {};
  userUpdates['/users/' + utorid + '/events/' + newEventId] = true;
  firebase.database().ref().update(userUpdates);

  return res.sendStatus(200);
})

app.get('/events', (req, res) => {
  const eventRef = firebase.database().ref('/events');
  eventRef.once('value').then(function(snapshot) {
    return res.send(snapshot.val());
  }).catch(function(error) {
    return res.sendStatus(404);
  });
})

app.get('/events/:id', (req, res) => {
  const eventRef = firebase.database().ref('/events/' + req.params.id);
  eventRef.once('value').then(function(snapshot) {
    return res.send(snapshot.val());
  }).catch(function(error) {
    return res.sendStatus(404);
  });
})

app.listen(port, () => {
  console.log(`Sportify server listening at http://localhost:${port}`)
})


