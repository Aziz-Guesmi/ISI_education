const express = require("express");
const axios = require("axios");
const app = express(); // Créez l'application Express
const port = process.env.PORT || 9250; // Port du serveur (9250 par défaut)
const host = "0.0.0.0";
const ONE_SIGNAL_APP_ID = "1e987a91-1e4a-43f0-8e53-ff9313671f66";
const ONE_SIGNAL_REST_KEY = "OTFmY2FlNmYtNjkzNS00YzJkLWJjZmMtOTRhNDZlMTRkNzY4";

async function sendGlobalNotification(title, body) {
  const notification = {
    app_id: ONE_SIGNAL_APP_ID,
    headings: { en: title },
    contents: { en: body },
    included_segments: ["All"], // Envoyer à tous les utilisateurs
  };

  try {
    const response = await axios.post(
      "https://onesignal.com/api/v1/notifications",
      notification,
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Basic ${ONE_SIGNAL_REST_KEY}`, // Autorisation
        },
      }
    );
    console.log("Notification sent:", response.data);
  } catch (error) {
    console.error("Error sending notification:", error);
  }
}

// Endpoint qui déclenche la notification
app.get("/api/sendNotification", async (req, res) => {
  await sendGlobalNotification("New Message !", "You Have new Message !"); // Appelez la fonction
  res.send("Notification sent to all devices"); // Réponse au client
});

// Endpoint qui déclenche la notification
app.get("/api/updateNotification", async (req, res) => {
  await sendGlobalNotification(
    "Message Updated !",
    "There are an updated message !"
  ); // Appelez la fonction
  res.send("Notification sent to all devices"); // Réponse au client
});

// Lancer le serveur
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
