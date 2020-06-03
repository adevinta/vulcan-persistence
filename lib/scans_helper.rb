class ScansHelper
  def self.push_created_metric(scan)
    scan_label = ""
    team_label = ""
    begin
      # obtain info from scan (program name)
      scan_label = scan[:program_name].downcase || "unknown-program"
    rescue
      Rails.logger.warn "error obtaining program name for scan [#{scan.id}] for pushing metrics"
      scan_label = "unknown-program"
    end
    begin
      team_label = scan[:tag].split(':').last.downcase || "unknown-team"
    rescue
      Rails.logger.warn "error obtaining team name for scan [#{scan.id}] for pushing metrics"
      team_label = "unknown-team"
    end

    # metric_tags = ["scan:#{team_label}-#{scan_label}"]
    metric_tags = ["scan:purple-periodic-full-scan"]
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
