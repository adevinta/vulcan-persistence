module Api::V1
  class ScansController < ApplicationController
    before_action :set_scan, only: [:show, :destroy, :checks, :stats, :abort]

    # GET /scans
    def index
      if params[:force].to_s.downcase != "true"
        render :json => { :error => "List method is not allowed without force param"}, status: :method_not_allowed
        return
      end
      @scans = Scan.where(deleted_at: nil)

      render json: @scans
    end

    # GET /scans/1
    def show
      render json: @scan
    end

    # GET /scans/1/checks
    def checks
      @checks = Check.includes(:checktype).where(deleted_at: nil, scan_id: @scan.id).
        filter(params.slice(:status, :target, :checktype_id, :agent_id))

      render json: @checks, :each_serializer => SimpleCheckSerializer
    end

    # GET /scans/1/stats
    def stats
      @stats = Check.select('status, count(*) as total').
        where(deleted_at: nil, scan_id: @scan.id).
        group(:scan_id, :status)

      render json: @stats, :each_serializer => ScanStatsSerializer
    end

    # POST /scans
    def create
      @scan = Scan.new

      if @scan.save
        render json: @scan, status: :created, location: [:v1, @scan]
        push_scan_metrics if Rails.application.config.metrics
      else
        render json: @scan.errors, status: :unprocessable_entity
        return
      end

      if params[:scan].present? && params[:scan][:checks].present?
        ChecksCreateEnqueueJob.perform_later(@scan.id, @scan.created_at.to_s, request.raw_post)
      end
    end

    # DELETE /scans/1
    def destroy
      @scan.deleted_at = DateTime.now
      if @scan.save
        render json: @scan
      else
        render json: @scan.errors, status: :unprocessable_entity
      end
    end

    # POST /scans/1/abort
    def abort
      if @scan.aborted
        # Scan has been already marked as aborted
        render status: :conflict
        return
      end
      @scan.aborted = true
      @scan.aborted_at = DateTime.now
      if @scan.save
        render status: :accepted
        notify('abort')
      else
        render json: @scan.errors, status: :unprocessable_entity
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_scan
      @scan = Scan.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def scan_params
      # NOTE: the :check definition should be in sync with its definition in the ChecksController.
      params.permit(:scan => [ :checks => [ :check => [ :checktype_id, :checktype_name, :target, :options, :webhook, :jobqueue_id, :jobqueue_name, :tag, :required_vars => [] ] ] ])
    end

    # Notifies action to stream
    def notify(action)
      NotificationsHelper.notify(action: action, scan_id: @scan.id)
    end

    def push_scan_metrics
      scan_label = ""
      team_label = ""
      begin
        # obtain info from scan (program name)
        scan_label = @scan[:program_name].downcase || "unknown-program"
      rescue
        Rails.logger.warn "error obtaining program name for scan [#{@scan.id}] for pushing metrics"
        scan_label = "unknown-program"
      end
      begin
        team_label = @scan[:tag].split(':').last.downcase || "unknown-team"
      rescue
        Rails.logger.warn "error obtaining team name for scan [#{@scan.id}] for pushing metrics"
        team_label = "unknown-team"
      end

      # metric_tags = ["scan:#{team_label}-#{scan_label}"]
      metric_tags = ["scan:purple-periodic-full-scan"]
      Metrics.count("scan.count", 1, metric_tags)
    end
  end
end
