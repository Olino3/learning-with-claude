# Request and Response Objects

require 'json'

class Request
  attr_reader :method, :path, :headers
  attr_accessor :params

  def initialize(method:, path:, params: {}, headers: {})
    @method = method
    @path = path
    @params = params
    @headers = headers
  end

  def get?
    @method == :GET
  end

  def post?
    @method == :POST
  end

  def put?
    @method == :PUT
  end

  def delete?
    @method == :DELETE
  end
end

class Response
  attr_accessor :status, :headers, :body

  def initialize
    @status = 200
    @headers = { 'Content-Type' => 'text/html' }
    @body = ""
  end

  def json(data)
    @headers['Content-Type'] = 'application/json'
    @body = data.to_json
    self
  end

  def html(content)
    @headers['Content-Type'] = 'text/html'
    @body = content
    self
  end

  def text(content)
    @headers['Content-Type'] = 'text/plain'
    @body = content
    self
  end

  def redirect(location)
    @status = 302
    @headers['Location'] = location
    self
  end

  def not_found
    @status = 404
    @body = "Not Found"
    self
  end

  def to_s
    "HTTP/1.1 #{@status}\n#{headers_string}\n\n#{@body}"
  end

  private

  def headers_string
    @headers.map { |k, v| "#{k}: #{v}" }.join("\n")
  end
end
