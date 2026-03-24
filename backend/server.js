const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const path = require('path');
const City = require('./models/city.model');
const Trip = require('./models/trip.model');
const multer = require("multer");
const subpath = "/public/assets/images/activities";

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(__dirname, subpath));
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});
const upload = multer({
  storage,
});

app.use(cors());
mongoose.set('debug', true);
mongoose
  .connect(
    //"mongodb://jean:123@cluster0-shard-00-00-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-01-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-02-urpjt.gcp.mongodb.net:27017/dymatrip_emu?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority"
    //"mongodb://jean:123@cluster0-urpjt.mongodb.net/dymatrip_emu?retryWrites=true&w=majority"
    "mongodb://jean:123@cluster0-shard-00-00-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-01-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-02-urpjt.gcp.mongodb.net:27017/dymatrip_emu?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority",
    //"mongodb://jean:123@cluster0-urpjt.gcp.mongodb.net/dymatrip?retryWrites=true&w=majority" // version web
    //"mongodb://jean:123@cluster0-shard-00-00-urpjt.gcp.mongodb.net/dymatrip_emu?retryWrites=true&w=majority" // version avec emulateur
  )
  .then(() => console.log('connexion ok !'));

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

// get cities
app.get('/api/cities', async (req, res) => {
  try {
    const cities = await City.find({}).exec();
    res.json(cities);
  } catch (e) {
    res.status(500).json(e);
  }
});

// get trips
app.get('/api/trips', async (req, res) => {
  try {
    const trips = await Trip.find({}).exec();
    res.json(trips);
  } catch (e) {
    res.status(500).json(e);
  }
});

// create trip
app.post('/api/trip', async (req, res) => {
  try {
    const body = req.body;
    const trip = await new Trip(body).save();
    res.json(trip);
  } catch (e) {
    res.status(500).json(e);
  }
});

// update trip
app.put('/api/trip', async (req, res) => {
  try {
    const body = req.body;
    const trip = await Trip.findOneAndUpdate({ _id: body._id }, body, {
      new: true,
    }).exec();
    res.json(trip);
  } catch (e) {
    res.status(500).json(e);
  }
});

// add activity to a city
app.post('/api/city/:cityId/activity', async (req, res) => {
  try {
    const cityId = req.params.cityId;
    const activity = req.body;
    const city = await City.findOneAndUpdate(
      { _id: cityId },
      { $push: { activities: activity } },
      {
        new: true,
      }
    ).exec();
    res.json(city);
  } catch (e) {
    res.status(500).json(e);
  }
});

// verify uniqueness of a trip
app.get(
  '/api/city/:cityId/activities/verify/:activityName',
  async (req, res) => {
    const { cityId, activityName } = req.params;
    const city = await City.findById(cityId).exec();
    const index = city.activities.findIndex(
      (activity) => activity.name === activityName
    );
    index === -1
      ? res.json('Ok')
      : res.status(400).json('L’activité existe déjà');
  }
);

// upload activity image
app.post("/api/activity/image", upload.single("activity"), (req, res, next) => {
  try {
    const publicPath = `http://10.0.2.2/public/assets/images/activities/${req.file.originalname}`;
    res.json(publicPath || "error");
  } catch (e) {
    next(e);
  }
});

app.listen(80);