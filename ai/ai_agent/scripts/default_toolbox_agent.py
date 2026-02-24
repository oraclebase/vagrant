from smolagents import OpenAIServerModel, CodeAgent

model = OpenAIServerModel(
    model_id="ibm/granite-4-h-tiny",
    api_base="http://10.0.2.2:1234/v1",
    api_key="not-needed",
)

# Create an agent with the default toolbox
agent = CodeAgent(
    name="AssistantWithDefaultTools",
    model=model,
    tools=[],  # Your custom tools would go here
    add_base_tools=True  # This adds DuckDuckGo search, Python interpreter, and Transcriber
)

response = agent.run("What is the current weather in London?")
print(f"Agent response: {response}")