# AI Agent interacting with LM Studio #

A simple Vagrant build of Ububtu to host an AI agent interactiving with LM Studio.

This asumes LM studio is running on your PC, and the API server has been enabled.

Q: Why is this done within a VM, rather than on the host PC?
A: I don't want to risk damaging you PC if the agent goes rogue. :)


## LM Studip Setup ##

Install LM Studio on your PC and enable the API server.

* Click on the Developer icon in the left-hand toolbar.
* Click on the “Local Server” tab.
* Enable the local server using the toggle on the top-left.
* Load the default model of choice using the “Load Model” button on the top-left.

The API should now be available on port 1234 by default. We can access it on the host PC as follows.

```
$ curl http://localhost:1234/api/v1/models
```

From with in the Agent VM we use the following address.

```
$ curl http://10.0.2.2:1234/api/v1/models
```


## Setup Python environment inside VM ##

Run these command to set up the python environment.

```
python3 -m venv vvv
source vvv/bin/activate
pip install 'smolagents[openai]'
pip install requests
pip install ddgs
```

You are now ready to start creating agents in Python.


## Create agents using Python ##

The following scripts are based on those shown in the following article.

* [Building AI Agents with Local LLMs: Using smolagents with LM Studio](https://www.matt-adams.co.uk/2025/03/14/smolagents-lmstudio.html)

The examples have been adjusted to reference my LM Studio location (10.0.2.2) and the model I'm using (ibm/granite-4-h-tiny).

```
python /vagrant/scripts/test_lm_studio_connection.py
python /vagrant/scripts/local_llm_example.py
python /vagrant/scripts/coding_assistant_agent.py
python /vagrant/scripts/default_toolbox_agent.py
```
