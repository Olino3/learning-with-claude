# Tutorial 23: WebSockets & Modern Async Network Programming

Welcome to the world of real-time network communication in Ruby! This tutorial explores how to build high-performance, asynchronous network applications using modern Ruby concurrency primitives and the WebSocket protocol.

## 📋 Learning Objectives

By the end of this tutorial, you will be able to:

- Understand TCP/UDP socket programming fundamentals in Ruby
- Master the `async` gem ecosystem for modern asynchronous I/O
- Comprehend WebSocket protocol internals (handshake, framing, masking)
- Build WebSocket servers using `async-websocket`
- Leverage Falcon as a high-performance async web server
- Apply real-time communication patterns (pub/sub, broadcasting)
- Compare Ruby's async approach with Python's `asyncio` and `websockets`
- Migrate legacy EventMachine code to modern async alternatives

## 🎯 Prerequisites

**Essential:** Complete [Tutorial 18: Concurrency and Parallelism](../18-Concurrency-Parallelism/README.md) first, especially the **Fibers** section. Understanding cooperative concurrency is critical for async programming.

**Recommended:**
- Basic HTTP protocol knowledge
- Familiarity with network concepts (ports, protocols, sockets)
- Sinatra or web framework experience (helpful but not required)

## 🐍➡️🔴 Coming from Python

If you're familiar with Python's async ecosystem, here's how Ruby concepts map:

| Python | Ruby | Notes |
|--------|------|-------|
| `asyncio` | `async` gem | Fiber-based async runtime |
| `async def` / `await` | `Async` blocks | Different syntax, same concept |
| `asyncio.create_task()` | `Async { }` | Creates async tasks |
| `websockets` library | `async-websocket` | WebSocket client/server |
| `uvicorn` / `hypercorn` | `falcon` | ASGI vs Async Rack server |
| `socket` module | `Socket` class | Similar low-level APIs |
| `asyncio.Server` | `Async::IO::Endpoint` | Server endpoints |
| GIL (removed in 3.13) | GVL (always present) | Ruby's concurrency constraint |

📘 **Python Note:** Ruby's `async` gem uses **Fibers** under the hood (cooperative concurrency), similar to how Python's `asyncio` uses coroutines. The key difference: Python has explicit `async`/`await` syntax, while Ruby uses blocks and Fiber schedulers. Both achieve non-blocking I/O without thread overhead.

## 📦 Installation

This tutorial requires external gems. Install them first:

```bash
gem install async async-websocket async-http falcon
```

**What each gem does:**
- `async` - Core async runtime and task scheduler
- `async-websocket` - WebSocket protocol implementation
- `async-http` - Async HTTP client/server
- `falcon` - High-performance async web server

## 📝 Part 1: Socket Programming Fundamentals

Before diving into WebSockets, let's understand basic network sockets—the foundation of all network communication.

### Understanding Sockets

A **socket** is an endpoint for sending/receiving data across a network. Think of it as a "phone connection" between two programs.

**Socket types:**
- **TCP (Transmission Control Protocol)** - Reliable, connection-oriented, ordered delivery
- **UDP (User Datagram Protocol)** - Unreliable, connectionless, faster but no guarantees

### TCP Echo Server Example

```ruby
require 'socket'

# Create a TCP server on port 9000
server = TCPServer.new('localhost', 9000)
puts "TCP Echo Server listening on port 9000..."

loop do
  # Accept a client connection (blocks until client connects)
  client = server.accept
  puts "Client connected: #{client.peeraddr[2]}"
  
  # Read data from client
  request = client.gets
  puts "Received: #{request}"
  
  # Echo it back
  client.puts "ECHO: #{request}"
  
  # Close connection
  client.close
end
```

**Test it:**
```bash
# Terminal 1: Run server
ruby tcp_echo_server.rb

# Terminal 2: Connect with telnet
telnet localhost 9000
# Type: Hello, server!
# Receive: ECHO: Hello, server!
```

