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

  messageDiv.innerHTML = `
    <div class="message-header">
      <strong class="message-username">${escapeHtml(data.username)}</strong>
      <span class="message-time">${timeString}</span>
    </div>
    <div class="message-content">${escapeHtml(data.content)}</div>
  `;

  messagesContainer.appendChild(messageDiv);
  scrollToBottom();
}

function addSystemMessage(text) {
  const messagesContainer = document.getElementById('messages');

  const messageDiv = document.createElement('div');
  messageDiv.className = 'message system-message';

  messageDiv.innerHTML = `
    <div class="message-content">
      <em>💬 ${escapeHtml(text)}</em>
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
    usersList.innerHTML = '<div class="no-users">No users online</div>';
    return;
  }

  usersList.innerHTML = users.map(username => {
    const isCurrentUser = username === config.username;
    const userClass = isCurrentUser ? 'user-item current-user' : 'user-item';
    const label = isCurrentUser ? ' (you)' : '';

    return `
      <div class="${userClass}">
        <span class="user-status"></span>
        <span class="user-name">${escapeHtml(username)}${label}</span>
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
  const statusText = statusElement.querySelector('.status-text');

  statusElement.className = `connection-status ${status}`;

  switch (status) {
    case 'connected':
      statusText.textContent = 'Connected';
      break;
    case 'disconnected':
      statusText.textContent = 'Disconnected';
      break;
    case 'error':
      statusText.textContent = 'Connection Error';
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
