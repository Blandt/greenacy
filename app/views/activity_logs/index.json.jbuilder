json.array!(@activity_logs) do |activity_log|
  json.extract! activity_log, :id, :user_id, :browser, :ip_address, :controller, :action, :params, :note, :is_read
  json.url activity_log_url(activity_log, format: :json)
end
