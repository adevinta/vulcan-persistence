# Copyright 2021 Adevinta

class Check < ApplicationRecord
  @@allowed_trasitions = {
    :CREATED => [:QUEUED, :ASSIGNED, :MALFORMED, :RUNNING, :FAILED, :FINISHED, :ABORTED,:PURGING, :KILLED, :TIMEOUT, :INCONCLUSIVE],
    :QUEUED => [:ASSIGNED, :MALFORMED, :RUNNING, :FAILED, :FINISHED, :ABORTED,:PURGING, :KILLED, :TIMEOUT, :INCONCLUSIVE],
    :ASSIGNED => [:MALFORMED, :RUNNING, :FAILED, :FINISHED, :ABORTED,:PURGING, :KILLED, :TIMEOUT, :INCONCLUSIVE],
    :RUNNING => [:MALFORMED, :FAILED, :FINISHED, :ABORTED,:PURGING, :KILLED, :INCONCLUSIVE],
    :PURGING => [:MALFORMED, :FAILED, :FINISHED, :ABORTED,:KILLED, :INCONCLUSIVE]
  }
  @@terminal_statuses= [:MALFORMED, :ABORTED, :KILLED, :FAILED, :FINISHED, :TIMEOUT, :INCONCLUSIVE]
  # checktype_name and metadata are virtual attributes, not persisted in the model.
  attr_accessor :checktype_name
  attr_accessor :metadata

  include Filterable

  after_commit :sns_publish
  before_update :verify_transition
  # In case the transaction is rolled back, we might had push an incorrect metric.
  # Proper hook to push the metric would be after_commit, but then is harder to
  # detect if status has changed. This is the best compromise in effort and consistency.
  after_save :push_check_metrics, if: -> { Rails.application.config.metrics && (status_changed? || new_record?) }

  belongs_to :agent
  belongs_to :checktype
  belongs_to :scan, optional: true
  validates :checktype_id, :presence => true
  validates :target, :presence => true

  scope :status, -> (status) { where status: status }
  scope :target, -> (target) { where target: target }
  scope :checktype_id, -> (checktype_id) { where checktype_id: checktype_id }
  scope :agent_id, -> (agent_id) { where agent_id: agent_id }
  def sns_publish()
    SNSPublishJob.perform_later(self)
  end

  def abort!
    self[:status] = "ABORTED"
    allowed = verify_transition
    return false unless allowed

    save
  end

  def purge!
    self[:status] = "PURGING"
    allowed = verify_transition
    return false unless allowed

    save
  end

  private
  def push_check_metrics
    scan_label = "unknown-program"
    team_label = "unknown-team"
    checktype_label = "unknown-checktype"
    check_status = "unknown-checkstatus"
    scan = Scan.find_by(id: self[:scan_id])
    if scan.nil? || scan.program.blank?
      Rails.logger.warn "error obtaining program name for check [#{self.id}] for pushing metrics"
    else
      scan_label = scan.program.downcase
    end
    if self[:tag].blank?
      Rails.logger.warn "error obtaining team name for check [#{self.id}] for pushing metrics"
      # try to obtain tag from scan
      if scan.nil? || scan.tag.blank?
        Rails.logger.warn "error obtaining team name name for check [#{self.id}] for pushing metrics from scan"
      else
        team_label = scan.tag.split(':').last.downcase
      end
    else
      team_label = self[:tag].split(':').last.downcase
    end
    begin
      checktype_label = self.checktype.name.downcase
    rescue
      Rails.logger.warn "error obtaining checktype name for check [#{self.id}] for pushing metrics"
    end
    begin
      check_status = self.status.downcase
    rescue
      Rails.logger.warn "error obtaining status name for check [#{self.id}] for pushing metrics"
    end

    metric_tags = ["scan:#{team_label}-#{scan_label}", "checktype:#{checktype_label}", "checkstatus:#{check_status}"]
    Metrics.count("scan.check.count", 1, metric_tags)
  end

  def verify_transition
    return true unless status
    db_check = Check.find(id)
    # We do not allow status changes if the check is already finished.
    return false if @@terminal_statuses.include?(db_check[:status].intern)
    # Check if the status change is allowed.
    # It will be only if the new estatus is "greater" than the current one.
    return true if db_check[:status] == self[:status]
    return true if @@terminal_statuses.include?(self[:status].intern)

    allowed = @@allowed_trasitions[db_check[:status].intern]

    return false unless allowed
    return false unless allowed.include?(self[:status].intern)

    return true
  end
end
