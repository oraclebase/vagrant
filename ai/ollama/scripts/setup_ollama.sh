. /vagrant/config/install.env

echo "******************************************************************************"
echo "Install Ollama." `date`
echo "******************************************************************************"
mkdir -p ${OLLAMA_MODELS}

curl -fsSL https://ollama.com/install.sh | sh
systemctl start ollama
systemctl enable ollama
systemctl status ollama

echo "******************************************************************************"
echo "Get llama3 Model." `date`
echo "******************************************************************************"
ollama pull llama3

echo "******************************************************************************"
echo "Create an Oracle Linux Bot." `date`
echo "******************************************************************************"
ollama create oracle-linux-bot -f /vagrant/scripts/ModelFile

echo "******************************************************************************"
echo "Show Models." `date`
echo "******************************************************************************"
curl http://localhost:11434/api/tags

echo "******************************************************************************"
echo "Start Open WebUI." `date`
echo "******************************************************************************"
python3.11 -m venv venv
. venv/bin/activate
python --version

#pip install open-webui
#open-webui serve

