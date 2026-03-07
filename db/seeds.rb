# frozen_string_literal: true

puts "=== Seeding User ==="
User.create!(email: "admin@admin.com", password: "admin", active: true)

# ─── Materials (20 шт) ───────────────────────────────────────────────
puts "=== Seeding Materials ==="
materials_data = [
  { title: "Шампунь профессиональный",    price: 450.0,  minimal_quantity: 5,  quantity: 0 },
  { title: "Краска для волос",             price: 680.0,  minimal_quantity: 10, quantity: 0 },
  { title: "Окислитель 6%",               price: 320.0,  minimal_quantity: 8,  quantity: 0 },
  { title: "Окислитель 9%",               price: 350.0,  minimal_quantity: 5,  quantity: 0 },
  { title: "Маска для волос",              price: 520.0,  minimal_quantity: 4,  quantity: 0 },
  { title: "Лак для волос",               price: 380.0,  minimal_quantity: 3,  quantity: 0 },
  { title: "Гель для укладки",            price: 290.0,  minimal_quantity: 3,  quantity: 0 },
  { title: "Перчатки одноразовые (пара)", price: 50.0,   minimal_quantity: 30, quantity: 0 },
  { title: "Фольга парикмахерская (лист)",price: 80.0,   minimal_quantity: 20, quantity: 0 },
  { title: "Кисть для окрашивания",       price: 150.0,  minimal_quantity: 3,  quantity: 0 },
  { title: "Полотенце одноразовое",       price: 60.0,   minimal_quantity: 30, quantity: 0 },
  { title: "Бальзам для волос",           price: 410.0,  minimal_quantity: 4,  quantity: 0 },
  { title: "Лосьон после бритья",         price: 340.0,  minimal_quantity: 3,  quantity: 0 },
  { title: "Воск для депиляции",          price: 750.0,  minimal_quantity: 5,  quantity: 0 },
  { title: "Крем для лица",               price: 890.0,  minimal_quantity: 3,  quantity: 0 },
  { title: "Пилка для ногтей",            price: 120.0,  minimal_quantity: 10, quantity: 0 },
  { title: "Лак для ногтей",              price: 350.0,  minimal_quantity: 8,  quantity: 0 },
  { title: "Жидкость для снятия лака",    price: 180.0,  minimal_quantity: 5,  quantity: 0 },
  { title: "Масло для кутикулы",          price: 260.0,  minimal_quantity: 5,  quantity: 0 },
  { title: "Дезинфицирующий раствор",     price: 210.0,  minimal_quantity: 5,  quantity: 0 },
]

now = Time.current
Material.insert_all(
  materials_data.map { |m| m.merge(created_at: now, updated_at: now) }
)
materials = Material.all.index_by(&:title)
puts "  Materials: #{Material.count}"

