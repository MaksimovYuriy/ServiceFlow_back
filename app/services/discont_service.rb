class DiscontService
    FIRST_DISCONT_PERCENT = 10

    def initialize(note)
        @note = note.data
        @service = note.data.service
        @client = note.data.client
    end

    def call
        if @client.notes.count == 1
            @note.update(total_price: calculate_discont_price)
        else
            @note.update(total_price: @service.price)
        end
    end

    private

    def calculate_discont_price
        default_price = @service.price
        default_price * (100 - FIRST_DISCONT_PERCENT) / 100
    end
end