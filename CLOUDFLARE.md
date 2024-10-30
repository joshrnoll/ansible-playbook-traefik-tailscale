# Creating Public DNS Entries in Cloudflare

1. Log in to your Cloudflare Dashboard and click on your domain name:

![](/static/cloudflare-dns1.png)

2. Click on DNS on the pop-out menu to the left

![](/static/cloudflare-dns2.png)

3. Click add a record

![](/static/cloudflare-dns3.png)

4. Create a CNAME for (service-name).mydomain.com pointing to (service-name).my-tailnet.ts.net -- where mydomain.com is the domain that you own and my-tailnet is your tailnet name. **Ensure proxy status is off**.

![](/static/cloudflare-dns4.png)