# ─── Services (25 шт, ~22 active) ────────────────────────────────────
puts "=== Seeding Services ==="
services_data = [
  { title: "Женская стрижка",             price: 1500, duration: "60",  active: true,
    description: "Стрижка с мытьём и укладкой" },
  { title: "Мужская стрижка",             price: 800,  duration: "40",  active: true,
    description: "Классическая мужская стрижка" },
  { title: "Детская стрижка",             price: 600,  duration: "30",  active: true,
    description: "Стрижка для детей до 12 лет" },
  { title: "Окрашивание в один тон",      price: 3500, duration: "60",  active: true,
    description: "Окрашивание волос в один цвет" },
  { title: "Мелирование",                 price: 4500, duration: "60",  active: true,
    description: "Частичное осветление прядей" },
  { title: "Балаяж",                      price: 5000, duration: "60",  active: true,
    description: "Техника окрашивания балаяж" },
  { title: "Тонирование волос",           price: 2500, duration: "60",  active: true,
    description: "Тонирование после осветления" },
  { title: "Укладка феном",               price: 1000, duration: "40",  active: true,
    description: "Укладка феном и брашингом" },
  { title: "Вечерняя укладка",            price: 2500, duration: "60",  active: true,
    description: "Праздничная причёска" },
  { title: "Ламинирование волос",         price: 3000, duration: "60",  active: true,
    description: "Восстанавливающее ламинирование" },
  { title: "Кератиновое выпрямление",     price: 4500, duration: "60",  active: true,
    description: "Выпрямление и восстановление кератином" },
  { title: "Маникюр классический",        price: 1200, duration: "60",  active: true,
    description: "Обрезной маникюр" },
  { title: "Маникюр с покрытием гель-лак",price: 2000, duration: "60",  active: true,
    description: "Маникюр + гель-лак" },
  { title: "Педикюр классический",        price: 1500, duration: "60",  active: true,
    description: "Обрезной педикюр" },
  { title: "Педикюр с покрытием гель-лак",price: 2500, duration: "60",  active: true,
    description: "Педикюр + гель-лак" },
  { title: "Уход за лицом базовый",       price: 2000, duration: "60",  active: true,
    description: "Очищение, тонизирование, увлажнение" },
  { title: "Уход за лицом премиум",       price: 3500, duration: "60",  active: true,
    description: "Комплексный уход с массажем и маской" },
  { title: "Депиляция воском (ноги)",     price: 1800, duration: "60",  active: true,
    description: "Восковая депиляция ног полностью" },
  { title: "Депиляция воском (подмышки)", price: 700,  duration: "30",  active: true,
    description: "Восковая депиляция подмышечных впадин" },
  { title: "Оформление бровей",           price: 800,  duration: "30",  active: true,
    description: "Коррекция формы и окрашивание бровей" },
  { title: "Окрашивание бровей и ресниц", price: 1000, duration: "40",  active: true,
    description: "Окрашивание краской" },
  { title: "Мужское бритьё",              price: 700,  duration: "30",  active: true,
    description: "Классическое бритьё опасной бритвой" },
  { title: "Spa-уход для рук",            price: 1500, duration: "60",  active: false,
    description: "Парафинотерапия и массаж рук" },
  { title: "Наращивание ресниц",          price: 3000, duration: "60",  active: false,
    description: "Поресничное наращивание (временно недоступно)" },
  { title: "Стрижка бороды",              price: 500,  duration: "30",  active: false,
    description: "Моделирование бороды (временно недоступно)" },
]

Service.insert_all(
  services_data.map { |s| s.merge(created_at: now, updated_at: now) }
)
services = Service.all.index_by(&:title)
puts "  Services: #{Service.count} (active: #{Service.where(active: true).count})"

puts "=== Подзадача 1 завершена ==="
puts "  User: #{User.count}"
puts "  Materials: #{Material.count}"
puts "  Services: #{Service.count}"

