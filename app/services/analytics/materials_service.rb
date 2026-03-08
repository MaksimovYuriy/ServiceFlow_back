module Analytics
  class MaterialsService
    def self.call(period)
      usage = MaterialOperation
        .where(operation_type: :out, status: :applied)
        .where(created_at: period)
        .group(:material_id)
        .sum(:amount)

      low_stock = Material.where("quantity <= minimal_quantity").map do |m|
        {
          id: m.id,
          title: m.title,
          quantity: m.quantity,
          minimal_quantity: m.minimal_quantity
        }
      end

      total_stock_value = Material.sum("quantity * price").to_f.round(2)

      usage_details = Material.all.map do |m|
        {
          id: m.id,
          title: m.title,
          quantity: m.quantity,
          usage: usage[m.id] || 0,
          price: m.price
        }
      end

      {
        total_stock_value: total_stock_value,
        low_stock_count: low_stock.size,
        low_stock: low_stock,
        usage_details: usage_details.sort_by { |m| -(m[:usage]) }
      }
    end
  end
end
