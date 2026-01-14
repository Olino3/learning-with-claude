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

# Configure the ruby-scripts container
dc_resource('ruby-scripts',
    labels=['ruby-dev'],
    # Add helpful resource links
    links=[
        link('https://www.ruby-lang.org/en/documentation/', 'Ruby Documentation'),
        link('https://docs.docker.com/', 'Docker Documentation')
    ]
)

# Configure the ruby-repl container
dc_resource('ruby-repl',
    labels=['ruby-interactive'],
    # Add helpful resource links
    links=[
        link('https://www.ruby-lang.org/en/documentation/', 'Ruby Documentation'),
        link('https://ruby-doc.org/core-3.3.0/', 'Ruby Core API')
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

# Configure the dart-scripts container
dc_resource('dart-scripts',
    labels=['dart-dev'],
    links=[
        link('https://dart.dev/guides', 'Dart Documentation'),
        link('https://api.dart.dev/', 'Dart API Reference')
    ]
)

# Configure the dart-repl container
dc_resource('dart-repl',
    labels=['dart-interactive'],
    links=[
        link('https://dart.dev/guides', 'Dart Documentation'),
        link('https://dart.dev/tools/dart-tool#dart-repl', 'Dart REPL Guide')
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
    • ruby-scripts - For running Ruby scripts, applications, and advanced labs
    • ruby-repl    - Interactive Ruby interpreter (IRB)
    • sinatra-web  - For running Sinatra web applications

  Dart:
    • dart-scripts - For running Dart scripts and applications
    • dart-repl    - Interactive Dart REPL

  Infrastructure:
    • postgres     - PostgreSQL database (port 5432)
    • redis        - Redis cache/session store (port 6379)

🌐 Web Application Ports:
  • http://localhost:4567 - Default Sinatra port
  • http://localhost:9292 - Rack applications
  • http://localhost:3000 - Alternative web port

🔧 Quick Commands:
  Ruby:
    • Run a script:     docker compose exec ruby-scripts ruby scripts/hello.rb
    • Open IRB:         docker compose exec ruby-repl irb
    • Bash shell:       docker compose exec ruby-scripts bash
    • Run Sinatra app:  docker compose exec sinatra-web ruby ruby/tutorials/sinatra/1-hello-sinatra/hello.rb

  Dart:
    • Run a script:     docker compose exec dart-scripts dart run scripts/hello.dart
    • Open Dart REPL:   docker compose exec dart-repl dart repl
    • Bash shell:       docker compose exec dart-scripts bash

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

Happy learning! 🎉
""")
