const express = require("express");
const app = express();
app.get("/", (req, res) => res.send("Bonjour depuis tpweek2"));
app.listen(3000, () => console.log("Serveur sur le port 3000"));