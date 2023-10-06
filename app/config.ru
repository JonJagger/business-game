$stdout.sync = true
$stderr.sync = true

require_relative 'bg'
require 'rack'
run BG.new(nil)
