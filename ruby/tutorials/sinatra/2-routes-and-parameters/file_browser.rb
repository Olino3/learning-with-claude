# Exercise 3 Solution: File Browser API
require 'sinatra'
require 'json'

# Simulated file system structure
FILES = {
  'documents' => {
    'report.pdf' => { size: 1024, type: 'PDF' },
    'notes.txt' => { size: 512, type: 'Text' }
  },
  'images' => {
    'photo1.jpg' => { size: 2048, type: 'JPEG' },
    'photo2.png' => { size: 1536, type: 'PNG' }
  },
  'projects' => {
    'ruby' => {
      'app.rb' => { size: 256, type: 'Ruby' },
      'config.yml' => { size: 128, type: 'YAML' }
    }
  }
}

# Browse files at any path
get '/files' do
  download = params[:download] == 'true'
  show_details = params[:details] == 'true'

  """
  <h1>File Browser</h1>
  <p>Browse: <a href='/files/documents'>documents</a> | <a href='/files/images'>images</a> | <a href='/files/projects'>projects</a></p>

  <h2>Request Information:</h2>
  <ul>
    <li>Path: #{request.path}</li>
    <li>Method: #{request.request_method}</li>
    <li>Host: #{request.host}</li>
    <li>User Agent: #{request.user_agent}</li>
  </ul>
  """
end

get '/files/*' do
  path = params[:splat][0]
  download = params[:download] == 'true'
  parts = path.split('/')

  # Navigate through the file structure
  current = FILES
  parts.each do |part|
    current = current[part]
    break unless current
  end

  if current.nil?
    status 404
    content_type :json
    return { error: 'File or directory not found', path: path }.to_json
  end

  # If it's a file (has :size key)
  if current.is_a?(Hash) && current.key?(:size)
    if download
      content_type :json
      {
        action: 'download',
        path: path,
        file: current,
        message: "Downloading #{parts.last}..."
      }.to_json
    else
      """
      <h1>File: #{parts.last}</h1>
      <ul>
        <li>Path: /files/#{path}</li>
        <li>Type: #{current[:type]}</li>
        <li>Size: #{current[:size]} bytes</li>
      </ul>
      <p><a href='/files/#{path}?download=true'>Download</a></p>
      <p><a href='/files/#{parts[0..-2].join('/')}'>Back</a></p>

      <h2>Request Details:</h2>
      <ul>
        <li>URL: #{request.url}</li>
        <li>Path: #{request.path}</li>
        <li>Query String: #{request.query_string}</li>
        <li>IP Address: #{request.ip}</li>
      </ul>
      """
    end
  else
    # It's a directory
    """
    <h1>Directory: /#{path}</h1>
    <ul>
      #{current.map { |name, item|
        if item.is_a?(Hash) && item.key?(:size)
          "<li>📄 <a href='/files/#{path}/#{name}'>#{name}</a> (#{item[:size]} bytes)</li>"
        else
          "<li>📁 <a href='/files/#{path}/#{name}'>#{name}/</a></li>"
        end
      }.join}
    </ul>
    <p><a href='/files'>Back to root</a></p>
    """
  end
end
