# Tiltfile for Ruby & Dart Learning Environment
# This configures Tilt to manage the multi-language development containers

# Load the docker-compose configuration
docker_compose('./docker-compose.yml')

# Watch for changes in Ruby and Dart files and automatically sync them to containers
# This enables live reloading without rebuilding containers
watch_file('./ruby/')
watch_file('./dart/')
watch_file('./scripts/')
watch_file('./Dockerfile')

# Configure the ruby-env container (unified Ruby environment)
dc_resource('ruby-env',
    labels=['ruby-dev'],
    # Add helpful resource links
    links=[
        link('https://www.ruby-lang.org/en/documentation/', 'Ruby Documentation'),
        link('https://ruby-doc.org/core-3.3.0/', 'Ruby Core API'),
        link('https://docs.docker.com/', 'Docker Documentation')
    ]
)

# Configure the sinatra-web container with port forwarding
dc_resource('sinatra-web',
    labels=['web'],
    links=[
        link('http://localhost:4567', 'Sinatra App (Default)'),
        link('http://localhost:9292', 'Rack App'),
        link('http://localhost:3000', 'Alternative Port'),
        link('https://sinatrarb.com/', 'Sinatra Documentation')
    ]
)

# Configure the dart-env container (unified Dart environment)
dc_resource('dart-env',
    labels=['dart-dev'],
    links=[
        link('https://dart.dev/guides', 'Dart Documentation'),
        link('https://api.dart.dev/', 'Dart API Reference'),
        link('https://dart.dev/tools/dart-tool', 'Dart CLI Tool')
    ]
)

# Configure the flutter-web container with port forwarding
dc_resource('flutter-web',
    labels=['web'],
    links=[
        link('http://localhost:8080', 'Flutter App (Default)'),
        link('http://localhost:8081', 'Alternative Flutter Port'),
        link('http://localhost:8082', 'Additional Flutter Port'),
        link('https://flutter.dev/docs', 'Flutter Documentation')
    ]
)

# Configure database and cache services
dc_resource('postgres',
    labels=['database'],
)

dc_resource('redis',
    labels=['cache'],
)

# Print helpful instructions when Tilt starts
print("""
╔══════════════════════════════════════════════════════════════╗
║       Ruby & Dart Learning Environment with Tilt             ║
╚══════════════════════════════════════════════════════════════╝

🚀 Your multi-language development environment is starting!

📦 Available Services:
  Ruby:
    • ruby-env    - For running Ruby scripts, IRB, and applications
    • sinatra-web - For running Sinatra web applications

  Dart:
    • dart-env    - For running Dart scripts and applications
    • flutter-web - For running Flutter web applications

  Infrastructure:
    • postgres    - PostgreSQL database (port 5432)
    • redis       - Redis cache/session store (port 6379)

🌐 Web Application Ports:
  • http://localhost:4567 - Default Sinatra port
  • http://localhost:9292 - Rack applications
  • http://localhost:3000 - Alternative web port
  • http://localhost:8080 - Default Flutter web port
  • http://localhost:8081 - Alternative Flutter port

🔧 Quick Commands:
  Ruby:
    • Run a script:     docker compose exec ruby-env ruby scripts/hello.rb
    • Open IRB:         docker compose exec ruby-env irb
    • Bash shell:       docker compose exec ruby-env bash
    • Run Sinatra app:  docker compose exec sinatra-web ruby ruby/tutorials/sinatra/1-hello-sinatra/hello.rb

  Dart:
    • Run a script:     docker compose exec dart-env dart run scripts/hello.dart
    • Bash shell:       docker compose exec dart-env bash

  Flutter:
    • Bash shell:       docker compose exec flutter-web bash
    • Run Flutter app:  docker compose exec flutter-web flutter run -d web-server --web-port=8080

  Database:
    • Connect to DB:    docker compose exec postgres psql -U postgres -d sinatra_dev
    • Redis CLI:        docker compose exec redis redis-cli

📝 Next Steps:
  Ruby:
    1. Start with /ruby/tutorials/1-Getting-Started
    2. Try Sinatra tutorials in /ruby/tutorials/sinatra
    3. Explore hands-on labs in /ruby/labs/sinatra

  Dart:
    1. Start with /dart/tutorials/1-Getting-Started
    2. Explore Dart examples and exercises

  Flutter:
    1. Start with Flutter basics in /dart/labs/beginner
    2. Build web applications with Flutter

Happy learning! 🎉
""")
