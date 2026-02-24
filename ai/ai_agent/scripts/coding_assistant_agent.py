import os
from smolagents import OpenAIServerModel, CodeAgent, tool

# Configure the model to use LM Studio's local API endpoint
model = OpenAIServerModel(
    model_id="ibm/granite-4-h-tiny",
    api_base="http://10.0.2.2:1234/v1",
    api_key="not-needed",
)

# Define a tool that the agent can use to search for Python documentation
@tool
def search_python_docs(query: str) -> str:
    """
    Search for Python documentation based on the query.
    This is a simplified example - in a real application, you might
    use a web API or local documentation.
    
    Args:
        query: The search query
        
    Returns:
        str: Information about the Python feature
    """
    # This is a mock implementation
    python_docs = {
        "list": "Lists are used to store multiple items in a single variable. Lists are ordered, changeable, and allow duplicate values.",
        "dict": "Dictionaries are used to store data values in key:value pairs. A dictionary is a collection which is ordered, changeable and do not allow duplicates.",
        "set": "Sets are used to store multiple items in a single variable. Set is one of 4 built-in data types in Python used to store collections of data.",
        "function": "A function is a block of code which only runs when it is called. You can pass data, known as parameters, into a function.",
    }
    
    for key, value in python_docs.items():
        if key in query.lower():
            return value
    
    return "No specific information found for that query. Try asking about lists, dictionaries, sets, or functions."

# Example usage of the agent
def chat_with_coding_assistant():
    print("Python Coding Assistant (powered by your local LLM)")
    print("Type 'exit' to end the conversation\n")
    
    # Store conversation history for context (since agents don't maintain state between runs)
    conversation_history = []
    
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'exit':
            print("Goodbye!")
            break
        
        # Add user input to conversation history
        conversation_history.append(f"User: {user_input}")
        
        # Create a new agent for each interaction
        coding_assistant = CodeAgent(
            name="PythonCodingAssistant",
            model=model,
            tools=[search_python_docs],
        )
        
        # Include conversation history in the prompt
        full_prompt = "\n".join(conversation_history) + "\n\nPlease respond to the latest message."
        
        # Use reset=False to continue the conversation without resetting the agent's memory
        response = coding_assistant.run(full_prompt, reset=False)
        print(f"Assistant: {response}")
        
        # Add assistant response to conversation history
        conversation_history.append(f"Assistant: {response}")
        
        # You can inspect the agent's logs to see what happened
        # print(coding_assistant.logs)

if __name__ == "__main__":
    print("Reminder: Ensure LM Studio is running with a model loaded on http://localhost:1234\n")
    chat_with_coding_assistant()