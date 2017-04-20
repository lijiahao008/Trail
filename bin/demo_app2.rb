require 'rack'
require 'byebug'
require_relative '../lib/controller_base.rb'
require_relative '../lib/router'

# Cat Model

class Cat
  attr_reader :name, :description
  attr_accessor :id

  def self.all
    # Uses array to represent the database
    @cats ||= []
  end

  def initialize(params = {})
    params ||= {}
    @id, @name, @description = Cat.all.length || 0, params["name"], params["description"]
  end

  def self.find(id)
    @cat = Cat.all.select{|cat| cat.id == id}.first
  end

  def errors
    #initialize with an empty array or existing errors
    @errors ||= []
  end

  def valid?
    unless description.present?
      errors << "Birthday should not be blank"
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

    Cat.all.push(self)
    true
  end


end

#Cats controller

class CatsController < ControllerBase
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      flash[:notice] = "Cat saved successfully"
      redirect_to "/cats"
    else
      flash.now[:errors] = @cat.errors
      render :new
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end

  def show
    @cat = Cat.find(params["id"].to_i)
    if @cat
      render :show
    else
      flash[:errors] = ["Can't find that cat!"]
      @cats = Cat.all
      render :index
    end
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/$"), CatsController, :index
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<id>\\d+)$"), CatsController, :show
  get Regexp.new("^/cats/new$"), CatsController, :new
  post Regexp.new("^/cats$"), CatsController, :create
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
