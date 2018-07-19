# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |sp|
  sp.log_level = :info
  sp.file_cache_path = Chef::Config[:file_cache_path]
  sp.color = true
end

Dir['*_spec.rb'].each { |f| require File.expand_path(f) }
at_exit { ChefSpec::Coverage.report! }
