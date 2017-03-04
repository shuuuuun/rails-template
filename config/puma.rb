#!/usr/bin/env puma

# Start Puma with next command:
# RAILS_ENV=production bundle exec puma -C ./config/puma.rb

require 'yaml'

RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")
RAILS_ENV  = ENV['RAILS_ENV'] || 'development'
PORT       = ENV['PORT']
CONFIG     = YAML.load_file("#{RAILS_ROOT}/config/puma.yml")[RAILS_ENV]

puts "root: #{RAILS_ROOT}"
puts "dir: #{ENV['RAILS_RELATIVE_URL_ROOT']}"
puts "env: #{RAILS_ENV}"

# TODO: PORT未指定時もrails sならtcpで起動したい。
# TODO: rails server -p 3000 で指定したportを取得したい。
# TODO: 起動時の -d でデーモナイズできない。
# rails serverで起動したのかpumaで起動したのか判別したい。
# 起動時のオプションを読みたい。
# $ bundle exec rails s -b 0.0.0.0
# $ bundle exec puma -C config/puma.rb
# puts 'daemonize: ' + CONFIG['daemonize'].to_s
# puts 'port: ' + PORT.to_s

# The directory to operate out of.
#
# The default is the current directory.
#
directory RAILS_ROOT

# Set the environment in which the rack's app will run.
#
# The default is “development”.
#
environment RAILS_ENV

# Daemonize the server into the background. Highly suggest that
# this be combined with “pidfile” and “stdout_redirect”.
#
# The default is “false”.
#
daemonize CONFIG['daemonize']

# Store the pid of the server in the file at “path”.
#
pidfile File.join(RAILS_ROOT, CONFIG['pid'])

# Use “path” as the file to store the server info state. This is
# used by “pumactl” to query and control the server.
#
state_path File.join(RAILS_ROOT, CONFIG['state'])

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# (“append”) specifies whether the output is appended, the default is
# “false”.
#
stdout_redirect File.join(RAILS_ROOT, CONFIG['log']['stdout']),
                File.join(RAILS_ROOT, CONFIG['log']['stderr']), CONFIG['log']['append'] if CONFIG['daemonize']

# Configure “min” to be the minimum number of threads to use to answer
# requests and “max” the maximum.
#
# The default is “0, 16”.
#
threads CONFIG['thread']['min'], CONFIG['thread']['max']

# Bind the server to “url”. “tcp://”, “unix://” and “ssl://” are the only
# accepted protocols.
#
# The default is “tcp://0.0.0.0:9292”.
#
if PORT
  bind "tcp://0.0.0.0:#{PORT}"
else
  bind "unix://#{File.join(RAILS_ROOT, CONFIG['socket'])}"
end

# Instead of “bind 'ssl://127.0.0.1:9292?key=path_to_key&cert=path_to_cert'” you
# can also use the “ssl_bind” option.
#
# ssl_bind '127.0.0.1', '9292', { key: path_to_key, cert: path_to_cert }

# Code to run before doing a restart. This code should
# close log files, database connections, etc.
#
# This can be called multiple times to add code each time.
#
# on_restart do
#   puts 'On restart...'
# end

# Command to use to restart puma. This should be just how to
# load puma itself (ie. 'ruby -Ilib bin/puma'), not the arguments
# to puma, as those are the same as the original process.
#
# restart_command '/u/app/lolcat/bin/restart_puma'

# === Cluster mode ===

# How many worker processes to run.
#
# The default is “0”.
#
workers CONFIG['worker']

# cluster mode recommendations
# If you have more than 1 GB RAM, uncomment one of the following lines:
#
# workers 2 # if you have at least 1.5 GB RAM
# workers 3 # if you have at least 2   GB RAM
# workers 4 # if you have at least 2.5 GB RAM

# Code to run when a worker boots to setup the process before booting
# the app.
#
# This can be called multiple times to add hooks.
#
on_worker_boot do
  # puts 'On worker boot...'

  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end

# === Puma control rack application ===

# Start the puma control rack application on “url”. This application can
# be communicated with to control the main server. Additionally, you can
# provide an authentication token, so all requests to the control server
# will need to include that token as a query parameter. This allows for
# simple authentication.
#
# Check out https://github.com/puma/puma/blob/master/lib/puma/app/status.rb
# to see what the app has available.
#
# activate_control_app 'unix:///var/run/pumactl.sock'
# activate_control_app 'unix:///var/run/pumactl.sock', { auth_token: '12345' }
# activate_control_app 'unix:///var/run/pumactl.sock', { no_token: true }
