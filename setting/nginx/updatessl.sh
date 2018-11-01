#!/usr/bin/env sh

_SCRIPT_="$0"

ACME_BIN="/acme.sh/acme.sh --home /acme.sh --config-home /acmecerts"

DEFAULT_CONF="/etc/nginx/conf.d/default.conf"


CERTS="/etc/nginx/certs"


updatessl() {
nginx -t && nginx -s reload

for site_info_base64 in $(cat /var/run/secrets/ssl | jq -r '.[] | @base64'); do
    _jq() {
       echo ${1} | base64 -d | jq -r ${2}
    }

    ssl_mode=$(_jq ${site_info_base64} '.ssl')

    case ${ssl_mode} in
        'letsencrypt')
            if ! [ -s "$CERTS/$(_jq ${site_info_base64} '.host').crt" ]; then
                ssl_parameter_base64=$(_jq ${site_info_base64} '.'$(echo "${ssl_mode}"'|@base64'))
                case $(_jq ${ssl_parameter_base64} '.mode') in
                    'dns')
                        eval export $(jq -r '.Key1_name' /var/run/secrets/dns_api)=$(jq -r '.Key1_value' /var/run/secrets/dns_api)
                        eval export $(jq -r '.Key2_name' /var/run/secrets/dns_api)=$(jq -r '.Key2_value' /var/run/secrets/dns_api)
                        eval $ACME_BIN --issue --dns $(jq -r '.Provider' /var/run/secrets/dns_api) $(_jq ${ssl_parameter_base64} '.domain_parameter') $(_jq ${ssl_parameter_base64} '.extra_parameter') \
                            --fullchain-file "$CERTS/$(_jq ${site_info_base64} '.host').crt" \
                            --key-file "$CERTS/$(_jq ${site_info_base64} '.host').key" \
                            --reloadcmd "\"nginx -t && nginx -s reload\"";
                        #generate nginx conf again.
                        docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
                        ;;
                    'webroot')
                        eval $ACME_BIN --issue $(_jq ${ssl_parameter_base64} '.domain_parameter') --nginx $(_jq ${ssl_parameter_base64} '.extra_parameter') \
                            --fullchain-file "$CERTS/$(_jq ${site_info_base64} '.host').crt" \
                            --key-file "$CERTS/$(_jq ${site_info_base64} '.host').key" \
                            --reloadcmd "\"nginx -t && nginx -s reload\"";
                        #generate nginx conf again.
                        docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
                        ;;
                    *)
                        echo "Unkown letsencrypt mode \"$(_jq ${ssl_parameter_base64} '.mode')\""
                        ;;
                esac
            else
               echo "skip updatessl"
            fi
            ;;
        'build')
            if ! [ -s "$CERTS/$(_jq ${site_info_base64} '.host').crt" ]; then
                ssl_parameter_base64=$(_jq ${site_info_base64} '.'$(echo "${ssl_mode}"'|@base64'))
                opssl_parameter=\"/C=$(_jq ${ssl_parameter_base64} '.country')/ST=$(_jq ${ssl_parameter_base64} '.state')/L=$(_jq ${ssl_parameter_base64} '.locality')/O=$(_jq ${ssl_parameter_base64} '.organization')/OU=$(_jq ${ssl_parameter_base64} '.organizationalunit')/emailAddress=$(_jq ${ssl_parameter_base64} '.email')/CN=$(_jq ${site_info_base64} '.host')\";
                openssl genrsa -des3 -passout pass:xxxx -out rootCA.key 2048;
                eval openssl req -x509 -passin pass:xxxx -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem -subj ${opssl_parameter};
                eval openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout "$CERTS/$(_jq ${site_info_base64} '.host').key" -subj ${opssl_parameter};
                openssl x509 -req -passin pass:xxxx -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out "$CERTS/$(_jq ${site_info_base64} '.host').crt" -days 3600 -sha256 -extfile /etc/nginx/vhost.d/v3.ext;
                #generate nginx conf again.
                docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
            else
               echo "skip updatessl"
            fi
            ;;
        'own')
            echo "own ssl mode"
            #generate nginx conf again.
            docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
            ;;
        'none')
            echo "no ssl"
            ;;
        *)
            echo "Unkown ssl mode \"${ssl_mode}\""
            ;;
    esac
done

nginx -t && nginx -s reload
}

"$@"
