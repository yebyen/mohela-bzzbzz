#!/usr/bin/env ruby
require 'bundler/setup'
Bundler.require

require_relative 'lib/driver'
require_relative 'super_secret'
#require_relative 'secrets'
require_relative 'lib/business'
require_relative 'lib/nelnet'

Driver.configure
Business.new
Nelnet.new
