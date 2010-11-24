# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/ripl/irb"
 
Gem::Specification.new do |s|
  s.name        = "ripl-irb"
  s.version     = Ripl::Irb::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github.com/cldwalker/ripl-irb"
  s.summary = "A ripl plugin to smooth the transition from irb"
  s.description =  "A ripl plugin that smooths the transition from irb by mocking out IRB. Safely captures all IRB calls and points to ripl equivalents for irb's commands and config options."
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = 'tagaholic'
  s.add_dependency 'ripl', '>= 0.2.5'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
