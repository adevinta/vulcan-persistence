require 'uuid'
class ScansHelper
  def self.get_program_team(scan)
    scan_label = "unknown-program"
    team_label = "unknown-team"
    if scan.nil?
      Rails.logger.warn "error obtaining program_team for nil scan"
      return "#{team_label}-#{scan_label}"
    end
    if scan[:program].blank?
      Rails.logger.warn "error obtaining program name for scan [#{scan.id}]"
    else
      scan_label = scan[:program].downcase
    end
    if scan[:tag].blank?
      Rails.logger.warn "error obtaining team name for scan [#{scan.id}]"
    else
      team_label = scan[:tag].split(':').last.downcase
    end
    return "#{team_label}-#{scan_label}"
  end

  def self.get_program_team_by_scan_id(scan_id)
    if scan_id
      scan = Scan.find(scan_id)
      return self.get_program_team(scan)
    end
    return self.get_program_team(nil)
  end

  def self.push_metric(scan,scanstatus="running")
    unless Rails.application.config.metrics
      return
    end
    program_team = self.get_program_team(scan)

    metric_tags = ["scan:#{program_team}","scanstatus:#{scanstatus}"]
    Metrics.count("scan.count", 1, metric_tags)
  end

  def self.normalize_program(program_id)
    if program_id.blank?
      return "unknown-program"
    end
    if UUID.validate(program_id)
      return "custom-program"
    end
    if program_id.include? "@"
      return program_id.split("@").last.downcase
    end
    return program_id.downcase
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
