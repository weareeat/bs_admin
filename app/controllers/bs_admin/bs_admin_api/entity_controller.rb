# -*- encoding : utf-8 -*-
class BsAdmin::AssetsController < BsAdminLoggedControllerBase


  # params[:entity]
  # params[:entity_id]
  # params[:nested_entity]

  def index
    @meta = BsAdmin.find params[:entity]
    # @base_instance = @base_meta.class.find params[:base_id]
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end
end