📘 **Python Note:** This is equivalent to Python's `socket.socket(socket.AF_INET, socket.SOCK_STREAM)` followed by `bind()`, `listen()`, and `accept()`. Ruby's `TCPServer` provides a higher-level abstraction.

### The Problem: Blocking I/O

The above server has a critical limitation—it handles **one client at a time**. The `accept()` and `gets()` calls **block**, meaning:

```ruby
client = server.accept  # Blocks here until a client connects
request = client.gets   # Blocks here until data arrives
```

While handling Client A, Client B must wait. This is where **async I/O** becomes essential.

## 📝 Part 2: Understanding the `async` Gem

The `async` gem provides a Fiber-based scheduler for non-blocking I/O operations. It allows thousands of concurrent tasks without thread overhead.

### Core Concepts

**1. The Async Block**

```ruby
require 'async'

# Creates an async reactor (event loop)
Sync do
  puts "Inside async context"
  # All async operations must be within this block
end
```

📘 **Python Note:** `Sync do` is similar to `asyncio.run()` in Python. It creates the event loop and runs until all tasks complete.

**2. Creating Async Tasks**

```ruby
require 'async'

Sync do
  # Create two concurrent tasks
  task1 = Async do
    sleep 2
    puts "Task 1 complete"
  end
  
  task2 = Async do
    sleep 1
    puts "Task 2 complete"
  end
  
  # Wait for both to finish
  task1.wait
  task2.wait
end

# Output:
# Task 2 complete (after 1 second)
# Task 1 complete (after 2 seconds)
# Total time: ~2 seconds (not 3!)
```

📘 **Python Note:** `Async { }` is like `asyncio.create_task()`. The tasks run concurrently, yielding control during I/O operations.

**3. Async I/O Operations**

```ruby
require 'async'
require 'async/http/internet'

Sync do
  internet = Async::HTTP::Internet.new
  
  # Fetch multiple URLs concurrently
  urls = [
    'https://jsonplaceholder.typicode.com/posts/1',
    'https://jsonplaceholder.typicode.com/posts/2',
    'https://jsonplaceholder.typicode.com/posts/3'
  ]
  
  tasks = urls.map do |url|
    Async do
      response = internet.get(url)
      puts "Fetched #{url}: #{response.status}"
      response.read
    end
  end
  
  # Wait for all fetches to complete
  results = tasks.map(&:wait)
  puts "Fetched #{results.size} URLs concurrently"
ensure
  internet&.close
end
```

This fetches all 3 URLs **concurrently** using a single thread!

### How It Works: Fiber Scheduling

Under the hood, `async` uses **Fibers** (covered in Tutorial 18):

```ruby
# When an async task blocks on I/O:
# 1. The Fiber yields control back to the scheduler
# 2. The scheduler runs another Fiber that's ready
# 3. When I/O completes, the original Fiber resumes

# Simplified illustration:
fiber1 = Fiber.new do
  puts "Fiber 1 start"
  Fiber.yield  # Simulates waiting for I/O
  puts "Fiber 1 resume"
end

fiber2 = Fiber.new do
  puts "Fiber 2 start"
  Fiber.yield
  puts "Fiber 2 resume"
end

# Scheduler interleaves them:
fiber1.resume  # => Fiber 1 start
fiber2.resume  # => Fiber 2 start
fiber1.resume  # => Fiber 1 resume
fiber2.resume  # => Fiber 2 resume
```

📘 **Python Note:** Python's `asyncio` uses coroutines and `await` points for yielding. Ruby's `async` gem handles yielding automatically when you perform async I/O operations.

## 📝 Part 3: Building an Async TCP Server

Let's rebuild our echo server using `async` to handle multiple clients:

