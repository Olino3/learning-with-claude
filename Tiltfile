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

# Print helpful instructions when Tilt starts
print("""
╔══════════════════════════════════════════════════════════════╗
║          Ruby Learning Environment with Tilt                 ║
╚══════════════════════════════════════════════════════════════╝

🚀 Your Ruby development environment is starting!

📦 Available Services:
  • ruby-scripts - For running Ruby scripts and applications
  • ruby-repl    - Interactive Ruby interpreter (IRB)

🔧 Quick Commands:
  • Run a script:  docker-compose exec ruby-scripts ruby scripts/hello.rb
  • Open IRB:      docker-compose exec ruby-repl irb
  • Bash shell:    docker-compose exec ruby-scripts bash

📝 Next Steps:
  1. Check the Tilt UI for service status
  2. Start with /ruby/tutorials/1-Getting-Started
  3. Try the example scripts in /scripts

Happy learning! 🎉
""")
