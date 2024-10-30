# ansible-playbook-traefik-tailscale

## An Ansible Playbook for Deploying Traefik and traefik-kop over Tailscale

[Traefik](https://traefik.io) is a highly flexible application proxy with significant of capabilities. However, this comes at the cost of being very complex. A common application of Traefik, especially in a self-hosted/homelab setup, is to use the [Docker provider](https://doc.traefik.io/traefik/providers/docker/). This provider allows you to automate the proxy configuration (requesting a wildcard certificate for HTTPS, configuring the port and protocol for the proxy host, etc.) through [Docker labels](https://docs.docker.com/engine/manage-resources/labels/). Unfortunately, this capability is limited to containers running on the same host as Traefik. 

That's where another open source project, [traefik-kop](https://github.com/jittering/traefik-kop) comes in. Traefik-kop deploys a container on your other Docker hosts which publishes information from the local docker daemon to a redis container running on the same host as Traefik. Traefik then uses the redis provider to talk to your containers on other hosts. 

This all sounds complicated right? Well, for you, it doesn't have to be. Because I automated it... mostly. You'll still have to create the DNS entries for your services. 

This playbook automates the process of deploying Traefik and traefik-kop, along with an NGINX container to verify that everything is working. Oh, and it's all on [Tailscale](https://github.com/joshrnoll/tailscale-info).

## Getting Started

Before you begin, you'll need a few things:

- A [Tailscale account](https://tailscale.com)
- A [Cloudflare account](https://cloudflare.com)
- A domain. You can get one from Cloudflare, or another registrar like [Namecheap](https://namecheap.com). If you do get one from another registrar, be sure to transfer the DNS over to Cloudflare. Namecheap has an [article on this](https://www.namecheap.com/support/knowledgebase/article.aspx/9607/2210/how-to-set-up-dns-records-for-your-domain-in-a-cloudflare-account/), for example.
- Ansible installed on your computer (obviously)

### Making DNS entries

You will need DNS entries that point your clients from, for example, **nginx.mydomain.com** to either their tailscale IP address or hostname. I recommend using CNAME/Alias records pointing, for example, **nginx.mydomain.com** to **nginx.my-tailnet.ts.net**. At a minimum you will need the following entries:

- traefik.mydomain.com --> traefik.my-tailnet.ts.net
- nginx.mydomain.com --> nginx.my-tailnet.ts.net

This can be done via internal DNS like pihole, however that will require access to your internal DNS to access your services. Because tailscale IPs are public IPs, but only accessible once authenticated into your tailnet, it's safe to add public DNS entries in a provider like Cloudflare. This is the recommended method so that you can access your services when you don't have access to your internal DNS. Additionally, this offers you the flexibility to [share a tailscale machine](https://tailscale.com/kb/1084/sharing) with a friend's tailscale account, allowing them to access the service through Traefik via your domain name over HTTPS.

For a how-to on generating CNAMEs in Cloudflare, click [here](/CLOUDFLARE.md).

### Generating a Tailscale Oauth client

See my [github repo](https://github.com/joshrnoll/tailscale-info), tailscale-info, for a how-to. 

### Generating a Cloudflare DNS token

I cover how to do this in this, [slightly related, blog post](https://joshrnoll.com/implementing-sso-using-authentik-and-nginx-reverse-proxy-manager/). It's about halfway through if you don't feel like reading the whole thing. 

### Creating your secrets.yml file

Fill out the example_secrets.yml file with your information. Then, copy the example_secrets.yml file to a file named secrets.yml. I recommend using cp rather than mv for this in case you mess up and need to try again.

```cp example_secrets.yml secrets.yml```

### Run the deployment script

Ensure the script is executable:

``` sudo chmod +x deploy.sh```

Then, run the script with:

```./deploy.sh```

### Troubleshooting

Common issues and potential solutions:

#### Complete reset

Follow [these instructions](/RESET.md) to do a complete reset and start from square one.

#### No secrets.yml file
If the script fails on after entering your vault password with output that looks like this, double check that you copied the example_secrets.yml to secrets.yml in the root playbook directory. 

![](/static/no-secrets-file.png)

#### Bad vault password
If you see an error like this, it likely means you successfully generated your vault password at the first two prompts, but on the third prompt you had a typo when providing the script your vault password. 

![](/static/bad-vault-pass.png)

If this happens, remove the secrets.yml file and recreate it:

```rm secrets.yml && cp example_secrets.yml secrets.yml```

Then, re-run the script.

If the issue persists, try a [full reset](/RESET.md).
