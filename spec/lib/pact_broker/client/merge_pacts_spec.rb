require 'pact_broker/client/merge_pacts'

module PactBroker
  module Client
    describe MergePacts do
      describe ".call" do
        describe "with a pact with interactions" do
          let(:pact_hash_1) do
            {
              other: 'info',
              interactions: [
                { providerState: 1, description: 1, foo: 'bar' }
              ]
            }
          end

          let(:pact_hash_2) do
            {
              interactions: [
                { providerState: 2, description: 2, foo: 'wiffle' }
              ]
            }
          end

          let(:pact_hash_3) do
            {
              interactions: [
                { providerState: 3, description: 3, foo: 'meep' },
                { providerState: 1, description: 1, foo: 'bar' }
              ]
            }
          end

          let(:pact_hashes) { [pact_hash_1, pact_hash_2, pact_hash_3] }

          let(:expected_merge) do
            {
              other: 'info',
              interactions: [
                { providerState: 1, description: 1, foo: 'bar' },
                { providerState: 2, description: 2, foo: 'wiffle' },
                { providerState: 3, description: 3, foo: 'meep' }
              ]
            }
          end

          subject { MergePacts.call(pact_hashes) }

          it "merges the interactions by consumer/provider" do
            expect(subject).to eq expected_merge
          end

          context "when an interaction is found with the same state and description but has a difference elsewhere" do
            let(:pact_hash_3) do
              {
                interactions: [
                  { providerState: 3, description: 3, foo: 'meep' },
                  { providerState: 1, description: 1, foo: 'different' }
                ]
              }
            end

            it "raises an error" do
              expect { subject }.to raise_error PactMergeError, /foo.*different/
            end
          end
        end

        describe "with a pact with messages" do
          let(:pact_hash_1) do
            {
              other: 'info',
              messages: [
                { providerState: 1, description: 1, foo: 'bar' }
              ]
            }
          end

          let(:pact_hash_2) do
            {
              messages: [
                { providerState: 2, description: 2, foo: 'wiffle' }
              ]
            }
          end

          let(:pact_hash_3) do
            {
              messages: [
                { providerState: 3, description: 3, foo: 'meep' },
                { providerState: 1, description: 1, foo: 'bar' }
              ]
            }
          end

          let(:pact_hashes) { [pact_hash_1, pact_hash_2, pact_hash_3] }

          let(:expected_merge) do
            {
              other: 'info',
              messages: [
                { providerState: 1, description: 1, foo: 'bar' },
                { providerState: 2, description: 2, foo: 'wiffle' },
                { providerState: 3, description: 3, foo: 'meep' }
              ]
            }
          end

          subject { MergePacts.call(pact_hashes) }

          it "merges the messages by consumer/provider" do
            expect(subject).to eq expected_merge
          end

          context "when an interaction is found with the same state and description but has a difference elsewhere" do
            let(:pact_hash_3) do
              {
                messages: [
                  { providerState: 3, description: 3, foo: 'meep' },
                  { providerState: 1, description: 1, foo: 'different' }
                ]
              }
            end

            it "raises an error" do
              expect { subject }.to raise_error PactMergeError, /foo.*different/
            end
          end
        end

        describe "with a pact with messages and a pact with interactions" do
          let(:pact_hash_1) do
            {
              other: 'info',
              messages: [
                { providerState: 1, description: 1, foo: 'bar' }
              ]
            }
          end

          let(:pact_hash_2) do
            {
              interactions: [
                { providerState: 2, description: 2, foo: 'wiffle' }
              ]
            }
          end

          let(:pact_hashes) { [pact_hash_1, pact_hash_2] }

          let(:expected_merge) do
            {
              other: 'info',
              messages: [
                { providerState: 1, description: 1, foo: 'bar' }
              ],
              interactions: [
                { providerState: 2, description: 2, foo: 'wiffle' }
              ]
            }
          end

          subject { MergePacts.call(pact_hashes) }

          it "merges the messages by consumer/provider" do
            expect(subject).to eq expected_merge
          end
        end
      end
    end
  end
end
