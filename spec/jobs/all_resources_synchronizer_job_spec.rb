require 'rails_helper'

RSpec.describe AllResourcesSynchronizerJob, type: :job do
  subject { described_class.perform_now(resource: resource)}

  shared_examples "triggers unit jobs" do
    it 'works' do
      ActiveJob::Base.queue_adapter = :test
      VCR.use_cassette("#{resource.parameterize}_index") { subject }
      expect(ResourceSynchronizerJob).to have_been_enqueued.exactly(resources_size)
    end
  end

  context 'pokemons' do
    let(:resource) { 'Pokemon' }
    let(:resources_size) { 1118 }

    include_examples "triggers unit jobs"
  end

  context 'types' do
    let(:resource) { 'PokemonType' }
    let(:resources_size) { 20 }

    include_examples "triggers unit jobs"
  end
end
