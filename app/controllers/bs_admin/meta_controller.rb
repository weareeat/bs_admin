class BsAdmin::MetaController < BsAdminLoggedControllerBase
  before_filter :bsadmin_initialize

  def index
    @collection = @meta.class
    @filter_options = {}

    if @meta.filters.any?
      @meta.filters.each do |f|
        @filter_options[f.field], @collection = send("apply_#{f.type}_filter", @collection, f)
      end
    else
      @collection = @meta.class.scoped
    end

    @collection = @collection.order(@meta.sort)
    @collection = @collection.page(params[:page]) if @meta.page_size
  end

  def apply_select_filter collection, filter
    filter_param = params[filter.field]
    options = { current: filter_param }
    if filter_param and filter_param != 'all'
      collection = collection.where(filter.field => filter_param)
    end
    collection = collection.page(params[:page]) if @meta.page_size
    [options, collection]
  end

  def apply_string_filter collection, filter
    filter_param = params[filter.field]
    options = { current: filter_param }
    if filter_param and filter_param != ''
      collection = collection.where("#{filter.field} LIKE ?", "%#{filter_param}%")
    end
    collection = collection.page(params[:page]) if @meta.page_size
    [options, collection]
  end

  def apply_monthly_filter collection, filter
    if params[filter.field] and params[filter.field][:year] and params[filter.field][:month]
      year, month = params[filter.field][:year].to_i, params[filter.field][:month].to_i
    else
      year, month = Time.zone.today.year, Time.zone.today.month
    end

    options = { current: Time.zone.local(year, month, 1).at_beginning_of_month }

    range = options[:current]..options[:current].at_end_of_month
    collection = collection.where(filter.field => range)
    collection = collection.page(params[:page]) if @meta.page_size

    [options, collection]
  end

  def new
    @model = @meta.class.new
    @url = bs_admin.meta_create_url(@meta.base_path)
  end

  def edit
    @model = @meta.class.find(params[:id])
    @url = bs_admin.meta_update_url(@meta.base_path, params[:id])
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
          @meta.class.new(base_params).save!
          save_count += 1
        end

        redirect_to index_url, notice: "#{save_count} #{@meta.humanized_name.pluralize} was successfully created."
      else
        @model = @meta.class.new(params[@meta.symbol])

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
      @model = @meta.class.find(params[:id])

      if @model.update_attributes(params[@meta.symbol])
        redirect_to bs_admin.meta_index_url(@meta.base_path), notice: "#{@meta.humanized_name} was successfully updated."
      else
        render action: "edit"
      end
    end
  end

  def destroy
    if @meta.can :delete
      @model = @meta.class.find(params[:id])
      @model.destroy

      redirect_to bs_admin.meta_index_url(@meta.base_path)
    end
  end

  def sort
    @meta.class.all.each do |m|
      m.sort = params[@meta.symbol].index(m.id.to_s) + 1
      m.save
    end

    render :nothing => true
  end

  def bulk_destroy
    params[:assets].each{ |p| @meta.class.find(p).destroy }
    render :nothing => true
  end

  def export
    @meta.page_size = false
    index()
    render :layout => false
  end

  private

  def bsadmin_initialize
    @meta = BsAdmin.find params[:base_path]
  end

  def index_url
    bs_admin.meta_index_url(@meta.base_path)
  end
end
