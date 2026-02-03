class ClientsController < ApplicationController
  def index
    clients = ClientResource.all(params)
    respond_with(clients)
  end

  def show
    client = ClientResource.find(params)
    respond_with(client)
  end

  def create
    client = ClientResource.build(params)

    if client.save
      render jsonapi: client, status: 201
    else
      render jsonapi_errors: client
    end
  end

  def update
    client = ClientResource.find(params)

    if client.update_attributes
      render jsonapi: client
    else
      render jsonapi_errors: client
    end
  end

  def destroy
    client = ClientResource.find(params)

    if client.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: client
    end
  end
end
