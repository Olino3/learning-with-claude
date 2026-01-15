# Plugin System

class Plugin
  def self.install(app)
    raise NotImplementedError
  end
end

class LoggingPlugin < Plugin
  def self.install(app)
    app.use(middleware)
  end

  def self.middleware
    ->(request, response) do
      start_time = Time.now
      puts "  [LOG] #{Time.now.strftime('%H:%M:%S')} #{request.method} #{request.path}"
    end
  end
end

class AuthenticationPlugin < Plugin
  def self.install(app, secret_key:)
    app.use(Auth.new(secret_key).middleware)
  end

  class Auth
    def initialize(secret_key)
      @secret_key = secret_key
    end

    def middleware
      secret = @secret_key
      ->(request, response) do
        unless request.headers['Authorization']
          response.status = 401
          response.body = "Unauthorized"
        end
      end
    end
  end
end

class CorsPlugin < Plugin
  def self.install(app, origins: "*")
    app.use(->(request, response) {
      response.headers['Access-Control-Allow-Origin'] = origins
      response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
    })
  end
end
