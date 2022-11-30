require "sinatra/base"
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  def input_checker
    params[:name].include? "<script>"
  end

  get "/" do
    return erb(:index)
  end

  post "/hello" do
    if input_checker == true
      return "INJECTION ATTACK DETECTED. LOCATING IP. SWAT TEAM DISPATCHED."
    else
      @name = "#{params[:name]}"

      return erb(:hello)
    end
  end
end
