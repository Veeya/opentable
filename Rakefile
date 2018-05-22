begin
  require "rspec/core/rake_task"
rescue LoadError
  puts "Rspec is not loaded"
end

if defined?(RSpec)
  RSpec::Core::RakeTask.new(:test) do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.verbose = false
  end
end

task :default => :test

task :environment do
  require "./boot"
end

namespace :opentable do
  desc "Flush all OpenTable data"
  task :flush => :environment do 
    Restaurant.delete_all
  end
  
  desc "Refresh Restaurants"
  task :refresh_restaurants => :environment do
	require 'rest-client'
	require 'base64'
	require 'yaml'
	require 'erb'

	opentable_config = YAML.load(ERB.new(File.read("./config/opentable.yml")).result)
	client_credentials = Base64.encode64(opentable_config['client_id'] + ':' + opentable_config['secret'])	
	auth_server = 'oauth-pp.opentable.com'
	endpoint_server = 'platform.otqa.com'
	if (opentable_config['env'] == 'PROD')
		auth_server = 'oauth.opentable.com'
		endpoint_server = 'platform.opentable.com'
	end

	auth_response = RestClient.get('https://' + auth_server + '/api/v2/oauth/token?grant_type=client_credentials', headers={'Authorization':'Basic ' + client_credentials})
	token = JSON.parse(auth_response)['access_token']

	offset = 0
	total_items = 1000000000
	items = []

	while offset < total_items do
		offset = items.count
		if total_items == 1000000000
			puts 'Fetching Initial Items'
		else
			puts 'Fetching Items ' + items.count.to_s + '/' + total_items.to_s
		end
		results_response = RestClient.get('https://' + endpoint_server + '/sync/directory?offset=' + offset.to_s, headers={'Authorization':'bearer ' + token})
		results = JSON.parse(results_response)
		total_items = results['total_items'].to_i
		items.push(*results['items'])
	end
	
	puts 'Final Items=' + items.count.to_s
    Restaurant.delete_all
	records = Restaurant.import_records(items)	
	puts 'Restaurant count=' + Restaurant.count.to_s
	puts 'OpenTable Restaurants Refreshed Successfully'
  end
end

task :console => :environment do
  require "irb"
  require "irb/completion"
  require "pp"
  
  ARGV.clear
  IRB.start
end

namespace :redis do
  task :flush => :environment do
    Redis.current.flushall
  end
end