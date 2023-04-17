FROM kong:2.8.3 as builder

USER root

ENV LUAROCKS_MODULE=kong-plugin-cads-jwt-keycloak

RUN apk add --no-cache git zip && \
    git config --global url.https://github.com/.insteadOf git://github.com/ && \
    luarocks install ${LUAROCKS_MODULE} && \
    luarocks pack ${LUAROCKS_MODULE}

FROM kong:2.8.3

USER root

ENV KONG_PLUGINS="bundled,jwt-keycloak"

COPY --from=builder kong-plugin-jwt-cads-keycloak* /tmp/
RUN luarocks install /tmp/kong-plugin-jwt-cads-keycloak*

USER kong
