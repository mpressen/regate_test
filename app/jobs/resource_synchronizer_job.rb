class ResourceSynchronizerJob < ApplicationJob
  def perform(resource:, element_url:)
    model = resource.constantize

    attributes = get_attributes(
      payload: PokemonApi.get(element_url),
      attribute_names: model.column_names.map(&:to_sym)
    )

    model.find_or_initialize_by(external_id: attributes[:external_id]).update!(attributes)
  end

  private

  def get_attributes(payload:, attribute_names:)
    payload.slice!(*attribute_names)
    payload[:external_id] = payload.delete(:id)
    payload
  end
end
