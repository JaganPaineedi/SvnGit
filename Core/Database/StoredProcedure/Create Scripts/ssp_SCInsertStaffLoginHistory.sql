
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInsertStaffLoginHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInsertStaffLoginHistory]
GO

CREATE procedure [dbo].[ssp_SCInsertStaffLoginHistory]                                                       
@CreatedBy varchar(30),     
@CreatedDate datetime,
@ModifiedBy varchar(30),
 @StaffId int,
 @LoginTime   datetime,
 @RemoteLogin   char(1),
 @SessionId VARCHAR(30)
                        
/********************************************************************************                                              
-- Copyright: Streamline Healthcate Solutions LLC                                         
--                                              
-- Purpose: Insert StaffLoginHistory                                            
--                                              
-- Updates:                                                                                                     
-- Date    Author     Purpose                                              
-- 09.07.2010  Priya              Created.             
-- 03/06/2018  jcarlson			  Core Bugs 2450 - Populate new LastRequest field with current datetime    
-- 11/9/2018	jcarlson			Core Bugs 2662 - Use @LoginTime instead of GetDate() for initial Last Request                                      
*********************************************************************************/                                              
AS           
BEGIN TRY  
insert into StaffLoginHistory(CreatedBy,CreatedDate,ModifiedBy, StaffId,LoginTime,RemoteLogin,SessionId,LastRequest)
values(@CreatedBy,@CreatedDate,@ModifiedBy,@StaffId,@LoginTime,@RemoteLogin,@SessionId,@LoginTime)  
END TRY  
BEGIN CATCH  
 DECLARE @Error varchar(8000)                      
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                       
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCInsertStaffLoginHistory')                       
 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                        
 + '*****' + Convert(varchar,ERROR_STATE())                      
               
 RAISERROR                       
 (                      
 @Error, -- Message text.                      
 16, -- Severity.                      
 1 -- State.                      
 );       
End CATCH
GO
