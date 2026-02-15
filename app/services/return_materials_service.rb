class ReturnMaterialsService
  def initialize(note)
    @note = note
  end

  def call
    ActiveRecord::Base.transaction do
      operations_to_return.each do |operation|
        Materials::OperationsProvider.call(:apply, {
          material_id: operation.material_id,
          amount: operation.amount,
          operation_type: :in,
          source: :booking
        })
      end
    end
  end

  private

  def operations_to_return
    @note.material_operations
         .where(operation_type: :out, status: :applied)
  end
end
