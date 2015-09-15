class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

  def proxy
    has_key?('proxy') ? fetch('proxy') : true # default: true
  end

  def auto_tagging
    has_key?('auto_tagging') ? fetch('auto_tagging') : true # default: true
  end

  def sumup
    has_key?('sumup') ? fetch('sumup') : false # default: false
  end
end
