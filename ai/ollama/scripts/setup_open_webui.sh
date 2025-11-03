. /vagrant/config/install.env

mkdir -p /u01/open-webui
podman pull ghcr.io/open-webui/open-webui:main
docker run -d -p 8080:8080 -v /u01/open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
