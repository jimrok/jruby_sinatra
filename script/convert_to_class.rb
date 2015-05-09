#!/usr/bin/env jruby

require 'jruby/jrubyc'
require 'fileutils'



source_path = File.expand_path("../../dist", __FILE__)
if source_path.nil? then
	puts "Source code path not found."
	exit 1
end


Dir["#{source_path}/lib/*.jar"].each do |jar|
	# next if jar.start_with? "lib/jruby"
	# next if ["lib/bundle-gems.jar","lib/gems.jar"].include?(jar)
	# #puts "require #{jar}"
	require jar
end

# Dir.chdir(source_path) do
# puts Dir.getwd

# ["api", "controllers", "helpers", "jobs", "mailers", "models"].each do |dir|
# 	system("./rubyencoder -r --external #{@project_id}.lic --projid #{@project_id} --projkey #{@project_key} --encoding UTF-8 --ruby 2.0.0 #{temp}/app/#{dir}")
# end

# ["cells"].each do |dir|
# 	system("./rubyencoder -r --external #{@project_id}.lic --projid #{@project_id} --projkey #{@project_key} --encoding UTF-8 --ruby 2.0.0 #{temp}/app/#{dir}/*.rb")
# end

# ["packages","entities","mqtt_agent","notifications","dispacher","devise"].each do |dir|
# 	system("./rubyencoder -r --external #{@project_id}.lic --projid #{@project_id} --projkey #{@project_key} --encoding UTF-8 --ruby 2.0.0 #{temp}/lib/#{dir}/*.rb")
# end

# ["models","strategies"].each do |dir|
# 	system("./rubyencoder -r --external #{@project_id}.lic --projid #{@project_id} --projkey #{@project_key} --encoding UTF-8 --ruby 2.0.0 #{temp}/lib/oauth2_providable/#{dir}/*.rb")
# end
#status = JRuby::Compiler::compile_argv(["*.rb"])

# end

# status =  JRuby::Compiler::compile_argv(ARGV)

status = JRuby::Compiler::compile_argv(["dist/*.rb","--verbose"])
status = JRuby::Compiler::compile_argv(["dist/app/helpers/*.rb","--verbose"])
status = JRuby::Compiler::compile_argv(["dist/app/controllers/*.rb","--verbose"])
status = JRuby::Compiler::compile_argv(["dist/app/models/*.rb","--verbose"])
status = JRuby::Compiler::compile_argv(["dist/app/models/concerns/*.rb","--verbose"])

FileUtils.rm_rf("#{source_path}/*.rb")
Dir.chdir(source_path) do
      system("find  app  -name  '*.rb'  -type  f -exec  rm  -rf  {} \\;")
      #system("find  .  -name  '*.rb'  -type  f -exec  rm  -rf  {} \\;")
end

if (status != 0)
	puts "Compilation FAILED: #{status} error(s) encountered"
	exit status
end
