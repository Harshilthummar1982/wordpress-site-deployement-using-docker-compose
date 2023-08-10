#!/bin/bash

# Update package lists
sudo apt-get update

# Install Node.js
curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs -y
node -v

# Create demo folder
mkdir example
cd example

# Initialize npm and install dependencies
npm init -y
npm install child_process
npm install fs

# Install Docker and Docker Compose
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce -y
sudo apt install docker-compose -y
sudo usermod -aG docker ${USER}
sudo apt update


# Create index.js
echo '#!/usr/bin/env node
const { execSync } = require("child_process");
const fs = require("fs");

function checkDockerInstalled() {
  try {
    execSync("docker --version");
    execSync("docker-compose --version");
    return true;
  } catch (error) {
    return false;
  }
}
function addEtcHostsEntry(siteName) {
  const hostsFilePath = "/etc/hosts";
  const newEntry = `127.0.0.1 ${siteName}`;

  // Read the existing contents of the hosts file
  const fileContents = fs.readFileSync(hostsFilePath, "utf8");

  // Split the contents into lines
  const lines = fileContents.split(`\\n`);

  // Find the index of the line containing "127.0.0.1 localhost"
  const localhostIndex = lines.findIndex(line => line.includes("127.0.0.1 localhost"));

  // Insert the new entry just below the "localhost" line
  lines.splice(localhostIndex + 1, 0, newEntry);

  // Join the lines back into a single string
  const updatedContents = lines.join(`\\n`);

  // Write the updated contents back to the hosts file
fs.writeFileSync(hostsFilePath, updatedContents);

  // Print the updated contents
  console.log(updatedContents);
}

function installDocker() {
  console.log("Docker and/or Docker Compose not found. Installing...");
  execSync("sudo apt update");
  execSync("sudo apt install apt-transport-https ca-certificates curl software-properties-common -y");
  execSync("curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -");
  execSync("sudo apt update");
  execSync("echo | sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"");
  execSync("sudo apt install docker-ce -y");
  execSync("sudo apt install docker-compose -y");
  execSync("sudo usermod -aG docker \${USER}");
}

function createWordPressSite(siteName) {
  const dockerCompose = `
version: "3.3"
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root_abc
      MYSQL_DATABASE: ${siteName}
      MYSQL_USER: abc
      MYSQL_PASSWORD: abc

  wordpress:
    depends_on:
      - db
    image: wordpress
    ports:
      - \"8000:80\"
    restart: always
    volumes:
      - ./wp-content:/var/www/html/wp-content
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: ${siteName}
      WORDPRESS_DB_USER: abc
      WORDPRESS_DB_PASSWORD: abc
volumes:
  db_data:
`;

  fs.writeFileSync("docker-compose.yml", dockerCompose);

  console.log("docker-compose.yml file created");
  execSync("docker-compose up -d");
  console.log("Docker Compose up");
  addEtcHostsEntry("example.com");
}

function enableDisableSite(action) {
  if (action === "start") { 
    execSync("docker-compose start");
  } else if (action === "stop") {
    execSync("docker-compose stop");
  }
}

function deleteSite() {
  execSync("docker-compose down -v");
  fs.unlinkSync("docker-compose.yml");
}

async function main() {
  if (!checkDockerInstalled()) {
    installDocker();
  }

  const [, , command, siteName] = process.argv;

  switch (command) {
    case "create":
      if (!siteName) {
        console.error("Please provide a site name.");
        return;
      }
      createWordPressSite(siteName);
      console.log("Open http://<ip_address>:8000 in your browser.");
      break;

    case "enable":
      enableDisableSite("start");
      break;

    case "disable":
      enableDisableSite("stop");
      break;

    case "delete":
      deleteSite();
      break;

    default:
      console.log("Invalid command. Usage:");
      console.log("node index.js create demo");
      console.log("node index.js enable");
      console.log("node index.js disable");
      console.log("node index.js delete");
  }
}

main();' > index.js

# Make index.js executable
chmod +x index.js

# Inform user
echo 'Setup completed. You can now use the script in the "demo" folder:'
echo '1. cd example'
echo '2. sudo node index.js create example.com'
echo '3. node index.js enable'
echo '4. node index.js disable'
echo '5. node index.js delete'

su - ${USER}
