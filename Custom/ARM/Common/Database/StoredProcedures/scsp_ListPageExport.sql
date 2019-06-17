/****** Object:  StoredProcedure [dbo].[scsp_ListPageExport]    Script Date: 08/20/2015 18:56:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageExport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageExport]
GO

/****** Object:  StoredProcedure [dbo].[scsp_ListPageExport]    Script Date: 08/20/2015 18:56:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
*********************************************************************************/                                                                                 
BEGIN   
 if(@ScreenId  = 10680)  
 begin                                                        
  select   
  MemberName as 'Client (Potential)',                    
  MemberId as 'Client Id',                    
  InquirerName as 'Inquirer',                    
  InQuiryDateTime as 'Date/Time',                    
  RecordedByName as 'Recorded By',                    
  AssignedToName as 'Assigned To',                    
  Disposition as 'Disposition'      
  --InquiryStatus  as 'Inquiry Status'  
  , 'CustomListPageInquiries' as tablename                                                                  
  from CustomListPageInquiries where SessionId = @SessionId and InstanceId = @InstanceId   
 end  
END
GO