```ruby
require 'async'
require 'async/io/stream'
require 'async/io/endpoint'

Sync do
  # Create endpoint for localhost:9000
  endpoint = Async::IO::Endpoint.tcp('localhost', 9000)
  
  # Bind and listen
  endpoint.bind do |server|
    puts "Async TCP Echo Server listening on port 9000..."
    
    # Accept connections in a loop
    server.listen(128) do |peer|
      # Each connection runs in its own async task!
      Async do |task|
        stream = Async::IO::Stream.new(peer)
        
        puts "Client connected"
        
        begin
          while line = stream.read_until("\n")
            puts "Received: #{line.strip}"
            stream.write("ECHO: #{line}")
            stream.flush
          end
        rescue EOFError
          puts "Client disconnected"
        ensure
          peer.close
        end
      end
    end
  end
end
```

**Key improvements:**
- ✅ Handles **unlimited clients concurrently**
- ✅ Each client gets its own async task (Fiber)
- ✅ Non-blocking I/O throughout
- ✅ Single thread, low memory overhead

📘 **Python Note:** This pattern is similar to `asyncio.start_server()` in Python. Each connection callback runs as a coroutine.

## 📝 Part 4: WebSocket Protocol Internals

WebSockets provide **full-duplex communication** over a single TCP connection. Unlike HTTP (request-response), both client and server can send messages anytime.

### The WebSocket Handshake

WebSocket connections start as HTTP, then **upgrade** to WebSocket:

**1. Client Request (HTTP Upgrade)**

```http
GET /chat HTTP/1.1
Host: localhost:9001
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13
```

**2. Server Response**

```http
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
```

**Key points:**
- `Sec-WebSocket-Key` is a random base64 string
- `Sec-WebSocket-Accept` is computed as: `Base64(SHA1(key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"))`
- After 101 response, connection switches to WebSocket framing

### WebSocket Frame Structure

Data is sent in **frames** (not raw bytes):

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-------+-+-------------+-------------------------------+
|F|R|R|R| opcode|M| Payload len |    Extended payload length    |
|I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
|N|V|V|V|       |S|             |   (if payload len==126/127)   |
| |1|2|3|       |K|             |                               |
+-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
|     Extended payload length continued, if payload len == 127  |
+ - - - - - - - - - - - - - - - +-------------------------------+
|                               |Masking-key, if MASK set to 1  |
+-------------------------------+-------------------------------+
| Masking-key (continued)       |          Payload Data         |
+-------------------------------- - - - - - - - - - - - - - - - +
:                     Payload Data continued ...                :
+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
|                     Payload Data continued ...                |
+---------------------------------------------------------------+
```

**Opcodes:**
- `0x0` - Continuation frame
- `0x1` - Text frame (UTF-8)
- `0x2` - Binary frame
- `0x8` - Close frame
- `0x9` - Ping frame
- `0xA` - Pong frame

**Masking:**
- Client → Server messages **MUST** be masked
- Server → Client messages **MUST NOT** be masked
- Prevents proxy cache poisoning attacks

📘 **Python Note:** Python's `websockets` library handles framing automatically. In Ruby, `async-websocket` does the same, but understanding the protocol helps with debugging.

## 📝 Part 5: Building a WebSocket Server with `async-websocket`

Let's build a real-time echo server using WebSockets:

```ruby
require 'async'
require 'async/http/endpoint'
require 'async/websocket/server'
require 'async/websocket/adapters/rack'

# Define WebSocket application
app = lambda do |env|
  # Check if it's a WebSocket upgrade request
  if Async::WebSocket::Adapters::Rack.websocket?(env)
    # Upgrade to WebSocket
    Async::WebSocket::Adapters::Rack.open(env) do |connection|
      puts "Client connected via WebSocket"
      
      # Read messages in a loop
      while message = connection.read
        puts "Received: #{message.inspect}"
        
        # Echo back
        connection.write("ECHO: #{message}")
        connection.flush
      end
      
      puts "Client disconnected"
    end
  else
    # Regular HTTP response
    [200, {'Content-Type' => 'text/plain'}, ['WebSocket server running']]
  end
end

