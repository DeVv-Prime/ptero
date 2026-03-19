const express = require("express");
const app = express();

// Payload script
const script = `#!/bin/bash
clear
echo "🔥 CodingPrime Connected!"
echo "Loading interface..."
sleep 1
echo "System ready. Menu will display..."
# Add your actual menu commands here
`;

app.get("/", (req, res) => {
  res.set("Content-Type", "text/plain");
  res.send(script);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log("Server running on port", PORT));
