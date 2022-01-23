require 'rails_helper'

RSpec.describe ResourceSynchronizerJob, type: :job do
  subject do
    described_class.perform_now(
      resource: resource,
      element_url: element_url
    )
  end

  let(:model) { resource.constantize }
  let(:cassette) { "first_#{resource}" }

  shared_examples "create_or_update" do
    context 'not in db' do
      it 'creates record' do
        VCR.use_cassette(cassette) { subject }
        expect(model.first.attributes.symbolize_keys)
          .to include(expected_attributes)
      end
    end

    context 'already in db' do
      context 'unchanged' do
        let!(:record) { model.create!(expected_attributes) }

        it 'does nothing' do
          VCR.use_cassette(cassette) { subject }
          record.reload
          expect(record.updated_at).to eq record.created_at
        end
      end

      context 'updated' do
        let!(:record) do
          record = model.new(expected_attributes)
          record.update!(name: '_')
          record
        end

        it 'updates record' do
          VCR.use_cassette(cassette) { subject }
          record.reload
          expect(record.updated_at).not_to eq record.created_at
        end
      end
    end
  end

  context 'pokemon' do
    let(:resource) { 'Pokemon' }
    let!(:element_url) { 'https://pokeapi.co/api/v2/pokemon/1' }
    let(:expected_attributes) do
      {
        name: "bulbasaur",
        height: 7,
        weight: 69,
        order: 1,
        base_experience: 64,
        is_default: true,
        external_id: 1
      }
    end

    include_examples "create_or_update"
  end

  context 'types' do
    let(:resource) { 'PokemonType' }
    let!(:element_url) { 'https://pokeapi.co/api/v2/type/1' }
    let(:expected_attributes) do
      {
        name: "normal",
        external_id: 1
      }
    end

    include_examples "create_or_update"
  end
end
