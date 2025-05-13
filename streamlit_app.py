
import streamlit as st
from huggingface_hub import InferenceClient

# Streamlit page configuration
st.set_page_config(page_title="Chatbot with Hugging Face", page_icon=":robot_face:", layout="wide")
st.title("Hugging Face Chatbot")
st.subheader("Powered by Llama-3.2-3B-Instruct")

# Initialize session state variables
if 'messages' not in st.session_state:
    st.session_state.messages = []

if 'display_full_history' not in st.session_state:
    st.session_state.display_full_history = True

# Set up the InferenceClient to access the Hugging Face model
client = InferenceClient(
    api_key="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"  # Your Hugging Face API token
)

# Function to generate a response using the Hugging Face model
def generate_response(user_input):
    # If we have previous messages, include them in the conversation
    messages = []
    
    # Add previous messages from history (limit to last 10 for context window reasons)
    for msg in st.session_state.messages[-10:]:
        role = "user" if msg["role"] == "user" else "assistant"
        messages.append({"role": role, "content": msg["content"]})
    
    # Add the new user message
    messages.append({"role": "user", "content": user_input})
    
    # Show a spinner while waiting for the model response
    with st.spinner("Thinking..."):
        try:
            # Use the chat_completion method with correct parameters
            response = client.chat_completion(
                model="meta-llama/Llama-3.2-3B-Instruct",
                messages=messages,
                temperature=0.7,
                max_tokens=500,  # Increased for longer responses
                top_p=0.9
            )
            
            # Extract and return the assistant's message
            return response.choices[0].message.content
        except Exception as e:
            st.error(f"Error: {str(e)}")
            return f"I'm sorry, I encountered an error: {str(e)}"

# Create the sidebar with information and examples
st.sidebar.header("About this Chatbot")
st.sidebar.markdown("""
This chatbot uses Meta's Llama-3.2-3B-Instruct model via Hugging Face's Inference API.

You can ask it questions, request information, or just chat with it.
""")

# Add a few example prompts to help users get started
st.sidebar.header("Example Prompts")
example_prompts = [
    "How to make a cake?",
    "Explain quantum computing in simple terms",
    "Write a short poem about nature",
    "What are the benefits of regular exercise?",
    "Tell me an interesting fact about space"
]

for i, prompt in enumerate(example_prompts):
    button_key = f"example_prompt_{i}"
    if st.sidebar.button(prompt, key=button_key):
        st.session_state.messages.append({"role": "user", "content": prompt})
        bot_response = generate_response(prompt)
        st.session_state.messages.append({"role": "assistant", "content": bot_response})
        st.rerun()

# Add sidebar toggle for full conversation history display
st.sidebar.markdown("---")
st.sidebar.header("Settings")
st.session_state.display_full_history = st.sidebar.checkbox(
    "Show full conversation history", 
    value=st.session_state.display_full_history
)

# Add a button to clear chat history
if st.sidebar.button("Clear Chat History", key="clear_history"):
    st.session_state.messages = []
    st.rerun()

# Create a chat interface in the main area
st.markdown("### Chat")

# Display the chat history
chat_container = st.container()
with chat_container:
    if st.session_state.display_full_history:
        messages_to_display = st.session_state.messages
    else:
        # Display only the last 6 messages if history is toggled off
        messages_to_display = st.session_state.messages[-6:] if len(st.session_state.messages) > 6 else st.session_state.messages
    
    for msg in messages_to_display:
        if msg["role"] == "user":
            st.markdown(f"**You:** {msg['content']}")
        else:
            st.markdown(f"**Bot:** {msg['content']}")

# Function to process user input
def process_user_input():
    if st.session_state.user_input:
        user_message = st.session_state.user_input
        
        # Store the user input in the chat history
        st.session_state.messages.append({"role": "user", "content": user_message})
        
        # Generate a response from the model
        bot_response = generate_response(user_message)
        
        # Store the model's response in the chat history
        st.session_state.messages.append({"role": "assistant", "content": bot_response})
        
        # Clear the input by setting an empty string in session_state
        st.session_state.user_input = ""

# Chat input area
user_input = st.text_input("Type your message:", key="user_input", on_change=process_user_input)

# Add a send button (optional, since pressing Enter also submits the form)
st.button("Send", on_click=process_user_input)
