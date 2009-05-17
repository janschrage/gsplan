module DashboardHelper

  include Statistics

  ReportType = Struct.new(:report_type, :name)

  RepWT_Tracking = 1
  RepWT_Cumul = 2
  RepPRJ_Time_since_update = 3
  RepPRJ_Project_times = 4
  RepPRJ_Parked = 5
  RepPRJ_Cycle_times = 6

  ReportTypes = []
  ReportTypes << ReportType.new(RepWT_Tracking,"Work types tracking")
  ReportTypes << ReportType.new(RepWT_Cumul,"Work types cumulative")
  ReportTypes << ReportType.new(RepPRJ_Time_since_update,"Projects - time since update")
  ReportTypes << ReportType.new(RepPRJ_Project_times,"Project times")
  ReportTypes << ReportType.new(RepPRJ_Parked,"Parked projects")
  ReportTypes << ReportType.new(RepPRJ_Cycle_times,"Process cycle times")


  def report_type_list
    return ReportTypes
  end

## Here come the reports
  def worktype_distribution_tracking(begda,endda)
    report = Report::Worktype.new
    return report.tracking(begda,endda)
  end

  def worktype_distribution_cumul(begda,endda)
    report = Report::Worktype.new
    report.cumul(begda,endda)
  end

  def project_age_current
    report = Report::Projects.new
    return report.project_age_current
  end

  def project_times(begda,endda)
    report = Report::Projects.new
    return report.project_times(begda,endda)
  end

  def parking_lot(team)
    report = Report::Projects.new
    return report.parking_lot(team)
  end

  def project_plt(begda,endda)
    report = Report::Process.new
    return report.project_plt(begda,endda)
  end

  def project_wip
    report = Report::Process.new
    return report.project_wip
  end

  def project_pct(begda, endda)
    report = Report::Process.new
    return report.pct(begda, endda)
  end
end
