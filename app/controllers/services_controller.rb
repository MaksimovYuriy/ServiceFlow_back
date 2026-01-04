class ServicesController < ApplicationController
  def index
    services = ServiceResource.all(params)
    respond_with(services)
  end

  def show
    service = ServiceResource.find(params)
    respond_with(service)
  end

  def create
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

  def destroy
    service = ServiceResource.find(params)

    if service.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: service
    end
  end
end
