# Ruby Development Environment
# This Dockerfile creates a development environment for learning Ruby
# It includes Ruby 3.4.7 and common development tools

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
    && rm -rf /var/lib/apt/lists/*

# Install commonly used gems for learning
# These will be available in all containers
RUN gem install bundler pry irb rspec sinatra

# Set environment variables for better Ruby experience
ENV RUBYOPT="-W0"
ENV BUNDLE_PATH="/usr/local/bundle"

# Create directories for tutorials, labs, and scripts
RUN mkdir -p /app/ruby/tutorials /app/ruby/labs /app/ruby/reading /app/scripts

# Copy the repository content
COPY . /app/

# Set the default command to keep container running
CMD ["tail", "-f", "/dev/null"]
