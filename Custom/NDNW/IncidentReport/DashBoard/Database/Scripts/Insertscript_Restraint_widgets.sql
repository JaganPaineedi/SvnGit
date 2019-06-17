/********************************************************************************                                                  
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Adding Widget Data to the Widget Table.
--
-- Author:  Anto
-- Date:    05-May-2015
--
-- *****History****
-- 
*********************************************************************************/


IF NOT EXISTS (SELECT * FROM Widgets WHERE WidgetName = 'Incident Reports') 
BEGIN 
INSERT INTO [dbo].[Widgets]([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [WidgetName], [WidgetURL], [CustomWidget], [Width], [Height], [MinimumWidth], [MinimumHeight], [MaximumWidth], [MaximumHeight], [RefreshInterval], [RefreshOnActivate], [AutoRefreshInterval])
SELECT  N'shs', getdate(), N'shs', getdate(), NULL, NULL, NULL, N'Incident Reports', N'/Custom/IncidentReport/DashBoard/WebPages/IncidentReport.ascx', N'N', 2, 1, NULL, NULL, NULL, NULL, 400, NULL, 77777 
END
ELSE
BEGIN
UPDATE Widgets
	SET CreatedBy = N'shs'
		,CreatedDate = getdate()
		,ModifiedBy = N'shs'
		,ModifiedDate = getdate()
		,RecordDeleted = NULL
		,DeletedDate = NULL
		,DeletedBy = NULL
		,WidgetName = N'Incident Reports'
		,WidgetURL =  N'/Custom/IncidentReport/DashBoard/WebPages/IncidentReport.ascx'
		,CustomWidget =  N'N'
		,Width = 2
		,Height= 1
		,MinimumWidth =NULL
		,MinimumHeight = NULL
		,MaximumWidth = NULL
		,MaximumHeight = NULL
		,RefreshInterval = 400
		,RefreshOnActivate = NULL
		,AutoRefreshInterval = 77777
	WHERE WidgetName = 'Incident Reports'		
END
GO


