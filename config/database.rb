configure :development do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

configure :development, :test do
  set :database, {
    'development' => {
      'adapter' => 'sqlite3',
      'database' => APP_ROOT.join('db', 'development.sqlite3')
    },
    'test' => {
      'adapter' => 'sqlite3',
      'database' => APP_ROOT.join('db', 'test.sqlite3')
    }
  }
  DB_NAME = APP_ROOT.join("db", "#{Sinatra::Application.environment}.sqlite3")
end


configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || "postgres://localhost/#{APP_NAME}_#{Sinatra::Application.environment}")
  DB_NAME = db.path[1..-1]

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end

configure do
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end
end
