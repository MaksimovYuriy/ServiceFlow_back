class ServicesController < ApplicationController
  skip_before_action :authenticate!, only: [:index]

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

  def update
    service = ServiceResource.find(params)

    if service.update_attributes
      render jsonapi: service
    else
      render jsonapi_errors: service
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end
end
