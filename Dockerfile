FROM elixir:1.16-alpine AS builder

ARG BUILD_ENV=prod
ARG BUILD_REL=k8six

# Install system dependencies
RUN mix local.hex --force
RUN mix local.rebar --force

# Add sources
ADD . /workspace/
WORKDIR /workspace

ENV MIX_ENV=${BUILD_ENV}

# let's install git 
RUN apk add --no-cache git

# Fetch dependencies
RUN mix deps.get

# Build project
RUN mix compile

# Run test-suite
# RUN mix test --cover

# Build release
RUN mix release

FROM alpine:latest AS runner

ARG BUILD_ENV=prod
ARG BUILD_REL=k8six

# Install system dependencies
RUN apk add --no-cache openssl ncurses-libs libgcc libstdc++

# Install release
COPY --from=builder /workspace/_build/${BUILD_ENV}/rel/${BUILD_REL} /opt/k8six

## Configure environment

# We want a FQDN in the nodename
ENV RELEASE_DISTRIBUTION="name"

# This value should be overriden at runtime
ENV RELEASE_NODE_IP="127.0.0.1"

# This will be the basename of our node
ENV RELEASE_NAME="${BUILD_REL}"

# This will be the full nodename
# ENV RELEASE_NODE="${RELEASE_NAME}@${RELEASE_NODE_IP}"

# This will be the basename of our node
ENV K8SIX_APP_NAME="${BUILD_REL}"

# this is going to be overriden by the service name on runtime
ENV DATAPIO_SERVICE_NAME="k8six-svc"

# FIXME: bellow we have a hard coded ... k8six ... 
ENTRYPOINT ["/opt/k8six/bin/k8six"]
CMD ["start"]