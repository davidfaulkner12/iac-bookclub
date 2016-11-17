#!/bin/bash
curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
sudo yum -y install nodejs
cat > server.js << EOL
//Lets require/import the HTTP module
var http = require('http')

//Lets define a port we want to listen to

//We need a function which handles requests and send response
function handleRequest(request, response){
    response.end("Hello dynamic server world!")
}

//Create a server
var server = http.createServer(handleRequest)

//Lets start our server
server.listen(8080, function(){
    console.log("Server listening on: http://localhost:%s", 8080)
})
EOL
sudo bash -c 'cat > /usr/lib/systemd/system/node-ws.service <<EOL
[Unit]
Description=Echo Microservice
After=network.target

[Service]
Type=simple
User=ec2-user
ExecStart=/usr/bin/node /home/ec2-user/server.js

# Give a reasonable amount of time for the server to start up/shut down
TimeoutSec=300

[Install]
WantedBy=default.target
EOL'
sudo chmod 664 /usr/lib/systemd/system/node-ws.service
sudo systemctl enable node-ws.service
