# README
This file (docker-compose.yaml) configures an n8n container that will run on port 5678 and store data in a Docker volume called n8n_data. Additionally, it enables basic authentication to protect access to n8n.
Instructions are for MacOS.

## How to run

```
docker-compose up -d
```

You should see your n8n instance running on port 5678 (http://localhost:5678).

If you want to have the customized domain:

0. Check the manual to have a customized port in cloudfare to expose ur lcoal computer
1. add the n9n-tunnet.json file inside ./cloudflared folder
2. adjust ./cloudflared/config.yaml to have ur domain 

## How to maintain n8n up to date

```
docker-compose pull
docker-compose up -d
```

## How to expose local to internet (if you want to do it manually)

We can use a lot of alternatives like: ngrok, localtunnel, cloudfare tunnel, expose, pagekite, telebit, tailscale, frp (fast reverse proxy) ...

I will try to use cloudfare tunnel because:

- It should be free
- We can keep the same URL for my exposed port 
- We can turn it on and turn it off without losing the URL

We need to have a domain registered in Cloudfare to use a subdomain there

1. Install `cloudflared`
```sh
// For MacOS
brew install cloudflare/cloudflare/cloudflared
```

2. Init session on cloudflared

```sh
cloudflared login
```

It will open brower to login, you need to have a domain there


3. Create the tunnel

```sh
cloudflared tunnel create n8n-tunnel

```

You will see something like:

Tunnel credentials written to /Users/carlos/.cloudflared/4023f610-5183-47c1-9dda-a525be1c6733.json. cloudflared chose this file based on where your origin certificate was found. Keep this file secret. To revoke these credentials, delete the tunnel.

Created tunnel n8n-tunnel with id 4023f610-5183-47c1-9dda-a525be1c6733

// Rename the file into n8n-tunnel.json

4. Configure the tunnel

```sh
nano ~/.cloudflared/config.yml


```
add the following if you have a domain

```yaml
tunnel: n8n-tunnel
credentials-file: /Users/carlos/.cloudflared/n8n-tunnel.json

ingress:
  - hostname: n8n.[domain].com
    service: http://localhost:5678
  - service: http_status:404


```



5. Associate tunnel to subdomain

```sh 
cloudflared tunnel route dns n8n-tunnel n8n.[domain].com
```

Go to the Cloudflare dashboard. Create a CNAME record for your subdomain (n8n.tudominio.com): Name: n8n Content:.cfargotunnel.com (you can find it in n8n-tunnel.json). Proxy Status: Enabled (orange icon).

6. Init the Tunnel

```sh
cloudflared tunnel run n8n-tunnel
```

7. Test

Make sure you have n8n running in http://localhost:5678 and go to https://n8n.[domain].com and see if you see the same website