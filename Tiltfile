# Tiltfile for Ruby Learning Environment
# This configures Tilt to manage the Ruby development containers

# Load the docker-compose configuration
docker_compose('./docker-compose.yml')

# Watch for changes in Ruby files and automatically sync them to containers
# This enables live reloading without rebuilding containers
watch_file('./ruby/')
watch_file('./scripts/')
watch_file('./Dockerfile')

# Configure the ruby-scripts container
dc_resource('ruby-scripts',
    labels=['development'],
    # Add helpful resource links
    links=[
        link('https://www.ruby-lang.org/en/documentation/', 'Ruby Documentation'),
        link('https://docs.docker.com/', 'Docker Documentation')
    ]
)

# Configure the ruby-repl container
dc_resource('ruby-repl',
    labels=['interactive'],
    # Add helpful resource links
    links=[
        link('https://www.ruby-lang.org/en/documentation/', 'Ruby Documentation'),
        link('https://ruby-doc.org/core-3.3.0/', 'Ruby Core API')
    ]
)

# Configure the ruby-advanced container
dc_resource('ruby-advanced',
    labels=['advanced'],
    links=[
        link('https://www.ruby-lang.org/en/documentation/', 'Ruby Documentation')
    ]
)

# Configure the sinatra-web container with port forwarding
dc_resource('sinatra-web',
    labels=['web'],
    port_forwards=['4567:4567', '9292:9292', '3000:3000'],
    links=[
        link('http://localhost:4567', 'Sinatra App (Default)'),
        link('http://localhost:9292', 'Rack App'),
        link('http://localhost:3000', 'Alternative Port'),
        link('https://sinatrarb.com/', 'Sinatra Documentation')
    ]
)

# Configure database and cache services
dc_resource('postgres',
    labels=['database'],
    port_forwards=['5432:5432']
)

dc_resource('redis',
    labels=['cache'],
    port_forwards=['6379:6379']
)

# Print helpful instructions when Tilt starts
print("""
╔══════════════════════════════════════════════════════════════╗
║          Ruby Learning Environment with Tilt                 ║
╚══════════════════════════════════════════════════════════════╝

🚀 Your Ruby development environment is starting!

📦 Available Services:
  • ruby-scripts - For running Ruby scripts and applications
  • ruby-repl    - Interactive Ruby interpreter (IRB)
  • ruby-advanced - For advanced profiling and concurrency
  • sinatra-web  - For running Sinatra web applications
  • postgres     - PostgreSQL database (port 5432)
  • redis        - Redis cache/session store (port 6379)

🌐 Web Application Ports:
  • http://localhost:4567 - Default Sinatra port
  • http://localhost:9292 - Rack applications
  • http://localhost:3000 - Alternative web port

🔧 Quick Commands:
  • Run a script:     docker-compose exec ruby-scripts ruby scripts/hello.rb
  • Open IRB:         docker-compose exec ruby-repl irb
  • Bash shell:       docker-compose exec ruby-scripts bash
  • Run Sinatra app:  docker-compose exec sinatra-web ruby ruby/tutorials/sinatra/1-hello-sinatra/app.rb
  • Connect to DB:    docker-compose exec postgres psql -U postgres -d sinatra_dev
  • Redis CLI:        docker-compose exec redis redis-cli

📝 Next Steps:
  1. Check the Tilt UI for service status
  2. Start with /ruby/tutorials/1-Getting-Started
  3. Try Sinatra tutorials in /ruby/tutorials/sinatra
  4. Explore hands-on labs in /ruby/labs/sinatra

Happy learning! 🎉
""")
