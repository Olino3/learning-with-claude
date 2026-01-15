# Simple View/Template System

class View
  def initialize(template_name, locals = {})
    @template_name = template_name
    @locals = locals
  end

  def render
    template = load_template
    evaluate_template(template)
  end

  private

  def load_template
    path = "views/#{@template_name}.html"
    if File.exist?(path)
      File.read(path)
    else
      "<h1>Template: #{@template_name}</h1><p>Locals: #{@locals}</p>"
    end
  end

  def evaluate_template(template)
    result = template.dup
    @locals.each do |key, value|
      result.gsub!(/\{\{\s*#{key}\s*\}\}/, value.to_s)
    end
    result
  end
end
