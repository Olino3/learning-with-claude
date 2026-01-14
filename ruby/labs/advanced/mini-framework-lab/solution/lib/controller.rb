# Base Controller

class Controller
  attr_reader :request, :response

  def initialize(request, response)
    @request = request
    @response = response
  end

  def render(template_name, locals = {})
    @response.html("Rendered: #{template_name} with #{locals}")
  end

  def redirect_to(path)
    @response.redirect(path)
  end

  def json(data)
    @response.json(data)
  end

  def params
    @request.params
  end

  def headers
    @request.headers
  end

  # Create action handler for routing
  def self.action(action_name)
    ->(request, response) do
      controller = new(request, response)
      controller.send(action_name)
      response
    end
  end
end
