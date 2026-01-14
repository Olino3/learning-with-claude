# Router with Pattern Matching

class Router
  def initialize
    @routes = []
  end

  def get(pattern, handler)
    add_route(:GET, pattern, handler)
  end

  def post(pattern, handler)
    add_route(:POST, pattern, handler)
  end

  def put(pattern, handler)
    add_route(:PUT, pattern, handler)
  end

  def delete(pattern, handler)
    add_route(:DELETE, pattern, handler)
  end

  def add_route(method, pattern, handler)
    @routes << {
      method: method,
      pattern: compile_pattern(pattern),
      handler: handler,
      param_names: extract_param_names(pattern)
    }
  end

  def match(method, path)
    @routes.each do |route|
      next unless route[:method] == method

      if match_data = route[:pattern].match(path)
        params = {}
        route[:param_names].each_with_index do |name, i|
          params[name] = match_data[i + 1]
        end

        return { handler: route[:handler], params: params }
      end
    end

    nil
  end

  def routes
    @routes
  end

  private

  def compile_pattern(pattern)
    regex_pattern = pattern.gsub(/:(\w+)/, '([^/]+)')
    Regexp.new("^#{regex_pattern}$")
  end

  def extract_param_names(pattern)
    pattern.scan(/:(\w+)/).flatten
  end
end
