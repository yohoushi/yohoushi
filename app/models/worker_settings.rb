class WorkerSettings < Settingslogic
  source "#{Rails.root}/config/worker.yml"
  namespace Rails.env
end
