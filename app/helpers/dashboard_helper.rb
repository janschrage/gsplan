module DashboardHelper

  ReportType = Struct.new(:report_type, :name)

  RepWT_Tracking = 1
  RepWT_Cumul = 2
  RepPRJ_Time_since_update = 3
  RepPRJ_Project_times = 4
  RepPRJ_Parked = 5
  RepPRJ_Cycle_times = 6
  RepWT_AdHoc_Perc = 7

  ReportTypes = []
  ReportTypes << ReportType.new(RepWT_Tracking,"Work types tracking")
  ReportTypes << ReportType.new(RepWT_Cumul,"Work types cumulative")
  ReportTypes << ReportType.new(RepPRJ_Time_since_update,"Projects - time since update")
  ReportTypes << ReportType.new(RepPRJ_Project_times,"Project times")
  ReportTypes << ReportType.new(RepPRJ_Parked,"Parked projects")
  ReportTypes << ReportType.new(RepPRJ_Cycle_times,"Process cycle times")
  ReportTypes << ReportType.new(RepWT_AdHoc_Perc,"Ad hoc work")


  def report_type_list
    return ReportTypes
  end

end
