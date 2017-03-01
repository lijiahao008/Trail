require 'json'

class Flash
  attr_reader :now, :flash

  #initialize function takes in a request
  def initialize(req)
    #selecting cookie from the request
    cookie = req.cookies["_trail_flash"]

    #set now ivar to a JSON object or an empty object
    @now = cookie ? JSON.parse(cookie) : {}
    #initial an empty object for flash
    @flash = {}
  end

  #bracket helper method for easy access of ivar
  def [](key)
    now[key.to_s] || flash[key.to_s]
  end

  #bracket helper method for easy assignment of ivar
  def []=(key, value)
    flash[key.to_s] = value
  end

  #call set_cookie on the response and store the flash message as json to the root path
  def store_flash(res)
    res.set_cookie("_trail_flash", value: flash.to_json, path: '/')
  end
end
