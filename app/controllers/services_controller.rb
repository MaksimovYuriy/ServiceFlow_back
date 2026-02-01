class ServicesController < ApplicationController
  skip_before_action :authenticate!, only: [:index, :available_slots]

  def index
    services = ServiceResource.all(params)
    respond_with(services)
  end

  def create
    # Поиск клиента в базе по введённым данным
    # Если нет - создаем, если есть - возвращаем найденного
    # Создаем объект записи - статус pending
    service = ServiceResource.build(params)

    if service.save
      render jsonapi: service, status: 201
    else
      render jsonapi_errors: service
    end
  end

  def cancel
    # Запись отменена
  end

  def complete
    # Услуга оказана
  end

  def available_slots
    # доступные слоты для записи
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end
end
