require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = 3000;

// Conectar a MongoDB
mongoose.connect(process.env.MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
   .then(() => console.log('Conectado a MongoDB'))
   .catch(err => console.error('Error al conectar a MongoDB:', err));

// Define el esquema de la playlist
const playlistSchema = new mongoose.Schema({
   title: String,
   artist: String,
   duration: String
});

const Playlist = mongoose.model('Playlist', playlistSchema);

// Ruta para obtener todas las playlists
app.get('/playlists', async (req, res) => {
   try {
      const playlists = await Playlist.find();
      res.json(playlists);
   } catch (err) {
      res.status(500).json({ message: err.message });
   }
});

// Middleware para analizar el cuerpo de las solicitudes JSON
app.use(express.json());

// Ruta para agregar una nueva playlist
app.post('/playlists', async (req, res) => {
   const { title, artist, duration } = req.body;

   const newPlaylist = new Playlist({
      title,
      artist,
      duration
   });

   try {
      const savedPlaylist = await newPlaylist.save();
      res.status(201).json(savedPlaylist);
   } catch (err) {
      res.status(400).json({ message: err.message });
   }
});

app.listen(PORT, () => {
   console.log(`Servidor escuchando en http://localhost:${PORT}`);
});

