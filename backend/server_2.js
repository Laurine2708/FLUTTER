const mongoose = require("mongoose");

mongoose.connect(
    "mongodb://jean:123@cluster0-shard-00-00-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-01-urpjt.gcp.mongodb.net:27017,cluster0-shard-00-02-urpjt.gcp.mongodb.net:27017/dymatrip_emu?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority",
    {
        family: 4
    })
    .then(() => {
        console.log("MongoDB connected");
    })
    .catch(err => {
        console.error("MongoDB connection error:", err);
    });