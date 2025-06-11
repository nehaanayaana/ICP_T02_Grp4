import React, { useState, useRef, useEffect } from 'react';
import './App.css';

const examplePrompts = [
  'How to fertilize during dry season?',
  'What tools help with palm harvesting?',
  'Tell me about eco-friendly pest control.'
];

const productRecommendations = [
  {
    name: 'Fertilizer ProMix',
    image: 'https://www.pngall.com/wp-content/uploads/2/Fertilizer-PNG-Clipart.png',
    price: 'IDR 150,000'
  },
  {
    name: 'Palm Cutter Pro',
    image: 'https://5.imimg.com/data5/SELLER/Default/2022/5/RR/DF/HE/148912598/palm-fruit-cutter-500x500.jpg',
    price: 'IDR 80,000'
  },
  {
    name: 'Organic Soil Booster',
    image: 'https://www.pngmart.com/files/7/Fertilizer-PNG-Photos.png',
    price: 'IDR 120,000'
  }
];

function App() {
  const [messages, setMessages] = useState([
    { text: '👋 Hello farmer! I’m PalmPal. Ask me anything to help your plantation thrive 🌱', sender: 'bot' }
  ]);
  const [input, setInput] = useState('');
  const [language, setLanguage] = useState('en');
  const messagesEndRef = useRef(null);

  const sendMessage = async () => {
    if (!input.trim()) return;

    setMessages((prev) => [...prev, { text: input, sender: 'user' }]);
    setInput('');

    try {
      const response = await fetch('http://localhost:5000/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: input, language })
      });
      const data = await response.json();
      setMessages((prev) => [...prev, { text: data.reply, sender: 'bot' }]);
    } catch {
      setMessages((prev) => [...prev, { text: '⚠️ Oops! Something went wrong.', sender: 'bot' }]);
    }
  };

  const handlePromptClick = (prompt) => setInput(prompt);
  const handleKeyPress = (e) => e.key === 'Enter' && sendMessage();
  const toggleLanguage = () => setLanguage((prev) => (prev === 'en' ? 'id' : 'en'));

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  return (
    <div className="chat-bg">
      <div className="chat-container">
        <div className="header">
          🌴 PalmPal Assistant
          <button onClick={toggleLanguage}>
            {language === 'en' ? '🇬🇧 EN' : '🇮🇩 ID'}
          </button>
        </div>

        <div className="example-prompts">
          {examplePrompts.map((prompt, i) => (
            <button key={i} onClick={() => handlePromptClick(prompt)}>
              {prompt}
            </button>
          ))}
        </div>

        <div className="chat-box">
          {messages.map((msg, idx) => (
            <div key={idx} className={`chat-bubble ${msg.sender}`}>
              {msg.text}
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>

        <div className="recommendation-section">
          <h4>🌾 Recommended Tools & Products</h4>
          <div className="products">
            {productRecommendations.map((item, i) => (
              <div className="product-card" key={i}>
                <img src={item.image} alt={item.name} />
                <div className="product-info">
                  <strong>{item.name}</strong>
                  <small>{item.price}</small>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="input-bar">
          <input
            type="text"
            placeholder="Type your question here..."
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={handleKeyPress}
          />
          <button onClick={sendMessage}>Send</button>
        </div>
      </div>
    </div>
  );
}

export default App;
