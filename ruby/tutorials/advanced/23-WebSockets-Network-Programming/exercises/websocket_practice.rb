#!/usr/bin/env ruby
# WebSocket and Async Network Programming Practice
# This file demonstrates progressive examples from basic sockets to WebSockets

require 'socket'
require 'async'
require 'async/io/stream'
require 'async/io/endpoint'
require 'async/http/internet'
require 'digest/sha1'
require 'base64'

puts "=" * 70
puts "WEBSOCKET & ASYNC NETWORK PROGRAMMING PRACTICE"
puts "Ruby Version: #{RUBY_VERSION}"
puts "=" * 70
puts

# Example 1: Basic TCP Socket Server (Blocking)
puts "Example 1: Basic TCP Echo Server (Blocking)"
puts "-" * 70

def run_tcp_echo_server_demo
  puts "Creating a simple TCP echo server on port 9000..."
  puts "Note: This is BLOCKING - handles one client at a time"
  puts
  
  # Start server in a thread so we can demo it
  server_thread = Thread.new do
    server = TCPServer.new('localhost', 9000)
    
    # Accept just one connection for demo
    client = server.accept
    puts "[Server] Client connected from #{client.peeraddr[2]}"
    
    # Echo one message
    message = client.gets
    puts "[Server] Received: #{message.strip}"
    client.puts "ECHO: #{message}"
    
    client.close
    server.close
  end
  
  # Give server time to start
  sleep 0.5
  
  # Connect as client
  client = TCPSocket.new('localhost', 9000)
  puts "[Client] Connected to server"
  
  client.puts "Hello, TCP Server!"
  response = client.gets
  puts "[Client] Received: #{response.strip}"
  
  client.close
  server_thread.join
  
  puts "✓ TCP echo completed"
  puts
end

# 📘 Python Note: This is equivalent to:
# import socket
# server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# server.bind(('localhost', 9000))
# server.listen()

run_tcp_echo_server_demo

# Example 2: UDP Socket (Connectionless)
puts "Example 2: UDP Broadcaster (Connectionless)"
puts "-" * 70

def run_udp_demo
  puts "UDP is connectionless - no accept/connect handshake"
  puts
  
  # Create UDP receiver
  receiver_thread = Thread.new do
    receiver = UDPSocket.new
    receiver.bind('localhost', 9001)
    
    # Receive one message
    data, addr = receiver.recvfrom(1024)
    puts "[Receiver] Got message from #{addr[2]}:#{addr[1]}: #{data}"
    
    receiver.close
  end
  
  sleep 0.5
  
  # Send UDP message
  sender = UDPSocket.new
  sender.send("Hello via UDP!", 0, 'localhost', 9001)
  puts "[Sender] Sent UDP message"
  
  sender.close
  receiver_thread.join
  
  puts "✓ UDP demo completed"
  puts
end

# 📘 Python Note: Similar to socket.SOCK_DGRAM in Python
run_udp_demo

# Example 3: Async Gem Basics - Concurrent Tasks
puts "Example 3: Async Gem - Concurrent Tasks"
puts "-" * 70

Sync do
  puts "Running 3 tasks concurrently with different sleep times..."
  start_time = Time.now
  
  task1 = Async do
    sleep 1
    puts "  Task 1 finished (1 second)"
    "Result 1"
  end
  
  task2 = Async do
    sleep 2
    puts "  Task 2 finished (2 seconds)"
    "Result 2"
  end
  
  task3 = Async do
    sleep 1.5
    puts "  Task 3 finished (1.5 seconds)"
    "Result 3"
  end
  
  # Wait for all tasks
  results = [task1.wait, task2.wait, task3.wait]
  
  elapsed = Time.now - start_time
  puts
  puts "All tasks completed in #{elapsed.round(2)} seconds"
  puts "Sequential would take: 4.5 seconds"
  puts "Results: #{results.inspect}"
  puts "✓ Async tasks completed"
end

