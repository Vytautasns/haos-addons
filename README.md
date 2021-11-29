# Home Assistant addons

## Addon configuration

1. Go to addon configuration and enter desired information, for example:
   - `tunnel: home`
   - `domain: mydomain.com`
   - `ha_path: http://homeassistant:8123` - default often is good for most installations
   - `certificate` - continue reading step 2
2. Download and install cloudflared binary from: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installaton
3. Login to cloudflare using the comand: `cloudflared login` and select specific domain you want to use.
4. Get your cloudflared authorization certificate: `awk '{printf "%s\\n", $0}' ~/.cloudflared/cert.pem`
   - Output should look something like: `-----BEGIN PRIVATE KEY-----\nMIGHAg......\n-----END ARGO TUNNEL TOKEN-----\n`
5. Enter it into `certificate` field in configuration
6. Save
7. Start addon
8. In logs you should see something like `Connection 1301c446-xxxx-xxxx-xxxx-xxxxxxx registered connIndex=0 location=ARN`, which means everything is ok and your `home.mydomain.com` should now work.
