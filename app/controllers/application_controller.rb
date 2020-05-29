class ApplicationController < ActionController::API
  include ActionController::Serialization
  before_action :check_content_type
  before_action :push_request_metrics,  if: -> { Rails.application.config.metrics }
  after_action  :push_response_metrics, if: -> { Rails.application.config.metrics }
  around_action :push_duration_metrics, if: -> { Rails.application.config.metrics }

  private

  def check_content_type
    if request.content_length > 0 && request.content_type != "application/json" && request.content_type != "multipart/form-data"
      Rails.logger.error "content-type error in request #{request.inspect}"
      render :json =>
      { :error => "Unsupported Media Type"},
        status: :unsupported_media_type
    end
  end

  def push_request_metrics
    metic_name = "request.#{metric_category}.total"
    Metrics.increment(metic_name, metric_tags)
  end

  def push_response_metrics
    if is_failed
      metic_name = "request.#{metric_category}.failed"
      Metrics.increment(metic_name, metric_tags)
    end
    # Metrics per status code
    metic_name = "request.#{metric_category}.#{status.to_s}"
    Metrics.increment(metic_name, metric_tags)
  end

  def push_duration_metrics
    unless is_failed
      start = Time.now
      yield
      duration = Time.now - start
      metic_name = "request.#{metric_category}.duration"
      Metrics.histogram(metic_name, duration, metric_tags)
    end
  end

  def metric_tags
    tags = []
    begin
      tags = ["entity:#{controller_name}", "action:#{action_name}"]
    rescue
      tags = ["entity:unknown", "action:unknown"]
    end
    return tags
  end

  def metric_category
    begin
      case request.method
      when 'GET'
        return 'read'
      when 'POST'
        return 'create'
      when 'PUT', 'PATCH'
        return 'update'
      when 'DELETE'
        return 'delete'
      end
      return 'other'
    rescue
      return 'unknown'
    end
  end

  def is_failed
    begin
      if status < 400
        return false
      end
      return true
    rescue
      return true
    end
  end
end
