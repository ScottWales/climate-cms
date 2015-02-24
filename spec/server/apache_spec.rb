require 'spec_helper'

describe "Apache server" do
    describe service("httpd") do
        it { should be_enabled }
        it { should be_running }
    end

    describe port("80") do
        it { should be_listening }
    end

    describe "SSL redirect" do
        describe port("443") do
            it { should be_listening }
        end

        describe command("curl -s   --write-out %{http_code}     --output /dev/null http://localhost") do
            it { should return_stdout '301' }
        end
        describe command("curl -skL --write-out %{url_effective} --output /dev/null http://localhost") do
            it { should return_stdout 'https://localhost/' }
        end
        describe command("curl -sk  --write-out %{http_code}     --output /dev/null https://localhost") do
            it { should return_stdout '404' }
        end
    end
end