# ─── ServiceMaterials ────────────────────────────────────────────────
puts "=== Seeding ServiceMaterials ==="
service_materials_map = {
  "Женская стрижка"              => [["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1], ["Бальзам для волос", 1]],
  "Мужская стрижка"             => [["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1]],
  "Детская стрижка"             => [["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1]],
  "Окрашивание в один тон"      => [["Краска для волос", 2], ["Окислитель 6%", 1], ["Перчатки одноразовые (пара)", 1], ["Кисть для окрашивания", 1], ["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1]],
  "Мелирование"                 => [["Краска для волос", 2], ["Окислитель 9%", 1], ["Фольга парикмахерская (лист)", 3], ["Перчатки одноразовые (пара)", 1], ["Кисть для окрашивания", 1], ["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1]],
  "Балаяж"                      => [["Краска для волос", 2], ["Окислитель 9%", 1], ["Фольга парикмахерская (лист)", 2], ["Перчатки одноразовые (пара)", 1], ["Кисть для окрашивания", 1], ["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1]],
  "Тонирование волос"           => [["Краска для волос", 1], ["Окислитель 6%", 1], ["Перчатки одноразовые (пара)", 1], ["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1]],
  "Укладка феном"               => [["Лак для волос", 1], ["Гель для укладки", 1]],
  "Вечерняя укладка"            => [["Лак для волос", 1], ["Гель для укладки", 1], ["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1]],
  "Ламинирование волос"         => [["Маска для волос", 1], ["Шампунь профессиональный", 1], ["Бальзам для волос", 1], ["Полотенце одноразовое", 1]],
  "Кератиновое выпрямление"     => [["Шампунь профессиональный", 1], ["Маска для волос", 1], ["Перчатки одноразовые (пара)", 1], ["Полотенце одноразовое", 1]],
  "Маникюр классический"        => [["Пилка для ногтей", 1], ["Масло для кутикулы", 1], ["Дезинфицирующий раствор", 1]],
  "Маникюр с покрытием гель-лак"=> [["Пилка для ногтей", 1], ["Масло для кутикулы", 1], ["Лак для ногтей", 1], ["Жидкость для снятия лака", 1], ["Дезинфицирующий раствор", 1]],
  "Педикюр классический"        => [["Пилка для ногтей", 1], ["Масло для кутикулы", 1], ["Дезинфицирующий раствор", 1]],
  "Педикюр с покрытием гель-лак"=> [["Пилка для ногтей", 1], ["Масло для кутикулы", 1], ["Лак для ногтей", 1], ["Жидкость для снятия лака", 1], ["Дезинфицирующий раствор", 1]],
  "Уход за лицом базовый"       => [["Крем для лица", 1], ["Полотенце одноразовое", 1], ["Дезинфицирующий раствор", 1]],
  "Уход за лицом премиум"       => [["Крем для лица", 2], ["Маска для волос", 1], ["Полотенце одноразовое", 2], ["Дезинфицирующий раствор", 1]],
  "Депиляция воском (ноги)"     => [["Воск для депиляции", 2], ["Перчатки одноразовые (пара)", 1], ["Полотенце одноразовое", 1], ["Дезинфицирующий раствор", 1]],
  "Депиляция воском (подмышки)" => [["Воск для депиляции", 1], ["Перчатки одноразовые (пара)", 1], ["Полотенце одноразовое", 1], ["Дезинфицирующий раствор", 1]],
  "Оформление бровей"           => [["Краска для волос", 1], ["Перчатки одноразовые (пара)", 1], ["Дезинфицирующий раствор", 1]],
  "Окрашивание бровей и ресниц" => [["Краска для волос", 1], ["Окислитель 6%", 1], ["Перчатки одноразовые (пара)", 1], ["Дезинфицирующий раствор", 1]],
  "Мужское бритьё"              => [["Лосьон после бритья", 1], ["Полотенце одноразовое", 1], ["Дезинфицирующий раствор", 1]],
  "Spa-уход для рук"            => [["Крем для лица", 1], ["Масло для кутикулы", 1], ["Полотенце одноразовое", 1]],
  "Наращивание ресниц"          => [["Перчатки одноразовые (пара)", 1], ["Дезинфицирующий раствор", 1]],
  "Стрижка бороды"              => [["Шампунь профессиональный", 1], ["Полотенце одноразовое", 1], ["Лосьон после бритья", 1]],
}

service_materials_rows = []
service_materials_map.each do |service_title, mat_list|
  service = services[service_title]
  next unless service
  mat_list.each do |mat_title, qty|
    material = materials[mat_title]
    next unless material
    service_materials_rows << {
      service_id:        service.id,
      material_id:       material.id,
      required_quantity: qty,
      created_at:        now,
      updated_at:        now,
    }
  end
end
ServiceMaterial.insert_all(service_materials_rows)
puts "  ServiceMaterials: #{ServiceMaterial.count}"

# ─── Masters (10 шт) ─────────────────────────────────────────────────
puts "=== Seeding Masters ==="
masters_data = [
  { first_name: "Анна",     middle_name: "Сергеевна",    last_name: "Иванова",   phone: "+79101234501", salary: 55000, active: true },
  { first_name: "Мария",    middle_name: "Александровна", last_name: "Петрова",   phone: "+79101234502", salary: 50000, active: true },
  { first_name: "Елена",    middle_name: "Дмитриевна",   last_name: "Сидорова",  phone: "+79101234503", salary: 60000, active: true },
  { first_name: "Ольга",    middle_name: "Викторовна",   last_name: "Козлова",   phone: "+79101234504", salary: 45000, active: true },
  { first_name: "Наталья",  middle_name: "Игоревна",     last_name: "Новикова",  phone: "+79101234505", salary: 65000, active: true },
  { first_name: "Дмитрий",  middle_name: "Андреевич",    last_name: "Волков",    phone: "+79101234506", salary: 50000, active: true },
  { first_name: "Алексей",  middle_name: "Павлович",     last_name: "Морозов",   phone: "+79101234507", salary: 55000, active: true },
  { first_name: "Светлана", middle_name: "Олеговна",     last_name: "Лебедева",  phone: "+79101234508", salary: 70000, active: true },
  { first_name: "Ирина",    middle_name: "Николаевна",   last_name: "Соколова",  phone: "+79101234509", salary: 40000, active: false },
  { first_name: "Татьяна",  middle_name: "Романовна",    last_name: "Кузнецова", phone: "+79101234510", salary: 35000, active: false },
]
Master.insert_all(
  masters_data.map { |m| m.merge(created_at: now, updated_at: now) }
)
puts "  Masters: #{Master.count}"

# ─── MasterSchedules ────────────────────────────────────────────────
puts "=== Seeding MasterSchedules ==="
masters = Master.all.to_a

# master index → [weekdays array, start_time, end_time]
schedule_config = {
  0 => [[1,2,3,4,5,6], "09:00", "18:00"],  # Анна
  1 => [[1,2,3,4,5,6], "09:00", "18:00"],  # Мария
  2 => [[1,2,3,4,5,6], "09:00", "18:00"],  # Елена
  3 => [[1,2,3,4,5,6], "09:00", "18:00"],  # Ольга
  4 => [[1,2,3,4,5],   "10:00", "19:00"],  # Наталья
  5 => [[1,2,3,4,5],   "10:00", "19:00"],  # Дмитрий
  6 => [[1,2,3,4,5,6], "09:00", "18:00"],  # Алексей
  7 => [[1,2,3,4,5,6], "09:00", "18:00"],  # Светлана
  8 => [[2,3,4,5,6],   "09:00", "18:00"],  # Ирина (inactive)
  9 => [[2,3,4,5,6],   "09:00", "18:00"],  # Татьяна (inactive)
}

schedule_rows = []
masters.each_with_index do |master, idx|
  cfg = schedule_config[idx]
  next unless cfg
  weekdays, start_time, end_time = cfg
  weekdays.each do |day|
    schedule_rows << {
      master_id:  master.id,
      weekday:    day,
      start_time: start_time,
      end_time:   end_time,
      created_at: now,
      updated_at: now,
    }
  end
end
MasterSchedule.insert_all(schedule_rows)
puts "  MasterSchedules: #{MasterSchedule.count}"

# ─── ServiceMasters ──────────────────────────────────────────────────
puts "=== Seeding ServiceMasters ==="

hair_services = [
  "Женская стрижка", "Мужская стрижка", "Детская стрижка",
  "Окрашивание в один тон", "Мелирование", "Балаяж", "Тонирование волос",
  "Укладка феном", "Вечерняя укладка", "Ламинирование волос",
  "Кератиновое выпрямление",
]
nail_services = [
  "Маникюр классический", "Маникюр с покрытием гель-лак",
  "Педикюр классический", "Педикюр с покрытием гель-лак",
  "Spa-уход для рук",
]
face_body_services = [
  "Мужская стрижка", "Мужское бритьё", "Стрижка бороды",
  "Уход за лицом базовый", "Уход за лицом премиум",
  "Депиляция воском (ноги)", "Депиляция воском (подмышки)",
  "Оформление бровей", "Окрашивание бровей и ресниц",
]
universal_services = [
  "Женская стрижка", "Мужская стрижка", "Детская стрижка",
  "Укладка феном", "Вечерняя укладка",
  "Маникюр классический", "Маникюр с покрытием гель-лак",
  "Уход за лицом базовый", "Оформление бровей",
  "Депиляция воском (подмышки)", "Наращивание ресниц",
]

# master index → service titles list
service_master_map = {
  0 => hair_services,                                                                      # Анна
  1 => hair_services,                                                                      # Мария
  2 => hair_services + ["Оформление бровей", "Окрашивание бровей и ресниц"],              # Елена
  3 => nail_services,                                                                      # Ольга
  4 => nail_services + ["Уход за лицом базовый", "Депиляция воском (ноги)", "Депиляция воском (подмышки)"], # Наталья
  5 => face_body_services,                                                                 # Дмитрий
  6 => face_body_services + ["Детская стрижка", "Женская стрижка"],                       # Алексей
  7 => hair_services + ["Уход за лицом базовый", "Уход за лицом премиум", "Наращивание ресниц"], # Светлана
  8 => universal_services,                                                                 # Ирина (inactive)
  9 => universal_services[0..9],                                                           # Татьяна (inactive)
}

service_master_rows = []
masters.each_with_index do |master, idx|
  service_titles = service_master_map[idx]
  next unless service_titles
  service_titles.uniq.each do |title|
    svc = services[title]
    next unless svc
    service_master_rows << {
      master_id:  master.id,
      service_id: svc.id,
      created_at: now,
      updated_at: now,
    }
  end
end
ServiceMaster.insert_all(service_master_rows)

puts "=== Подзадача 2 завершена ==="
puts "  ServiceMaterials: #{ServiceMaterial.count}"
puts "  Masters: #{Master.count} (active: #{Master.where(active: true).count})"
puts "  MasterSchedules: #{MasterSchedule.count}"
puts "  ServiceMasters: #{ServiceMaster.count}"

# ============================================================
# Подзадача 3 — Клиенты (500 записей)
# ============================================================

male_first_names = %w[
  Александр Алексей Андрей Артём Борис Василий Виктор Владимир Дмитрий Евгений
  Иван Кирилл Максим Михаил Никита Николай Павел Роман Сергей Тимур
]

female_first_names = %w[
  Анастасия Валерия Виктория Дарья Екатерина Елена Ирина Кристина Мария Наталья
  Ольга Светлана Татьяна Юлия Алина Полина Вероника Диана Софья Лидия
]

last_name_bases = %w[
  Иванов Смирнов Кузнецов Попов Васильев Петров Соколов Михайлов Новиков Фёдоров
  Морозов Волков Алексеев Лебедев Семёнов Егоров Павлов Козлов Степанов Николаев
]

rng = Random.new(42)

client_rows = 500.times.map do |i|
  is_male = rng.rand < 0.5
  first = if is_male
    male_first_names[rng.rand(male_first_names.size)]
  else
    female_first_names[rng.rand(female_first_names.size)]
  end
  base = last_name_bases[rng.rand(last_name_bases.size)]
  last = is_male ? base : "#{base}а"

  phone = "+7910#{format('%07d', rng.rand(10_000_000))}"
  telegram = if rng.rand < 0.1
    "@client_#{format('%04d', i)}"
  end
  {
    full_name:  "#{first} #{last}",
    phone:      phone,
    telegram:   telegram,
    created_at: now,
    updated_at: now,
  }
end

Client.insert_all(client_rows)

clients = Client.all.to_a
puts "=== Подзадача 3 завершена ==="
puts "  Clients: #{Client.count}"

# =============================================================================
# Subtask 4: Notes (service-driven generation with seasonal profiles)
# =============================================================================
puts "=== Подзадача 4: генерация записей ==="

# --- 4.1 Lookup structures ---

master_services = {}
ServiceMaster.all.each do |sm|
  master_services[sm.master_id] ||= []
  master_services[sm.master_id] << sm.service_id
end

# Reverse: service_id -> [master_ids who can do it]
service_masters_map = {}
ServiceMaster.all.each do |sm|
  service_masters_map[sm.service_id] ||= []
  service_masters_map[sm.service_id] << sm.master_id
end

master_scheds = {}
MasterSchedule.all.each do |ms|
  master_scheds[ms.master_id] ||= {}
  master_scheds[ms.master_id][ms.weekday] = {
    start_hour: ms.start_time.hour,
    end_hour:   ms.end_time.hour
  }
end

services_by_id = Service.all.index_by(&:id)
active_masters = masters.select(&:active?)
active_master_ids = active_masters.map(&:id).to_set

regular_clients = clients[0..299]
new_clients     = clients[300..499]

# --- 4.2 Seasonal profiles per service category ---
# 12 monthly coefficients (Jan-Dec), 1.0 = baseline
seasonal_profiles = {
  haircut:    [0.80, 0.85, 0.95, 1.00, 1.10, 1.20, 1.25, 1.20, 1.10, 1.00, 0.90, 0.75],
  coloring:   [0.70, 0.80, 1.10, 1.25, 1.20, 1.00, 0.90, 0.85, 1.10, 1.20, 1.00, 0.70],
  styling:    [0.75, 0.80, 0.90, 0.95, 1.00, 1.10, 1.15, 1.10, 1.00, 0.95, 1.05, 1.30],
  nails:      [0.85, 0.90, 1.00, 1.05, 1.10, 1.15, 1.20, 1.15, 1.05, 0.95, 0.90, 1.10],
  face_care:  [1.20, 1.15, 1.10, 1.00, 0.90, 0.80, 0.75, 0.80, 0.90, 1.00, 1.10, 1.15],
  depilation: [0.50, 0.55, 0.70, 0.90, 1.20, 1.40, 1.50, 1.40, 1.10, 0.75, 0.55, 0.45],
  brows:      [0.85, 0.90, 1.00, 1.10, 1.15, 1.10, 1.05, 1.00, 1.05, 1.10, 1.00, 0.85],
  barber:     [0.90, 0.90, 0.95, 1.00, 1.05, 1.10, 1.15, 1.10, 1.05, 1.00, 0.95, 0.85],
}

# --- 4.3 Service config: category + base bookings per month ---
service_config = {
  "Женская стрижка"              => { category: :haircut,    base: 45 },
  "Мужская стрижка"              => { category: :haircut,    base: 45 },
  "Детская стрижка"              => { category: :haircut,    base: 25 },
  "Окрашивание в один тон"       => { category: :coloring,   base: 18 },
  "Мелирование"                  => { category: :coloring,   base: 10 },
  "Балаяж"                       => { category: :coloring,   base: 7 },
  "Тонирование волос"            => { category: :coloring,   base: 15 },
  "Укладка феном"                => { category: :styling,    base: 35 },
  "Вечерняя укладка"             => { category: :styling,    base: 12 },
  "Ламинирование волос"          => { category: :coloring,   base: 8 },
  "Кератиновое выпрямление"      => { category: :coloring,   base: 5 },
  "Маникюр классический"         => { category: :nails,      base: 35 },
  "Маникюр с покрытием гель-лак" => { category: :nails,      base: 30 },
  "Педикюр классический"         => { category: :nails,      base: 25 },
  "Педикюр с покрытием гель-лак" => { category: :nails,      base: 20 },
  "Уход за лицом базовый"        => { category: :face_care,  base: 15 },
  "Уход за лицом премиум"        => { category: :face_care,  base: 8 },
  "Депиляция воском (ноги)"      => { category: :depilation, base: 12 },
  "Депиляция воском (подмышки)"  => { category: :depilation, base: 15 },
  "Оформление бровей"            => { category: :brows,      base: 25 },
  "Окрашивание бровей и ресниц"  => { category: :brows,      base: 18 },
  "Мужское бритьё"               => { category: :barber,     base: 20 },
  "Spa-уход для рук"             => { category: :nails,      base: 5 },
  "Наращивание ресниц"           => { category: :brows,      base: 5 },
  "Стрижка бороды"               => { category: :barber,     base: 5 },
}

# --- 4.4 Year-over-year growth ---
year_trend = { 2024 => 1.0, 2025 => 1.10, 2026 => 1.15 }

# --- 4.5 Generate notes ---
occupied = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = Set.new } }
note_rows = []

months_to_generate = (2024..2025).flat_map { |y| (1..12).map { |m| [y, m] } } +
                     [[2026, 1], [2026, 2], [2026, 3]]

today = Date.new(2026, 2, 28)

months_to_generate.each do |year, month|
  month_generated = 0

  services.each do |_title, service|
    cfg = service_config[service.title]
    next unless cfg

    profile = seasonal_profiles[cfg[:category]]
    season_coef = profile[month - 1]
    trend_coef = year_trend[year] || 1.0

    # Target bookings for this service in this month + noise +-10%
    target = (cfg[:base] * season_coef * trend_coef * (1.0 + rng.rand(-0.1..0.1))).round
    target = [target, 1].max

    # Masters who can do this service (active only)
    capable_masters = (service_masters_map[service.id] || []).select { |mid| active_master_ids.include?(mid) }
    next if capable_masters.empty?

    days_in_month = Date.new(year, month, -1).day
    generated = 0
    attempts = 0
    max_attempts = target * 8

    while generated < target && attempts < max_attempts
      attempts += 1

      day = rng.rand(1..days_in_month)
      date = Date.new(year, month, day)
      wday = date.wday

      master_id = capable_masters[rng.rand(capable_masters.size)]
      sched = master_scheds.dig(master_id, wday)
      next unless sched

      all_hours = (sched[:start_hour]...sched[:end_hour]).to_a
      free_hours = all_hours - occupied[master_id][date.to_s].to_a
      next if free_hours.empty?

      slot_hour = free_hours[rng.rand(free_hours.size)]
      occupied[master_id][date.to_s].add(slot_hour)

      client = if rng.rand < 0.8
        regular_clients[rng.rand(regular_clients.size)]
      else
        new_clients[rng.rand(new_clients.size)]
      end

      start_at = Time.utc(year, month, day, slot_hour, 0)
      end_at   = Time.utc(year, month, day, slot_hour + 1, 0)

      note_status = if date > today
        0 # pending
      elsif rng.rand < 0.05
        1 # canceled
      else
        2 # completed
      end

      if note_status == 1
        occupied[master_id][date.to_s].delete(slot_hour)
      end

      note_rows << {
        status:      note_status,
        total_price: service.price.to_f,
        service_id:  service.id,
        client_id:   client.id,
        master_id:   master_id,
        start_at:    start_at,
        end_at:      end_at,
        created_at:  start_at,
        updated_at:  start_at,
      }

      generated += 1
    end

    month_generated += generated
  end

  puts "  #{year}-#{format('%02d', month)}: #{month_generated} notes"
end

note_rows.each_slice(500) do |batch|
  Note.insert_all(batch)
end

puts "=== Подзадача 4 завершена ==="
puts "  Notes: #{Note.count}"

# ===========================================================
# Подзадача 5: MaterialOperations + финальные остатки
# ===========================================================

puts "=== Подзадача 5: MaterialOperations ==="

# --- 5.1 Preload service_materials into hash: service_id => [{material_id:, required_quantity:}, ...] ---
svc_materials = Hash.new { |h, k| h[k] = [] }
ServiceMaterial.all.select(:service_id, :material_id, :required_quantity).each do |sm|
  svc_materials[sm.service_id] << { material_id: sm.material_id, required_quantity: sm.required_quantity }
end

# --- 5.2 Load all completed notes from DB (skip canceled and pending) ---
all_notes = Note.where(status: 2).select(:id, :service_id, :start_at).to_a

# --- 5.3 Build "out" rows for every completed note ---
out_rows = []
all_notes.each do |note|
  svc_mats = svc_materials[note.service_id]
  next if svc_mats.empty?

  svc_mats.each do |sm|
    out_rows << {
      operation_type: 1,           # out
      status:         1,           # applied
      source:         1,           # booking
      amount:         sm[:required_quantity],
      material_id:    sm[:material_id],
      note_id:        note.id,
      created_at:     note.start_at,
      updated_at:     note.start_at,
    }
  end
end

puts "  Inserting #{out_rows.size} 'out' MaterialOperations..."
out_rows.each_slice(1000) do |batch|
  MaterialOperation.insert_all(batch)
end

# --- 5.4 Calculate total consumption per material ---
material_consumption = Hash.new(0)
out_rows.each { |row| material_consumption[row[:material_id]] += row[:amount] }

# --- 5.5 Generate periodic "in" (restock) operations ---
# Spread over Jan 2024 — Mar 2026, every ~14 days (~56 deliveries)
restock_start = Time.utc(2024, 1, 1)
restock_end   = Time.utc(2026, 3, 1)
restock_dates = []
current_date  = restock_start
while current_date <= restock_end
  restock_dates << current_date
  current_date += 14 * 24 * 3600  # 14 days in seconds
end
num_deliveries = restock_dates.size

in_amounts = Hash.new(0)
in_rows    = []

Material.all.each do |mat|
  total_consumed   = material_consumption[mat.id] || 0
  # Buffer: 2% surplus — minimal stock remains for realistic forecast demo
  total_restock    = (total_consumed * 1.02).ceil
  # Ensure at least 1 unit per delivery even if consumption is 0
  per_delivery     = [(total_restock.to_f / num_deliveries).ceil, 1].max

  restock_dates.each do |delivery_date|
    in_rows << {
      operation_type: 0,           # in
      status:         1,           # applied
      source:         0,           # manual
      amount:         per_delivery,
      material_id:    mat.id,
      note_id:        nil,
      created_at:     delivery_date,
      updated_at:     delivery_date,
    }
    in_amounts[mat.id] += per_delivery
  end
end

puts "  Inserting #{in_rows.size} 'in' MaterialOperations..."
in_rows.each_slice(1000) do |batch|
  MaterialOperation.insert_all(batch)
end

# --- 5.6 Update final material quantities ---
puts "  Updating material quantities..."
Material.all.each do |mat|
  total_in  = in_amounts[mat.id]  || 0
  total_out = material_consumption[mat.id] || 0
  mat.update_column(:quantity, total_in - total_out)
end

puts "=== Подзадача 5 завершена ==="
puts "  MaterialOperations: #{MaterialOperation.count}"
puts "  Пример остатков материалов:"
Material.all.each { |m| puts "    #{m.title}: #{m.quantity} шт" }
