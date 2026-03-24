const mongoose = require("mongoose");
const City = require("./models/city.model");

async function seedDatabase() {
  try {
    // Connexion MongoDB Atlas
    await mongoose.connect(
      //"mongodb://jean:123@cluster0-urpjt.mongodb.net/dymatrip_emu?retryWrites=true&w=majority"
      "mongodb://jean:123@cluster0-shard-00-00-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-01-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-02-urpjt.gcp.mongodb.net:27017/dymatrip_emu?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority",
    );

    console.log("MongoDB connected");

    // Suppression des anciennes données
    await City.deleteMany({});
    console.log("Old data removed");

    const cities = [
      {
        name: "Paris",
        image: "http://10.0.2.2/assets/images/paris.jpg",
        activities: [
          {
            image: "http://10.0.2.2/assets/images/activities/louvre.jpg",
            name: "Louvre",
            city: "Paris",
            price: 12.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/chaumont.jpg",
            name: "Chaumont",
            city: "Paris",
            price: 0.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/dame.jpg",
            name: "Notre Dame",
            city: "Paris",
            price: 0.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/defense.jpg",
            name: "La Défense",
            city: "Paris",
            price: 0.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/effeil.jpg",
            name: "Tour Eiffel",
            city: "Paris",
            price: 15.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/luxembourg.jpg",
            name: "Jardin Luxembourg",
            city: "Paris",
            price: 0.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/mitterrand.jpg",
            name: "Bibliothèque Mitterrand",
            city: "Paris",
            price: 0.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/montmartre.jpg",
            name: "Montmartre",
            city: "Paris",
            price: 0.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/catacombe.jpg",
            name: "Catacombes",
            city: "Paris",
            price: 10.0,
          },
        ],
      },

      {
        name: "Lyon",
        image: "http://10.0.2.2/assets/images/lyon.jpg",
        activities: [
          {
            image: "http://10.0.2.2/assets/images/activities/lyon_opera.jpg",
            name: "Opéra",
            city: "Lyon",
            price: 100.0,
          },
          {
            image:
              "http://10.0.2.2/assets/images/activities/lyon_bellecour.jpg",
            name: "Place Bellecour",
            city: "Lyon",
            price: 0.0,
          },
          {
            image:
              "http://10.0.2.2/assets/images/activities/lyon_basilique.jpg",
            name: "Basilique St-Pierre",
            city: "Lyon",
            price: 10.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/lyon_mairie.jpg",
            name: "Mairie",
            city: "Lyon",
            price: 0.0,
          },
        ],
      },

      {
        name: "Nice",
        image: "http://10.0.2.2/assets/images/nice.jpg",
        activities: [
          {
            image:
              "http://10.0.2.2/assets/images/activities/nice_orthodox.jpg",
            name: "Église Orthodoxe",
            city: "Nice",
            price: 5.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/nice_riviera.jpg",
            name: "Riviera",
            city: "Nice",
            price: 0.0,
          },
          {
            image:
              "http://10.0.2.2/assets/images/activities/nice_promenade.jpg",
            name: "Promenade des Anglais",
            city: "Nice",
            price: 0.0,
          },
          {
            image: "http://10.0.2.2/assets/images/activities/nice_opera.jpg",
            name: "Opéra",
            city: "Nice",
            price: 100.0,
          },
        ],
      },
    ];

    // Insertion des données
    await City.insertMany(cities);

    console.log("Data successfully installed");

    // Fermeture connexion
    await mongoose.connection.close();

    console.log("MongoDB connection closed");
  } catch (error) {
    console.error("Error while seeding database:", error);
  }
}

seedDatabase();