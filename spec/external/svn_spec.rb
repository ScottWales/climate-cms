require 'spec_helper'

# Disable sudo on the client
RSpec.configure do |c|
    c.disable_sudo = true
end

server = '130.56.244.76'

describe "Unauthorised access" do 
    describe 'Check svn client version' do
        describe command('svn --version') do
            it {should return_exit_status 0}
        end
    end
    
    describe 'Check connection to mirror repo' do
        repo = "https://#{server}/svn/um_ext"
        describe command("svn info --non-interactive --trust-server-cert #{repo}") do
            it {should_not return_exit_status 0}
        end
        describe command("curl -skL --write-out %{http_code}     --output /dev/null #{repo}") do
            it { should return_stdout '403' }
        end
    end

    describe 'Check connection to sync repo' do
        repo = "https://#{server}/svn/um_ext-sync"
        describe command("svn info --non-interactive --trust-server-cert #{repo}") do
            it {should_not return_exit_status 0}
        end
        describe command("curl -skL --write-out %{http_code}     --output /dev/null #{repo}") do
            it { should return_stdout '403' }
        end
    end
end