# 📘 Python Note: Similar to asyncio.create_task() and asyncio.gather()
puts

# Example 4: Async HTTP Requests
puts "Example 4: Concurrent HTTP Requests"
puts "-" * 70

Sync do
  puts "Fetching multiple URLs concurrently..."
  
  internet = Async::HTTP::Internet.new
  
  urls = [
    'https://jsonplaceholder.typicode.com/posts/1',
    'https://jsonplaceholder.typicode.com/posts/2',
    'https://jsonplaceholder.typicode.com/posts/3'
  ]
  
  start_time = Time.now
  
  tasks = urls.map do |url|
    Async do
      response = internet.get(url)
      {
        url: url,
        status: response.status,
        size: response.read.bytesize
      }
    end
  end
  
  results = tasks.map(&:wait)
  elapsed = Time.now - start_time
  
  results.each do |result|
    puts "  #{result[:url]}"
    puts "    Status: #{result[:status]}, Size: #{result[:size]} bytes"
  end
  
  puts
  puts "Fetched #{results.size} URLs in #{elapsed.round(2)} seconds"
  puts "✓ Concurrent HTTP requests completed"
  
  internet.close
end

# 📘 Python Note: Similar to using aiohttp or httpx with asyncio
puts

# Example 5: Async TCP Server (Non-blocking)
puts "Example 5: Async TCP Echo Server (Non-blocking)"
puts "-" * 70

def run_async_tcp_server_demo
  puts "Creating async TCP server that handles multiple clients..."
  
  # Track connected clients
  client_count = 0
  
  server_task = Async do |task|
    endpoint = Async::IO::Endpoint.tcp('localhost', 9002)
    
    endpoint.bind do |server|
      puts "[Server] Async TCP server listening on port 9002"
      
      # Accept multiple connections concurrently
      server.listen(10) do |peer|
        Async do
          client_count += 1
          client_id = client_count
          
          stream = Async::IO::Stream.new(peer)
          puts "[Server] Client #{client_id} connected"
          
          begin
            while line = stream.read_until("\n")
              msg = line.strip
              puts "[Server] Client #{client_id}: #{msg}"
              stream.write("ECHO #{client_id}: #{msg}\n")
              stream.flush
            end
          rescue EOFError
            # Client disconnected
          ensure
            puts "[Server] Client #{client_id} disconnected"
            peer.close
          end
        end
      end
    end
  end
  
  # Give server time to start
  sleep 0.5
  
  # Connect multiple clients concurrently
  Sync do
    3.times do |i|
      Async do
        endpoint = Async::IO::Endpoint.tcp('localhost', 9002)
        
        endpoint.connect do |peer|
          stream = Async::IO::Stream.new(peer)
          
          # Send message
          stream.write("Hello from client #{i + 1}\n")
          stream.flush
          
          # Read echo
          response = stream.read_until("\n")
          puts "[Client #{i + 1}] Received: #{response.strip}"
          
          peer.close
        end
      end
    end
  end
  
  # Stop server
  server_task.stop
  
  puts "✓ Async TCP server handled multiple concurrent clients"
  puts
end

run_async_tcp_server_demo

# Example 6: WebSocket Handshake Parsing
puts "Example 6: WebSocket Handshake Calculation"
puts "-" * 70

def calculate_websocket_accept(sec_websocket_key)
  # WebSocket magic string from RFC 6455
  magic_string = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
  
  # Concatenate key + magic string
  combined = sec_websocket_key + magic_string
  
  # SHA1 hash
  hash = Digest::SHA1.digest(combined)
  
  # Base64 encode
  Base64.strict_encode64(hash)
end

puts "Demonstrating WebSocket handshake calculation:"
puts
puts "Client sends: Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ=="
client_key = "dGhlIHNhbXBsZSBub25jZQ=="

puts "Server must calculate Sec-WebSocket-Accept..."
accept_key = calculate_websocket_accept(client_key)

