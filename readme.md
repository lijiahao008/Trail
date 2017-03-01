# Trail

Trail is a lightweight MVC framework inspired by Ruby on Rails.

## Components

### Controller
- Renders `view` template with the correct response or redirects
- Goes to the `views` folder and find the view template file based on the controller's name
- Raises errors if there is a double render error

### Router
  - Accepts a block with `http_method`, `pattern`, `controller_class`, and `controller_name` to generate a valid `Route`
  - Takes a request and matches it to a `Route`
    - If there's a matching `Route`, it will invoke the action associated with the `Route`
    - Otherwise raises a 404 error

### Session
  - When there is a request, the `Controller` generates a new `Session` with the request's cookies associated with the app 
  - When the `Controller` generates a response, it stores the `Session` into the response's cookie

## Getting Started

1. Clone this repository
- Run `bundle install`
- Place app code in `bin` folder (see `example_app.rb`)
  - Define database entries
  - Define controllers
    - Have new controller inherit from `ControllerBase`
    - Have response redirect or render
      - `redirect_to(url)`
      - `render_content(content, content_type)`
      - `render(template_name)`
  - Define routes
    ```ruby
    router = Router.new
    router.draw do
      <http_method> <pattern> <controller_class> <action_name>
      ...
    end
    ```
- Place views for each controller in `/views` folder; name should be snake_case version of `Controller` class name
- Run in terminal `ruby bin/<app_file_name>.rb`
- See result at `localhost:3000` in your browser

### Example Code

- visit counter: illustrates session data being stored in cookies
- two routes defined:
  - `/teams`: displays all teams
  - `/teams/:id/players`: displays team's players


```ruby
# bin/example_app.rb

# required gems/files
require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'

# Define database entries here
$teams = [
  { id: 1, name: "Warriors" },
  { id: 2, name: "Cavaliers" }
]

$players = [
  { id: 1, team_id: 1, player: "Stephen Curry" },
  { id: 2, team_id: 2, player: "LeBron James" },
  { id: 3, team_id: 1, player: "Draymond Green" }
]

# Define controllers here
class PlayersController < ControllerBase
  def index
    players = $players.select do |s|
      s[:team_id] == Integer(params['team_id'])
    end

    render_content(players.to_json, "application/json")
  end
end

class TeamsController < ControllerBase
  def index
    session["count"] ||= 0
    session["count"] += 1
    @teams = $teams
    render :index
  end
end

# Define routes here
router = Router.new
router.draw do
  get Regexp.new("^/teams$"), TeamsController, :index
  get Regexp.new("^/teams/(?<team_id>\\d+)/players$"), PlayersController, :index
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
```
