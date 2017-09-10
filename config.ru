require './index'
run Sinatra::Application
enable :logging, :dump_errors, :raise_errors
$stdout.sync = true
