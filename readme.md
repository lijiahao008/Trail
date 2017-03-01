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
- Place app code in `bin` folder (see `demo_app.rb`)
  - Create new records through form or define database entries using json format
  - Have new controller inherit from `ControllerBase`
  - Set up redirect or render `redirect_to(url)` or `render_content(content, content_type)` or `render(template_name)`
  - Define routes

    ```ruby
    router = Router.new
    router.draw do
      <http_method> <pattern> <controller_class> <action_name>
    end
    ```
- Place corresponding views for each controller under `/views` folder;
- In terminal, run `ruby bin/<file_name>.rb`
- See result at `localhost:3000` in your browser

### Demo Code

- run `ruby bin/demo_app.rb` in the terminal
- visit the following two routes:
  - `/dogs`: displays all dogs
  - `/dogs/new`: displays a new dog creating form
