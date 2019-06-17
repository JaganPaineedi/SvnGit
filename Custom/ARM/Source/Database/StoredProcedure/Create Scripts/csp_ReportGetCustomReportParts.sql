  
CREATE Procedure [dbo].[csp_ReportGetCustomReportParts]  
 @StoredProcedure varchar(300)  
  
AS  
  
  
 Select ReportName, Title, SubTitle, Comment, ReportURL  
 From CustomReportParts  
 Where StoredProcedure = @StoredProcedure