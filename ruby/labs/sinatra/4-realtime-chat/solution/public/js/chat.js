// WebSocket Chat Client
// Handles real-time communication with the WebSocket server

let ws = null;
let config = null;
let reconnectAttempts = 0;
const MAX_RECONNECT_ATTEMPTS = 5;

function initializeChat(chatConfig) {
  config = chatConfig;
  connectWebSocket();
  setupMessageForm();
}

function connectWebSocket() {
  console.log('Connecting to WebSocket server...');

  ws = new WebSocket(config.wsUrl);

  ws.onopen = () => {
    console.log('WebSocket connected');
    reconnectAttempts = 0;
    updateConnectionStatus('connected');

    // Join the room
    sendMessage({
      type: 'join',
      username: config.username,
      room: config.roomName
    });
  };

  ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    handleMessage(data);
  };

  ws.onerror = (error) => {
    console.error('WebSocket error:', error);
    updateConnectionStatus('error');
  };

  ws.onclose = () => {
    console.log('WebSocket disconnected');
    updateConnectionStatus('disconnected');

    // Attempt to reconnect
    if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
      reconnectAttempts++;
      const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 30000);
      console.log(`Reconnecting in ${delay}ms...`);
      setTimeout(connectWebSocket, delay);
    } else {
      showError('Connection lost. Please refresh the page.');
    }
  };
}

function handleMessage(data) {
  console.log('Received:', data);

  switch (data.type) {
    case 'chat':
      addChatMessage(data);
      break;
    case 'join':
      addSystemMessage(`${escapeHtml(data.username)} joined the room`);
      break;
    case 'leave':
      addSystemMessage(`${escapeHtml(data.username)} left the room`);
      break;
    case 'users':
      updateUsersList(data.users);
      break;
    default:
      console.log('Unknown message type:', data.type);
  }
}

function addChatMessage(data) {
  const messagesContainer = document.getElementById('messages');

  const messageDiv = document.createElement('div');
  messageDiv.className = 'message';

  const isOwnMessage = data.username === config.username;
  if (isOwnMessage) {
    messageDiv.classList.add('own-message');
  }

  const time = new Date(data.timestamp);
  const timeString = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  const initial = data.username.charAt(0).toUpperCase();

  messageDiv.innerHTML = `
    <div class="flex space-x-3 group hover:bg-white/50 rounded-lg p-3 transition-colors">
      <div class="flex-shrink-0">
        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-secondary flex items-center justify-center text-white font-bold">
          ${initial}
        </div>
      </div>
      <div class="flex-1 min-w-0">
        <div class="flex items-baseline space-x-2">
          <span class="font-semibold text-slate-900">${escapeHtml(data.username)}</span>
          <span class="text-xs text-slate-400">${timeString}</span>
        </div>
        <p class="text-slate-700 mt-1 break-words">${escapeHtml(data.content)}</p>
      </div>
    </div>
  `;

  messagesContainer.appendChild(messageDiv);
  scrollToBottom();
}

function addSystemMessage(text) {
  const messagesContainer = document.getElementById('messages');

  const messageDiv = document.createElement('div');
  messageDiv.className = 'flex justify-center my-2';

  messageDiv.innerHTML = `
    <div class="bg-slate-200 text-slate-600 px-4 py-2 rounded-full text-sm">
      <i class="fas fa-info-circle mr-1"></i>
      <em>${escapeHtml(text)}</em>
    </div>
  `;

  messagesContainer.appendChild(messageDiv);
  scrollToBottom();
}

function updateUsersList(users) {
  const usersList = document.getElementById('users-list');
  const userCount = document.getElementById('user-count');

  userCount.textContent = users.length;

  if (users.length === 0) {
    usersList.innerHTML = '<div class="text-slate-400 text-sm text-center py-4">No users online</div>';
    return;
  }

  usersList.innerHTML = users.map(username => {
    const isCurrentUser = username === config.username;
    const bgClass = isCurrentUser ? 'bg-primary/10 border-primary/30' : 'bg-slate-100 border-transparent';
    const textClass = isCurrentUser ? 'text-primary font-semibold' : 'text-slate-700';
    const label = isCurrentUser ? ' (you)' : '';
    const initial = username.charAt(0).toUpperCase();

    return `
      <div class="flex items-center space-x-3 px-3 py-2 rounded-lg ${bgClass} border transition-colors">
        <div class="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-secondary flex items-center justify-center text-white text-sm font-bold flex-shrink-0">
          ${initial}
        </div>
        <span class="${textClass} text-sm truncate">${escapeHtml(username)}${label}</span>
        <span class="w-2 h-2 rounded-full bg-green-500 flex-shrink-0 ml-auto"></span>
      </div>
    `;
  }).join('');
}

function setupMessageForm() {
  const form = document.getElementById('message-form');
  const input = document.getElementById('message-input');

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const content = input.value.trim();
    if (!content) return;

    // Check connection
    if (ws.readyState !== WebSocket.OPEN) {
      showError('Not connected to server');
      return;
    }

    // Send message
    sendMessage({
      type: 'chat',
      username: config.username,
      room: config.roomName,
      content: content
    });

    // Clear input
    input.value = '';
    input.focus();
  });
}

function sendMessage(data) {
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify(data));
  } else {
    console.error('WebSocket not connected');
  }
}

function updateConnectionStatus(status) {
  const statusElement = document.getElementById('connection-status');
  const statusDot = statusElement.querySelector('.status-dot');
  const statusText = statusElement.querySelector('.status-text');

  switch (status) {
    case 'connected':
      statusDot.className = 'status-dot w-2.5 h-2.5 rounded-full bg-green-500';
      statusText.textContent = 'Connected';
      statusElement.className = 'flex items-center space-x-2 p-3 rounded-lg bg-green-50';
      break;
    case 'disconnected':
      statusDot.className = 'status-dot w-2.5 h-2.5 rounded-full bg-red-500';
      statusText.textContent = 'Disconnected';
      statusElement.className = 'flex items-center space-x-2 p-3 rounded-lg bg-red-50';
      break;
    case 'error':
      statusDot.className = 'status-dot w-2.5 h-2.5 rounded-full bg-yellow-500';
      statusText.textContent = 'Connection Error';
      statusElement.className = 'flex items-center space-x-2 p-3 rounded-lg bg-yellow-50';
      break;
  }
}

function scrollToBottom() {
  const messagesContainer = document.getElementById('messages');
  messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function showError(message) {
  const messagesContainer = document.getElementById('messages');

  const errorDiv = document.createElement('div');
  errorDiv.className = 'message error-message';
  errorDiv.innerHTML = `
    <div class="message-content">
      <strong>⚠️ Error:</strong> ${escapeHtml(message)}
    </div>
  `;

  messagesContainer.appendChild(errorDiv);
  scrollToBottom();
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
  if (ws && ws.readyState === WebSocket.OPEN) {
    sendMessage({
      type: 'leave',
      username: config.username,
      room: config.roomName
    });
    ws.close();
  }
});
