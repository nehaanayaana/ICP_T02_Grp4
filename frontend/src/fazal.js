import React, { useState, useEffect, useRef } from 'react';
import { MessageCircle, X, Send, ShoppingCart, Star, Heart, Filter, Search, Bot, User, Sparkles, Zap, TrendingUp, Award } from 'lucide-react';

const SawitProEcommerce = () => {
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [messages, setMessages] = useState([
    {
      id: 1,
      text: "Hello! I'm your SawitPro AI shopping assistant. I can help you find the perfect palm oil products and equipment for your needs. How can I assist you today?",
      sender: 'bot',
      timestamp: new Date()
    }
  ]);
  const [inputMessage, setInputMessage] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [currentFilter, setCurrentFilter] = useState('all');
  const [favorites, setFavorites] = useState(new Set());
  const [cart, setCart] = useState([]);
  const [isConnected, setIsConnected] = useState(false);
  const messagesEndRef = useRef(null);

  // SawitPro product data
  const products = [
    {
      id: 1,
      name: "Premium Crude Palm Oil (CPO)",
      price: 899.99,
      originalPrice: 1099.99,
      image: "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&h=300&fit=crop",
      rating: 4.8,
      reviews: 1250,
      category: "palm-oil",
      badge: "Premium Quality",
      description: "High-grade crude palm oil with excellent purity and yield",
      specifications: "Moisture: <0.1%, FFA: <3%, Iodine Value: 50-55"
    },
    {
      id: 2,
      name: "Refined Bleached Deodorized Palm Oil (RBDPO)",
      price: 1299.99,
      originalPrice: 1499.99,
      image: "https://images.unsplash.com/photo-1581579582669-7b4f7d8c8c7c?w=300&h=300&fit=crop",
      rating: 4.9,
      reviews: 890,
      category: "palm-oil",
      badge: "Best Seller",
      description: "Premium refined palm oil ready for food industry applications",
      specifications: "Smoke Point: 235°C, Shelf Life: 24 months"
    },
    {
      id: 3,
      name: "Palm Oil Extraction Machine",
      price: 24999.99,
      originalPrice: 29999.99,
      image: "https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=300&h=300&fit=crop",
      rating: 4.7,
      reviews: 145,
      category: "equipment",
      badge: "Industrial Grade",
      description: "High-efficiency palm oil extraction equipment for commercial use",
      specifications: "Capacity: 500kg/hour, Power: 15kW, Efficiency: 95%"
    },
    {
      id: 4,
      name: "Palm Kernel Oil",
      price: 1599.99,
      originalPrice: 1899.99,
      image: "https://images.unsplash.com/photo-1593514222469-015d743211be?w=300&h=300&fit=crop",
      rating: 4.6,
      reviews: 320,
      category: "palm-oil",
      badge: "Organic Certified",
      description: "Premium palm kernel oil for cosmetic and food applications",
      specifications: "Lauric Acid: 48%, Myristic Acid: 16%, Palmitic Acid: 8%"
    },
    {
      id: 5,
      name: "Palm Oil Refining System",
      price: 45999.99,
      originalPrice: 54999.99,
      image: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=300&fit=crop",
      rating: 4.8,
      reviews: 78,
      category: "equipment",
      badge: "Complete Solution",
      description: "Complete palm oil refining system for large-scale operations",
      specifications: "Capacity: 1000kg/hour, Automation: Full PLC Control"
    },
    {
      id: 6,
      name: "Palm Oil Quality Testing Kit",
      price: 899.99,
      originalPrice: 1199.99,
      image: "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=300&h=300&fit=crop",
      rating: 4.5,
      reviews: 234,
      category: "testing",
      badge: "Laboratory Grade",
      description: "Professional testing kit for palm oil quality analysis",
      specifications: "Tests: FFA, Moisture, Iodine Value, Peroxide Value"
    }
  ];

  // Llama 3.2 API Integration (placeholder for now)
  const callLlamaAPI = async (message) => {
    try {
      // Placeholder for Llama 3.2 API call
      // const response = await fetch('https://api.huggingface.co/models/meta-llama/Llama-3.2-1B-Instruct', {
      //   method: 'POST',
      //   headers: {
      //     'Authorization': `Bearer ${API_KEY}`,
      //     'Content-Type': 'application/json',
      //   },
      //   body: JSON.stringify({
      //     inputs: message,
      //     parameters: {
      //       max_new_tokens: 250,
      //       temperature: 0.7,
      //       top_p: 0.95,
      //     }
      //   })
      // });
      
      // For now, return a simulated response
      return generateBotResponse(message);
    } catch (error) {
      console.error('Error calling Llama API:', error);
      return "I apologize, but I'm having trouble connecting to my AI service. Please try again later.";
    }
  };

  // Enhanced bot responses for SawitPro
  const generateBotResponse = (userMessage) => {
    const message = userMessage.toLowerCase();
    
    if (message.includes('hello') || message.includes('hi') || message.includes('hey')) {
      return "Hello! Welcome to SawitPro. I'm here to help you with palm oil products and equipment. What can I assist you with today?";
    } else if (message.includes('palm oil') || message.includes('cpo') || message.includes('crude')) {
      return "We offer premium palm oil products including CPO, RBDPO, and Palm Kernel Oil. Our crude palm oil has excellent purity with moisture content <0.1% and FFA <3%. Would you like to know more about specific grades?";
    } else if (message.includes('equipment') || message.includes('machine') || message.includes('extraction')) {
      return "Our industrial equipment includes palm oil extraction machines and complete refining systems. Our extraction machines have 95% efficiency and can process 500kg/hour. Are you looking for specific capacity requirements?";
    } else if (message.includes('price') || message.includes('cost') || message.includes('how much')) {
      return "Our products range from $899.99 for testing kits to $45,999.99 for complete refining systems. Palm oil prices start at $899.99 for CPO. Would you like pricing for specific products or bulk orders?";
    } else if (message.includes('quality') || message.includes('specification') || message.includes('test')) {
      return "Quality is our priority at SawitPro. All our palm oil products meet international standards. We provide detailed specifications including FFA, moisture content, and iodine values. We also offer professional testing kits for quality analysis.";
    } else if (message.includes('recommend') || message.includes('suggest') || message.includes('help')) {
      return "I'd be happy to recommend products based on your needs! Are you looking for palm oil for food production, cosmetics, or industrial use? Or do you need equipment for processing?";
    } else if (message.includes('organic') || message.includes('certified') || message.includes('sustainable')) {
      return "We offer organic certified palm kernel oil and follow sustainable practices. Our products are certified and meet international sustainability standards. Would you like more information about our certifications?";
    } else {
      return "I'm here to help with any questions about SawitPro's palm oil products and equipment. Feel free to ask about specifications, pricing, applications, or recommendations!";
    }
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSendMessage = async () => {
    if (inputMessage.trim() === '') return;

    const userMessage = {
      id: Date.now(),
      text: inputMessage,
      sender: 'user',
      timestamp: new Date()
    };

    setMessages(prev => [...prev, userMessage]);
    setInputMessage('');
    setIsTyping(true);

    // Call Llama API (or use fallback)
    setTimeout(async () => {
      const response = await callLlamaAPI(inputMessage);
      const botMessage = {
        id: Date.now() + 1,
        text: response,
        sender: 'bot',
        timestamp: new Date()
      };
      setMessages(prev => [...prev, botMessage]);
      setIsTyping(false);
    }, 1500);
  };

  const handleQuickAction = (action) => {
    const quickMessages = {
      'recommend-palm-oil': "Can you recommend the best palm oil products for food industry applications?",
      'equipment-inquiry': "I'm interested in palm oil processing equipment. What options do you have?",
      'quality-specs': "What are the quality specifications of your palm oil products?",
      'bulk-pricing': "Can you provide bulk pricing information for large orders?"
    };
    
    if (quickMessages[action]) {
      setInputMessage(quickMessages[action]);
    }
  };

  const toggleFavorite = (productId) => {
    setFavorites(prev => {
      const newFavorites = new Set(prev);
      if (newFavorites.has(productId)) {
        newFavorites.delete(productId);
      } else {
        newFavorites.add(productId);
      }
      return newFavorites;
    });
  };

  const addToCart = (product) => {
    setCart(prev => {
      const existingItem = prev.find(item => item.id === product.id);
      if (existingItem) {
        return prev.map(item =>
          item.id === product.id
            ? { ...item, quantity: item.quantity + 1 }
            : item
        );
      }
      return [...prev, { ...product, quantity: 1 }];
    });
  };

  const filteredProducts = currentFilter === 'all' 
    ? products 
    : products.filter(product => product.category === currentFilter);

  const categories = ['all', 'palm-oil', 'equipment', 'testing'];

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-yellow-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-green-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-2">
                <div className="w-8 h-8 bg-gradient-to-r from-green-700 to-yellow-500 rounded-lg flex items-center justify-center">
                  <span className="text-white font-bold text-sm">SP</span>
                </div>
                <h1 className="text-2xl font-bold" style={{ color: '#576A34' }}>
                  SawitPro
                </h1>
              </div>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <input
                  type="text"
                  placeholder="Search palm oil products..."
                  className="pl-10 pr-4 py-2 border border-green-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent w-64"
                />
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <div className="relative">
                <ShoppingCart className="w-6 h-6" style={{ color: '#576A34' }} />
                {cart.length > 0 && (
                  <span className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs">
                    {cart.reduce((sum, item) => sum + item.quantity, 0)}
                  </span>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Hero Section */}
        <div className="mb-8 text-center">
          <div className="flex items-center justify-center space-x-2 mb-4">
            <Sparkles className="w-6 h-6" style={{ color: '#E9D037' }} />
            <h2 className="text-3xl font-bold" style={{ color: '#576A34' }}>Premium Palm Oil Products</h2>
          </div>
          <p className="text-gray-600 text-lg">Industry-leading palm oil and processing equipment</p>
        </div>

        {/* Category Filter */}
        <div className="flex items-center space-x-2 mb-6 overflow-x-auto pb-2">
          <Filter className="w-5 h-5 text-gray-500 flex-shrink-0" />
          {categories.map(category => (
            <button
              key={category}
              onClick={() => setCurrentFilter(category)}
              className={`px-6 py-3 rounded-full text-sm font-medium whitespace-nowrap transition-all duration-200 ${
                currentFilter === category
                  ? 'text-white shadow-lg scale-105'
                  : 'bg-white text-gray-700 hover:bg-green-50 border border-green-200'
              }`}
              style={currentFilter === category ? { backgroundColor: '#576A34' } : {}}
            >
              {category === 'all' ? 'All Products' : 
               category === 'palm-oil' ? 'Palm Oil' :
               category === 'equipment' ? 'Equipment' : 
               'Testing Kits'}
            </button>
          ))}
        </div>

        {/* Products Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {filteredProducts.map(product => (
            <div key={product.id} className="bg-white rounded-xl shadow-sm hover:shadow-xl transition-all duration-300 overflow-hidden group border border-green-100">
              <div className="relative">
                <img
                  src={product.image}
                  alt={product.name}
                  className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <div className="absolute top-3 left-3">
                  <span className="text-white px-3 py-1 rounded-full text-xs font-medium" style={{ backgroundColor: '#576A34' }}>
                    {product.badge}
                  </span>
                </div>
                <button
                  onClick={() => toggleFavorite(product.id)}
                  className="absolute top-3 right-3 p-2 bg-white rounded-full shadow-md hover:scale-110 transition-transform duration-200"
                >
                  <Heart
                    className={`w-4 h-4 ${
                      favorites.has(product.id) ? 'fill-red-500 text-red-500' : 'text-gray-400'
                    }`}
                  />
                </button>
              </div>
              
              <div className="p-4">
                <h3 className="font-semibold text-gray-900 mb-2 line-clamp-2">{product.name}</h3>
                <p className="text-sm text-gray-600 mb-2">{product.description}</p>
                <p className="text-xs text-gray-500 mb-3">{product.specifications}</p>
                
                <div className="flex items-center space-x-1 mb-3">
                  <div className="flex">
                    {[...Array(5)].map((_, i) => (
                      <Star
                        key={i}
                        className={`w-4 h-4 ${
                          i < Math.floor(product.rating) ? 'text-yellow-400' : 'text-gray-300'
                        }`}
                        style={i < Math.floor(product.rating) ? { fill: '#E9D037' } : {}}
                      />
                    ))}
                  </div>
                  <span className="text-sm text-gray-600">({product.reviews})</span>
                </div>
                
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center space-x-2">
                    <span className="text-xl font-bold text-gray-900">${product.price}</span>
                    <span className="text-sm text-gray-500 line-through">${product.originalPrice}</span>
                  </div>
                  <span className="text-sm font-medium text-green-600">
                    {Math.round(((product.originalPrice - product.price) / product.originalPrice) * 100)}% off
                  </span>
                </div>
                
                <button
                  onClick={() => addToCart(product)}
                  className="w-full text-white py-2 rounded-lg transition-all duration-200 flex items-center justify-center space-x-2 group hover:shadow-lg"
                  style={{ backgroundColor: '#576A34' }}
                  onMouseEnter={(e) => e.target.style.backgroundColor = '#4a5a2d'}
                  onMouseLeave={(e) => e.target.style.backgroundColor = '#576A34'}
                >
                  <ShoppingCart className="w-4 h-4 group-hover:scale-110 transition-transform" />
                  <span>Add to Cart</span>
                </button>
              </div>
            </div>
          ))}
        </div>
      </main>

      {/* Enhanced Chatbot */}
      <div className="fixed bottom-6 right-6 z-50">
        {!isChatOpen && (
          <button
            onClick={() => setIsChatOpen(true)}
            className="text-white p-4 rounded-full shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-110 relative"
            style={{ backgroundColor: '#576A34' }}
          >
            <MessageCircle className="w-6 h-6" />
            <div className="absolute -top-1 -right-1 w-3 h-3 bg-green-400 rounded-full animate-pulse"></div>
          </button>
        )}

        {isChatOpen && (
          <div className="bg-white rounded-xl shadow-2xl w-96 h-[500px] flex flex-col overflow-hidden border border-green-200">
            {/* Chat Header */}
            <div className="text-white p-4 flex items-center justify-between" style={{ backgroundColor: '#576A34' }}>
              <div className="flex items-center space-x-2">
                <Bot className="w-5 h-5" />
                <div>
                  <span className="font-semibold">SawitPro AI Assistant</span>
                  <div className="text-xs opacity-75">Palm Oil Expert</div>
                </div>
              </div>
              <button
                onClick={() => setIsChatOpen(false)}
                className="hover:bg-white/20 p-1 rounded transition-colors"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Quick Action Buttons */}
            <div className="p-3 bg-green-50 border-b border-green-100">
              <div className="text-xs font-medium text-gray-600 mb-2">Quick Actions:</div>
              <div className="flex flex-wrap gap-2">
                <button
                  onClick={() => handleQuickAction('recommend-palm-oil')}
                  className="px-3 py-1 bg-white text-xs rounded-full hover:bg-green-100 transition-colors border border-green-200"
                >
                  <Award className="w-3 h-3 inline mr-1" />
                  Recommend Products
                </button>
                <button
                  onClick={() => handleQuickAction('equipment-inquiry')}
                  className="px-3 py-1 bg-white text-xs rounded-full hover:bg-green-100 transition-colors border border-green-200"
                >
                  <Zap className="w-3 h-3 inline mr-1" />
                  Equipment Info
                </button>
                <button
                  onClick={() => handleQuickAction('quality-specs')}
                  className="px-3 py-1 bg-white text-xs rounded-full hover:bg-green-100 transition-colors border border-green-200"
                >
                  <TrendingUp className="w-3 h-3 inline mr-1" />
                  Quality Specs
                </button>
              </div>
            </div>

            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4">
              {messages.map(message => (
                <div
                  key={message.id}
                  className={`flex ${message.sender === 'user' ? 'justify-end' : 'justify-start'}`}
                >
                  <div className={`flex items-start space-x-2 max-w-[80%] ${message.sender === 'user' ? 'flex-row-reverse space-x-reverse' : ''}`}>
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                      message.sender === 'user' 
                        ? 'text-white' 
                        : 'bg-green-100'
                    }`}
                    style={message.sender === 'user' ? { backgroundColor: '#576A34' } : { color: '#576A34' }}
                    >
                      {message.sender === 'user' ? <User className="w-4 h-4" /> : <Bot className="w-4 h-4" />}
                    </div>
                    <div className={`rounded-lg p-3 ${
                      message.sender === 'user'
                        ? 'text-white'
                        : 'bg-gray-100 text-gray-800'
                    }`}
                    style={message.sender === 'user' ? { backgroundColor: '#576A34' } : {}}
                    >
                      <p className="text-sm">{message.text}</p>
                      <div className="text-xs opacity-70 mt-1">
                        {message.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                      </div>
                    </div>
                  </div>
                </div>
              ))}
              
              {isTyping && (
                <div className="flex justify-start">
                  <div className="flex items-start space-x-2 max-w-xs">
                    <div className="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center flex-shrink-0" style={{ color: '#576A34' }}>
                      <Bot className="w-4 h-4" />
                    </div>
                    <div className="bg-gray-100 rounded-lg p-3">
                      <div className="flex space-x-1">
                        <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                        <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{animationDelay: '0.1s'}}></div>
                        <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{animationDelay: '0.2s'}}></div>
                      </div>
                    </div>
                  </div>
                </div>
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Input */}
            <div className="p-4 border-t border-green-100">
              <div className="flex space-x-2">
                <input
                  type="text"
                  value={inputMessage}
                  onChange={(e) => setInputMessage(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
                  placeholder="Ask about palm oil products..."
                  className="flex-1 border border-green-200 rounded-lg px-3 py-2 focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm"
                />
                <button
                  onClick={handleSendMessage}
                  disabled={!inputMessage.trim()}
                  className="text-white p-2 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  style={{ backgroundColor: '#576A34' }}
                >
                  <Send className="w-4 h-4" />
                </button>
              </div>
              <div className="text-xs text-gray-500 mt-2 text-center">
                Powered by Llama 3.2 AI • SawitPro Assistant
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default SawitProEcommerce;
