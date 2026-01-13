# Multi-language Development Environment
# This Dockerfile creates a development environment for learning Ruby and Dart
# It includes Ruby 3.4.7, Dart SDK, and common development tools

FROM ruby:3.4.7-slim

# Set working directory
WORKDIR /app

# Install essential build tools and dependencies
# These are needed for gems with native extensions and general development
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    nano \
    less \
    sqlite3 \
    libsqlite3-dev \
    postgresql-client \
    libpq-dev \
    redis-tools \
    && rm -rf /var/lib/apt/lists/*

# Install commonly used gems for learning
# These will be available in all containers
RUN gem install bundler pry irb rspec

# Install Sinatra and related web development gems
RUN gem install sinatra sinatra-contrib thin puma \
    rack rack-test webrick \
    tilt erubis

# Install database gems for Sinatra tutorials
RUN gem install sqlite3 sequel activerecord pg

# Install authentication and security gems
RUN gem install bcrypt rack-protection

# Install WebSocket support for real-time apps
RUN gem install faye-websocket eventmachine

# Install testing gems
RUN gem install rack-test minitest capybara

# Install advanced gems for profiling, performance, and concurrency
# memory_profiler - Memory usage profiling
# benchmark-ips - Iterations per second benchmarking
# stackprof - CPU profiling
# rubocop - Code quality and style checking
RUN gem install memory_profiler benchmark-ips stackprof rubocop

# Set environment variables for better Ruby experience
ENV RUBYOPT="-W0"
ENV BUNDLE_PATH="/usr/local/bundle"

# Install Dart SDK
# Download and install Dart from the official repository
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    wget \
    gnupg \
    && wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list \
    && apt-get update \
    && apt-get install -y dart \
    && rm -rf /var/lib/apt/lists/*

# Add Dart to PATH
ENV PATH="/usr/lib/dart/bin:${PATH}"
ENV PATH="/root/.pub-cache/bin:${PATH}"

# Create directories for tutorials, labs, and scripts
RUN mkdir -p /app/ruby/tutorials /app/ruby/labs /app/ruby/reading /app/dart/tutorials /app/dart/labs /app/dart/reading /app/scripts

# Copy the repository content
COPY . /app/

# Set the default command to keep container running
CMD ["tail", "-f", "/dev/null"]