puts "Server responds: Sec-WebSocket-Accept: #{accept_key}"
puts
puts "Expected: s3pPLMBiTxaQ9kYGzzhZRbK+xOo="
puts "Matches: #{accept_key == 's3pPLMBiTxaQ9kYGzzhZRbK+xOo='} ✓"

# 📘 Python Note: The websockets library does this automatically in the
# handshake, but understanding the algorithm helps with debugging
puts

# Example 7: WebSocket Frame Structure (Conceptual)
puts "Example 7: WebSocket Frame Structure (Conceptual)"
puts "-" * 70

puts "WebSocket frames have this structure:"
puts
puts "  Byte 0: FIN (1 bit) + Reserved (3 bits) + Opcode (4 bits)"
puts "  Byte 1: MASK (1 bit) + Payload Length (7 bits)"
puts "  Bytes 2-5: Masking key (if MASK=1, required for client->server)"
puts "  Remaining: Payload data (XORed with masking key if masked)"
puts
puts "Opcodes:"
puts "  0x1 = Text frame"
puts "  0x2 = Binary frame"
puts "  0x8 = Close frame"
puts "  0x9 = Ping frame"
puts "  0xA = Pong frame"
puts
puts "Example text frame (simplified):"
puts "  [FIN=1, Opcode=1][Length=5][Mask=0][Payload='Hello']"
puts "  In bytes: 0x81 0x05 'H' 'e' 'l' 'l' 'o'"
puts

# 📘 Python Note: The 'websockets' library and 'async-websocket' both
# handle frame encoding/decoding automatically
puts "✓ Frame structure explained"
puts

# Example 8: Simple WebSocket Echo Server (using async-websocket)
puts "Example 8: WebSocket Echo Server with async-websocket"
puts "-" * 70

begin
  require 'async/websocket/adapters/rack'
  require 'async/http/endpoint'
  require 'async/websocket/client'
  
  puts "Building a simple WebSocket echo server..."
  
  # Define Rack app with WebSocket support
  app = lambda do |env|
    if Async::WebSocket::Adapters::Rack.websocket?(env)
      # Upgrade to WebSocket
      Async::WebSocket::Adapters::Rack.open(env) do |connection|
        puts "[Server] WebSocket client connected"
        
        # Echo messages
        message_count = 0
        while message = connection.read
          message_count += 1
          puts "[Server] Received message #{message_count}: #{message.inspect}"
          
          # Echo back
          connection.write("ECHO: #{message}")
          connection.flush
          
          # Stop after 3 messages for demo
          break if message_count >= 3
        end
        
        puts "[Server] Client disconnected"
      end
    else
      # Regular HTTP response
      [200, {'Content-Type' => 'text/plain'}, ['WebSocket server']]
    end
  end
  
  # Run server in background
  server_task = Async do
    endpoint = Async::HTTP::Endpoint.parse('http://localhost:9003')
    server = Async::HTTP::Server.for(endpoint, protocol: Async::HTTP::Protocol::HTTP1, &app)
    
    puts "[Server] WebSocket server running on ws://localhost:9003"
    server.run
  end
  
  # Give server time to start
  sleep 0.5
  
  # Connect client and send messages
  Sync do
    endpoint = Async::HTTP::Endpoint.parse('ws://localhost:9003')
    
    Async::WebSocket::Client.connect(endpoint) do |connection|
      puts "[Client] Connected to WebSocket server"
      
      # Send 3 messages
      ['Hello', 'WebSocket', 'World'].each_with_index do |msg, i|
        puts "[Client] Sending: #{msg}"
        connection.write(msg)
        connection.flush
        
        # Read echo response
        response = connection.read
        puts "[Client] Received: #{response.inspect}"
      end
      
      puts "[Client] Closing connection"
    end
  end
  
  # Stop server
  server_task.stop
  
  puts "✓ WebSocket echo completed"
  
rescue LoadError
  puts "⚠ async-websocket gem not installed"
  puts "Run: gem install async-websocket"
  puts "Skipping WebSocket examples"
