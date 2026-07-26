#=============================================================================
# ADDON_SLUG HA Addon
#=============================================================================
# TODO: Choose build strategy (see SKILL.md → Build strategy selection)
# and replace this Dockerfile accordingly.
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Build / Fetch sources ----
# TODO: Add build stages based on strategy

# ---- Stage 2: HA base runtime ----
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# Install runtime deps
# RUN apt-get update && apt-get install -y --no-install-recommends \
#         <packages> \
#     && rm -rf /var/lib/apt/lists/*

# Copy app binary / sources
# COPY --from=<stage> <src> <dst>

# Copy HA rootfs
COPY rootfs /

# Ensure scripts are executable
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run

# Healthcheck — prefer upstream's native health endpoint
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null http://127.0.0.1:<PORT>/ || exit 1
