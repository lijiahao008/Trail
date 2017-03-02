require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require_relative './flash'


class ControllerBase
  attr_reader :req, :res, :params

  # Initialize the controller
  def initialize(req, res, params = {})
    @req, @res = req, res
    @responsed = false
    @params = params.merge(req.params)
  end

  # Helper method to reflect @responsed
  def responsed?
    @responsed
  end

  def redirect_to(url)
    #prevent double render errors
    raise "double render error" if responsed?
    # Set up the coresponding status code and header for response
    res.status = 302
    res['location'] = url

    #set response ivar to true to prevent doubel render errors
    @responsed = true

    #Calls session function to call store_session on the session ivar and pass in with an response ivar
    session.store_session(res)
    #store the flash message
    flash.store_flash(res)
    #retunr nothing
    nil
  end


  def render_content(content, content_type)
    #raise console error if response has already been built
    raise "double render error" if responsed?
    # Set the response's content type.
    res['Content-Type'] = content_type
    # Write content to the response.
    res.write(content)
    #Set response to true to prevent doubel render errors
    @responsed = true
    #Calls session function to call store_session on the session ivar and pass in with an response ivar
    session.store_session(res)
    #store the flash message
    flash.store_flash(res)

    #return nothing
    nil

  end

  def render(name)
    #constructing the path name for the template
    path_name = "#{File.dirname(__FILE__)}/../views/#{self.class.name.underscore}/#{name}.html.erb"
    #Read the template file and store it into a ivar
    template = File.read(path_name)
    #call render_content use ERB and binding to evaluate templates and set content_type to "text/html"
    render_content(ERB.new(template).result(binding), "text/html")
  end

  # method create a Session object or return an existing one
  def session
    @session ||= Session.new(req)
  end

  #initialize a flash message or return an existing one
  def flash
    @flash ||= Flash.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    #use send to call the passed in action
    self.send(name)
    render(name) unless responsed?

    nil
  end
end
