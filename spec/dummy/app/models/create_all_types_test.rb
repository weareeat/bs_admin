class CreateAllTypesTest < ActiveRecord::Base
  bs_admin do |c|
    c.fields do |f|    
      f.custom       :custom_param,       required: true
      f.checkbox     :checkbox_param,     required: true
      f.email        :email_param,        required: true
      f.password     :password_param,     required: true
      f.string       :string_param,       required: true
      f.currency     :currency_param,     required: true
      f.permalink    :permalink_param,    required: true
      f.text         :text_param,         required: true
      f.date         :date_param,         required: true
      f.image        :image_param,        required: true
      f.radiogroup   :radiogroup_param,   required: true
      f.time         :time_param,         required: true
      f.datetime     :datetime_param,     required: true
      f.number       :number_param,       required: true
      f.select       :select_param,       required: true
      f.wysi         :wysi_param,         required: true
      f.file         :file_param,         required: true
      f.money        :money_param,        required: true
      f.integer      :integer_param,      required: true
      f.color_picker :color_picker_param, required: true
      f.tags         :tags_param,         required: true
      f.view         :view_param,         required: true
    end
  end
end
