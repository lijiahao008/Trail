require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Initialize the controller
  def initialize(req, res, params = {})
    @req, @res = req, res
    @params = params.merge(req.params)
    @already_built_response = false
    @@protect_from_forgery ||= false
  end

  # Helper method to reflect @already_built_response
  def already_built_response?
    @already_built_response
  end


  def redirect_to(url)
    #prevent double render errors
    raise "double render error" if already_built_response?
    # Set up the coresponding status code and header for response
    @res.status = 302
    @res['location'] = url

    #set already_built_response ivar to true to prevent doubel render errors
    @already_built_response = true

    #Calls session function to call store_session on the session ivar and pass in with an response ivar
    session.store_session(@res)

    #retunr nothing
    nil
  end



  def render_content(content, content_type)
    #raise console error if response has already been built
    raise "double render error" if already_built_response?
    # Write content to the response.
    @res.write(content)
    # Set the response's content type.
    @res['Content-Type'] = content_type
    #Set already_built_response to true to prevent doubel render errors
    @already_built_response = true
    #Calls session function to call store_session on the session ivar and pass in with an response ivar
    session.store_session(@res)

    #return nothing
    nil

  end

  def render(template_name)
    #constructing the path name for the template
    path_name = "#{File.dirname(__FILE__)}/../views/#{self.class.name.underscore}/#{template_name}.html.erb"
    #Read the template file and store it into a ivar
    template = File.read(path_name)
    #call render_content use ERB and binding to evaluate templates and set content_type to "text/html"
    render_content(ERB.new(template).result(binding), "text/html")
  end

  # method create a Session object or return an existing one
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    #use send to call the passed in action
    self.send(name)
    render(name) unless already_built_response?

    nil
  end
end
