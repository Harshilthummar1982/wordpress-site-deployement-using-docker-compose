# wordpress-site-deployement-using-docker-compose
# WordPress Deployment Script

## Introduction

This script automates the deployment of a WordPress site using a combination of Node.js and Bash scripting. The script simplifies the process of setting up a local development environment for managing WordPress instances through Docker and Docker Compose.

## Prerequisites

Before using this script, ensure that you have the following dependencies installed on your system:

- Node.js (version 16.x)
- Docker
- Docker Compose

## Installation

1. Clone this repository or copy the script to a local directory.
2. Open a terminal and navigate to the directory containing the script.

## Usage

The script provides several commands to manage your WordPress instances:

### Create a WordPress Site

Use the following command to create a new WordPress site:

```bash
sudo node index.js create <site_name>
```
## Enable/Start a Site

To start an existing site, use the following command:

```bash
node index.js enable
```

## Disable/Stop a Site

To stop a running site, use the following command:

```bash
node index.js disable
```

## Delete a Site
To delete a site and its associated Docker containers, use the following command:

```bash
node index.js delete
```

## Example

Navigate to the script directory in the terminal:

```bash
cd path/to/script
```

## Example

1. Navigate to the script directory in the terminal:

```bash
cd path/to/script
```

2. Create a new WordPress site:

```bash
sudo node index.js create example.com
```

3. Start the site:

```bash
node index.js enable
```

4. Stop the site:

```bash
node index.js disable
```

5. delete the site:

```bash
node index.js delete
```

## Troubleshooting

If Docker or Docker Compose is not installed, the script will automatically attempt to install them. However, you may encounter issues based on your system's configuration.

## Disclaimer

This script is intended for local development and testing purposes. It simplifies the process of setting up and managing WordPress instances using Docker, but it may not cover all production scenarios or best practices.

## Credits

This script was created by Harshil Thummar as a helpful tool for deploying WordPress sites in a local and server development environment.
