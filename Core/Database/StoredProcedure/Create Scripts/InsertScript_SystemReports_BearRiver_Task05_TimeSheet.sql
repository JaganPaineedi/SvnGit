SET IDENTITY_INSERT SystemReports ON

IF NOT EXISTS (SELECT 1 FROM SystemReports WHERE SystemReportId=511)
INSERT INTO SystemReports (SystemReportId,ReportName,ReportURL,Active,AllowAllStaff)
VALUES
(511
,'TimeSheetList'
,'http://10.0.253.11/ReportServer/Pages/ReportViewer.aspx?/ValleySmartCareDEV40/TimeSheetRDL&rs:Command=Render&rc:Parameters=false&StartDate=<StartDate>&EndDate=<EndDate>&LeaveType=<LeaveType>&SecondaryActivity=<SecondaryActivity>&PageNumber=<PageNumber>&PageSize=<PageSize>&SortExpression=<SortExpression>&LoggedInStaffId=<LoggedInStaffId>&StaffId=<StaffId>'
,'Y'
,'Y'
)

SET IDENTITY_INSERT SystemReports OFF



