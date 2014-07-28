require 'spec_helper'

describe "Local svn access" do
    describe 'Check connection to repo' do
        repo = 'https://svn/um_ext'
        describe command("svn info --non-interactive --trust-server-cert #{repo}") do
            it {should return_exit_status 0}
        end
    end
end

describe "Sync access" do
    describe 'Check connection to repo' do
        repo = 'https://svn/um_ext-sync'
        describe command("svn info --non-interactive --trust-server-cert #{repo}") do
            it {should return_exit_status 0}
        end
    end
end
