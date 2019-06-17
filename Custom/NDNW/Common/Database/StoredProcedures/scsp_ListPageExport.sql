IF OBJECT_ID('scsp_ListPageExport') IS NOT NULL
	DROP PROCEDURE dbo.scsp_ListPageExport
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[scsp_ListPageExport]                      
(                                                                                                                           
	@ScreenId INT,                                                                        
	@SessionId VARCHAR(50),                                                                        
	@InstanceId INT                                           
)                                                                                 
AS 
/********************************************************************************                                                      
** Stored Procedure: scsp_ListPageExport                                                        
**                                                      
** Copyright: Streamline Healthcate Solutions                                                      
**                                                      
** Purpose: Export the data  
**                 
** Author: Sudhir Singh 
**        
**Called By:called when export click
**         
**Created Date:19 march 2012                                                     
** Updates:                                                                                                             
** Date        Author      Purpose            
** 2015-7-9	   dknewtson   Removed select from CustomListPageInquiries table Containing invalid Column References                                                        
*********************************************************************************/                                                                               
BEGIN 
	--if(@ScreenId  = 10680)
	--begin                                                      
	--	select 
	--	MemberName as 'Client (Potential)',                  
	--	MemberId as 'Client Id',                  
	--	InquirerName as 'Inquirer',                  
	--	InQuiryDateTime as 'Date/Time',                  
	--	RecordedByName as 'Recorded By',                  
	--	AssignedToName as 'Assigned To',                  
	--	Disposition as 'Disposition',    
	--	InquiryStatus  as 'Inquiry Status'
	--	, 'CustomListPageInquiries' as tablename                                                                
	--	from CustomListPageInquiries where SessionId = @SessionId and InstanceId = @InstanceId 
	--end
RETURN
END
GO

