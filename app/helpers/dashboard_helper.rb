module DashboardHelper
  ReportType = Struct.new(:report_type, :name)

  RepWT_Tracking = 1
  RepWT_Cumul = 2

  ReportTypes = []
  ReportTypes << ReportType.new(RepWT_Tracking,"Work types tracking")
  ReportTypes << ReportType.new(RepWT_Cumul,"Work types cumulative")

  def report_type_list
    rt = []
    rt << ReportType.new(RepWT_Tracking,"Work types tracking")
    rt << ReportType.new(RepWT_Cumul,"Work types cumulative")    
    return rt
  end

end
