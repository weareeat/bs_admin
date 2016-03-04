class BsAdmin::BsAdminApi::SettingsController < BsAdminLoggedControllerBase

  def groups
    render json: BsAdmin::SettingGroup.all
  end

  def subgroups
    render json: BsAdmin::Settings.group(params[:group_key]).subgroups
  end

  def index
    render json: BsAdmin::Settings.subgroup(params[:group_key], params[:subgroup_key]).settings
  end

  def show
    render json: get_setting
  end

  def update
    match = get_setting
    match.update_attributes params[:setting]
    render json: match
  end

  private

  def get_setting
    BsAdmin::Settings.subgroup(params[:group_key], params[:subgroup_key]).find_setting_by_key params[:setting_key]  
  end
end