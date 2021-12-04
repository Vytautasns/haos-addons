# Cloudflare Argo tunnel

## Configuration

### HomeAssistant configuration
For this addon to work, you will need to configure your home assistant, to trust proxies (which argo tunnel is). Otherwise you will receive responses with status code 400.

Add following lines to your HAOS `configuration.yaml` file:
```
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 0.0.0.0/0
```

### Addon configuration

1. Go to addon configuration and enter desired information, for example:
   - `domain: homeassistant.mydomain.com`
   - `ha_path: http://homeassistant:8123` - default often is good for most installations
2. Start your cf-argo plugin
3. Wait for plugin to start up and navigate to logs
4. In logs you will find promp with address which you will need to open in your browser and authorize the addon with your cloudflare account
5. Once authorized, you should now see that tunnel is connected and `homeassistant.mydomain.com` should now work.
