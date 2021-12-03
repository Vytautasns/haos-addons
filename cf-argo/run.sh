#!/usr/bin/with-contenv bashio

TUNNEL_AUTH_CERT="$(bashio::config 'certificate')"
TUNNEL_DOMAIN="$(bashio::config 'domain')"

export TUNNEL_URL="$(bashio::config 'ha_url')"
export TUNNEL_FORCE_PROVISIONING_DNS=true

# Check if auth avialable
if [ "${TUNNEL_AUTH_CERT}x" = "x" ]; then
    cloudflared tunnel login

    TUNNEL_AUTH_CERT=$(base64 -w0 < ~/.cloudflared/cert.pem)
    bashio::addon.option 'certificate' "${TUNNEL_AUTH_CERT}"
else
    if [ ! -d  ~/.cloudflared ]; then
        mkdir ~/.cloudflared
    fi

    printf "%s" "${TUNNEL_AUTH_CERT}" | base64 -d > ~/.cloudflared/cert.pem
fi

cloudflared tunnel --hostname "${TUNNEL_DOMAIN}" --url "${TUNNEL_URL}"