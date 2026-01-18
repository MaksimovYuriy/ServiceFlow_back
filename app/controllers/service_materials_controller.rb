class ServiceMaterialsController < ApplicationController

  def index
    sm = ServiceMaterialResource.all(params)
    respond_with(sm)
  end

  def create
    sm = ServiceMaterialResource.build(params)
    
    if sm.save
      render jsonapi: sm, status: 201
    else
      render jsonapi_errors: sm
    end
  end

  def update
    sm = ServiceMaterialResource.find(params)
    
    if sm.update_attributes
      render jsonapi: sm
    else
      render jsonapi_errors: sm
    end
  end

  def destroy
    sm = ServiceMaterialResource.find(params)

    if sm.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: sm
    end
  end
end
