class AllResourcesSynchronizerJob < ApplicationJob
  def perform(resource:)
    all_elements = PokemonApi.get_all(resource)

    all_elements.each do |element|
      ResourceSynchronizerJob.perform_later(
        resource: resource,
        element_url: element[:url]
      )
    end
  end
end
