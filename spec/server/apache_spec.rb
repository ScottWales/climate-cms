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

    describe command("curl --write-out %{http_code} --silent --output /dev/null http://localhost") do
        it { should return_stderr '301' }
    end
    describe command("curl --write-out %{http_code} --insecure --silent --output /dev/null https://localhost") do
        it { should return_stderr '200' }
    end
end
