require 'spec_helper'

# Disable sudo on the client
RSpec.configure do |c|
    c.disable_sudo = true
end

describe 'Check svn client version' do
    describe command('svn --version') do
        it {should return_exit_status 0}
    end
end
describe 'Check fcm client version' do
    describe command('fcm --version') do
        it {should return_exit_status 0}
    end
end

describe 'Check connection to mirror repo' do
    repo = 'https://svn.accessdev.nci.org.au/ext_um/UM'
    describe command("svn info --non-interactive #{repo}") do
        it {should return_exit_status 0}
    end
end

describe 'Check FCM alias' do
    repo = 'fcm:ext/UM'
    describe command("fcm info --non-interactive #{repo}") do
        it {should return_exit_status 0}
    end
end
