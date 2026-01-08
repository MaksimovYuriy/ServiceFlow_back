module Materials
  class OperationsProvider
    class InvalidAction < StandardError; end
    class InvalidTransition < StandardError; end
    class NotEnoughMaterial < StandardError; end

    def self.call(action, params)
        new(action, params).call
    end

    def initialize(action, params)
        @action = action.to_sym
        @params = params.to_unsafe_h.symbolize_keys
    end

    def call
        case @action
        when :apply
            apply!
        when :confirm
            confirm!
        when :cancel
            cancel!
        else
            raise InvalidAction, "Unknown action: #{@action}"
        end
    end


    private

    def apply!
        material_id = @params.fetch(:material_id)
        amount = @params.fetch(:amount).to_i
        operation_type = @params.fetch(:operation_type).to_sym
        source = @params.fetch(:source).to_sym

        raise InvalidAction if amount <= 0

        ActiveRecord::Base.transaction do
            material = Material.lock.find(material_id)

            if operation_type == :out && material.quantity < amount
                raise NotEnoughMaterial
            end

            operation = MaterialOperation.create!(
                material: material,
                amount: amount,
                operation_type: operation_type,
                source: source,
                status: :pending
            )

            delta = operation.in? ? amount : -amount
            material.update!(quantity: material.quantity + delta)

            operation.update!(status: :applied)

            operation
        end
    end

    def confirm!
      operation = MaterialOperation.find(@params.fetch(:operation_id))

      raise InvalidTransition unless operation.pending?

      operation.update!(status: :applied)
      operation
    end

    def cancel!
      ActiveRecord::Base.transaction do
        operation = MaterialOperation.lock.find(@params.fetch(:operation_id))
        material = operation.material

        return operation if operation.cancelled?
        raise InvalidTransition if operation.applied?

        delta = operation.in? ? -operation.amount : operation.amount

        material.update!(quantity: material.quantity + delta)
        operation.update!(status: :cancelled)

        operation
      end
    end
  end
end
