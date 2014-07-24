require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

properties = YAML.load_file('spec/properties.yaml')

task :spec => 'serverspec:all'

namespace :serverspec do
    task :all => properties.keys.map do |key| 
        'serverspec:' + key
    end



    properties.keys.each do |key|
        role = properties[key][:role]
        puts "#{key} #{role}"
    end
    properties.keys.each do |key|
        RSpec::Core::RakeTask.new(key.to_sym) do |t|
            ENV['TARGET_HOST'] = key

            role = properties[key][:role]
            t.pattern = 'spec/'+role+'/*_spec.rb'
        end
    end
end

task :default => :spec
