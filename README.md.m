# README
This file (docker-compose.yaml) configures an n8n container that will run on port 5678 and store data in a Docker volume called n8n_data. Additionally, it enables basic authentication to protect access to n8n.
Instructions are for MacOS.

## How to run
```
docker-compose up -d
```

You should see your n8n instance running on port 5678 (http://localhost:5678).

## How to maintain n8n up to date

```
docker-compose pull
docker-compose up -d
```
