# Ollama on Oracle Linux 9 #

A simple Vagrant build for Ollama on Oracle Linux 9, based on the blog post linked below.

I had trouble installed Open WebUI directly, so instead I used the container version of it.

References:

* [Running LLMs on Oracle Linux with Ollama](https://blogs.oracle.com/linux/running-llms-on-oracle-linux-with-ollama)
* [Podman : Install Podman on Oracle Linux 9 (OL9)](oracle-base.com/articles/linux/podman-install-on-oracle-linux-ol9)
* [Open WebUI : Quick Start](https://docs.openwebui.com/getting-started/quick-start/)



## Warning ##

I ran this on an old laptop without a suitable NVidia or AMD GPU, so it ran in CPU mode. It and was pretty slow, but it did work.



## Build the VM ##

Initiate the build.

```
cd C:\git\oraclebase\vagrant\ai\ollama
vagrant up
```

Once the VM is built, connect to it using SSH using the password "vagrant" and switch to root.

```
ssh vagrant@localhost -p 2222

sudo su -
```

At this point the VM is configured ready to start. See the steps below.



## Setup Ollama ##

To setup Ollama and the Llama3 model, run the following script.

```
sh /vagrant/scripts/setup_ollama.sh
```



## Ollama Usage ##

At this point you are ready to use the model.

```
# Main model
ollama run llama3

# Short Answer Bot : Scope restricted by ModelFile
ollama run short-answer-bot
```

An alternative to using the prompt to ask questions is to call the queries directly using curl. This can be done in streaming or non-streaming mode.

```
# Streaming.
curl http://localhost:11434/api/generate -d '{
"model": "llama3",
"prompt": "In less than 50 words, what is Star Trek about?"
}'

# Non-streaming, and using Short Answer Bot. Scope restricted by ModelFile
curl http://localhost:11434/api/generate -d '{
"model": "short-answer-bot",
"prompt": "In less than 50 words, what is Star Trek about?",
"stream": false
}'
```



## Setup Open WebUI ##

If you want the Open WebUI interface, run the following script.

```
sh /vagrant/scripts/setup_open_webui.sh
```

This should now be accessible from your desktop using this following URL.

```
http://localhost:8080/
```
