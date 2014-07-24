require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS
include SpecInfra::Helper::Properties

properties = YAML.load_file('spec/properties.yaml')

RSpec.configure do |c|

    c.before :all do
        block = self.class.metadata[:example_group_block]
        if RUBY_VERSION.start_with?('1.8')
            file = block.to_s.match(/.*@(.*):[0-9]+>/)[1]
        else
            file = block.source_location.first
        end

        c.host = ENV['TARGET_HOST']
        set_property properties[c.host]
        c.ssh.close if c.ssh
        options = Net::SSH::Config.for(c.host)
        user    = options[:user] || Etc.getlogin
        c.ssh   = Net::SSH.start(c.host, user, options)

        @repo = properties[c.host][:repo]
    end
end
