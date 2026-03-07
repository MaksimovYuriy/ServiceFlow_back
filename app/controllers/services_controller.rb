class ServicesController < ApplicationController
  skip_before_action :authenticate!, only: [:index]

  def index
    services = ServiceResource.all(params)
    respond_with(services)
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
end
