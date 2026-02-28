require 'csv'

class PriceAnalysisService
  ALPHA = 0.05
  BETA  = 0.03
  START_DATE = Date.new(2024, 1, 1)
  END_DATE   = Date.new(2026, 2, 28)

  def call
    services = Service.all.includes(service_materials: :material)
    return if services.empty?

    notes_data         = preload_notes_data
    first_visit_counts = preload_first_visit_counts
    material_costs     = compute_material_costs(services)
    months             = generate_months

    rows = []

    months.each do |year, month|
      max_bookings = services.map { |s| notes_data.dig(s.id, year, month, :count) || 0 }.max
      max_bookings = 1 if max_bookings.zero?

      services.each do |service|
        data           = notes_data.dig(service.id, year, month) || {}
        total_bookings = data[:count] || 0
        revenue        = data[:sum] || 0.0
        avg_price_fact = data[:avg] || 0.0

        fv_count          = first_visit_counts.dig(service.id, year, month) || 0
        first_visit_share = total_bookings > 0 ? fv_count.to_f / total_bookings : 0.0

        avg_material_cost  = material_costs[service.id] || 0.0
        material_cost_share = service.price > 0 ? avg_material_cost / service.price : 0.0

        demand_factor      = total_bookings.to_f / max_bookings
        first_visit_factor = first_visit_share
        target = service.price * (1 + ALPHA * demand_factor - BETA * first_visit_factor)
        target = target.clamp(service.price * 0.85, service.price * 1.15)

        rows << [
          service.id,
          service.price,
          service.active? ? 1 : 0,
          total_bookings,
          revenue.round(2),
          avg_price_fact.round(2),
          first_visit_share.round(4),
          year,
          month,
          avg_material_cost.round(2),
          material_cost_share.round(4),
          target.round(2)
        ]
      end
    end

    write_csv(rows)
  end

  private

  def generate_months
    months = []
    date = START_DATE
    while date <= END_DATE
      months << [date.year, date.month]
      date = date.next_month
    end
    months
  end

  def preload_notes_data
    results = Note.completed
      .select(
        "service_id",
        "CAST(strftime('%Y', start_at) AS INTEGER) as year",
        "CAST(strftime('%m', start_at) AS INTEGER) as month",
        "COUNT(*) as cnt",
        "SUM(total_price) as total",
        "AVG(total_price) as average"
      )
      .group("service_id, strftime('%Y', start_at), strftime('%m', start_at)")

    data = {}
    results.each do |r|
      data[r.service_id] ||= {}
      data[r.service_id][r.year] ||= {}
      data[r.service_id][r.year][r.month] = {
        count: r.cnt,
        sum:   r.total,
        avg:   r.average
      }
    end
    data
  end

  def preload_first_visit_counts
    rows = ActiveRecord::Base.connection.select_all(<<~SQL)
      WITH client_firsts AS (
        SELECT client_id, MIN(start_at) AS first_at
        FROM notes
        WHERE status = 2
        GROUP BY client_id
      )
      SELECT
        n.service_id,
        CAST(strftime('%Y', n.start_at) AS INTEGER) AS year,
        CAST(strftime('%m', n.start_at) AS INTEGER) AS month,
        COUNT(*) AS fv_count
      FROM notes n
      JOIN client_firsts cf ON cf.client_id = n.client_id
      WHERE n.status = 2
        AND strftime('%Y-%m', n.start_at) = strftime('%Y-%m', cf.first_at)
      GROUP BY n.service_id, strftime('%Y', n.start_at), strftime('%m', n.start_at)
    SQL

    data = {}
    rows.each do |r|
      sid   = r['service_id']
      year  = r['year']
      month = r['month']
      data[sid] ||= {}
      data[sid][year] ||= {}
      data[sid][year][month] = r['fv_count']
    end
    data
  end

  def compute_material_costs(services)
    costs = {}
    services.each do |service|
      costs[service.id] = service.service_materials.sum { |sm| sm.required_quantity * (sm.material.price || 0) }
    end
    costs
  end

  def write_csv(rows)
    path = Rails.root.join('tmp', 'price_analysis.csv')
    CSV.open(path, 'w') do |csv|
      csv << %w[
        service_id base_price is_active total_bookings revenue
        avg_price_fact first_visit_share year month
        avg_material_cost_per_service material_cost_share target_price
      ]
      rows.each { |row| csv << row }
    end
    path.to_s
  end
end
