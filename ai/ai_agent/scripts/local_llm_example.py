import os
from smolagents import OpenAIServerModel, ToolCallingAgent

# Configure the model to use LM Studio's local API endpoint
model = OpenAIServerModel(
    model_id="ibm/granite-4-h-tiny",  # This can be any name, LM Studio will use whatever model you have loaded
    api_base="http://10.0.2.2:1234/v1",  # Default LM Studio API endpoint
    api_key="not-needed",  # LM Studio doesn't require an API key by default
)

# Create a simple agent using the local model
agent = ToolCallingAgent(
    name="LocalLLMAgent",
    model=model,
    tools=[],  # Empty list of tools
    # You can also add the default toolbox with add_base_tools=True
)

# Example conversation with the agent
response = agent.run("Hello! Can you tell me what you are and how you're running?")
print(f"Agent response: {response}")