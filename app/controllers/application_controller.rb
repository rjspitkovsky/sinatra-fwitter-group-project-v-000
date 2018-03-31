require 'pry'
require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect to '/tweets'
    end
    erb :'users/create_user'
  end

  post '/signup' do
    @user = User.create(username: params[:username], email: params[:email], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect '/tweets'
    elsif @user.username.nil?
      redirect '/signup'
    elsif @user.email.nil?
      redirect '/signup'
    elsif @user.password.nil?
      redirect '/signup'
    else
      redirect '/signup'
    end
  end

  get '/tweets' do
    if !logged_in?
      redirect '/login'
    else
    @user = current_user(session)
    @tweets = Tweet.all
    erb :'tweets/tweets'
  end
  end

  get '/login' do
    if logged_in?
      redirect to '/tweets'
    else
    erb :'users/login'
  end
end

  post '/login' do
    @user = User.find_by(username: params[:username])
    session[:user_id] = @user.id
    redirect to '/tweets'
  end

  get '/logout' do
    if !logged_in?
      redirect '/'
    else
    session.clear
    redirect '/login'
  end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end


  get '/tweets/new' do
    if !logged_in?
      redirect to '/login'
    else
      erb :'tweets/create_tweet'
    end
  end

  post '/tweets' do
    @user = current_user(session)
    if params[:content] != ""
    @tweet = Tweet.create(content: params[:content], user_id: @user.id)
    redirect to '/tweets'
    else
      redirect to '/tweets/new'
    end
  end

  get '/tweets/:id' do
    if !logged_in?
      redirect to '/login'
    else
    @tweet = Tweet.find_by_id(params[:id])
    erb :'tweets/show_tweet'
  end
  end

  get '/tweets/:id/edit' do
    if !logged_in?
      redirect to '/login'
    else
    @tweet = Tweet.find_by_id(params[:id])
    erb :'tweets/edit_tweet'
  end
end


  patch '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    if params[:content] != ""
      @tweet.update(content: params[:content])
      redirect to '/tweets'
    else
    redirect to "/tweets/#{@tweet.id}/edit"
  end
end


delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && current_user(session).id == @tweet.user_id
        @tweet.delete
        redirect to '/tweets'
    else
        redirect to '/tweets'
    end
  end


  ##HELPER METHODS
  def logged_in?
    !!session[:user_id]
  end

  def current_user(session)
    User.find(session[:user_id])
  end
end
