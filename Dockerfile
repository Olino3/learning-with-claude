# Multi-language Development Environment
# This Dockerfile creates a development environment for learning Ruby, Dart, and Python
# It includes Ruby 3.4.7, Dart SDK, Python 3.12, and common development tools

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
    python3.12 \
    python3.12-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for better Ruby experience
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

# Install Dart SDK with cache mount for efficiency
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
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

# Install Flutter SDK for web development
ENV FLUTTER_VERSION="3.24.5"
ENV FLUTTER_HOME="/opt/flutter"
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
    && ${FLUTTER_HOME}/bin/flutter config --no-analytics \
    && ${FLUTTER_HOME}/bin/flutter precache --web \
    && ${FLUTTER_HOME}/bin/flutter doctor -v

# Add Flutter to PATH
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Copy pubspec.yaml for Dart package management (similar to Gemfile for Ruby)
COPY pubspec.yaml ./

# Install Dart packages with cache mount for faster builds
RUN --mount=type=cache,target=/root/.pub-cache,sharing=locked \
    dart pub get

# Install Python and create virtual environment
# Set up Python virtual environment in /opt/venv
ENV PYTHON_VERSION="3.12"
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Create virtual environment
RUN python3.12 -m venv $VIRTUAL_ENV

# Copy requirements.txt for Python package management
COPY requirements.txt ./

# Install Python packages with cache mount for faster builds
RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Create directories for tutorials, labs, and scripts
RUN mkdir -p /app/ruby/tutorials /app/ruby/labs /app/ruby/reading /app/dart/tutorials /app/dart/labs /app/dart/reading /app/python/tutorials /app/python/labs /app/python/reading /app/scripts

# Copy the repository content last
# This ensures gem installation layers aren't invalidated by code changes
COPY . /app/

# Set the default command to keep container running
CMD ["tail", "-f", "/dev/null"]
