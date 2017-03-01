require 'rack'
require_relative '../lib/controller_base.rb'
require_relative '../lib/router'

# Dog Model

class Dog
  attr_reader :name, :owner

  def self.all
    # Uses array to represent the database
    @dogs ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def errors
    @errors ||= []
  end

  def valid?
    unless owner.present?
      errors << "Owner's name should not be blank"
      return false
    end

    unless name.present?
      errors << "Name should not be blank"
      return false
    end
    true
  end

  def save
    return false unless valid?

    Dog.all.push(self)
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end

#Dogs controller

class DogsController < ControllerBase
  def create
    @dog = Dog.new(params["dog"])
    if @dog.save
      flash[:notice] = "Dog saved successfully"
      redirect_to "/dogs"
    else
      flash.now[:errors] = @dog.errors
      render :new
    end
  end

  def index
    @dogs = Dog.all
    render :index
  end

  def new
    @dog = Dog.new
    render :new
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  post Regexp.new("^/dogs$"), DogsController, :create
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