# Run server
Sync do
  endpoint = Async::HTTP::Endpoint.parse('http://localhost:9001')
  
  server = Async::HTTP::Server.for(endpoint, protocol: Async::HTTP::Protocol::HTTP1) do |request|
    # Convert HTTP request to Rack env
    app.call(request.env)
  end
  
  puts "WebSocket server running on ws://localhost:9001"
  server.run
end
```

**Test with a client:**

```ruby
require 'async'
require 'async/websocket/client'

Sync do
  endpoint = Async::HTTP::Endpoint.parse('ws://localhost:9001')
  
  Async::WebSocket::Client.connect(endpoint) do |connection|
    # Send a message
    connection.write("Hello, WebSocket!")
    connection.flush
    
    # Read the echo response
    response = connection.read
    puts "Server replied: #{response.inspect}"
  end
end
```

📘 **Python Note:** This is equivalent to Python's:
```python
import asyncio
import websockets

async def echo(websocket):
    async for message in websocket:
        await websocket.send(f"ECHO: {message}")

asyncio.run(websockets.serve(echo, "localhost", 9001))
```

## 📝 Part 6: Real-Time Chat Server

Let's build a multi-client chat room with broadcasting:

```ruby
require 'async'
require 'async/http/endpoint'
require 'async/websocket/adapters/rack'
require 'set'

# Track all connected clients
clients = Set.new
clients_mutex = Mutex.new

# Broadcast to all clients
def broadcast(clients, clients_mutex, message, exclude: nil)
  clients_mutex.synchronize do
    clients.each do |client|
      next if client == exclude
      begin
        client.write(message)
        client.flush
      rescue => e
        puts "Failed to send to client: #{e.message}"
      end
    end
  end
end

app = lambda do |env|
  if Async::WebSocket::Adapters::Rack.websocket?(env)
    Async::WebSocket::Adapters::Rack.open(env) do |connection|
      # Add to clients set
      clients_mutex.synchronize { clients << connection }
      client_id = connection.object_id
      
      puts "Client #{client_id} connected (#{clients.size} total)"
      broadcast(clients, clients_mutex, "User #{client_id} joined", exclude: connection)
      
      begin
        while message = connection.read
          puts "[#{client_id}]: #{message}"
          # Broadcast to all other clients
          broadcast(clients, clients_mutex, "[#{client_id}]: #{message}", exclude: connection)
        end
      rescue => e
        puts "Client #{client_id} error: #{e.message}"
      ensure
        # Remove from clients set
        clients_mutex.synchronize { clients.delete(connection) }
        puts "Client #{client_id} disconnected (#{clients.size} remaining)"
        broadcast(clients, clients_mutex, "User #{client_id} left")
      end
    end
  else
    [200, {'Content-Type' => 'text/html'}, [<<~HTML]]
      <!DOCTYPE html>
      <html>
      <head><title>Chat</title></head>
      <body>
        <h1>WebSocket Chat</h1>
        <div id="messages"></div>
        <input id="input" type="text" placeholder="Type message...">
        <script>
          const ws = new WebSocket('ws://localhost:9001');
          const messages = document.getElementById('messages');
          const input = document.getElementById('input');
          
          ws.onmessage = (event) => {
            const msg = document.createElement('div');
            msg.textContent = event.data;
            messages.appendChild(msg);
          };
          
          input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && input.value) {
              ws.send(input.value);
              input.value = '';
            }
          });
        </script>
      </body>
      </html>
    HTML
  end
end

Sync do
  endpoint = Async::HTTP::Endpoint.parse('http://localhost:9001')
  server = Async::HTTP::Server.for(endpoint, protocol: Async::HTTP::Protocol::HTTP1, &app)
  
  puts "Chat server running on http://localhost:9001"
  server.run
