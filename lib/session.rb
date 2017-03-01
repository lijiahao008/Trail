require 'json'

class Session

  def initialize(req)
    # find the cookie for this app
    @cookie = req.cookies['_trail']
    # deserialize the cookie into a hash
    @data = @cookie ? JSON.parse(@cookie) : {}
  end

  #bracket method for easy access of the session cookie
  def [](key)
    @data[key]
  end

  #bracket method for easy assign of the session cookie
  def []=(key, val)
    @data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    @cookie = {path: "/", value: @data.to_json}
    res.set_cookie("_trail", @cookie)
  end
end
