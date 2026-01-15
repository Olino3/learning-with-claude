# Application Class

require_relative 'router'
require_relative 'request_response'

class Application
  def initialize
    @router = Router.new
    @middleware = []
  end

  def get(pattern, &handler)
    @router.get(pattern, handler)
  end

  def post(pattern, &handler)
    @router.post(pattern, handler)
  end

  def put(pattern, &handler)
    @router.put(pattern, handler)
  end

  def delete(pattern, &handler)
    @router.delete(pattern, handler)
  end

  def use(middleware)
    @middleware << middleware
  end

  def call(request)
    response = Response.new

    # Apply middleware (before)
    @middleware.each do |m|
      m.call(request, response)
    end

    # Find and execute route
    route = @router.match(request.method, request.path)

    if route
      request.params.merge!(route[:params])
      result = route[:handler].call(request, response)
      response.body = result if result.is_a?(String)
    else
      response.not_found
    end

    response
  end
end
