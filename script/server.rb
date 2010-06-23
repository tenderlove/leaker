require 'logger'
require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require 'active_support'
require 'action_controller'
require 'fileutils'
require 'optparse'

options = {
  :Port        => 3000,
  :Host        => "0.0.0.0",
  :environment => (ENV['RAILS_ENV'] || "development").dup,
  :config      => RAILS_ROOT + "/config.ru",
  :detach      => false,
  :debugger    => false,
  :path        => nil
}

%w(cache pids sessions sockets).each do |dir_to_make|
  FileUtils.mkdir_p(File.join(RAILS_ROOT, 'tmp', dir_to_make))
end

ENV["RAILS_ENV"] = options[:environment]
RAILS_ENV.replace(options[:environment]) if defined?(RAILS_ENV)

require RAILS_ROOT + "/config/environment"
inner_app = ActionController::Dispatcher.new

app = Rack::Builder.new {
  use Rails::Rack::LogTailer unless options[:detach]
  map "/" do
    use Rails::Rack::Static
    run inner_app
  end
}

app = app.to_app

fake_params = {
  "GATEWAY_INTERFACE"=>"CGI/1.1",
  "PATH_INFO"=>"/policies/view.xml",
  "QUERY_STRING"=>"",
  "REMOTE_ADDR"=>"127.0.0.1",
  "REMOTE_HOST"=>"localhost",
  "REQUEST_METHOD"=>"GET",
  "REQUEST_URI"=>"http://127.0.0.1:3000/policies/view.xml",
  "SCRIPT_NAME"=>"",
  "SERVER_NAME"=>"127.0.0.1",
  "SERVER_PORT"=>"3000",
  "SERVER_PROTOCOL"=>"HTTP/1.1",
  "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/1.9.3/2010-06-24)",
  "HTTP_HOST"=>"127.0.0.1:3000",
  "HTTP_USER_AGENT"=>"ApacheBench/2.3",
  "HTTP_ACCEPT"=>"*/*",
  "rack.version"=>[1, 1],
  #"rack.input"=>#<StringIO:0x000001016c0578>,
  "rack.errors"=>$stderr,
  "rack.multithread"=>true,
  "rack.multiprocess"=>false,
  "rack.run_once"=>false,
  "rack.url_scheme"=>"http",
  "HTTP_VERSION"=>"HTTP/1.1",
  "REQUEST_PATH"=>"/"
}

100_000.times do
  env = fake_params
  env['rack.input'] = StringIO.new
  app.call env
end
