class BsAdmin::MetaNestedController < BsAdminLoggedControllerBase
  before_filter :bsadmin_initialize

  def index
    if @custom_page.nil?
      @collection = @relationship_collection.order(@meta.sort)
      @collection = @collection.page(params[:page]) if @meta.page_size
      render "image_upload" if @relationship.view_type == :images
    else
      @meta = @base_meta
      @instance = @base_instance

      render template: "bs_admin/#{@meta.base_path}/#{@custom_page.template}", layout: @custom_page.layout
    end
  end

  def new
    @model = @relationship_collection.new
    @url = bs_admin.meta_nested_create_url(@base_meta.base_path, @base_instance.id, @relationship.nested_path)
  end

  def edit
    @model = @relationship_collection.find(params[:nested_id])
    @url = bs_admin.meta_nested_update_url(@base_meta.base_path, @base_instance.id, @relationship.nested_path, params[:nested_id])
  end

  def view
    edit
  end

  def create
    if @meta.can :create
      multiple_upload_field = @meta.multiple_upload_field
      if multiple_upload_field and params[@meta.symbol][multiple_upload_field.name].is_a?(Array)
        file_array = params[@meta.symbol][multiple_upload_field.name].dup
        base_params = params[@meta.symbol].dup
        save_count = 0
        file_array.each do |i|
          base_params[multiple_upload_field.name] = i
          @relationship_collection.new(base_params).save!
          save_count += 1
        end

        redirect_to index_url, notice: "#{save_count} #{@meta.humanized_name.pluralize} was successfully created."
      else
        @model = @relationship_collection.new(params[@meta.symbol])

        if @model.save
          redirect_to index_url, notice: "#{@meta.humanized_name} was successfully created."
        else
          render action: "new"
        end
      end
    end
  end

  def update
    if @meta.can :edit
      @model = @relationship_collection.find(params[:nested_id])

      if @model.update_attributes(params[@meta.symbol])
        redirect_to index_url, notice: "#{@meta.humanized_name} was successfully updated."
      else
        render action: "edit"
      end
    end
  end

  def destroy
    if @meta.can :delete
      @model = @relationship_collection.find(params[:nested_id])
      @model.destroy

      redirect_to index_url
    end
  end

  def sort
    @relationship_collection.all.each do |m|
      m.sort = params[@meta.symbol].index(m.id.to_s) + 1
      m.save
    end

    render :nothing => true
  end

  def bulk_destroy
    params[:assets].each{ |p| @relationship_collection.find(p).destroy }
    render :nothing => true
  end

  private

  def bsadmin_initialize
    @base_meta = BsAdmin.find params[:base_path]
    @base_instance = @base_meta.class.find params[:base_id]

    @custom_page = @base_meta.find_custom_page params[:nested_path]

    if @custom_page.nil?
      @relationship = @base_meta.find_relationship params[:nested_path]
      @meta = @relationship.meta
      @relationship_collection = @base_instance.send(@relationship.field)
    end
  end

  def index_url
    bs_admin.meta_nested_index_url(@base_meta.base_path, @base_instance.id)
  end
end
