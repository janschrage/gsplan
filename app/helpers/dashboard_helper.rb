module DashboardHelper
  ReportType = Struct.new(:report_type, :name)

  RepWT_Tracking = 1
  RepWT_Cumul = 2
  RepPRJ_Time_since_update = 3

  ReportTypes = []
  ReportTypes << ReportType.new(RepWT_Tracking,"Work types tracking")
  ReportTypes << ReportType.new(RepWT_Cumul,"Work types cumulative")
  ReportTypes << ReportType.new(RepPRJ_Time_since_update,"Projects - time since update")

  def report_type_list
    return ReportTypes
  end

end
