class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

  def proxy
    has_key?('proxy') ? fetch('proxy') : true # default: true
  end
end
