import requests
import json

def test_lm_studio_connection():
    """
    Test if the connection to LM Studio's API is working properly.
    """
    print("Testing connection to LM Studio API...")
    
    # LM Studio API endpoint
    api_url = "http://10.0.2.2:1234/v1/chat/completions"
    
    # Simple test message
    payload = {
        "model": "ibm/granite-4-h-tiny",
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Hello, are you working?"}
        ],
        "temperature": 0.7,
        "max_tokens": 50
    }
    
    try:
        # Send a request to the API
        response = requests.post(
            api_url,
            headers={"Content-Type": "application/json"},
            data=json.dumps(payload),
            timeout=10
        )
        
        # Check if the request was successful
        if response.status_code == 200:
            result = response.json()
            assistant_message = result["choices"][0]["message"]["content"]
            print("\n✅ Connection successful!")
            print("\nLM Studio API response:")
            print(f"Assistant: {assistant_message}")
            return True
        else:
            print(f"\n❌ Error: Received status code {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("\n❌ Connection Error: Could not connect to LM Studio API.")
        print("Make sure LM Studio is running and the server is started.")
        print("Check that the server is running on http://10.0.2.2:1234")
        return False
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        return False

if __name__ == "__main__":
    test_lm_studio_connection()