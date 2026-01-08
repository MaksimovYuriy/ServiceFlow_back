module Materials
    class OperationsController < ApplicationController

        def add
            OperationsProvider.call(:apply, 
                                    operation_params.merge(
                                        operation_type: :in,
                                        source: :manual
                                    ))
            render json: success, status: :ok
        rescue StandardError => e
            render json: internal_error, status: :unprocessable_entity
        end

        def substract
            OperationsProvider.call(:apply, 
                                    operation_params.merge(
                                        operation_type: :out,
                                        source: :manual
                                    ))
            render json: success, status: :ok
        rescue Materials::OperationsProvider::NotEnoughMaterial
            render json: not_enough_error, status: :unprocessable_entity
        rescue StandardError => e
            render json: internal_error, status: :unprocessable_entity
        end

        private 

        def operation_params
            params.permit(:material_id, :amount)
        end

        def success
            {
                status: 'success',
                message: 'Operation applied successfully'
            }
        end

        def internal_error
            {
                status: 'error',
                message: 'Something went wrong'
            }
        end

        def not_enough_error
            {
                status: 'error',
                message: 'Not enough material available'
            }
        end

    end
end