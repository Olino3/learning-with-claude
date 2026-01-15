# Dart & Flutter Development Environment
# This Dockerfile creates a dedicated Dart and Flutter development environment
# It includes Dart SDK and Flutter for web development

FROM debian:bookworm-slim

# Set working directory
WORKDIR /app

# Install essential build tools and dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    nano \
    less \
    wget \
    gnupg \
    apt-transport-https \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Dart SDK with cache mount for efficiency
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list \
    && apt-get update \
    && apt-get install -y dart \
    && rm -rf /var/lib/apt/lists/*

# Add Dart to PATH
ENV PATH="/usr/lib/dart/bin:${PATH}"
ENV PATH="/root/.pub-cache/bin:${PATH}"

# Install Flutter SDK for web development with cache mount for efficiency
# NOTE: Flutter version is intentionally pinned for reproducible tutorials and labs.
# Flutter releases frequent updates (including security and bug fixes). To update:
#   1. Check the latest stable version at https://flutter.dev/docs/development/tools/sdk/releases
#   2. Update FLUTTER_VERSION below to the new stable tag (e.g., "3.x.y")
#   3. Rebuild the Docker image and run all Dart/Flutter tutorials, labs, and tests
#      inside the container (see Makefile targets like `make dart-shell`) to verify
#      that examples still work as expected.
ENV FLUTTER_VERSION="3.24.5"
ENV FLUTTER_HOME="/opt/flutter"
RUN --mount=type=cache,target=/root/.cache/flutter,sharing=locked \
    git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
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

# Create directories for tutorials, labs, and scripts
RUN mkdir -p /app/dart/tutorials /app/dart/labs /app/dart/reading /app/scripts

# Copy the repository content last
# This ensures package installation layers aren't invalidated by code changes
COPY . /app/

# Set Flutter environment variables
ENV FLUTTER_WEB=true
ENV CHROME_EXECUTABLE=chromium

# Set the default command to keep container running
CMD ["tail", "-f", "/dev/null"]
