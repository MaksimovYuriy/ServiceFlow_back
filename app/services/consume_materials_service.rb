class ConsumeMaterialsService
  def initialize(note)
    @note = note.data
    @service = note.data.service
  end

  def call
    ActiveRecord::Base.transaction do
      @service.service_materials.each do |sm|
        operation = Materials::OperationsProvider.call(:apply, {
          material_id: sm.material_id,
          amount: sm.required_quantity,
          operation_type: :out,
          source: :booking
        })
        operation.update!(note: @note)
      end
    end
  rescue Materials::OperationsProvider::NotEnoughMaterial => e
    raise Materials::OperationsProvider::NotEnoughMaterial, "Недостаточно материалов для услуги: #{e.message}"
  end
end
