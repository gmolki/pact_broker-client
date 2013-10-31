require 'spec_helper'
require 'fakefs/safe'
require 'pact_broker/client/publish_pacts'
require 'json'

module PactBroker
  module ClientSupport
    describe PublishPacts do

      before do
        FakeFS.activate!
      end

      after do
        FakeFS.deactivate!
      end

      let(:pact_broker_client) { double("PactBroker::Client")}
      let(:pacts) { ['spec/pacts/consumer-provider.json']}
      let(:consumer_version) { "1.2.3" }
      let(:pact_hash) { {consumer: {name: 'Consumer'}, provider: {name: 'Provider'} } }
      let(:pacts_client) { instance_double("PactBroker::ClientSupport::Pacts")}

      subject { PublishPacts.new(pact_broker_client, pacts, consumer_version) }

      before do
        FileUtils.mkdir_p "spec/pacts"
        File.open("spec/pacts/consumer-provider.json", "w") { |file| file << pact_hash.to_json }
        pact_broker_client.stub_chain(:pacticipants, :versions, :pacts).and_return(pacts_client)
      end

      describe "call" do
        context "when publishing is successful" do
          it "uses the pact_broker client to publish the given pact" do
            pacts_client.should_receive(:publish).with(pact_json: pact_hash.to_json, consumer_version: consumer_version)
            subject.call
          end
        end
        context "when publishing one pact fails" do
          let(:pacts) { ['spec/pacts/doesnotexist.json','spec/pacts/consumer-provider.json']}

          it "continues publishing the rest" do
            pacts_client.should_receive(:publish).with(pact_json: pact_hash.to_json, consumer_version: consumer_version)
            subject.call
          end
        end

      end
    end
  end
end