end
```

**Features:**
- ✅ Multiple clients can connect
- ✅ Messages broadcast to all clients
- ✅ Join/leave notifications
- ✅ Thread-safe client management
- ✅ Built-in HTML chat interface

📘 **Python Note:** Similar to Python's `websockets.broadcast()` or using a pub/sub pattern with `asyncio.Queue`.

## 📝 Part 7: Using Falcon Web Server

Falcon is a modern, async-first Rack server built on the `async` gem. It's designed for high concurrency.

### Basic Falcon Setup

**config.ru:**
```ruby
require 'async/websocket/adapters/rack'

# Your Rack app
app = lambda do |env|
  if Async::WebSocket::Adapters::Rack.websocket?(env)
    Async::WebSocket::Adapters::Rack.open(env) do |connection|
      connection.write("Hello from Falcon!")
      connection.flush
    end
  else
    [200, {'Content-Type' => 'text/plain'}, ['Falcon server running']]
  end
end

run app
```

**Run with Falcon:**
```bash
falcon serve --bind http://localhost:9001
```

### Performance Comparison

| Server | Model | Concurrency | WebSocket Support |
|--------|-------|-------------|-------------------|
| **WEBrick** | Threaded | Low (~5-10 threads) | No |
| **Puma** | Threaded | Medium (~16 threads) | Limited |
| **Thin** | EventMachine | High (event-driven) | Yes |
| **Falcon** | **Async/Fibers** | **Very High** | **Native** |

**Benchmark example (1000 concurrent connections):**
- Thin (EventMachine): ~800 req/sec, 200MB memory
- Falcon (async): ~1500 req/sec, 150MB memory

📘 **Python Note:** Falcon is similar to `uvicorn` or `hypercorn` for ASGI apps. All are async-first servers designed for high concurrency.

## 📝 Part 8: EventMachine vs Async (Historical Context)

Before the `async` gem, **EventMachine** was Ruby's primary async I/O library. However, it has several limitations:

### EventMachine Approach

```ruby
require 'eventmachine'

EM.run do
  EM::WebSocket.run(host: '0.0.0.0', port: 9001) do |ws|
    ws.onopen { puts "Client connected" }
    ws.onmessage { |msg| ws.send("ECHO: #{msg}") }
    ws.onclose { puts "Client disconnected" }
  end
end
```

### Why Migrate to Async?

**EventMachine limitations:**
1. **Not Ruby 3.x native** - Doesn't integrate with modern Fiber scheduler
2. **Global state** - `EM.run` blocks entire process
3. **C extensions** - Harder to debug, platform-specific issues
4. **Callback hell** - Deeply nested callbacks instead of structured code
5. **Stalled development** - Last major update was years ago

**Async advantages:**
1. ✅ **Native Ruby Fibers** - Clean integration with Ruby's concurrency model
2. ✅ **Structured concurrency** - Tasks, not callbacks
3. ✅ **Pure Ruby** - Easier debugging, better portability
4. ✅ **Active development** - Regular updates and improvements
5. ✅ **Better composability** - Works with any Fiber-aware code

**Migration path:**
- Replace `EM.run` with `Sync do`
- Replace callbacks with `Async` blocks
- Replace `EM::WebSocket` with `async-websocket`
- Replace `thin` server with `falcon`

📘 **Python Note:** This mirrors Python's evolution from `Twisted` (callback-based, like EventMachine) to `asyncio` (coroutine-based, like `async` gem).

## 📝 Part 9: Advanced Patterns

### Pattern 1: Pub/Sub with Channels

```ruby
require 'async'
require 'async/queue'

class PubSub
  def initialize
    @subscribers = {}
    @mutex = Mutex.new
  end
  
  def subscribe(channel, subscriber)
    @mutex.synchronize do
      @subscribers[channel] ||= []
      @subscribers[channel] << subscriber
    end
  end
  
  def unsubscribe(channel, subscriber)
    @mutex.synchronize do
      @subscribers[channel]&.delete(subscriber)
    end
  end
  
  def publish(channel, message)
    subscribers = @mutex.synchronize { @subscribers[channel]&.dup || [] }
    subscribers.each do |subscriber|
      subscriber.call(message) rescue nil
    end
  end
end

# Usage
pubsub = PubSub.new

