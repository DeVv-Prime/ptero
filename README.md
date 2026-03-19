# CodingPrime Server

This is a ready-to-deploy Bash payload server for Render.

## Deploy on Render

1. Connect this GitHub repo to Render as a Web Service.
2. Set Build Command: `npm install`
3. Set Start Command: `node server.js`
4. Add custom domain: `ptero.diddymc.fun`
5. Deploy.

## Run on client

```bash
bash <(curl -s https://codingprime.diddymc.fun)
