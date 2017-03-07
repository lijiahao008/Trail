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

- Clone this repository
- Run `bundle install`
- Place your own app file in `bin` folder (for example: `bin/demo_app.rb`)
  - Your app file should contain both a model class and controller class.
  - Have your controller inherit from `ControllerBase`
  - Use `redirect_to(url)` or `render_content(content, content_type)` or `render(template_name)` in your controller
  - Define routes

    ```ruby
    router = Router.new
    router.draw do
      <http_method> <pattern> <controller_class> <action_name>
    end
    ```
- Place corresponding views for each controller under `/views` folder;
- In terminal, run `ruby bin/<file_name>.rb`
- Visit `localhost:3000` in the browser and type in your desired route in the address bar.

### Demo Code

- run `ruby bin/demo_app.rb` in the terminal
- visit `localhost:3000` and type in the following two routes:
  - `/dogs`: displays all dogs
  - `/dogs/new`: displays a new dog creating form
