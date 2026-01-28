class MastersController < ApplicationController
  def index
    masters = MasterResource.all(params)
    respond_with(masters)
  end

  def show
    master = MasterResource.find(params)
    respond_with(master)
  end

  def create
    master = MasterResource.build(params)

    if master.save
      render jsonapi: master, status: 201
    else
      render jsonapi_errors: master
    end
  end

  def update
    master = MasterResource.find(params)

    if master.update_attributes
      render jsonapi: master
    else
      render jsonapi_errors: master
    end
  end

  def destroy
    master = MasterResource.find(params)

    if master.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: master
    end
  end
end
