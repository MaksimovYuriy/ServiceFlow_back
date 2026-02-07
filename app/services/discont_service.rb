class DiscontService
    FIRST_DISCONT_PERCENT = 10

    def initialize(note)
        @note = note.data
        @service = note.data.service
        @client = note.data.client
    end

    def call
        debugger
        @note.update(total_price: calculate_new_price) if @client.notes.count == 1
    end

    private

    def calculate_new_price
        default_price = @service.price
        default_price * (100 - FIRST_DISCONT_PERCENT) / 100
    end
end