Sync do
  # Subscriber 1
  Async do
    pubsub.subscribe('news') { |msg| puts "Sub1: #{msg}" }
    sleep 10
  end
  
  # Subscriber 2
  Async do
    pubsub.subscribe('news') { |msg| puts "Sub2: #{msg}" }
    sleep 10
  end
  
  # Publisher
  Async do
    3.times do |i|
      sleep 1
      pubsub.publish('news', "Breaking news ##{i + 1}")
    end
  end
end
```

### Pattern 2: Connection Pooling

```ruby
require 'async'
require 'async/pool'

class ConnectionPool
  def initialize(size, &factory)
    @pool = Async::Pool::Controller.new(Async::Pool::Fixed, limit: size)
    @factory = factory
  end
  
  def acquire(&block)
    @pool.acquire do
      connection = @factory.call
      begin
        yield connection
      ensure
        connection.close
      end
    end
  end
end

# Usage
Sync do
  pool = ConnectionPool.new(5) do
    # Create new connection
    Async::HTTP::Internet.new
  end
  
  # Use pool for concurrent requests
  10.times do |i|
    Async do
      pool.acquire do |internet|
        response = internet.get("https://api.example.com/data/#{i}")
        puts "Request #{i}: #{response.status}"
      end
    end
  end
end
```

## 🎯 Challenges

Test your understanding with these exercises:

### Challenge 1: WebSocket Ping/Pong
Implement a WebSocket server that sends PING frames every 30 seconds and disconnects clients that don't respond with PONG within 5 seconds.

**Hint:** WebSocket protocol includes built-in ping/pong frames (opcodes 0x9 and 0xA).

### Challenge 2: Chat Rooms
Extend the chat server to support multiple rooms. Clients should send messages like `/join <room>` to switch rooms, and messages should only broadcast within the same room.

### Challenge 3: Binary Protocol
Create a custom binary message protocol over WebSocket. Design frames with: [message_type (1 byte)][payload_length (4 bytes)][payload]. Implement encoder/decoder.

### Challenge 4: Presence Tracking
Add online/offline status tracking. When a user connects, broadcast their presence to all other users. Implement heartbeat detection to mark users offline after 60 seconds of inactivity.

### Challenge 5: Load Test
Write a script using `async-websocket` that creates 1000 concurrent WebSocket connections to your chat server. Measure message latency and memory usage.

## 📚 Further Reading

**Ruby Resources:**
- [Async Gem Documentation](https://socketry.github.io/async/)
- [Falcon Server Guide](https://socketry.github.io/falcon/)
- [async-websocket Documentation](https://github.com/socketry/async-websocket)
- [WebSocket RFC 6455](https://datatracker.ietf.org/doc/html/rfc6455)

**Python Equivalents:**
- [asyncio Documentation](https://docs.python.org/3/library/asyncio.html)
- [websockets Library](https://websockets.readthedocs.io/)
- [Uvicorn Server](https://www.uvicorn.org/)

**Practical Applications:**
- [Sinatra Lab 4: Realtime Chat](../../../labs/sinatra/4-realtime-chat/README.md) - Build a complete chat app (TODO: Update to async gem)
- [Tutorial 18: Concurrency](../18-Concurrency-Parallelism/README.md) - Deep dive into Fibers

**Next Steps:**
- Explore `async-http` for building async HTTP clients/servers
- Learn about `async-container` for process management
- Study `protocol-websocket` for low-level WebSocket implementation
- Investigate `socketry` ecosystem for more async tools

---

**Congratulations!** You now understand modern async network programming in Ruby. You can build high-performance, real-time applications using WebSockets and the `async` gem. Practice with the exercises, then apply these concepts to real projects!

**TODO:** The [Sinatra Lab 4: Realtime Chat](../../../labs/sinatra/4-realtime-chat/README.md) currently uses EventMachine. It should be updated to use the `async` gem and Falcon server following the patterns demonstrated in this tutorial.
