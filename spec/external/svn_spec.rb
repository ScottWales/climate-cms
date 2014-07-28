require 'spec_helper'

# Disable sudo on the client
RSpec.configure do |c|
    c.disable_sudo = true
end

describe "Unauthorised access" do 
    describe 'Check svn client version' do
        describe command('svn --version') do
            it {should return_exit_status 0}
        end
    end
    
    describe 'Check connection to mirror repo' do
        repo = 'https://svn.accessdev.nci.org.au/ext_um'
        describe command("svn info --non-interactive #{repo}") do
            it {should_not return_exit_status 0}
        end
    end

    describe 'Check connection to sync repo' do
        repo = 'https://svn.accessdev.nci.org.au/ext_um-sync'
        describe command("svn info --non-interactive #{repo}") do
            it {should_not return_exit_status 0}
        end
    end
end
