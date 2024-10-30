# Reset

## Clean up files

To do a proper cleanup and restart from square one, you'll need to remove the secrets.yml file, the hosts file and the host_vars directory:

```rm secrets.yml hosts.yml && rm -r host_vars```

Then, recreate your secrets.yml file:

```cp example_secrets.yml secrets.yml```

## Stop containers

Before re-running the script, ensure you SSH into each host machine and stop and remove the containers.

### On the Traefik host:

```docker stop traefik ts-traefik redis-traefik ts-redis-traefik```

then,

```docker rm traefik ts-traefik redis-traefik ts-redis-traefik```

### On the nginx host:

```docker stop nginx ts-nginx```

then,

```docker rm nginx ts-nginx```

### On the additional docker hosts:

```docker stop traefik-kop-serverhostname ts-traefik-kop-serverhostname```

then,

```docker rm traefik-kop-serverhostname ts-traefik-kop-serverhostname```

## Remove machines from Tailscale

Log in to your Tailscale admin console and remove the following machines:
- traefik
- redis-traefik
- traefik-kop-serverhostname (there may be multiple of these depending on how many additional docker hosts you provided)
- nginx

![](/static/remove-tailscale-machines.png)

## Re-run script

Finally, re-run the script.

```./deploy.sh```