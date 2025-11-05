. /vagrant/config/install.env

echo "******************************************************************************"
echo "Install Ollama." `date`
echo "******************************************************************************"
mkdir -p ${OLLAMA_MODELS}

curl -fsSL https://ollama.com/install.sh | sh
systemctl start ollama
systemctl enable ollama

# Make sure the service responds to all IP addresses.
sed -i -e "s|Environment=\"|Environment=\"OLLAMA_HOST=0.0.0.0:11434\"\nEnvironment=\"|g" /etc/systemd/system/ollama.service

systemctl daemon-reload
systemctl restart ollama
#systemctl status ollama

# Pause while service restarts.
sleep 20

echo "******************************************************************************"
echo "Get Model(s)." `date`
echo "******************************************************************************"
ollama pull llama3
#ollama pull deepseek-r1
#ollama pull gpt-oss:20b
#ollama pull codellama
#ollama pull deepseek-coder
#ollama pull codestral

echo "******************************************************************************"
echo "Create an Oracle Linux Bot." `date`
echo "******************************************************************************"
ollama create short-answer-bot -f /vagrant/scripts/ModelFile

echo "******************************************************************************"
echo "Show Models." `date`
echo "******************************************************************************"
curl http://localhost:11434/api/tags
