class ServiceMastersController < ApplicationController

  def index
    sm = ServiceMasterResource.all(params)
    respond_with(sm)
  end

  def create
    sm = ServiceMasterResource.build(params)
    
    if sm.save
      render jsonapi: sm, status: 201
    else
      render jsonapi_errors: sm
    end
  end

  def destroy
    sm = ServiceMasterResource.find(params)

    if sm.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: sm
    end
  end
end
