get '/' do
  @user = User.all
  erb :index
end
