class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  #initialize a Route object with passed in params
  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name = pattern, http_method, controller_class, action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    req.request_method.downcase.to_sym == http_method && (pattern =~ req.path)
  end

  def run(req, res)
    # use pattern to pull out route params
    match_data = pattern.match(req.path)
    route_params = Hash[match_data.names.zip(match_data.captures)]

    # instantiate controller and call controller action
    controller_class
      .new(req, res, route_params)
      .invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    #initialize with an empty array for routes ivar
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    # adds a new route to the list of routes
    @routes.push(Route.new(pattern, method, controller_class, action_name))
  end

  # evaluate the proc in the context of the instance
  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    #define method for a http_method and call add_route to create a route
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # helper method that returns the route that matches the request and return nil if none were found
  def match(req)
    routes.find { |route| route.matches?(req) }
  end


  def run(req, res)
    #selecting the matching route
    route = match(req)

    #return 404 page if no matching route found or
    #call run method on the matching route
    route.nil? ? res.status = 404 : route.run(req, res)
  end
end
