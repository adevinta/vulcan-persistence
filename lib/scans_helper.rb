class ScansHelper
  def self.push_created_metric(scan)
    scan_label = "unknown-program"
    team_label = "unknown-team"
    if scan[:program].blank?
      Rails.logger.warn "error obtaining program name for scan [#{scan.id}] for pushing metrics"
    else
      scan_label = scan[:program].downcase
    end
    if scan[:tag].blank?
      Rails.logger.warn "error obtaining team name for scan [#{scan.id}] for pushing metrics"
    else
      team_label = scan[:tag].split(':').last.downcase
    end

    metric_tags = ["scan:#{team_label}-#{scan_label}"]
    Metrics.count("scan.count", 1, metric_tags)
  end

  def self.is_aborted(scan_id)
    if scan_id
      scan = Scan.find(scan_id)
      unless scan.nil?
        return scan.aborted
      end
    end
    return false
  end
end
