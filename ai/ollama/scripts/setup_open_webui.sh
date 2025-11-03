#######################################################
# If the container can't speak to the host OS,
# run this and recreate the container.
#
#cat >> /usr/share/containers/containers.conf << EOF
#default_rootless_network_cmd = "slirp4netns"
#EOF
#######################################################

mkdir -p /u01/open-webui
podman pull ghcr.io/open-webui/open-webui:main
#podman rm -vf open-webui
podman run -d -p 8080:8080 \
           -v /u01/open-webui:/app/backend/data \
           --name open-webui \
           -e OLLAMA_HOST=host.containers.internal \
           -e OLLAMA_PORT=11434 \
           --add-host host.containers.internal:host-gateway \
           ghcr.io/open-webui/open-webui:main
#podman logs --follow open-webui
