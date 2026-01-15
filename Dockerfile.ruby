# Ruby Development Environment
# This Dockerfile creates a dedicated Ruby development environment
# It includes Ruby 3.4.7 and common development tools for web development

FROM ruby:3.4.7-slim

# Set working directory
WORKDIR /app

# Install essential build tools and dependencies in a single layer
# These are needed for gems with native extensions and general development
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    nano \
    less \
    sqlite3 \
    libsqlite3-dev \
    pkg-config \
    postgresql-client \
    libpq-dev \
    redis-tools \
    procps \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for better Ruby experience
# RUBYOPT="-W0" disables warnings to reduce noise in learning environment
# This helps beginners focus on core concepts without warning distractions
ENV RUBYOPT="-W0"
ENV BUNDLE_PATH="/usr/local/bundle"
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3

# Copy Gemfile first for better layer caching
# This layer only rebuilds when Gemfile changes
COPY Gemfile* ./

# Install all gems using Bundler with cache mount for much faster builds
# The cache mount persists gem downloads between builds
RUN --mount=type=cache,target=/usr/local/bundle/cache,sharing=locked \
    --mount=type=cache,target=/root/.bundle/cache,sharing=locked \
    bundle config set --local system 'true' && \
    bundle install --jobs=4 --retry=3 && \
    find /usr/local/lib/ruby/gems -name "*.c" -delete 2>/dev/null || true && \
    find /usr/local/lib/ruby/gems -name "*.o" -delete 2>/dev/null || true

# Create directories for tutorials, labs, and scripts
RUN mkdir -p /app/ruby/tutorials /app/ruby/labs /app/ruby/reading /app/scripts

# Copy the repository content last
# This ensures gem installation layers aren't invalidated by code changes
COPY . /app/

# Set environment variables for performance optimization
# Enable YJIT for performance optimization
ENV RUBY_YJIT_ENABLE=1
# Better garbage collection stats for profiling
ENV RUBY_GC_HEAP_GROWTH_FACTOR=1.1
ENV RUBY_GC_HEAP_INIT_SLOTS=10000

# Set the default command to keep container running
CMD ["tail", "-f", "/dev/null"]
