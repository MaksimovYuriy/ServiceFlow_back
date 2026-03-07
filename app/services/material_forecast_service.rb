require 'csv'

class MaterialForecastService
  def call
    services = Service.all
    return if services.empty?

    bookings = preload_bookings
    months = generate_months

    return if months.size < 4

    avg_bookings = compute_avg_bookings(bookings, services, months)

    rows = []

    services.each do |service|
      avg_b = avg_bookings[service.id]
      next if avg_b.nil? || avg_b.zero?

      months.each_with_index do |(year, month), idx|
        next if idx < 3

        total = bookings.dig(service.id, year, month) || 0
        ratio = total.to_f / avg_b

        lag_1 = get_ratio(bookings, service.id, months, idx, 1, avg_b)
        lag_2 = get_ratio(bookings, service.id, months, idx, 2, avg_b)
        lag_3 = get_ratio(bookings, service.id, months, idx, 3, avg_b)

        avg_last_3m = (lag_1 + lag_2 + lag_3) / 3.0

        trend = compute_trend(bookings, service.id, months, idx, avg_b)

        month_sin = Math.sin(2 * Math::PI * month / 12.0)
        month_cos = Math.cos(2 * Math::PI * month / 12.0)

        rows << [
          service.id,
          total,
          avg_b.round(2),
          ratio.round(4),
          lag_1.round(4),
          lag_2.round(4),
          lag_3.round(4),
          avg_last_3m.round(4),
          trend.round(4),
          month_sin.round(4),
          month_cos.round(4),
          year,
          month
        ]
      end
    end

    write_csv(rows)
    export_materials_json
    export_service_materials_json
  end

  private

  def generate_months
    first_note = Note.where(status: 2).minimum(:start_at)
    return [] unless first_note

    start_date = first_note.to_date.beginning_of_month
    end_date = Date.today.beginning_of_month

    months = []
    date = start_date
    while date <= end_date
      months << [date.year, date.month]
      date = date.next_month
    end
    months
  end

  def preload_bookings
    results = Note.where(status: 2)
      .select(
        "service_id",
        "CAST(strftime('%Y', start_at) AS INTEGER) as year",
        "CAST(strftime('%m', start_at) AS INTEGER) as month",
        "COUNT(*) as cnt"
      )
      .group("service_id, strftime('%Y', start_at), strftime('%m', start_at)")

    data = {}
    results.each do |r|
      data[r.service_id] ||= {}
      data[r.service_id][r.year] ||= {}
      data[r.service_id][r.year][r.month] = r.cnt
    end
    data
  end

  def compute_avg_bookings(bookings, services, months)
    avgs = {}
    services.each do |service|
      values = months.map { |y, m| bookings.dig(service.id, y, m) || 0 }
      avgs[service.id] = values.sum.to_f / values.size
    end
    avgs
  end

  def get_ratio(bookings, service_id, months, current_idx, lag, avg_b)
    target_idx = current_idx - lag
    return 1.0 if target_idx < 0

    y, m = months[target_idx]
    total = bookings.dig(service_id, y, m) || 0
    total.to_f / avg_b
  end

  def compute_trend(bookings, service_id, months, current_idx, avg_b)
    recent_count = 0
    recent_sum = 0.0
    prev_count = 0
    prev_sum = 0.0

    6.times do |i|
      idx = current_idx - 1 - i
      next if idx < 0
      y, m = months[idx]
      val = (bookings.dig(service_id, y, m) || 0).to_f / avg_b
      if i < 3
        recent_sum += val
        recent_count += 1
      else
        prev_sum += val
        prev_count += 1
      end
    end

    return 1.0 if prev_count.zero? || recent_count.zero?

    recent_avg = recent_sum / recent_count
    prev_avg = prev_sum / prev_count

    prev_avg > 0 ? recent_avg / prev_avg : 1.0
  end

  def export_materials_json
    data = Material.all.map do |m|
      { id: m.id, title: m.title, current_quantity: m.quantity,
        minimal_quantity: m.minimal_quantity, price: m.price || 0.0 }
    end
    path = Rails.root.join('tmp', 'materials.json')
    File.write(path, data.to_json)
  end

  def export_service_materials_json
    data = ServiceMaterial.all.map do |sm|
      { service_id: sm.service_id, material_id: sm.material_id,
        required_quantity: sm.required_quantity }
    end
    path = Rails.root.join('tmp', 'service_materials.json')
    File.write(path, data.to_json)
  end

  def write_csv(rows)
    path = Rails.root.join('tmp', 'material_forecast.csv')
    CSV.open(path, 'w') do |csv|
      csv << %w[
        service_id total_bookings avg_bookings booking_ratio
        bookings_lag_1 bookings_lag_2 bookings_lag_3
        avg_bookings_last_3m usage_trend
        month_sin month_cos
        year month
      ]
      rows.each { |row| csv << row }
    end
    path.to_s
  end
end
