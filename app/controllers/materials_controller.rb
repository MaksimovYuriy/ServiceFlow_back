class MaterialsController < ApplicationController
  def index
    materials = MaterialResource.all(params)
    respond_with(materials)
  end

  def show
    material = MaterialResource.find(params)
    respond_with(material)
  end

  def create
    material = MaterialResource.build(params)

    if material.save
      render jsonapi: material, status: 201
    else
      render jsonapi_errors: material
    end
  end

  def update
    material = MaterialResource.find(params)

    if material.update_attributes
      render jsonapi: material
    else
      render jsonapi_errors: material
    end
  end

  def destroy
    material = MaterialResource.find(params)

    if material.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: material
    end
  end
end
