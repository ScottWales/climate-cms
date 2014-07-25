require 'spec_helper'

describe "Apache server" do
    describe service("httpd") do
        it { should be_enabled }
        it { should be_running }
    end

    describe port("80") do
        it { should be_listening }
    end

    describe port("443") do
        it { should be_listening }
    end

    describe "SSL redirection" do
        describe command("curl --write-out %{http_code} --silent --output/dev/null localhost") {
            it { should return_stderr '301' }
        }
        describe command("curl --write-out %{http_code} --silent --output/dev/null https://localhost") {
            it { should return_stderr '200' }
        }
    end
end