end

puts

# Example 9: Pub/Sub Pattern
puts "Example 9: Pub/Sub Pattern with Async"
puts "-" * 70

class SimplePubSub
  def initialize
    @subscribers = {}
    @mutex = Mutex.new
  end
  
  def subscribe(channel, &block)
    @mutex.synchronize do
      @subscribers[channel] ||= []
      @subscribers[channel] << block
    end
  end
  
  def publish(channel, message)
    subscribers = @mutex.synchronize { @subscribers[channel]&.dup || [] }
    subscribers.each { |subscriber| subscriber.call(message) }
  end
end

puts "Creating pub/sub system with multiple subscribers..."
pubsub = SimplePubSub.new

Sync do
  # Subscriber 1
  Async do
    pubsub.subscribe('news') do |msg|
      puts "  [Subscriber 1] #{msg}"
    end
    sleep 5
  end
  
  # Subscriber 2
  Async do
    pubsub.subscribe('news') do |msg|
      puts "  [Subscriber 2] #{msg}"
    end
    sleep 5
  end
  
  # Subscriber for different channel
  Async do
    pubsub.subscribe('sports') do |msg|
      puts "  [Sports Subscriber] #{msg}"
    end
    sleep 5
  end
  
  # Publisher
  Async do
    sleep 0.5
    
    puts "[Publisher] Publishing to 'news' channel"
    pubsub.publish('news', 'Breaking: Ruby 4.0 released!')
    
    sleep 1
    pubsub.publish('news', 'Weather: Sunny with a chance of code')
    
    sleep 1
    puts "[Publisher] Publishing to 'sports' channel"
    pubsub.publish('sports', 'Local team wins championship!')
  end
end

puts "✓ Pub/Sub pattern demonstrated"
puts

# Example 10: Fiber Scheduler Insight
puts "Example 10: Understanding Fiber Scheduling"
puts "-" * 70

puts "The async gem uses Fibers for cooperative concurrency:"
puts

Sync do
  puts "Creating async tasks that yield control during I/O..."
  
  Async do
    puts "  [Task A] Started"
    sleep 0.1  # Yields to scheduler
    puts "  [Task A] Resumed after sleep"
    sleep 0.1
    puts "  [Task A] Finished"
  end
  
  Async do
    puts "  [Task B] Started"
    sleep 0.15  # Yields to scheduler
    puts "  [Task B] Resumed after sleep"
    puts "  [Task B] Finished"
  end
  
  Async do
    puts "  [Task C] Started (no sleep, runs to completion)"
    100.times { |i| } # CPU work, doesn't yield
    puts "  [Task C] Finished"
  end
end

puts
puts "Notice: Tasks interleave during sleep (I/O operations)"
puts "CPU-bound work (Task C) doesn't yield until complete"
puts "✓ Fiber scheduling demonstrated"
puts

# 📘 Python Note: Similar to how asyncio uses coroutines and 'await' points
# In Ruby, the async gem automatically yields at I/O operations

puts "=" * 70
puts "ALL EXAMPLES COMPLETED!"
puts "=" * 70
puts
puts "Key Takeaways:"
puts "1. TCP sockets are blocking by default (one client at a time)"
puts "2. UDP is connectionless and doesn't guarantee delivery"
puts "3. The async gem enables concurrent I/O with Fibers"
puts "4. WebSocket handshake uses SHA1 + Base64 calculation"
puts "5. WebSocket frames have opcodes for different message types"
puts "6. async-websocket provides high-level WebSocket APIs"
puts "7. Pub/Sub patterns enable real-time message distribution"
puts "8. Fiber scheduling yields during I/O, not CPU work"
puts
puts "Next Steps:"
puts "- Build a chat application using WebSockets"
puts "- Explore async-http for building HTTP servers"
puts "- Try Falcon server for production deployments"
puts "- Read WebSocket RFC 6455 for protocol details"
puts "- Review Tutorial 18 for more on Fibers and concurrency"
