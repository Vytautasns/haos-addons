#!/usr/bin/with-contenv bashio

# Params
CF_CLI=/data/cloudflared-linux-arm64
CF_CERT=/data/cert.pem
CF_TUNNEL_SECRET=/data/tunnel/creds.json
CF_TUNNEL_CONFIG=/data/tunnel/config.yml

# Options
CF_CERT_CONTENTS="$(bashio::config 'certificate')"
CF_TUNNEL="$(bashio::config 'tunnel')"
CF_DOMAIN="$(bashio::config 'domain')"
HA_PATH="$(bashio::config 'ha_path')"

login()
{
    $CF_CLI tunnel login
    echo "Copying certificate to persistent storage."
    mv /root/.cloudflared/cert.pem ./
}

cleanup()
{
    echo "Cleaning old tunnel"
    if [ -d "/data/tunnel" ]; then
        rm -rf /data/
        echo "Removed tunnel configs"
    fi
    $CF_CLI tunnel cleanup $CF_TUNNEL
    $CF_CLI tunnel delete $CF_TUNNEL
}

export TUNNEL_ORIGIN_CERT="$CF_CERT"

if [ -f "$CF_CLI" ]; then
    echo "$($CF_CLI --version)"
else
    wget -O $CF_CLI https://github.com/cloudflare/cloudflared/releases/download/2021.11.0/cloudflared-linux-arm64
    chmod a+x $CF_CLI

    echo "$($CF_CLI --version)"
fi

if [ "$CF_TUNNEL" = "Tunnel name. Used as subdomain." ]; then
    echo "Please configure addon first."
    exit 1
fi

if [ "$CF_DOMAIN" = "Top level domain" ]; then
    echo "Please configure addon first."
    exit 1
fi

if [ ! -f "$CF_CERT" ]; then
    if [ ! "$CF_CERT_CONTENTS" = "Certificate contents" ]; then
        if [ ! -z "$CF_CERT_CONTENTS" ]; then
            echo "Copying certificate from options."
            echo -e "$CF_CERT_CONTENTS" >> $CF_CERT
        fi
    else
        echo "Missing certificate."
        login
    fi
fi

if [ ! -f "$CF_TUNNEL_SECRET" ]; then
    echo "Missing tunnel secret."
    cleanup || true

    echo "Setting up tunnel."
    CREATED="$($CF_CLI tunnel create $CF_TUNNEL)"

    # Take the uuid
    UUID="$(echo $CREATED | awk '{ print substr( $0, length($0)-35 ) }')"
    
    mkdir /data/tunnel
    mv /data/$UUID.json $CF_TUNNEL_SECRET

    echo -e "url: $HA_PATH \ntunnel: $UUID \ncredentials-file: /data/tunnel/creds.json" >> $CF_TUNNEL_CONFIG

    cat $CF_TUNNEL_CONFIG

    $CF_CLI tunnel route dns $CF_TUNNEL $CF_TUNNEL.$CF_DOMAIN
fi

$CF_CLI tunnel --config $CF_TUNNEL_CONFIG run $CF_TUNNEL