/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromSystemConfigurations]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataFromSystemConfigurations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataFromSystemConfigurations]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCGetResourceInfo]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetResourceInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetResourceInfo]
GO
/****** Object:  StoredProcedure [dbo].[SSP_PMResource]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PMResource]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_PMResource]
GO
/****** Object:  StoredProcedure [dbo].[ssp_PMResourceDetailOnLoadData]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMResourceDetailOnLoadData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMResourceDetailOnLoadData]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetServiceNoteDocumentData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetServiceNoteDocumentData]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCListPageMyServices]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageMyServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageMyServices]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWDCalendarEvents]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWDCalendarEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWDCalendarEvents]
GO
/****** Object:  StoredProcedure [dbo].[ssp_GetAvailableResources]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAvailableResources]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAvailableResources]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCGetResources]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetResources]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetResources]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCMultiResourceCalendarSelDropDowns]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCMultiResourceCalendarSelDropDowns]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCMultiResourceCalendarSelDropDowns]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateResourceAppointment]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCUpdateResourceAppointment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCUpdateResourceAppointment]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWDCalendarResourceEvents]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWDCalendarResourceEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWDCalendarResourceEvents]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCValidateResourceAppointment]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateResourceAppointment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateResourceAppointment]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCInsertUpdateDeleteMultiResourceViewResource]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertUpdateDeleteMultiResourceViewResource]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCInsertUpdateDeleteMultiResourceViewResource]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCInsertUpdateMultiResourceView]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertUpdateMultiResourceView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCInsertUpdateMultiResourceView]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCDeleteResourceAppointment]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCDeleteResourceAppointment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCDeleteResourceAppointment]
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCMultiResourceView]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCMultiResourceView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCMultiResourceView]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWDResourceCalendarEventById]    Script Date: 05/02/2013 00:58:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWDResourceCalendarEventById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWDResourceCalendarEventById]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWDResourceCalendarEventById]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWDResourceCalendarEventById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_SCWDResourceCalendarEventById]    
    @AppointmentMasterId INT     
AS     
BEGIN    
 BEGIN TRY  
  DECLARE @AltAppointmentId INT    
     
  SET @AltAppointmentId = @AppointmentMasterId    
      
  SELECT  a.[AppointmentMasterId],  
    a.[CreatedBy],  
    a.[CreatedDate],  
    a.[ModifiedBy],  
    a.[ModifiedDate],  
    a.[RecordDeleted],  
    a.[DeletedBy],  
    a.[DeletedDate],  
    a.[Subject],  
    a.[StartTime],  
    a.[EndTime],  
    a.[AppointmentType],  
    a.[Description],  
    a.[ShowTimeAs],  
    a.[ServiceId]  
  FROM    AppointmentMaster a    
  WHERE   a.AppointmentMasterId = @AltAppointmentId  
    AND ISNULL(a.RecordDeleted,''N'')=''N''      
      
  SELECT  AppointmentMasterResourceId,  
    CreatedBy,  
    CreatedDate,  
    ModifiedBy,  
    ModifiedDate,  
    RecordDeleted,  
    DeletedBy,  
    DeletedDate,  
    AppointmentMasterId,  
    ResourceId  
  FROM AppointmentMasterResources  
  WHERE ISNULL(RecordDeleted,''N'')=''N''  
     AND AppointmentMasterId =@AltAppointmentId  
    
  SELECT  AppointmentMasterStaffId,  
    CreatedBy,  
    CreatedDate,  
    ModifiedBy,  
    ModifiedDate,  
    RecordDeleted,  
    DeletedBy,  
    DeletedDate,  
    AppointmentMasterId,  
    StaffId  
  FROM AppointmentMasterStaff  
  WHERE ISNULL(RecordDeleted,''N'')=''N''     
     AND AppointmentMasterId =@AltAppointmentId  
 END TRY  
 BEGIN CATCH  
   DECLARE @Error varchar(8000)                                                                                                                              
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                               
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCWDResourceCalendarEventById'')                                                                                                                               
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                               
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                             
  RAISERROR                                                                      
    (                                                                        
   @Error, -- Message text.                                                                                            
   16, -- Severity.                 
   1 -- State.                                                        
  );       
 END CATCH  
END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCMultiResourceView]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCMultiResourceView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SSP_SCMultiResourceView]  
 @StaffId INT  
AS  
-- =============================================
-- Author:		Pradeep A
-- Create date: 04/01/2013
-- Description:	Returns all Resource Views.
-- =============================================
BEGIN  
 BEGIN TRY  
  SELECT  0  MultiResourceViewId,  
       '''' AS UserStaffId,  
    '''' AS ViewName,  
    '''' AS AllResource,  
    '''' AS CreatedBy,  
    '''' AS CreatedDate,  
    '''' AS ModifiedBy,  
    '''' AS ModifiedDate,  
    '''' AS RecordDeleted,  
    '''' AS DeletedDate,  
    '''' AS DeletedBy,                          
    ''D'' AS DeleteButton,                      
    ''N'' AS RadioButton,                      
    '''' as  AllResource1  
   UNION  
    SELECT MultiResourceViewId,  
     UserStaffId,  
     ViewName,  
     AllResource,  
     CreatedBy,  
     CreatedDate,  
     ModifiedBy,  
     ModifiedDate,  
     RecordDeleted,  
     DeletedDate,  
     DeletedBy,  
     ''D'' AS DeleteButton,  
     ''N'' AS RadioButton,  
     ALLResource1=  
      CASE AllResource  
       WHEN ''Y'' THEN ''All''  
       WHEN ''N'' THEN ''Some''  
      END  
  FROM MultiResourceViews   
  WHERE UserStaffId =@StaffId   
  AND ISNULL(RecordDeleted,''N'')=''N''  
 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                                                                              
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                               
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''SSP_SCMultiResourceView'')                                                                                                                               
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                               
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                             
        RAISERROR                                                                      
    (                                                                        
   @Error, -- Message text.                                                                                            
   16, -- Severity.                 
   1 -- State.                                                        
  );       
 END CATCH  
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCDeleteResourceAppointment]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCDeleteResourceAppointment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SSP_SCDeleteResourceAppointment]      
@UserId VARCHAR(30),      
@AppointmentMasterId int =null      
AS      
BEGIN      
 DECLARE @deletedDate DATETIME      
 SET @deletedDate = GETDATE()      
 BEGIN TRY      
  IF @AppointmentMasterId IS NOT NULL      
   BEGIN      
    UPDATE AppointmentMaster      
     SET RecordDeleted =''Y'',      
         DeletedBy=@UserId,      
         DeletedDate =@deletedDate      
     WHERE AppointmentMasterId=@AppointmentMasterId      
          
    IF EXISTS (SELECT 1 FROM AppointmentMasterResources WHERE AppointmentMasterId=@AppointmentMasterId)      
     UPDATE AppointmentMasterResources      
      SET RecordDeleted =''Y'',      
       DeletedBy =@UserId,      
       DeletedDate=@deletedDate      
     WHERE AppointmentMasterId=@AppointmentMasterId      
    IF EXISTS (SELECT 1 FROM AppointmentMasterStaff WHERE AppointmentMasterId=@AppointmentMasterId)      
     UPDATE AppointmentMasterStaff      
      SET RecordDeleted =''Y'',      
       DeletedBy =@UserId,      
       DeletedDate=@deletedDate      
     WHERE AppointmentMasterId=@AppointmentMasterId      
   END      
 END TRY      
 BEGIN CATCH      
    DECLARE @Error varchar(8000)                                                                                                                                
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                 
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''SSP_SCDeleteResourceAppointment'')                                                                                                                                 
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                 
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                               
        RAISERROR                                                                        
    (                                                                          
   @Error, -- Message text.                                                                                              
   16, -- Severity.                   
   1 -- State.                                                          
  );         
 END CATCH      
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCInsertUpdateMultiResourceView]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertUpdateMultiResourceView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SSP_SCInsertUpdateMultiResourceView]  
(  
 @MultiResourceViewId bigint,                     
 @UserStaffId int,                    
 @ViewName varchar(100),                    
 @AllResource type_YOrN,                     
 @RecordDeleted type_YOrN,                
 @CreatedBy type_UserId,                
 @ModifyBy type_UserId ,              
 @ReturnId bigint output   
)  
AS  
BEGIN  
 BEGIN TRY  
  IF NOT EXISTS(SELECT MultiResourceViewId from MultiResourceViews where MultiResourceViewId=@MultiResourceViewId)    
   BEGIN  
    INSERT INTO [MultiResourceViews]  
       ([UserStaffId]  
       ,[ViewName]  
       ,[AllResource]  
       ,[CreatedBy]  
       ,[RecordDeleted]  
       ,[ModifiedBy])  
    VALUES  
       (@UserStaffId  
       ,@ViewName  
       ,@AllResource  
       ,@CreatedBy  
       ,@RecordDeleted  
       ,@CreatedBy)  
            
    SET @ReturnId=@@identity  
         
   END  
  ELSE  
   BEGIN  
    IF @RecordDeleted=''Y''  
     BEGIN  
      UPDATE  [MultiResourceViews]  
       SET [RecordDeleted] =@RecordDeleted ,   
        [DeletedBy] = @ModifyBy  ,          
        [DeletedDate] =GETDATE()    
       WHERE MultiResourceViewId=@MultiResourceViewId                
               
      SET @ReturnId=@MultiResourceViewId   
     END  
    ELSE  
     BEGIN  
      UPDATE [MultiResourceViews]  
       SET [UserStaffId]=@UserStaffId,  
        [ViewName]=@ViewName,  
        [AllResource]=@AllResource,  
        [ModifiedBy]=@ModifyBy,  
        [ModifiedDate]=GETDATE()    
       WHERE MultiResourceViewId=@MultiResourceViewId   
       
       SET @ReturnId=@MultiResourceViewId 
     END    
   END         
 END TRY        
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                                                                              
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                               
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''SSP_SCInsertUpdateMultiResourceView'')                                                                                                                               
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                               
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                             
        RAISERROR                                                                      
    (                                                                        
   @Error, -- Message text.                                                                                            
   16, -- Severity.                 
   1 -- State.                                                        
  );       
 END CATCH  
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCInsertUpdateDeleteMultiResourceViewResource]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertUpdateDeleteMultiResourceViewResource]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SSP_SCInsertUpdateDeleteMultiResourceViewResource]
(                  
	@MultiResourceViewResourceId bigint,                  
	@MultiResourceViewId bigint,                  
	@ResourceId bigint,                
	@RecordDeleted type_YOrN,              
	@CreatedBy type_UserId,              
	@ModifyBy type_UserId                
) 
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT MultiResourceViewResourceId from MultiResourceViewResource where MultiResourceViewResourceId=@MultiResourceViewResourceId)  
			BEGIN
					INSERT INTO [MultiResourceViewResource]
					   ([MultiResourceViewId]
					   ,[ResourceId]
					   ,[RecordDeleted]
					   ,[CreatedBy]
					   ,[ModifiedBy])
					VALUES
					   (@MultiResourceViewId
					   ,@ResourceId
					   ,@RecordDeleted
					   ,@CreatedBy
					   ,@ModifyBy)								
			END
		ELSE
			BEGIN
				IF @RecordDeleted=''Y''
					BEGIN
						UPDATE [MultiResourceViewResource]
							SET [RecordDeleted] =@RecordDeleted , 
								[DeletedBy] = @ModifyBy  ,        
								[DeletedDate] =GETDATE()  
							WHERE MultiResourceViewResourceId=@MultiResourceViewResourceId
					END  
				ELSE
					BEGIN
						UPDATE	[MultiResourceViewResource]
								SET [MultiResourceViewId]=@MultiResourceViewId,
									[ResourceId]=@ResourceId,
									[RecordDeleted]=@RecordDeleted,
									[ModifiedBy]=@ModifyBy,
									[ModifiedDate]=GETDATE()  
								WHERE MultiResourceViewResourceId=@MultiResourceViewResourceId
					END
							
			END
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                                                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                             
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''SSP_SCInsertUpdateDeleteMultiResourceViewResource'')                                                                                                                             
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                             
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                           
        RAISERROR                                                                    
	   (                                                                      
		 @Error, -- Message text.                                                                                          
		 16, -- Severity.               
		 1 -- State.                                                      
		);     
	END CATCH
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCValidateResourceAppointment]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateResourceAppointment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_SCValidateResourceAppointment]                
@StartDateTime datetime,        
@EndDateTime datetime,        
@ResourceListAsCSV varchar(max),      
@ResourceBooked Char(1) OUTPUT ,-- If T then (true) else F (False)      
@ServiceId int=null,    
@AppointmentMasterId int =NULL      
                                                                                                                                           
/********************************************************************************                    
-- Stored Procedure: dbo.ssp_SCValidateResourceAppointment                    
--                    
-- Copyright: Streamline Healthcate Solutions                    
--                    
-- Purpose: Validates Resource appointment                  
--        
--Test Data:      
Declare @ResourceBooked Char(1)      
Exec ssp_SCValidateResourceAppointment ''2013-03-22 11:00:00.000'',''2013-03-22 14:15:00.000'',''3,37'',@ResourceBooked output,null,100               
select @ResourceBooked    
--        
-- Updates:                    
-- Date        Author      Purpose                 
-- 25.03.2013  Gautam       Created                
      
      
*********************************************************************************/                                                                
as                
 Begin      
       
 Begin Try         
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                
      
Declare @ResourceCount int                                          
CREATE TABLE #ExistingResourceId (ResourceId INT,AptMasterId INT)      
CREATE TABLE #ResourceId (ResourceId INT)      
    
-- fill all existing resource against serviceId or AppointmentMasterId into #ExistingResourceId table    
if @AppointmentMasterId is null    
 Begin                 
  INSERT INTO #ExistingResourceId (ResourceId, AptMasterId)      
  select AMR.ResourceId, AMR.AppointmentMasterId           
  from AppointmentMaster AM  Inner Join AppointmentMasterResources AMR On AM.AppointmentMasterId=AMR.AppointmentMasterId               
  and AM.ServiceId = @ServiceId       
  and isnull(AM.RecordDeleted,''N'') = ''N''                                                                      
  and isnull(AMR.RecordDeleted,''N'') = ''N''       
 End    
Else    
 Begin    
  INSERT INTO #ExistingResourceId (ResourceId, AptMasterId)      
  select AMR.ResourceId, AMR.AppointmentMasterId           
  from AppointmentMaster AM  Inner Join AppointmentMasterResources AMR On AM.AppointmentMasterId=AMR.AppointmentMasterId               
  and AM.AppointmentMasterId=@AppointmentMasterId       
  and isnull(AM.RecordDeleted,''N'') = ''N''                                                                      
  and isnull(AMR.RecordDeleted,''N'') = ''N''      
 End    
     
-- fill all new resource into #ResourceId table     
INSERT INTO #ResourceId      
SELECT * FROM [dbo].fnSplit(@ResourceListAsCSV,'','')     
     
-- Remove all resource from #ResourceId table which is available in #ExistingResourceId. Now only new resource is left    
-- in #ResourceId table       
delete from #ResourceId where ResourceId in (select ResourceId from #ExistingResourceId)      
      
      
Select @ResourceCount=COUNT(*) from #ResourceId    
SELECT @ResourceCount  
if @ResourceCount = 0       
 Begin      
	  select *         
	  from AppointmentMaster AM  Inner Join AppointmentMasterResources AMR On AM.AppointmentMasterId = AMR.AppointmentMasterId               
		 Inner Join #ExistingResourceId RES on RES.ResourceId = AMR.ResourceId   and RES.AptMasterId <> AMR.AppointmentMasterId  
	  where (( AM.StartTime <= @StartDateTime AND @StartDateTime < AM.EndTime)        
	   OR ( @StartDateTime <= AM.StartTime AND AM.StartTime < @EndDateTime))            
	  and AM.ShowTimeAs = 4342 -- GlobalCodeID from GLOBALCODES for Category = SHOWTIMEAS & CodeName = Busy                             
	  and isnull(AM.RecordDeleted,''N'') = ''N''                                                                      
	  and isnull(AMR.RecordDeleted,''N'') = ''N''  
	  if @@rowcount = 0     
	   Begin      
		Select @ResourceBooked=''F''      
	   End      
	  else      
	   Begin      
		Select @ResourceBooked=''T''      
	   End 
	                 
  return      
 End      
                
-- Find Resource Appointment with new resource                
select AM.AppointmentMasterId           
from AppointmentMaster AM  Inner Join AppointmentMasterResources AMR On AM.AppointmentMasterId=AMR.AppointmentMasterId               
       Inner Join #ResourceId RES on RES.ResourceId=AMR.ResourceId      
where (( AM.StartTime <= @StartDateTime AND @StartDateTime < AM.EndTime)        
      OR ( @StartDateTime <= AM.StartTime AND AM.StartTime < @EndDateTime))            
   and AM.ShowTimeAs = 4342 -- GlobalCodeID from GLOBALCODES for Category = SHOWTIMEAS & CodeName = Busy                             
   and isnull(AM.RecordDeleted,''N'') = ''N''                                                                      
   and isnull(AMR.RecordDeleted,''N'') = ''N''       
      
                
if @@rowcount = 0     
 Begin      
  Select @ResourceBooked=''F''      
 End      
else      
 Begin      
  Select @ResourceBooked=''T''      
 End             
                
      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
      
END TRY             
                                                   
  BEGIN CATCH                                     
  DECLARE @Error varchar(MAX)                                                                                      
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                       
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCValidateResourceAppointment'')                                                            
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                        
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                                                               
   RAISERROR                                                                 
    (                                                     
  @Error, -- Message text.                                                                                      
  16, -- Severity.                                                                                      
  1 -- State.                                                                                      
    );                  
 End CATCH                                                    
             
   END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWDCalendarResourceEvents]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWDCalendarResourceEvents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    
CREATE PROCEDURE [dbo].[ssp_SCWDCalendarResourceEvents]              
    @ViewType VARCHAR(15) , -- (''MULTIRESOURCE'', ''SINGLERESOURCE'')                                                                     
    @StartDate DATETIME ,              
    @EndDate DATETIME ,              
    @ResourceList VARCHAR(MAX) ,              
    @CurrentResourceId INT   
    /********************************************************************************                    
-- Stored Procedure: dbo.ssp_SCValidateResourceAppointment                    
--                    
-- Copyright: Streamline Healthcate Solutions                    
--                    
-- Purpose: Validates Resource appointment                  
--        
--Test Data:      
Declare @ResourceBooked Char(1)      
Exec ssp_SCWDCalendarResourceEvents ''MULTIRESOURCE'',''2013-03-22 11:00:00.000'',''2013-03-22 14:15:00.000'',''3,37'',3              
select @ResourceBooked    
--        
-- Updates:                    
-- Date        Author      Purpose                 
-- 18.03.2013  Pradeep      Created                
-- 25.03.2013  Gautam       Added Stafflist        
      
*********************************************************************************/                   
AS               
    BEGIN              
        CREATE TABLE #ResourceIds              
            (              
              ResourceId INT NOT NULL ,              
              SortOrder INT NOT NULL              
            )              
          Create Table #AppointmentList    
        (    
     AppointmentMasterResourceId int,    
     AppointmentMasterId int,          
            ResourceId int,          
            Subject Varchar(250),          
            StartTime DateTime,          
            endtime DateTime,          
            AppointmentType int,          
            AppointmentTypeCodeName varchar(250),          
            AppointmentTypeDescription Text,          
            AppointmentTypeColor varchar(10),          
            Description text,          
            ShowTimeAs int,          
            ShowTimeAsCodeName varchar(250),          
            ShowTimeAsDescription Text,          
            ShowTimeAsColor varchar(10),          
            ServiceId int,          
            DocumentId int,    
            StaffList varchar(max) null,
            ClientId int          
        )    
              
        IF @ViewType = ''MULTIRESOURCE''               
            BEGIN               
                INSERT  INTO #ResourceIds              
                        ( ResourceId ,              
                          SortOrder               
                        )              
                        SELECT  a.Resourceid ,              
                                ROW_NUMBER() OVER ( ORDER BY s.ResourceName,a.ResourceId ASC )              
                        FROM    dbo.MultiResourceViewResource a              
                                JOIN Resources s ON ( a.ResourceId = s.ResourceId )              
                        WHERE   MultiResourceViewId IN (              
                                SELECT  ids              
                                FROM    dbo.SplitIntegerString(@ResourceList, '','') )              
                                AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''              
            END               
        ELSE               
            IF @ViewType = ''SELECTED''      
      OR @ViewType = ''SINGLERESOURCE''              
                BEGIN               
                    INSERT  INTO #ResourceIds              
                            ( ResourceId ,              
                              SortOrder                                              
                            )              
                            SELECT  ids ,              
                                    ROW_NUMBER() OVER ( ORDER BY s.ResourceName, a.ids ASC )              
                            FROM    dbo.SplitIntegerString(@ResourceList, '','') a              
                                    JOIN Resources s ON ( a.ids = s.ResourceId )              
                END               
            ELSE               
                BEGIN               
                    INSERT  INTO #ResourceIds              
                            ( ResourceId, SortOrder )              
                    VALUES  ( -1, 1 )              
                END ;              
        WITH    ResourceAppointmentList ( AppointmentMasterResourceId,AppointmentMasterId, ResourceId, Subject, StartTime, endtime, AppointmentType, AppointmentTypeCodeName, AppointmentTypeDescription, AppointmentTypeColor, Description, ShowTimeAs,    
         ShowTimeAsCodeName, ShowTimeAsDescription,         
        ShowTimeAsColor,ServiceId,DocumentId,ClientId)-- ReadOnly ,)              
                  AS ( SELECT   a.AppointmentMasterResourceId ,      
								am.AppointmentMasterId,           
                                a.ResourceId ,              
                                am.Subject ,              
                                am.StartTime ,              
                                am.endtime ,              
                                am.AppointmentType ,              
                                ISNULL(c.CodeName, '''') AS AppointmentTypeCodeName ,              
                                ISNULL(c.Description, '''') AS AppointmentTypeDescription ,              
                                ISNULL(c.color, '''') AS AppointmentTypeColor ,              
                                am.Description ,              
                                am.ShowTimeAs ,              
                                ISNULL(b.CodeName, '''') AS ShowTimeAsCodeName ,              
                                ISNULL(b.Description, '''') AS ShowTimeAsDescription ,              
                                ISNULL(b.color, '''') AS ShowTimeAsColor ,       
                                am.ServiceId ,      
                                doc.DocumentId,
                                serv.ClientId       
                       FROM     #ResourceIds s              
                           JOIN AppointmentMasterResources a ON ( s.ResourceId = a.ResourceId )       
                                JOIN AppointmentMaster am ON am.AppointmentMasterId=a.AppointmentMasterId          
                                LEFT JOIN globalcodes b ON ( am.ShowTimeAs = b.GlobalCodeId              
                                                             AND b.Category = ''SHOWTIMEAS''              
                                                           )              
                                LEFT JOIN globalcodes c ON ( am.AppointmentType = c.GlobalCodeId              
                                                             AND c.Category = ''APPOINTMENTTYPE''              
                                                           )              
                                LEFT JOIN dbo.Services serv ON ( am.ServiceId = serv.ServiceId )            
                                LEFT JOIN dbo.Documents doc ON(serv.ServiceId=doc.ServiceId)        
                                             
                       WHERE    ( EndTime >= @StartDate              
                                  OR EndTime IS NULL              
                                )              
                                AND ( StartTime <= @EndDate )              
                                AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''              
                     )     
            Insert Into #AppointmentList             
            SELECT  AppointmentMasterResourceId ,       
     AppointmentMasterId,             
                    ResourceId ,              
                    Subject ,              
                    StartTime ,              
                    endtime ,              
                    AppointmentType ,              
                    AppointmentTypeCodeName ,              
                    AppointmentTypeDescription ,              
                    AppointmentTypeColor ,              
                    Description ,              
                    ShowTimeAs ,              
                    ShowTimeAsCodeName ,              
                    ShowTimeAsDescription ,              
                    ShowTimeAsColor ,         
                    ServiceId ,          
                    ISNULL(DocumentId, 0) AS DocumentId,    
                    '''' as StaffList,
                    ClientId                       
            FROM    ResourceAppointmentList            
            ORDER BY StartTime ,              
                    EndTime ,              
            AppointmentMasterResourceId ;             
                
-- Update StaffList         
  Update AP    
  Set AP.StaffList=ResourceWithService.DisplayAs    
  From #AppointmentList AP Left Outer Join (Select AppointmentResourceList.AppointmentMasterId,case when AppointmentResourceList.DisplayAs is not null     
       then ''('' + AppointmentResourceList.DisplayAs + '')'' else AppointmentResourceList.DisplayAs end DisplayAs  From       
        ( Select AM.AppointmentMasterId,    
        REPLACE(REPLACE(STUFF(    
       (SELECT Distinct '', '' + S.LastName + '','' +S.FirstName      
        From AppointmentMasterStaff AMS Inner Join Staff S on S.StaffId=AMS.StaffId      
       Where AM.AppointmentMasterId=AMS.AppointmentMasterId     
        And isNull(AMS.RecordDeleted,''N'')<>''Y''      
        And isNull(S.RecordDeleted,''N'')<>''Y''        
       FOR XML PATH(''''))    
       ,1,1,'''')    
       ,''&lt;'',''<''),''&gt;'',''>'')''DisplayAs''    
          From #AppointmentList RS Inner Join AppointmentMaster AM ON RS.AppointmentMasterId=AM.AppointmentMasterId       
          Where isNull(AM.RecordDeleted,''N'')<>''Y''         
          ) AppointmentResourceList      
        ) ResourceWithService on (AP.AppointmentMasterId=ResourceWithService.AppointmentMasterId )        
    
 SELECT  AppointmentMasterResourceId ,    
     AppointmentMasterId ,          
            ResourceId ,          
            Subject,          
            StartTime ,          
            endtime ,          
            AppointmentType ,          
            AppointmentTypeCodeName ,          
            AppointmentTypeDescription,          
            AppointmentTypeColor ,          
            Description ,          
            ShowTimeAs ,          
            ShowTimeAsCodeName ,          
            ShowTimeAsDescription ,          
            ShowTimeAsColor ,          
            ServiceId ,          
            DocumentId ,    
            StaffList,
            ClientId           
       FROM #AppointmentList                     
                
        SELECT  a.ResourceId ,              
                a.ResourceName AS ResourceName ,              
                CASE WHEN a.ResourceId = @CurrentResourceId THEN 1              
                     ELSE 1              
                END AS CanSchedule              
        FROM    #ResourceIds s              
                JOIN Resources a ON ( s.ResourceId = a.ResourceId )              
        ORDER BY s.SortOrder              
              
   END 
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateResourceAppointment]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCUpdateResourceAppointment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SSP_SCUpdateResourceAppointment]        
 @UserId varchar(30),         
 @AppointmentMasterId int = null output,         
 @Subject varchar(250),        
 @StartTime datetime,                                       
 @EndTime datetime,         
 @AppointmentType type_GlobalCode,                                       
 @Description type_Comment = null,         
 @ShowTimeAs type_GlobalCode,                                  
 @ServiceId int = null,        
 @ResourceListAsCSV varchar(max),        
 @StaffListAsCSV varchar(max),        
 @TransactionMode varchar(6),
 @ResourceBooked char(1) output         
 /********************************************************************************                      
 -- Stored Procedure: dbo.SSP_SCUpdateResourceAppointment                      
 --                      
 -- Copyright: Streamline Healthcate Solutions                      
 --                      
 -- Purpose: Insert/Update/Delete Resource appointment                    
 --          
 --Test Data:        
  --Exec SSP_SCUpdateResourceAppointment ''AVOSS'',null,''abc'',''2013-03-25 11:00:00.000'',''2013-03-25 14:15:00.000'',4761,null,4342,null,''12'',897,''ADD'',@ResourceBooked output               
 --          
 -- Updates:                      
 -- Date        Author      Purpose                   
 -- 25.03.2013  Gautam       Created                  
        
        
 *********************************************************************************/              
AS        
         
BEGIN        
 BEGIN TRY        
          
  DECLARE @ModifiedDate DATETIME            
  SET @ModifiedDate = GETDATE()          
  Declare @ResourceCount Int        
  Declare @StaffCount Int        
  Declare @CurrentCount Int        
  Declare @ResourceStaffId int        
  Declare @StaffId int        
  Declare @AppointmentTypeId int  
          
  exec ssp_SCValidateResourceAppointment @StartTime,@EndTime,@ResourceListAsCSV,@ResourceBooked  OUTPUT,@ServiceId,@AppointmentMasterId        
          
  IF @ResourceBooked=''T''        
   Begin        
    Select ''Resource is already booked.''        
    Return        
   End     
     
  select Top 1 @AppointmentTypeId= GlobalCodeId from GlobalCodes where Category =''APPOINTMENTTYPE'' and CodeName=''Resource'' and Active=''Y''  
      and ISNULL(RecordDeleted,''N'')=''N''  
           
  Create Table #ResourceList(        
  ResSequenceId int identity(1,1),        
  ResourceId int        
  )        
  Insert into #ResourceList        
  select * from dbo.fnsplit(@ResourceListAsCSV,'','')        
  select @ResourceCount=COUNT(ResSequenceId) from #ResourceList        
          
  Create Table #StaffList(        
  StaffSequenceId int identity(1,1),        
  StaffId int        
  )        
  Insert into #StaffList        
  select * from dbo.fnsplit(@StaffListAsCSV,'','')        
  select @StaffCount=COUNT(StaffSequenceId) from #StaffList        
        
         
  Begin Transaction        
  IF @TransactionMode=''ADD''        
  BEGIN        
    IF @AppointmentMasterId IS NULL        
    BEGIN        
     INSERT INTO [AppointmentMaster]        
          (CreatedBy,        
        CreatedDate,        
        ModifiedBy,        
        ModifiedDate,        
        RecordDeleted,        
        DeletedBy,        
        DeletedDate,        
        Subject,        
        Description,        
        StartTime,        
        EndTime,        
        AppointmentType,        
        ShowTimeAs,        
        ServiceId)               
     SELECT        
      @UserId        
        ,@ModifiedDate        
        ,@UserId        
        ,@ModifiedDate        
        ,NULL        
        ,NULL        
        ,NULL             
        ,@Subject        
        ,@Description        
        ,@StartTime        
        ,@EndTime        
        ,@AppointmentTypeId           
        ,4342 -- SHOWTIMEAS BUSY        
        ,@ServiceId        
                   
     SET @AppointmentMasterId = scope_identity()        
    END        
    -- Insert into AppointmentMasterResources     
    set @CurrentCount=1        
    IF @ResourceCount>0        
     BEGIN        
      While @CurrentCount<=@ResourceCount        
       Begin        
        Select @ResourceStaffId =ResourceId from #ResourceList where ResSequenceId=@CurrentCount        
        INSERT INTO [AppointmentMasterResources]        
            (CreatedBy,        
          CreatedDate,        
          ModifiedBy,        
          ModifiedDate,        
          RecordDeleted,        
   DeletedBy,        
          DeletedDate,        
          AppointmentMasterId,        
          ResourceId)         
        SELECT        
         @UserId        
           ,@ModifiedDate        
           ,@UserId        
           ,@ModifiedDate        
           ,NULL        
           ,NULL        
           ,NULL             
           ,@AppointmentMasterId        
           ,@ResourceStaffId        
                   
           set @CurrentCount=@CurrentCount+1        
       End        
     END          
    -- Insert into AppointmentMasterStaff            
    set @CurrentCount=1             
    IF @StaffCount>0        
     BEGIN        
      While @CurrentCount<=@StaffCount        
       Begin        
        Select @ResourceStaffId =StaffId from #StaffList where StaffSequenceId=@CurrentCount        
        INSERT INTO [AppointmentMasterStaff]        
            (CreatedBy,        
          CreatedDate,        
          ModifiedBy,        
          ModifiedDate,        
          RecordDeleted,        
          DeletedBy,        
          DeletedDate,        
          AppointmentMasterId,        
          StaffId)         
        SELECT        
         @UserId        
           ,@ModifiedDate        
           ,@UserId        
           ,@ModifiedDate        
           ,NULL        
           ,NULL        
           ,NULL             
           ,@AppointmentMasterId        
           ,@ResourceStaffId        
                   
           set @CurrentCount=@CurrentCount+1        
       End        
     END                                                    
   END        
        
  IF @TransactionMode=''MODIFY''        
   BEGIN        
    UPDATE RES        
        SET [ModifiedBy] = @UserId        
        ,[ModifiedDate] = @ModifiedDate        
        ,[Subject] = @Subject        
        ,[Description] = @Description        
        ,[StartTime] = @StartTime        
        ,[EndTime] = @EndTime        
        ,[AppointmentType] = @AppointmentTypeId              
        ,[ShowTimeAs] = 4342        
        ,[ServiceId] = @ServiceId        
    FROM [AppointmentMaster] RES        
    WHERE AppointmentMasterId= @AppointmentMasterId        
           
    IF @ResourceCount>0        
     BEGIN        
       -- First update all resource Deleted to ''Y'' for selected appointment        
       UPDATE AMR                                    
       SET RecordDeleted = ''Y'',                        
        DeletedBy = @UserId,                                    
        DeletedDate = @ModifiedDate                                    
       FROM AppointmentMasterResources AMR                                                              
       WHERE AMR.AppointmentMasterId = @AppointmentMasterId              
       -- Then check all resource one by one if exists then update RecordDeleted =''N'' else insert new record        
       set @CurrentCount=1        
       IF @ResourceCount>0        
       BEGIN        
        While @CurrentCount<=@ResourceCount        
         Begin        
          Select @ResourceStaffId =ResourceId from #ResourceList where ResSequenceId=@CurrentCount        
          If Not Exists(Select * from AppointmentMasterResources where AppointmentMasterId = @AppointmentMasterId and ResourceId=@ResourceStaffId)        
           Begin        
            INSERT INTO [AppointmentMasterResources]        
                (CreatedBy,        
              CreatedDate,        
              ModifiedBy,        
              ModifiedDate,        
              RecordDeleted,        
         DeletedBy,        
              DeletedDate,        
              AppointmentMasterId,        
              ResourceId)         
            SELECT        
             @UserId        
               ,@ModifiedDate        
               ,@UserId        
               ,@ModifiedDate        
               ,NULL        
               ,NULL        
               ,NULL             
               ,@AppointmentMasterId        
               ,@ResourceStaffId        
           End        
          Else        
           Begin        
            UPDATE AMR                                    
            SET RecordDeleted = ''N'',                        
             DeletedBy = Null,                         
             DeletedDate = Null                                    
         FROM AppointmentMasterResources AMR                                                              
            WHERE AMR.AppointmentMasterId = @AppointmentMasterId and AMR.ResourceId=@ResourceStaffId           
           End        
                     
             set @CurrentCount=@CurrentCount+1        
         End        
       END              
     END         
     IF @StaffCount>0        
     BEGIN        
       -- First update all Staff Deleted to ''Y'' for selected appointment        
       UPDATE AMS                                    
       SET RecordDeleted = ''Y'',                        
        DeletedBy = @UserId,                                    
        DeletedDate = @ModifiedDate                                    
       FROM AppointmentMasterStaff AMS                                                              
       WHERE AMS.AppointmentMasterId = @AppointmentMasterId              
       -- Then check all STAFF one by one if exists then update RecordDeleted =''N'' else insert new record        
       set @CurrentCount=1        
       IF @StaffCount>0        
       BEGIN        
        While @CurrentCount<=@StaffCount        
         Begin        
          Select @ResourceStaffId =StaffId from #StaffList where StaffSequenceId=@CurrentCount        
          If Not Exists(Select * from AppointmentMasterStaff where AppointmentMasterId = @AppointmentMasterId and StaffId=@ResourceStaffId)        
           Begin        
            INSERT INTO [AppointmentMasterStaff]        
                (CreatedBy,        
              CreatedDate,        
              ModifiedBy,        
              ModifiedDate,        
              RecordDeleted,        
              DeletedBy,        
              DeletedDate,        
              AppointmentMasterId,        
              StaffId)         
            SELECT        
             @UserId        
               ,@ModifiedDate        
               ,@UserId        
               ,@ModifiedDate        
               ,NULL        
               ,NULL        
               ,NULL             
               ,@AppointmentMasterId        
               ,@ResourceStaffId        
           End        
          Else        
           Begin        
            UPDATE AMS                                    
            SET RecordDeleted = ''N'',                        
             DeletedBy = Null,                                    
             DeletedDate = Null                                    
            FROM AppointmentMasterStaff AMS                                                              
            WHERE AMS.AppointmentMasterId = @AppointmentMasterId and AMS.StaffId=@ResourceStaffId           
           End        
                     
             set @CurrentCount=@CurrentCount+1        
         End        
       END              
     END         
    END        
    IF @TransactionMode=''DELETE''        
     BEGIN        
      -- First update AppointmentMaster        
       UPDATE AM                                    
       SET RecordDeleted = ''Y'',                        
        DeletedBy = @UserId,                                    
        DeletedDate = @ModifiedDate                                    
 FROM AppointmentMaster AM                                                              
       WHERE AM.AppointmentMasterId = @AppointmentMasterId              
       -- Then update AppointmentMasterStaff        
       UPDATE AMS                                    
       SET RecordDeleted = ''Y'',                        
        DeletedBy = @UserId,                                    
        DeletedDate = @ModifiedDate                                    
       FROM AppointmentMasterStaff AMS                                                              
       WHERE AMS.AppointmentMasterId = @AppointmentMasterId              
       -- Then update AppointmentMasterResource        
       UPDATE AMS                                    
       SET RecordDeleted = ''Y'',                        
        DeletedBy = @UserId, DeletedDate = @ModifiedDate                                    
       FROM AppointmentMasterResources AMS                                                              
       WHERE AMS.AppointmentMasterId = @AppointmentMasterId              
     END        
 Commit Transaction             
 END TRY        
 BEGIN CATCH        
  DECLARE @Error VARCHAR(8000)           
  Rollback Tran            
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                    
   + ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''SSP_SCUpdateResourceAppointment'')                                                                                                     
   + ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                            
   + ''*****'' + CONVERT(VARCHAR,ERROR_STATE())        
  RAISERROR        
  (        
   @Error, -- Message text.        
   16,  -- Severity.        
   1  -- State.        
  );        
 END CATCH         
END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCMultiResourceCalendarSelDropDowns]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCMultiResourceCalendarSelDropDowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[SSP_SCMultiResourceCalendarSelDropDowns]  
 @UserCode INT  
AS  
BEGIN  
 BEGIN TRY  
  --AppointmentType  
  SELECT GlobalCodeId,  
      CodeName,  
      Color,  
      Active  
  FROM GlobalCodes  
  WHERE Category =''APPOINTMENTTYPE''  
     AND ISNULL(RecordDeleted,''N'')=''N''  
  ORDER BY SortOrder ASC, CodeName ASC  
    
  --ShowTimeAs                    
  SELECT GlobalCodeId,  
      CodeName,                 
      Color,                  
      Active                  
  FROM GlobalCodes                  
  WHERE Category=''ShowTimeAs''                  
   AND ISNULL(RecordDeleted,''N'')=''N''                 
  ORDER BY GlobalCodeId    
     
  --Resources  
  SELECT ResourceId,  
      ResourceName,  
      ResourceType,  
      ResourceSubtype,  
      Active  
  FROM Resources  
  WHERE ISNULL(RecordDeleted,''N'')=''N''  
  AND ISNULL(Active,''N'')!=''N''   
    
  --MultiResourceViews  
  SELECT  MultiResourceViewId,  
    UserStaffId,  
    ViewName,  
    AllResource,  
    CreatedBy,  
    CreatedDate,  
    ModifiedBy,  
    ModifiedDate,  
    RecordDeleted,  
    DeletedDate,  
    DeletedBy,  
    ''D'' AS DeleteButton,  
    ''N'' AS RadioButton,  
    AllResource1=  
     CASE AllResource  
      WHEN ''Y'' THEN ''All''  
      WHEN ''N'' THEN ''Some''  
     END  
  FROM MultiResourceViews  
  WHERE ISNULL(RecordDeleted,''N'')=''N''  
     AND UserStaffId=@UserCode  
  ORDER BY ViewName  
    
  --MultiResourceViewResource  
  SELECT *  
  FROM MultiResourceViewResource RVR  
  INNER JOIN MultiResourceViews RV ON RV.MultiResourceViewId=RVR.MultiResourceViewId  
  INNER JOIN Resources R ON R.ResourceId=RVR.ResourceId  
  WHERE ISNULL(RV.RecordDeleted,''N'')=''N''  
     AND ISNULL(RVR.RecordDeleted,''N'')=''N''  
     AND R.Active=''Y''  
     AND ISNULL(R.RecordDeleted,''N'')=''N''  
       
 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                                                                              
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                               
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''SSP_SCMultiResourceCalendarSelDropDowns'')                                                                                                                               
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                               
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                             
        RAISERROR                                                                      
    (                                                                        
   @Error, -- Message text.                                                                                            
   16, -- Severity.                 
   1 -- State.                                                        
  );       
 END CATCH  
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCGetResources]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetResources]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[SSP_SCGetResources]               
@ResourceType INT ,        
@StartDateTime DATETIME = NULL,        
@EndDateTime DATETIME = NULL,    
@AppointmentMasterId int =NULL          
/************************************************************************************/                                                                                      
  /* Stored Procedure: dbo.SSP_SCGetResources         */                                                                                      
  /* Copyright: 2013 Streamline Healthcare Solutions,  LLC       */                                                                                      
  /* Creation Date:    28/Mar/2013             */                                                                                         
  /* Purpose:  This will return all available resources on given parameters   */                                                                                                                                                       
  /* Input Parameters:  @ResourceType,@StartDateTime,@EndDateTime,@StaffId,@ServiceID */                                                                                    
  /*                      */                                                                                                                                                             
  /*  Date          Author         Purpose            */        
  /* 22/Mar/2013    Pradeep        Created              */                                                                    
  /* 28/Mar/2013    Gautam         Modify to filter availability of the resources            */                                                
  /************************************************************************************/                  
 -- TEST DATA BLOCK        
 --exec SSP_SCGetResources -1,null,null,null       
 -- exec SSP_SCGetResources 24453,null,null,null      
 --exec SSP_SCGetResources -1,''2013-03-29 12:30:00.000'',''2013-03-29 12:35:00.000'',95            
AS                    
BEGIN                    
 BEGIN TRY      
  IF @StartDateTime IS NULL OR  @EndDateTime IS NULL      
   BEGIN      
    SELECT  RES.[ResourceId],           
        RES.[ResourceName]+'' (''+G.[SubCodeName]+'')'' as Name          
    FROM Resources RES          
     JOIN GlobalSubCodes G on G.GlobalSubCodeId=RES.ResourceSubType          
    WHERE ISNULL(RES.RecordDeleted,''N'')!=''Y''           
     AND ISNULL(RES.Active,''N'')=''Y''          
     AND (RES.ResourceType=@ResourceType or @ResourceType=-1)         
   END      
  ELSE                         
   BEGIN                 
    SELECT RES.ResourceId, RES.[ResourceName]+'' (''+GSC.[SubCodeName]+'')'' as Name         
    FROM   Resources RES       
      Left Outer Join GlobalSubCodes GSC on RES.ResourceSubType=GSC.GlobalSubCodeId --and GSC.GlobalCodeId=RES.Type                     
    WHERE   (@ResourceType =-1 OR RES.ResourceType=@ResourceType)                      
      AND ISNULL(RES.Active, ''N'') = ''Y''         
      AND ISNULL(RES.recorddeleted, ''N'') = ''N''         
      AND ISNULL(GSC.recorddeleted, ''N'') = ''N''          
    AND NOT EXISTS (        
      SELECT AMR.ResourceId        
      FROM    AppointmentMaster AM Inner Join AppointmentMasterResources AMR        
        On AM.AppointmentMasterId =AMR.AppointmentMasterId        
      WHERE   RES.ResourceId=AMR.ResourceId AND AM.ShowTimeAs = 4342 -- GlobalCodeID from GLOBALCODES for Category = SHOWTIMEAS & CodeName = Busy        
         AND ( ( AM.StartTime <= @StartDateTime          
          AND @StartDateTime < AM.EndTime          
           )          
           OR ( @StartDateTime <= AM.StartTime          
          AND AM.StartTime < @EndDateTime          
           )          
          )          
          AND ISNULL(AM.recorddeleted, ''N'') = ''N''         
          AND ISNULL(AMR.recorddeleted, ''N'') = ''N'')       
   Union    
    SELECT RES.ResourceId, RES.[ResourceName]+'' (''+GSC.[SubCodeName]+'')'' as Name         
    FROM   AppointmentMaster AM Inner Join AppointmentMasterResources AMR        
        On AM.AppointmentMasterId =AMR.AppointmentMasterId             
      Inner Join Resources RES On RES.ResourceId = AMR.ResourceId        
      Left Outer Join GlobalSubCodes GSC on RES.ResourceSubType=GSC.GlobalSubCodeId --and GSC.GlobalCodeId=RES.Type                     
    WHERE   AM.AppointmentMasterId=@AppointmentMasterId   
		AND ISNULL(RES.Active, ''N'') = ''Y''         
		AND ISNULL(RES.recorddeleted, ''N'') = ''N''         
		AND ISNULL(GSC.recorddeleted, ''N'') = ''N'' 
		AND ISNULL(AM.recorddeleted, ''N'') = ''N''         
        AND ISNULL(AMR.recorddeleted, ''N'') = ''N''       
           
   END                      
 END TRY                    
 BEGIN CATCH                    
  DECLARE @Error varchar(8000)                                                                                                                                                
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                                 
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''SSP_SCGetResources'')                                                                                                                                                 
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                 
  + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                                               
    RAISERROR                                                                                        
   (                                                                                          
  @Error, -- Message text.                                                                                                              
  16, -- Severity.                                   
  1 -- State.                                                                          
    );                         
  END CATCH                    
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_GetAvailableResources]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAvailableResources]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[ssp_GetAvailableResources]    
    (    
      @ResourceType  INT,  
      @StartDateTime DATETIME,  
      @EndDateTime  DATETIME,  
      @StaffId   INT,  
      @ServiceID  INT= NULL  
    )    
AS   
  /************************************************************************************/                                                                                
  /* Stored Procedure: dbo.ssp_GetAvailableResources         */                                                                                
  /* Copyright: 2013 Streamline Healthcare Solutions,  LLC       */                                                                                
  /* Creation Date:    07/Mar/2013             */                                                                                   
  /* Purpose:  This will return all available resources on given parameters   */                                                                                                                                                 
  /* Input Parameters:  @ResourceType,@StartDateTime,@EndDateTime,@StaffId,@ServiceID */                                                                              
  /*                      */                                                                                                                                                       
  /*  Date   Author         Purpose            */                                                                                
  /* 07/Mar/2013   Gautam         Created            */                                          
  /************************************************************************************/            
 -- TEST DATA BLOCK  
 -- set @ResourceType=24453 -- room ,24452 - Projector     
 -- set @StartDateTime=''2013-03-08 11:00:00.000''     
 -- set @EndDateTime=''2013-03-08 12:00:00.000''     
 -- set @StaffId =897       
 --Exec ssp_GetAvailableResources 24453,''2013-03-21 10:00:00.000'',''2013-03-21 11:00:00.000'',897,NULL  
   --Exec ssp_GetAvailableResources 24453,''2013-03-13 10:00:00.000'',''2013-03-13 11:00:00.000'',897,NULL  
   BEGIN  
   BEGIN TRY    
        
   -- STEP  
   -- Create a temporary table that will be used to return the output from this procedure  
   CREATE TABLE #AvailableResources  
   (          
     ResourceId         INT NULL,          
     ResourceDisplay VARCHAR(100) NULL,  
     ResourceSubType VARCHAR(100) NULL,  
     StaffName   VARCHAR(100) NULL,  
     ClosestStartTime TIME NULL,  
     ClosestEndTime  TIME NULL          
    )  
   -- STEP   
   -- Grab the list of all resources that are available for the   
   -- @ResourceType , @StartTime , @EndTime and store these to   
   -- a temporary table  
    INSERT INTO #AvailableResources(ResourceId,ResourceDisplay,ResourceSubType)  
          SELECT RES.ResourceId, RES.DisplayAs,GSC.SubCodeName   
          FROM    Resources RES Inner Join ResourceAvailability REA   
    On RES.ResourceId = REA.ResourceId  
    Left Outer Join GlobalSubCodes GSC on RES.ResourceSubType=GSC.GlobalSubCodeId --and GSC.GlobalCodeId=RES.Type               
          WHERE   RES.ResourceType = @ResourceType  
    AND CONVERT(VARCHAR(10), REA.StartDate, 101) <= CONVERT(VARCHAR(10), @StartDateTime, 101)  
           AND (CONVERT(VARCHAR(10), REA.EndDate, 101) >= CONVERT(VARCHAR(10), @EndDateTime, 101)  
            OR REA.EndDate is null)  
           AND ISNULL(REA.recorddeleted, ''N'') = ''N''  
           AND ISNULL(RES.recorddeleted, ''N'') = ''N''   
           AND ISNULL(GSC.recorddeleted, ''N'') = ''N''    
           AND ISNULL(RES.Active, ''Y'') = ''Y''  
               AND NOT EXISTS (  
                         SELECT AMR.ResourceId  
                         FROM    AppointmentMaster AM Inner Join AppointmentMasterResources AMR  
								On AM.AppointmentMasterId =AMR.AppointmentMasterId  
                         WHERE  RES.ResourceId=AMR.ResourceId AND  AM.ShowTimeAs = 4342 -- GlobalCodeID from GLOBALCODES for Category = SHOWTIMEAS & CodeName = Busy  
								AND ( ( AM.StartTime <= @StartDateTime    
                                       AND @StartDateTime < AM.EndTime  )          
                                       OR ( @StartDateTime <= AM.StartTime    
                                                     AND AM.StartTime < @EndDateTime    
                                                )    
                                       )    
                              AND ISNULL(AM.recorddeleted, ''N'') = ''N''   
                              AND ISNULL(AMR.recorddeleted, ''N'') = ''N'')  
   -- STEP   
   -- For the resource(s) that are available from previous step to check if    
   -- the any of these resource(s) also have other appointments during the  
   -- same DAY of the @StartTime for the @StaffId. For such resources, get the   
   -- closent appointment information and append this to the ResourceSubType AND ResourceDisplay  
   UPDATE AR  
   SET AR.StaffName =Final.StaffName, ClosestStartTime=StartTime,ClosestEndTime=EndTime--,AR.ResourceSubType=Final.ResourceSubType  
   FROM #AvailableResources AR LEFT OUTER JOIN   
   (  
              SELECT  Main.StaffName,  
                           Main.ResourceId,  
                           CAST(Main.StartTime AS TIME) AS StartTime ,  
                           CAST(Main.EndTime AS TIME) AS EndTime,  
                           Main.ResourceSubType  
              FROM  
              (  
                     SELECT SubRecord.StaffName,  
                                  SubRecord.ResourceId,  
                                  SubRecord.TimeDiff,  
                                  SubRecord.StartTime,  
                                  SubRecord.EndTime,  
                                  SubRecord.ResourceSubType,  
                                  ROW_NUMBER()OVER(PARTITION BY SubRecord.ResourceId ORDER BY SubRecord.TimeDiff ASC ) AS RowCountNo  
                     FROM  
                     (  
                           SELECT S.LastName + '', ''+ S.FirstName AS ''StaffName'',  
                                         AM.StartTime,  
                                         AM.EndTime,  
                                         CASE   
                                                WHEN DATEDIFF(MINUTE,@StartDateTime, AM.StartTime) < 0   
                                                THEN (-1) * DATEDIFF(MINUTE,@StartDateTime, AM.StartTime)   
                                                ELSE DATEDIFF(MINUTE,@StartDateTime, AM.StartTime)   
                                         END ''TimeDiff'',  
                                         AR.ResourceId,  
                                         AR.ResourceSubType  
                           FROM #AvailableResources AR   
                           INNER JOIN AppointmentMasterResources AMR ON AR.ResourceId=AMR.ResourceId  
                           INNER JOIN AppointmentMaster AM ON AM.AppointmentMasterId=AMR.AppointmentMasterId  
                           INNER JOIN AppointmentMasterStaff AMS ON AM.AppointmentMasterId=AMS.AppointmentMasterId  
                           INNER JOIN Staff S on S.StaffId=AMS.StaffId  
                           WHERE AMS.StaffId = @StaffId AND ISNULL(AMR.recorddeleted, ''N'') = ''N''  
        AND ISNULL(AM.recorddeleted, ''N'') = ''N''  
        AND ISNULL(AMS.recorddeleted, ''N'') = ''N''  
        AND ISNULL(S.recorddeleted, ''N'') = ''N''  
        AND CONVERT(VARCHAR(10), AM.StartTime, 101) = CONVERT(VARCHAR(10), @StartDateTime, 101)  
                     ) SubRecord   
              ) Main WHERE Main.RowCountNo = 1   
       ) Final ON AR.ResourceId = Final.ResourceId  
   
       -- STEP   
       -- Finally  get the available resources returned  
      -- SELECT  ResourceId,  
      --ResourceDisplay  
      --,StaffName,ClosestStartTime,ClosestEndTime       
      -- FROM #AvailableResources  Order by ClosestStartTime Asc  
        
       -- Add the existing resources for the Service   
      INSERT INTO #AvailableResources(ResourceId,ResourceDisplay,ResourceSubType)  
       SELECT RES.ResourceId, RES.DisplayAs,GSC.SubCodeName   
          FROM    Resources RES   
      Left Outer Join GlobalSubCodes GSC on RES.ResourceSubType=GSC.GlobalSubCodeId --and GSC.GlobalCodeId=RES.Type               
          WHERE   RES.ResourceType = @ResourceType  
           AND ISNULL(RES.recorddeleted, ''N'') = ''N''   
           AND ISNULL(GSC.recorddeleted, ''N'') = ''N''    
           AND ISNULL(RES.Active, ''Y'') = ''Y''  
      AND exists  (SELECT AMR.ResourceId  
                         FROM    AppointmentMaster AM Inner Join AppointmentMasterResources AMR  
        On AM.AppointmentMasterId = AMR.AppointmentMasterId  
                         WHERE   AM.ServiceID = @ServiceID 
							AND AMR.ResourceId=RES.ResourceId
							AND ISNULL(AMR.recorddeleted, ''N'') = ''N''  
							AND ISNULL(AM.recorddeleted, ''N'') = ''N'' ) 
	and not exists (select ResourceId from #AvailableResources AR where RES.ResourceId =AR.ResourceId)
         
         
       SELECT  ResourceId,  
      CASE   
                    WHEN ISNULL(StaffName,''N'') = ''N''  
                    THEN ResourceDisplay  + '' (''  
       + ISNULL(ResourceSubType,'''')   
       + '') ''  
                    ELSE  
      CASE WHEN ResourceSubType IS NULL THEN   
       ResourceDisplay  
       + '' (''   
       + StaffName  
       + '' ''   
       + ISNULL(CONVERT(VARCHAR,CAST(ClosestStartTime AS TIME),100),'''')  
       + '' - ''   
       + ISNULL(CONVERT(VARCHAR,CAST(ClosestEndTime AS TIME),100),'''')  
       + '')''  
       ELSE  
        ResourceDisplay  
       + '' (''  
       + ISNULL(ResourceSubType,'''')   
       + '') ''  
       + '' (''   
       + StaffName  
       + '' ''   
       + ISNULL(CONVERT(VARCHAR,CAST(ClosestStartTime AS TIME),100),'''')  
       + '' - ''   
       + ISNULL(CONVERT(VARCHAR,CAST(ClosestEndTime AS TIME),100),'''')  
       + '')''  
       END  
      END ''ResourceDisplay'',  
      ClosestStartTime,  
      ClosestEndTime,  
      ResourceSubType      
       FROM #AvailableResources  Order by case When ClosestStartTime IS NULL Then 1  
            Else 0 End,ClosestStartTime    
       -- STEP   
       -- Before existing clean up  
       DROP TABLE  #AvailableResources        
         
  END TRY         
                                               
  BEGIN CATCH                                 
  DECLARE @Error varchar(MAX)                                                                                  
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_GetAvailableResources'')                                                        
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                    
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                                                           
   RAISERROR                                                                                   
    (                                                 
  @Error, -- Message text.                                                                                  
  16, -- Severity.                                                                                  
  1 -- State.                                                                                  
    );              
 End CATCH                                                
         
   END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWDCalendarEvents]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWDCalendarEvents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

    
-- =============================================      
-- Author:  Kneale Alpers      
-- Create date: May 27, 2011      
-- Description: Pulls appointments for the wdcalendar      
-- Modified      
-- June 14, 2011 Kneale Alpers - Added staff list return      
-- Aug 23, 2011 Wasif Butt - Hide Service Title if staff doesn''t have access to client records and make it read only      
-- Jul 12, 2012 JHB - Removed Canceled, Error and Deleted Services      
-- Aug 07, 2012 Davinderk -  Added the new column status into select list per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Aug 08, 2012 Davinderk - Displayed status with subject as per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Aug 17, 2012 Davinderk - Check to IsNull(al.Subject,'''') as per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Aug 30, 2012 Davinderk - Added the new column ClientId,Comments into AppointmentList as per Task#-26 - Scheduling - Missing Client Name and Appointment Type on the Appointment - Primary Care - Summit Pointe      
-- Sep 14, 2012 Vishant Garg-Add condition ''PCAPPOINTMENTTYPE'' TO GET THE COLORS FOR APPOINTMENT STATUS TYPE AS per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Sep 19, 2012 Vishant Garg-Add Clkient Label AS per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Sep 20 2012 Vishant Garg-Add Condition to get the thpe for appointmentstatus    
-- Oct. 10 2012 Wasif Butt - Specific Location added to appointments    
-- 16 Nov 2012 Added By Mamta Gupta - Ref Task 61 - Primary Care - Bugs/Features - To Remove Rescheduled and Error appointments from Calendar    
-- 30/Nov/2012 Mamta Gupta  Ref Task 61 - Primary Care - Bugs/Features - Isnull check added for a.Status    
-- 21/Jan/2013  SunilKh  Added by Sunil for task 2618 (Threshold bugs/Featurs)check for procedurecodes    
-- 29 jan 2013  SunilKh  Revert the changes made for task 2618, As not showing Primary Care appointments on calendar. Now NotonCalendar will be handle through code      
-- =============================================      
CREATE PROCEDURE [dbo].[ssp_SCWDCalendarEvents]      
    @ViewType VARCHAR(15) , -- (''MULTISTAFF'', ''SINGLESTAFF'',''SELECTED'')                                                             
    @StartDate DATETIME ,      
    @EndDate DATETIME ,      
    @StaffList VARCHAR(MAX) ,      
    @LoggedInStaffId INT      
AS       
    BEGIN      
        CREATE TABLE #StaffIds      
            (      
              StaffId INT NOT NULL ,      
              SortOrder INT NOT NULL      
            )      
  CREATE TABLE #AppointmentList        
   (        
   AppointmentId int,              
            StaffId int,              
            Subject Varchar(250),              
            StartTime DateTime,              
            endtime DateTime,              
            AppointmentType int,              
            AppointmentTypeCodeName varchar(250),              
            AppointmentTypeDescription Text,              
            AppointmentTypeColor varchar(10),              
            Description text,              
            ShowTimeAs int,              
            ShowTimeAsCodeName varchar(250),              
            ShowTimeAsDescription Text,              
            ShowTimeAsColor varchar(10),              
            LocationId int,              
            ServiceId int,              
            LocationCode varchar(30),              
            LocationName varchar(100),              
            RecurringAppointment char(1),              
            RecurringAppointmentId int,              
            ReadOnly int,          
            DocumentId int,     
            GroupId int,      
            GroupServiceId int ,      
            RecurringGroupServiceId int,      
            STATUS int,    
            SpecificLocation varchar(250),    
      NotonCalendar char(1),           
            Resource varchar(max) null,        
            DataFrom varchar(15) null                
        )        
        IF @ViewType = ''MULTISTAFF''       
            BEGIN       
                INSERT  INTO #StaffIds      
                        ( StaffId ,      
          SortOrder       
                        )      
                        SELECT  a.staffid ,      
                                ROW_NUMBER() OVER ( ORDER BY s.lastName, s.firstName, a.StaffId ASC )      
                        FROM    dbo.MultiStaffViewStaff a      
                                JOIN staff s ON ( a.StaffId = s.StaffId )      
                        WHERE   MultiStaffViewId IN (      
                                SELECT  ids      
                                FROM    dbo.SplitIntegerString(@StaffList, '','') )      
                                AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''      
            END       
        ELSE       
            IF @ViewType = ''SELECTED''      
                OR @ViewType = ''SINGLESTAFF''       
                BEGIN       
                    INSERT  INTO #StaffIds      
                            ( StaffId ,      
                              SortOrder                                      
                            )      
                            SELECT  ids ,      
                                    ROW_NUMBER() OVER ( ORDER BY s.lastName, s.firstName, a.ids ASC )      
                            FROM    dbo.SplitIntegerString(@StaffList, '','') a      
                                    JOIN staff s ON ( a.ids = s.StaffId )      
                END       
            ELSE       
                BEGIN       
                    INSERT  INTO #StaffIds      
                            ( StaffId, SortOrder )      
                    VALUES  ( -1, 1 )      
                END ;      
        WITH    AppointmentList ( AppointmentId, StaffId, Subject, StartTime, endtime, AppointmentType, AppointmentTypeCodeName, AppointmentTypeDescription, AppointmentTypeColor, Description, ShowTimeAs, ShowTimeAsCodeName, ShowTimeAsDescription, ShowTimeAsColor, LocationId, ServiceId, LocationCode, LocationName, RecurringAppointment, RecurringAppointmentId, ReadOnly, DocumentId, GroupId, GroupServiceId, RecurringGroupServiceId,Status,ClientId,Comments, SpecificLocation,NotonCalendar )      
                  AS ( SELECT   a.AppointmentId ,      
                                a.staffid ,      
                                a.Subject ,      
                                a.StartTime ,      
                                a.endtime ,      
                                a.AppointmentType ,      
                  ISNULL(c.CodeName, '''') AS AppointmentTypeCodeName ,      
                                ISNULL(c.Description, '''') AS AppointmentTypeDescription ,      
                                ISNULL(c.color, '''') AS AppointmentTypeColor ,      
                                a.Description ,      
                                a.ShowTimeAs ,      
                                ISNULL(b.CodeName, '''') AS ShowTimeAsCodeName ,      
                                ISNULL(b.Description, '''') AS ShowTimeAsDescription ,      
                                ISNULL(b.color, '''') AS ShowTimeAsColor ,      
                                a.locationid ,      
                                a.ServiceId ,      
                                ISNULL(d.LocationCode, '''') AS LocationCode ,      
                                ISNULL(d.LocationName, '''') AS LocationName ,      
                                ISNULL(a.RecurringAppointment, ''N'') AS RecurringAppointment ,      
                                ISNULL(a.RecurringAppointmentId, 0) AS RecurringAppointmentId ,      
                                CASE WHEN ISNULL(serv.ServiceId, -1) = -1      
                                     THEN 0      
                                     ELSE CASE WHEN ISNULL(sc.ClientId, -1) <> -1      
                                               THEN 0      
                                               ELSE 1      
                                          END      
                                END AS READONLY ,      
                                ISNULL(doc.DocumentId, 0) ,      
                                ISNULL(gs.GroupId, 0) AS GroupId ,      
                                ISNULL(a.GroupServiceId, 0) AS GroupServiceId ,      
                ISNULL(a.RecurringGroupServiceId, 0) AS RecurringGroupServiceId,      
                                a.Status,      
                                a.ClientId,      
                                a.Description,      
                                a.SpecificLocation,    
                                Isnull(p.Notoncalendar,''N'') as  NotonCalendar     
                       FROM     #StaffIds s      
                                JOIN appointments a ON ( s.StaffId = a.StaffId )      
                                LEFT JOIN globalcodes b ON ( a.ShowTimeAs = b.GlobalCodeId      
                                                             AND b.Category = ''SHOWTIMEAS''      
                                                           )      
                                LEFT JOIN globalcodes c ON ( a.AppointmentType = c.GlobalCodeId      
                                                            -- AND c.Category = ''APPOINTMENTTYPE''      
                                                               AND (c.Category = ''APPOINTMENTTYPE'' OR c.Category=''PCAPPOINTMENTTYPE'')          
                                                            --ADDED BY VISHANT GARG      
                                                                  
                                                            -----      
                                                           )      
                                LEFT JOIN dbo.Locations d ON ( a.LocationId = d.LocationId )      
                                LEFT JOIN dbo.Services serv ON ( a.ServiceId = serv.ServiceId       
                                and isnull(serv.RecordDeleted,''N'') = ''N''      
                                and serv.status in (70, 71, 72, 75))       
                                LEFT JOIN dbo.Documents doc ON ( serv.ServiceId = doc.ServiceId )  -- Added by Rakesh w.r.f to task 413 in SC web phase II bugs/Features          
                                    
                                LEFT JOIN dbo.StaffClients sc ON ( sc.StaffId = @LoggedInStaffId      
                                                              AND serv.ClientId = sc.ClientId      
                                                              )     
                                --Added by Sunil for task 2618 (Threshold bugs/Featurs)    
                                LEFT JOIN dbo.procedurecodes p ON p.Procedurecodeid=serv.procedurecodeid      
                                LEFT JOIN dbo.GroupServices gs ON ( a.GroupServiceId = gs.GroupServiceId )      
                                       
                       WHERE    ( EndTime >= @StartDate      
                                  OR EndTime IS NULL      
                                )      
                                AND ( StartTime <= @EndDate )      
          -- JHB 7/12/2012 - Remove cancelled and error appointments and deleted services      
                                AND (a.ServiceId is null or (isnull(serv.RecordDeleted,''N'') = ''N''      
                                and serv.status in (70, 71, 72, 75)))     
                                     
           --Added By Mamta Gupta - Ref Task 61 - Primary Care - Bugs/Features - To Remove Rescheduled and Error appointments from Calendar    
                                and Isnull(a.Status,0) not in(8044,8045)    
                                AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''      
                     )      
            Insert Into #AppointmentList     
            SELECT  al.AppointmentId ,      
                    al.StaffId ,      
                    CASE WHEN al.ReadOnly = 1 THEN ''Exists''      
                         WHEN ISNULL(al.GroupServiceId, 0) <> 0      
                         THEN ''Group Service: ''      
                         + CAST(g.GroupName AS VARCHAR(100)) + '' (#''      
                              + CAST(al.GroupServiceId AS VARCHAR(100)) + '')''                                    
                         WHEN ISNULL(al.RecurringGroupServiceId, 0) <> 0      
                         THEN CASE WHEN ISNULL(al.GroupServiceId, 0) = 0      
                                   THEN ''Group Service Exists''      
                              END      
                         ELSE ISNULL(al.Subject,'''')        
                    END AS Subject ,        
                    al.StartTime ,      
                    al.endtime ,      
                    al.AppointmentType ,      
                    al.AppointmentTypeCodeName ,      
                    al.AppointmentTypeDescription ,      
                    al.AppointmentTypeColor ,      
                    al.Description ,      
                    al.ShowTimeAs ,      
                    al.ShowTimeAsCodeName ,      
                    al.ShowTimeAsDescription ,      
                    al.ShowTimeAsColor ,      
                    al.LocationId ,      
                    al.ServiceId ,      
                    al.LocationCode ,      
                    al.LocationName ,      
                    al.RecurringAppointment ,      
                    al.RecurringAppointmentId ,      
                    CASE WHEN ISNULL(al.RecurringGroupServiceId, 0) <> 0      
                         THEN CASE WHEN ISNULL(al.GroupServiceId, 0) = 0      
                                   THEN 1      
                              END      
                         ELSE al.ReadOnly      
                    END AS ReadOnly ,      
                    al.DocumentId ,      
                    al.GroupId ,      
                    al.GroupServiceId ,      
                    al.RecurringGroupServiceId,      
                    al.STATUS,    
                    al.SpecificLocation,    
     NotonCalendar,    
     '''' as Resource,        
     '''' as DataFrom              
            FROM    AppointmentList al      
                    LEFT JOIN dbo.Groups g ON al.GroupId = g.GroupId                           
            WHERE   ( ( al.RecurringAppointment = ''Y''      
                        AND al.RecurringAppointmentId > 0      
                      )      
                      OR al.RecurringAppointment = ''N''      
                    )      
            ORDER BY al.StartTime ,      
                    al.EndTime ,      
                    al.AppointmentId ;      
        
     Insert Into #AppointmentList        
        SELECT  AM.AppointmentMasterId AS AppointmentId ,              
                AMS.StaffId ,              
                ISNULL(AM.Subject,'''') AS Subject ,          
                AM.StartTime AS StartTime ,              
                AM.EndTime AS endtime ,              
                AM.AppointmentType AS AppointmentType ,              
                ISNULL(c.CodeName, '''') AS AppointmentTypeCodeName ,              
                ISNULL(c.Description, '''') AS AppointmentTypeDescription ,              
                ISNULL(c.color, '''') AS AppointmentTypeColor ,              
                AM.Description AS Description ,              
                AM.ShowTimeAs AS ShowTimeAs ,              
                ISNULL(b.CodeName, '''') AS ShowTimeAsCodeName ,              
                ISNULL(b.Description, '''') AS ShowTimeAsDescription ,              
                ISNULL(b.color, '''') AS ShowTimeAsColor ,              
                '''' AS LocationId ,         
                NULL AS ServiceId ,        
                '''' AS LocationCode ,              
    '''' AS LocationName ,                                             
                ''N'' AS RecurringAppointment ,              
                0 AS RecurringAppointmentId ,              
                0 AS ReadOnly,            
                '''' AS DocumentId,        
                0 AS GroupId ,      
                0 AS GroupServiceId ,      
   0 AS RecurringGroupServiceId,      
                null as STATUS,    
                '''' as SpecificLocation,    
    ''N'' as NotonCalendar,    
    '''' as Resource,        
    ''ResourceEvents'' as DataFrom                     
       FROM     AppointmentMasterStaff AMS              
                JOIN AppointmentMaster AM ON ( AMS.AppointmentMasterId = AM.AppointmentMasterId )              
                LEFT JOIN globalcodes b ON ( AM.ShowTimeAs = b.GlobalCodeId              
       AND b.Category = ''SHOWTIMEAS''              
                                           )              
                LEFT JOIN globalcodes c ON ( AM.AppointmentType = c.GlobalCodeId              
                                             AND c.Category = ''APPOINTMENTTYPE''              
                                           )                                                       
       WHERE    ( EndTime >= @StartDate              
                  OR EndTime IS NULL              
                )              
                AND ( StartTime <= @EndDate )           
             AND (AM.ServiceId is null )             
                AND ISNULL(AM.RecordDeleted, ''N'') <> ''Y''        
       ORDER BY AM.StartTime ,              
                    AM.EndTime ,              
     AM.AppointmentMasterId         
             
        
        
-- Update Resources where ServiceId is null             
  Update AP        
  Set AP.Resource=ltrim(ResourceWithService.DisplayAs)        
  From #AppointmentList AP Left Outer Join (Select AppointmentResourceList.AppointmentMasterId,case when AppointmentResourceList.DisplayAs is not null         
       then ''('' + AppointmentResourceList.DisplayAs + '')'' else AppointmentResourceList.DisplayAs end DisplayAs  From           
        ( Select AM.AppointmentMasterId,        
        REPLACE(REPLACE(STUFF(        
       (SELECT Distinct '', '' + RES.DisplayAs          
        From AppointmentMasterResources AMR Inner Join Resources RES on RES.ResourceId=AMR.ResourceId          
       Where AM.AppointmentMasterId=AMR.AppointmentMasterId         
        And isNull(AMR.RecordDeleted,''N'')<>''Y''          
        And isNull(RES.RecordDeleted,''N'')<>''Y''            
       FOR XML PATH(''''))        
       ,1,1,'''')        
       ,''&lt;'',''<''),''&gt;'',''>'')''DisplayAs''        
          From #AppointmentList RS Inner Join AppointmentMaster AM ON RS.AppointmentId=AM.AppointmentMasterId           
        and RS.DataFrom=''ResourceEvents''         
          Where isNull(AM.RecordDeleted,''N'')<>''Y''             
          ) AppointmentResourceList          
        ) ResourceWithService on (AP.AppointmentId=ResourceWithService.AppointmentMasterId          
        and AP.DataFrom=''ResourceEvents'')        
        
-- Update Resources where ServiceId is available             
  Update AP        
  Set AP.Resource= ltrim(ResourceWithService.DisplayAs)        
  From #AppointmentList AP Left Outer Join (Select AppointmentResourceList.ServiceId,case when AppointmentResourceList.DisplayAs is not null         
       then ''('' + AppointmentResourceList.DisplayAs + '')'' else AppointmentResourceList.DisplayAs end DisplayAs  From           
        ( Select AM.AppointmentMasterId,AM.ServiceId,        
        REPLACE(REPLACE(STUFF(        
       (SELECT Distinct '', '' + RES.DisplayAs          
        From AppointmentMasterResources AMR Inner Join Resources RES on RES.ResourceId=AMR.ResourceId          
       Where AM.AppointmentMasterId=AMR.AppointmentMasterId         
        And isNull(AMR.RecordDeleted,''N'')<>''Y''          
        And isNull(RES.RecordDeleted,''N'')<>''Y''            
       FOR XML PATH(''''))        
       ,1,1,'''')        
       ,''&lt;'',''<''),''&gt;'',''>'')''DisplayAs''        
          From #AppointmentList RS Inner Join AppointmentMaster AM ON RS.ServiceId=AM.ServiceId            
          Where isNull(AM.RecordDeleted,''N'')<>''Y''            
          ) AppointmentResourceList          
        ) ResourceWithService on AP.ServiceId=ResourceWithService.ServiceId where AP.DataFrom <> ''ResourceEvents''                                
               
       SELECT AppointmentId ,              
            StaffId ,              
            Subject ,              
            StartTime ,              
            endtime ,              
            AppointmentType ,              
            AppointmentTypeCodeName,              
            AppointmentTypeDescription ,              
            AppointmentTypeColor,              
            Description ,              
            ShowTimeAs ,              
            ShowTimeAsCodeName ,              
            ShowTimeAsDescription ,              
            ShowTimeAsColor ,              
            LocationId ,              
            ServiceId ,              
            LocationCode ,              
            LocationName ,              
            RecurringAppointment ,              
            RecurringAppointmentId ,              
            ReadOnly ,          
            DocumentId ,     
            GroupId ,      
            GroupServiceId  ,      
            RecurringGroupServiceId ,      
            STATUS ,    
            SpecificLocation,    
      NotonCalendar ,           
            Resource ,        
            DataFrom               
    FROM #AppointmentList    
        
        
        SELECT  a.StaffId ,      
                LTRIM(RTRIM(a.LastName)) + '', '' + LTRIM(RTRIM(a.FirstName)) AS StaffName ,      
                CASE WHEN a.StaffId = @LoggedInStaffId THEN 1      
                     ELSE 1      
                END AS CanSchedule      
        FROM    #StaffIds s      
                JOIN Staff a ON ( s.StaffId = a.StaffId )      
        ORDER BY s.SortOrder      
      
    END       
      
    
    

' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCListPageMyServices]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageMyServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


         
                                    
Create procedure [dbo].[ssp_SCListPageMyServices]    
@SessionId varchar(30),                                                    
@InstanceId int,                                                    
@PageNumber int,                                                        
@PageSize int,                                                        
@SortExpression varchar(100),                                                    
@varStaffId int,                                                                    
@DOSFrom datetime = null,                                                                    
@DOSTo datetime = null,                                         
@ClientFilter int,  -- 0 (All Clients) - default, 1 (only clients where staffId is primaryClinicianId), 2 (only clients where staffId is not primaryClinicianId)                                         
@StatusFilter int,                                        
@ProcedureFilter int,                                        
@DateFilter int,                                        
@ProgramFilter int,                                                                   
@ServiceFilter int ,                                                
@OtherFilter int ,            
@LoggedInStaffId int                                                   
/********************************************************************************                                                    
-- Stored Procedure: dbo.ssp_SCListPageMyServices                                                      
--                                                    
-- Copyright: Streamline Healthcate Solutions                                                    
--                                                    
-- Purpose: used by MyServices list page                                                    
--                                                    
-- Updates:                                                                                                           
-- Date        Author            Purpose                                                    
-- 01.21.2010  Sweety Kamboj     Created.                                                          
-- Modified By Damanpreet Kaur 07.17.2010 as per Filters Problem modify the Services Filter              
-- Modified By Mahesh S         Set null as NumberOfTimesCancelled in place of '''' as NumberOfTimesCancelled as '''' take 0 as default                         -- 23 May 12   Sudhir Singh       get the services having signed document for status filter value  
  
187                          
--14Aug2012  Shifali   show status of service signed if service.status = show and document.status = sign (Task# 1799, project Thresholds Buges/Feature)    
--29Aug2012  Vikas     Added Filter condition documentstatus<>22 In Status Filter 186 w.r.t. Task#1866 (Threshold phase III Buges)
--31Aug2012	 Shifali	Modified - When Filter = "signed" (187), then show services where status = 71 and not is signed (Discussion with SHS - task# 1866 (Thresholds Bugs/Features)
--28Dec2012	 Maninder	   Added Groups.RecordDeleted and GroupServices.RecordDeleted check
--18Jan2013	 Maninder	   Added Logic for opening of service list page from dashboard documents widget
--28Feb2013	 Rahul Aneja   Added GroupId and GroupServiceId ref task#2808 in Thresholds Bugs and Features ,why:when sorting the list page Data GroupId and GroupServiceId is not returning 
*********************************************************************************/                                                    
as                                                    
                                                                                                                  
create table #ResultSet(                                           
RowId int identity(1,1),                           
RowNumber  int,                                                    
PageNumber      int,                                        
ClientId  int,                                        
ClientName  varchar(100),                                        
AuthorizationsRequested char(3),                                        
DateOfService datetime,                                        
ServiceId  int,                                        
[DocumentId] int,                                        
[ProcedureCodeName] varchar(100),                                        
ProgramName varchar(100),                                        
[Status]    varchar(50),                                        
GroupName  varchar(100),                                        
Comment    ntext,                    
NumberOfTimesCancelled int,                                         
ErrorMessage varchar(max),                    
GroupId int,                    
GroupServiceId int, 
ScreenId int,                
ResourceNameDisplayAs varchar(100)            
                                     
)                                        
declare @CustomFiltersApplied char(1)                                          
declare @CustomFilters table (ServiceId int)                                                    
declare @Today datetime                                       
declare @ApplyFilterClicked char(1)                
--                    
-- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                                                    
--              
if @PageNumber > 0 and exists(select * from ListPageSCMyServices where SessionId = @SessionId and InstanceId = @InstanceId)                                                     
                                        
begin                                                    
  set @ApplyFilterClicked = ''N''                                                    
  goto GetPage                                                    
end                                           
                                                    
--                                                    
-- New retrieve - the request came by clicking on the Apply Filter button                                                               
--                                                   
set @ApplyFilterClicked = ''Y''                                                    
set @PageNumber = 1                                                                          
set @Today = convert(char(10), getdate(), 101)                                                    
set @CustomFiltersApplied = ''N'' 
 
IF (@ClientFilter>10000 or @StatusFilter>10000 or @ProcedureFilter>10000 or @DateFilter>10000 or @ProgramFilter>10000 or @ServiceFilter>10000 or @OtherFilter>10000)
BEGIN        
             
	EXEC scsp_SCListPageMyServices @varStaffId, @DOSFrom, @DOSTo, @ClientFilter, @StatusFilter, @ProcedureFilter, @DateFilter, @ProgramFilter, @ServiceFilter, @OtherFilter, @LoggedInStaffId

	IF EXISTS ( select 1 from #ResultSet ) 
		SET @CustomFiltersApplied = ''N''                             
	ELSE 
		SET @CustomFiltersApplied = ''Y''                             
END    

IF(@CustomFiltersApplied=''N'')
BEGIN
                                                    
insert into #ResultSet(                                          
ClientId,                                        
ClientName,                                        
AuthorizationsRequested,                                        
DateOfService,                                        
ServiceId,                                        
[DocumentId],                                        
[ProcedureCodeName],                                        
ProgramName,                                        
[Status],                                        
GroupName,                                        
Comment,-- as Comment                                        
NumberOfTimesCancelled,                                         
ErrorMessage,                    
GroupId,                    
GroupServiceId,
ScreenId,  
ResourceNameDisplayAs	                                        
                                               
)                                        
                                             
select                                                
C.ClientID ,                                          
convert(varchar(50),rtrim(C.Lastname)) +'', ''+ convert(varchar(50),rtrim(C.Firstname)) as ClientName ,                                                       
--case                                                                    
--when S.AuthorizationsRequested like ''N'' then ''NO''                                                                    
--when S.AuthorizationsRequested like ''Y'' then ''Yes''                                                                    
--when S.AuthorizationsRequested is Null then ''''                                                  
--end                                                                    
--as AuthorizationsRequested,                  
case when isnull(S.AuthorizationsNeeded, 0) = 0 then '' ''                                      
when isnull(S.AuthorizationsNeeded, 0)=isnull(S.AuthorizationsApproved, 0) then ''Yes''                                               
when isnull(S.AuthorizationsNeeded, 0)<> isnull(S.AuthorizationsApproved, 0) and isnull(S.AuthorizationsRequested, 0) >0 then ''Req''                                            
when isnull(S.AuthorizationsNeeded, 0)<> isnull(S.AuthorizationsApproved, 0)and isnull(S.AuthorizationsRequested, 0) =0 then ''No''               
end                                     
as AuthorizationsRequested,              
S.DateOfService as DateOfService,                                        
S.ServiceId,                                          
convert(int,D.DocumentId) as [DocumentId],                
case                                                            
when len(PC.DisplayAs)< 20  then Rtrim(PC.DisplayAs)                                  
 else (SUBSTRING(Rtrim(PC.DisplayAs),0,17)+''...'')          
end +                                  
Case When PC.AllowDecimals=''Y'' then '' ''+CAST(isnull(S.Unit,'''') AS VARCHAR(10))+'' ''+SUBSTRING(isnull(GC1.CodeName,''''),0,4)                                   
 else '' ''+Cast(CAST(isnull(S.Unit,'''') AS Decimal) as Varchar(10)) +'' ''+SUBSTRING(isnull(GC1.CodeName,''''),0,4)                                                              
end as ProcedureCodeName,                               
isnull(P.ProgramName,'''') as ProgramName,                                                                                                  
/*isnull(GC.CodeName,'''') + rtrim(isnull( '' (''+rtrim(Glo.CodeName)+ '')'','''')) as [Status],*/    
/*CASE WHEN S.GroupServiceId IS NULL     
 THEN */
 CASE WHEN D.CurrentVersionStatus = 22 AND S.Status = 71 THEN GCD.CodeName ELSE GC.CodeName END  -- If d.Status=Signed and S.Status=Show    
 /*ELSE dbo.SCGetGroupServiceStatusName(S.GroupServiceId)    
END*/
 AS Status,                                                  
IsNull(Groups.GroupName,'''') as ''GroupName'',                                          
isnull(S.Comment,'''') as Comment, null as NumberOfTimesCancelled, --Old syntax is '''' as NumberOfTimesCancelled  so it will take 0 as default            
dbo.getServiceErrors(s.ServiceId) as ''ErrorMessage'',                    
GroupServices.GroupId,                    
GroupServices.GroupServiceId,      
Scr.ScreenId,  
'''' as ResourceNameDisplayAs                                                
from Services S                   
join Clients C on S.ClientId=C.ClientId                 
 join StaffClients sc on sc.StaffId = @LoggedInStaffId and sc.ClientId = c.ClientId                  
join ProcedureCodes PC on S.ProcedureCodeId=PC.ProcedureCodeId                                                                           
join Programs P on P.ProgramId=S.ProgramId                                                                           
left join Documents D on D.ServiceId = S.ServiceId  and isNull(D.RecordDeleted,''N'')<>''Y''                      
left outer join GroupServices on S.GroupServiceId=GroupServices.GroupServiceId                      
left outer join Groups ON GroupServices.GroupId=Groups.GroupId                                                                                
left join DocumentCodes DC on D.DocumentCodeID = Dc.DocumentCodeID and DC.DocumentCodeID  in (select DocumentCodeId from  DocumentCodes where ServiceNote = ''Y'')                                    
left join Screens Scr on Dc.DocumentCodeID=Scr.DocumentCodeId	
left join GlobalCodes GC on (GC.GlobalCodeId=S.Status and GC.Category =''SERVICESTATUS'')                                
left join GlobalCodes GLo on (GLo.GlobalCodeID = S.CancelReason and GLo.Category =''CancelReason'')                                                         
left join GlobalCodes GC1 on (GC1.GlobalCodeId = S.UnitType and GC1.Category Like ''UNITTYPE'')                                                                   
LEFT JOIN GlobalCodes GCD ON GCD.GlobalCodeId = D.CurrentVersionStatus                                                                   
where S.ClinicianId = @varStaffId                                                
and isNull(S.RecordDeleted,''N'')<>''Y''                                                                        
and isNull(C.RecordDeleted,''N'')<>''Y''                                                                       
and isnull(Groups.RecordDeleted,''N'')<>''Y''       -- Added by Maninder: don''t show deleted groups services 
and isnull(GroupServices.RecordDeleted,''N'')<>''Y'' -- Added by Maninder: don''t show deleted groups services                                        
and (S.ProgramId=@ProgramFilter or (isnull(@ProgramFilter, -1) = -1) )-- -1 For All Programs                                                            
and (S.ProcedureCodeId=@ProcedureFilter or (isnull(@ProcedureFilter, 0) = 0))-- 0 For All ProcedureCode                                                            
and (@DOSFrom is null or S.DateOfService >= @DOSFrom)                                     
and (@DOSTo is null or S.DateOfService < dateadd(dd, 1, @DOSTo))                                                            
          
--Services Filter                 
--Modified by Damanpreet Kaur           
               
and((@ServiceFilter = -1 and        
exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId  and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76))                 
)        
or  @ServiceFilter = 0                                           
--or (@ServiceFilter = 216 and exists (select ServiceId from ServiceErrors SE where S.ServiceId = SE.ServiceId and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)                
--)        
--)                 
          
or  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = @ServiceFilter and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76))          
          
--or (@ServiceFilter = 190 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4401 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                   
--or (@ServiceFilter = 191 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4402 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                      
  
    
      
        
            
            
              
                 
--or (@ServiceFilter = 192 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4403 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                       
  
    
      
        
            
            
              
                
--or (@ServiceFilter = 193 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4404 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                       
  
    
      
        
         
              
                
--or (@ServiceFilter = 194 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4405 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                       
  
    
      
        
           
             
              
                
--or (@ServiceFilter = 195 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4406 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)                
--))                                         
--or (@ServiceFilter = 196 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4407 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                       
  
    
      
        
            
            
              
                
--or (@ServiceFilter = 197 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4408 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                       
  
    
      
        
            
            
              
                
--or (@ServiceFilter = 198 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4409 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                       
  
    
      
        
            
            
              
                
--or (@ServiceFilter = 199 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 4410 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))              
      
        
            
            
              
                
--or (@ServiceFilter = 200 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 10934 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                      
 
     
      
        
            
            
              
                 
--or (@ServiceFilter = 201 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11018 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                      
  
    
      
        
            
            
              
                 
--or (@ServiceFilter = 202 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11019 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 203 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11047 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 204 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11048 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 205 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11088 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 206 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11089 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 207 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11090 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 208 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11092 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 209 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11093 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 210 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11132 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 211 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11199 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 212 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11225 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 213 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11466 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 214 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11505 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                
--or (@ServiceFilter = 215 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11552 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                      
  
    
      
        
            
            
--or (@ServiceFilter = 415 and  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = 11880 and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,''N'')=''N'' and s.status not in (75, 72, 73, 76)))                      
  
    
      
        
            
              
)                                       
--and (                          
--    @ServiceFilter = 0 or -- All Service                          
--    @ServiceFilter = 217 -- All Services                                                                   
--or (@ServiceFilter = 216 and exists (select ServiceId from ServiceErrors SE where S.ServiceId = SE.ServiceId)) --Services with Errors                                                                   
--or ((@ServiceFilter >= 190 and @ServiceFilter <= 215) and exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = @ServiceFilter)))                                                            
                                        
-------------StatusFilter                                        
and (                          
 @StatusFilter = 0 or -- All Statuses                           
 @StatusFilter = 184 or -- All Statuses                                                    
(@StatusFilter = 185 and S.Status = 70) or -- Sheduled                          
(@StatusFilter = 186 and S.Status in(70,71) AND D.CurrentVersionStatus <> 22) or -- show and sheduled                                        
(@StatusFilter = 188 and S.Status in(72,73)) or -- Cancel or not show                                        
(@StatusFilter = 189 and S.Status = 75) or -- Complete    
 (@StatusFilter = 187 and S.Status in (71) and D.CurrentVersionStatus = 22)  -- signed document --added by sudhir singh                                   
                                               
    )                                        
                                              
 ------------ClientFilter                                        
  and(                          
   @ClientFilter=0 or ---All Client                                        
   @ClientFilter=98 or ---All Client                                        
  (@ClientFilter =99 and C.PrimaryClinicianId=@varStaffId ) or -- primary clients                                        
  (@ClientFilter=100 and C.PrimaryClinicianId <> @varStaffId )-- no primary                                        
  )                                         
                                          
END                       
                                             
---- Apply custom filters                            
--if @OtherFilter > 10000                                                    
                                        
--begin                                                    
--  insert into @CustomFilters (ServiceId)                                                    
--  exec scsp_SCListPageMyServices  @OtherFilter = @OtherFilter                                  
                                       
--  delete d                                                    
--    from #ResultSet d     where not exists(select * from @CustomFilters f where f.ServiceId = d.ServiceId)                                                    
--end                                         
              
                                                  
                                                  
GetPage:                                                    
                                                    
--                                                    
-- If the sort expression has changed, resort the data set, otherwise goto Final and retrieve the page                         
--                                                    
                                                    
if @ApplyFilterClicked = ''N'' and exists(select * from ListPageSCMyServices where SessionId = @SessionId and InstanceId = @InstanceId and SortExpression = @SortExpression)                                                    
  goto Final                                                    
                                             
set @PageNumber = 1                                                    
                                                    
if @ApplyFilterClicked = ''N''                                                    
begin                                                    
  insert into #ResultSet(                                                    
ClientId,                                        
ClientName,                                        
AuthorizationsRequested,                                        
DateOfService,                                        
ServiceId,                                        
[DocumentId],                                        
[ProcedureCodeName],                                        
ProgramName,                                        
[Status],                                        
GroupName,                                        
Comment,-- as Comment                                        
NumberOfTimesCancelled,                                         
ErrorMessage,
GroupId,     -- added by Rahul Aneja ref task#2808 in Threshold Bugs and Featu                  
GroupServiceId,       -- added by Rahul Aneja ref task#2808 in Threshold Bugs and Featu       
ScreenId,  
ResourceNameDisplayAs                             
)                                                                                         
SELECT                                        
ClientId,                                        
ClientName,                                        
AuthorizationsRequested,                                        
DateOfService,                                        
ServiceId,                                        
[DocumentId],                                        
[ProcedureCodeName],                                        
ProgramName,                                        
[Status],                                        
GroupName,                                        
Comment,-- as Comment                                        
NumberOfTimesCancelled,                                         
ErrorMessage ,
GroupId,     -- added by Rahul Aneja ref task#2808 in Threshold Bugs and Features                    
GroupServiceId,     -- added by Rahul Aneja ref task#2808 in Threshold Bugs and Features  
ScreenId,  
'''' as ResourceNameDisplayAs                                                                                                
FROM ListPageSCMyServices                                                    
where SessionId = @SessionId                                                    
and InstanceId = @InstanceId   

Update R      
Set R.ResourceNameDisplayAs= ResourceWithService.DisplayAs      
From #ResultSet R Left Outer Join (Select AppointmentResourceList.ServiceId,AppointmentResourceList.DisplayAs From       
         ( Select AM.AppointmentMasterId,AM.ServiceId,RES.DisplayAs,       
           ROW_NUMBER()OVER(PARTITION BY AM.AppointmentMasterId  ORDER BY RES.DisplayAs ASC ) AS RowCountNo        
           From #ResultSet RS Inner Join AppointmentMaster AM ON RS.ServiceId=AM.ServiceId       
              Inner Join AppointmentMasterResources AMR On  AMR.AppointmentMasterId=AM.AppointmentMasterId       
              Inner Join Resources RES on RES.ResourceId=AMR.ResourceId      
              Where isNull(AM.RecordDeleted,''N'')<>''Y''       
              And isNull(AMR.RecordDeleted,''N'')<>''Y''      
              And isNull(RES.RecordDeleted,''N'')<>''Y''      
              ) AppointmentResourceList  Where AppointmentResourceList.RowCountNo=1      
         ) ResourceWithService on R.ServiceId=ResourceWithService.ServiceId                                                    
                                        
end                                                    
                                            
                                     
update d                                                    
   set RowNumber = rn.RowNumber,                                                    
       PageNumber = (rn.RowNumber/@PageSize) + case when rn.RowNumber % @PageSize = 0 then 0 else 1 end                                                    
  from #ResultSet d                                                    
       join (select RowId,                                                  
                    row_number() over (order by case when @SortExpression= ''ClientId'' then ClientId end,                                              
                                                case when @SortExpression= ''ClientId desc'' then ClientId end desc,                                                    
                                                case when @SortExpression= ''AuthorizationsRequested'' then AuthorizationsRequested end,                                                        
                                                case when @SortExpression= ''AuthorizationsRequested desc'' then AuthorizationsRequested end desc,                                                     
                           case when @SortExpression= ''ClientName'' then ClientName end,                                                        
                                                case when @SortExpression= ''DateOfService'' then DateOfService end,                                                        
                                                case when @SortExpression= ''DateOfService desc'' Then DateOfService end desc,                                                    
                                                case when @SortExpression= ''ProcedureCodeName'' then [ProcedureCodeName] end,                                                        
                                                case when @SortExpression= ''ProcedureCodeName desc'' then [ProcedureCodeName] end desc,                                                    
                                                case when @SortExpression= ''ProgramName'' then ProgramName end,                                                        
                                                case when @SortExpression= ''ProgramName desc'' then ProgramName end desc,                                          
                                                case when @SortExpression= ''Status'' then Status end,                                                   
                                                case when @SortExpression= ''Status desc'' then Status end desc,                                         
                                                case when @SortExpression= ''GroupName'' then GroupName end,                                                        
                                                case when @SortExpression= ''GroupName desc'' then GroupName end desc,                     
                                                case when @SortExpression= ''Comment'' then cast(Comment as varchar(500)) end,                                                        
                                                case when @SortExpression= ''Comment desc'' then cast(Comment as varchar(500)) end desc,                                         
                                                case when @SortExpression= ''NumberOfTimesCancelled'' then NumberOfTimesCancelled end,                                                        
                                                case when @SortExpression= ''NumberOfTimesCancelled desc'' then NumberOfTimesCancelled end desc,                                         
                                                case when @SortExpression= ''ErrorMessage'' then ErrorMessage end,                                                        
                                       case when @SortExpression= ''ErrorMessage desc'' then ErrorMessage end desc,   
                                       case when @SortExpression= ''ResourceNameDisplayAs'' then ResourceNameDisplayAs end,                                                                  
                                                case when @SortExpression= ''ResourceNameDisplayAs desc'' then ResourceNameDisplayAs end desc                                                         
                                                ) as RowNumber                      
										from #ResultSet) rn on rn.RowId = d.RowId                                                       
                                                                                                    
                                                   
                                                    
delete from ListPageSCMyServices                                                    
 where SessionId = @SessionId                                                    
   and InstanceId = @InstanceId                                                    
                                               
                                                    
insert into ListPageSCMyServices(                                         
SessionId,                                                            
InstanceId,                                                            
RowNumber,                                                            
PageNumber,                                                            
SortExpression,                                                    
ClientId,                                        
ClientName,                                        
AuthorizationsRequested,                                        
DateOfService,                                        
ServiceId,                                        
[DocumentId],                                        
[ProcedureCodeName],                                        
ProgramName,                        
[Status],                                        
GroupName,                                        
Comment,-- as Comment                                  
NumberOfTimesCancelled,                                         
ErrorMessage,                    
GroupId,                    
GroupServiceId,
ScreenId                                                
)                                         
                                                   
select                                         
@SessionId,                                                            
@InstanceId,                                                            
RowNumber,                                                            
PageNumber,                                                            
@SortExpression,                                        
ClientId,                                        
ClientName,                                        
AuthorizationsRequested,                                        
DateOfService,                                        
ServiceId,                                        
[DocumentId],                                        
[ProcedureCodeName],                                        
ProgramName,                                        
[Status],                                        
GroupName,                                        
Comment,-- as Comment                                        
NumberOfTimesCancelled,                                   
ErrorMessage,                    
GroupId,                    
GroupServiceId,
ScreenId                                                       
from #ResultSet                                                     
                                                    
                                                
Final:                                         
                                        
                                                   
                                                    
select @PageNumber as PageNumber, isnull(max(PageNumber), 0) as NumberOfPages, isnull(max(RowNumber), 0) as NumberOfRows                                                    
  from ListPageSCMyServices                                                    
  where SessionId = @SessionId                                                    
   and InstanceId = @InstanceId                                                    
                                                    
select                  
ClientId,                                        
ClientName,                                        
AuthorizationsRequested,                                        
DateOfService,                                        
ListPageSCMyServices.ServiceId,                                        
[DocumentId],                                        
[ProcedureCodeName],                                        
ProgramName,                                        
[Status],                                        
GroupName,                                        
Comment,-- as Comment                                        
NumberOfTimesCancelled,                   
ErrorMessage,                    
GroupId,                    
GroupServiceId,
ScreenId, 
ISnull(ResourceWithService.DisplayAs,'''') as ResourceNameDisplayAs                                                    
  from ListPageSCMyServices  Left Outer Join (Select AppointmentResourceList.ServiceId,AppointmentResourceList.DisplayAs From       
         ( Select AM.AppointmentMasterId,AM.ServiceId,RES.DisplayAs,       
           ROW_NUMBER()OVER(PARTITION BY AM.AppointmentMasterId  ORDER BY RES.DisplayAs ASC ) AS RowCountNo        
           From ListPageSCMyServices RS Inner Join AppointmentMaster AM ON RS.ServiceId=AM.ServiceId       
              Inner Join AppointmentMasterResources AMR On  AMR.AppointmentMasterId=AM.AppointmentMasterId       
              Inner Join Resources RES on RES.ResourceId=AMR.ResourceId      
              Where isNull(AM.RecordDeleted,''N'')<>''Y''       
              And isNull(AMR.RecordDeleted,''N'')<>''Y''      
              And isNull(RES.RecordDeleted,''N'')<>''Y''      
              ) AppointmentResourceList  Where AppointmentResourceList.RowCountNo=1      
         ) ResourceWithService on ListPageSCMyServices.ServiceId=ResourceWithService.ServiceId                                                   
 where SessionId = @SessionId                                                    
   and InstanceId = @InstanceId                
   and PageNumber = @PageNumber                                                    
 order by RowNumber 


' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetServiceNoteDocumentData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


 CREATE Procedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]                                                                                           
(                                                                                                                                                                                  
 @DocumentID int,                                                                                                                                                                                  
 @Version  int,                                                                                                                                                                                  
 @ServiceId int,                                                                                                                                                                         
 @DocumentCodeId int,                                                                                                                                                                                  
 @Mode varchar(10),
 @AuthorId int,                                              
 @CustomStoredProcedure varchar(100),                                              
 @DocumentVersionId int,                                              
 @FillCustomTablesData AS CHAR(1)=''Y''                                              
)                                                                                                                                                                                  
As                                                                                                                                                                                  
/*********************************************************************                                                                                                  
-- Stored Procedure: dbo.ssp_SCGetServiceNoteDocumentData                                                                                                  
--                                                                                                  
-- Copyright: 2005 Provider Claim Management System                                                                                                  
--                                                                                                  
-- Creation Date:  01/02/2010                                                                                                  
--                                                                                                  
-- Purpose: Gets Service Note  Values                                                                                                  
--                                                                                                                                                                                                 
-- Data Modifications:                                                                                                  
--                                                                                                  
-- Updates:                                                                                                  
-- Date            Author              Purpose                                                                                                  
   1st  Feb-2010   Vikas Vyas          Get Service Note Data                                   */                                                 
/*13Oct2011		   Shifali			   Added Column ClientLifeEventId,AuthorId,RevisionNumber                      */
/*3 Jan, 2012	   Davinder Kumar	   Added AuthorId                      */
/*29/March/2012    Rohit Katoch        Added Column  Prescriber             */
/*10/Apr/2012      Rohit Katoch        Remove Column  Prescriber  */
/*17/Apr/2012      Shifali			   Added Column  SpecificLocation   */
/*2/May/2012       Maninder			   Changed  Documents.CurrentDocumentVersionId to Documents.InProgressDocumentVersionId=DocumentVersions.DocumentVersionId in join condition to pick @Version   */
/*8/June/2012	   Shifali		       Added Column Appointments.RecurringOccurrenceIndex as per DM Change from 11.49 to 11.50 (Core Version)*/
/*10aug2012		   Shifali         	   Added Column SavedStatus table Services (Merge of task# 1533 from 3.5x (Thresholds Bugs/Feature)*/
/*28Sep2012		   Rahul Aneja		   Added new column into table Appointments.SpecificLocation */
/*01Oct2012		   Sudhir Singh		Remove the CustomFieldsData Table from the Sp*/
/*25.10.2012	   Sanjayb          Merge from 2.x to 3.5xMerge By Sanjayb - Ref Task No. 259 SC Web Phase II - Bugs/Features -13-July-2012 - Document Version Views:  Refresh repository PDF*/				
/*26/Oct/2012	   Mamta Gupta		Added new column into table Appointments.NumberofTimeRescheduledTo Count no of appointment rescheduling. Task No. 35 Primary Care - Summit Pointe */									
/*12.12.2012       Rakesh Garg      W.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId for avoiding concurrency issues*/									
/*17Apr2013		   Pradeepa			Added AppointmentMaster,AppointmentMasterResources table.
/**********************************************************************/ */                                                                                                                         
BEGIN TRY                                                                                         
            
--Changes by sonia Ref Task #701                               
Declare @DocumentType int                                      
             
Select @DocumentType=DocumentType                     
from DocumentCodes                                                  
where DocumentCodeId=@DocumentCodeId                                                  
--Changes end over here                                                           
                                            
if(@ServiceId=-1)                                                            
begin                                   
 Select @ServiceId = ServiceID from Documents where DocumentID = @DocumentID                                                                       
end                                            
                                                                                              
if(@Version=-1)                                                                                                     
begin                                                                                            
 --Select @Version = CurrentVersion from Documents where DocumentID = @DocumentID                                                                                                                                                        
 if Exists (select DocumentVersions.Version from documents inner join DocumentVersions on Documents.CurrentDocumentVersionId=DocumentVersions.DocumentVersionId  where Documents.DocumentId=@DocumentID              
and ISNULL(Documents.RecordDeleted,''N'')<>''Y'')            
 Begin            
  --Code Commented by Maninder: for task#748 in Threshold Bugs/Feature    
-- Select @Version = DocumentVersions.Version from documents inner join DocumentVersions on Documents.CurrentDocumentVersionId=DocumentVersions.DocumentVersionId  where Documents.DocumentId=@DocumentID                
--and ISNULL(Documents.RecordDeleted,''N'')<>''Y''          
Select @Version = DocumentVersions.Version from documents inner join DocumentVersions on Documents.InProgressDocumentVersionId=DocumentVersions.DocumentVersionId  where Documents.DocumentId=@DocumentID                
and ISNULL(Documents.RecordDeleted,''N'')<>''Y''            
 End            
 else            
set @Version=-1            
             
 Select @DocumentVersionId=DocumentVersionId from DocumentVersions where DocumentID = @DocumentID              
 and Version=@Version                                        
                                 
end                                                                                                                                                 
                                                                                                                                                    
 SELECT [ServiceId]                                                
      ,[ClientId]                                                
      ,[GroupServiceId]                                                
      ,[ProcedureCodeId]                                                
      ,[DateOfService]                                                
      ,[EndDateOfService]                                                
      ,[RecurringService]                                                
      ,[Unit]                                                
      ,[UnitType]                                                
      ,[Status]                                                
      ,[CancelReason]                                                
      ,[ProviderId]                                                
      ,[ClinicianId]                                                
      ,[AttendingId]                                                
      ,[ProgramId]                                                
      ,[LocationId]                                                
      ,[Billable]                                                
      ,[DiagnosisCode1]                                                
      ,[DiagnosisNumber1]                                                
      ,[DiagnosisVersion1]                                                
      ,[DiagnosisCode2]                                                
      ,[DiagnosisNumber2]                                                
      ,[DiagnosisVersion2]                                                
      ,[DiagnosisCode3]                                                
      ,[DiagnosisNumber3]                                             
      ,[DiagnosisVersion3]                                                
      ,[ClientWasPresent]                        
 ,[OtherPersonsPresent]                                       
      ,[AuthorizationsApproved]            
      ,[AuthorizationsNeeded]                                                
      ,[AuthorizationsRequested]                                                
      ,[Charge]                                                
      ,[NumberOfTimeRescheduled]                                                
      ,[NumberOfTimesCancelled]                                                
 ,[ProcedureRateId]                                                
      ,[DoNotComplete]                                                
      ,Services.[Comment]                                                
      ,[Flag1]                                                
      ,[OverrideError]                                                
      ,[OverrideBy]                                                
      ,[ReferringId]                                                
      --,DateOfService as DateTimeIn                                               
      --,EndDateOfService as DateTimeOut                           
       ,DateTimeIn                                               
       ,DateTimeOut                           
      ,[NoteAuthorId]                                               
      --,Services.[RowIdentifier]                                    
      --,Services.[ExternalReferenceId]                                                
      ,Services.[CreatedBy]                                                
      ,Services.[CreatedDate]                                                
      ,Services.[ModifiedBy]                        
      ,Services.[ModifiedDate]                                                
      ,Services.[RecordDeleted]                                                
      ,Services.[DeletedDate]                                                
      ,Services.[DeletedBy]                     
      --,right(CONVERT(varchar, DateOfService, 100),7)  as ''StartTimeDateOfService''                        
   , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateofService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')        
   as ''StartTimeDateOfService''         
           
     -- ,right(CONVERT(varchar, EndDateOfService, 100),7)  as  ''EndTimeEndDateOfService''                      
    , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,EndDateOfService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')        
   as ''EndTimeEndDateOfService''         
      --,right(CONVERT(varchar, DateOfService, 100),7)  as ''DateInDateTimeIn''                       
   --   , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateOfService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')        
   --as ''DateInDateTimeIn''         
       
    , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateTimeIn,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')        
   as ''DateInDateTimeIn''        
        
   --        , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,EndDateOfService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')        
   --as ''DateOutDateTimeOut''     
, REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateTimeOut,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')        
as ''DateOutDateTimeOut''     
              
      ,Staff.LastName +  '', '' + Staff.FirstName as ''ClinicianName''                      
                            
      ,SpecificLocation                       
      ,[Status] as SavedStatus
  FROM Services  left join Staff on Staff.StaffId=Services.ClinicianId                                                
  where ServiceId=@ServiceId and ISNULL(Services.RecordDeleted,''N'')=''N''                                                  
                                                  
                               
  Declare @serviceStatus as int                        
  Declare @disableNoShowNotes as char(1)                        
  Declare @disableCancelNotes as char(1)                        
                          
  select @serviceStatus=status from Services where ServiceId=@ServiceId and ISNULL(RecordDeleted,''N'')=''N''                 select @disableNoShowNotes=ISNULL(SystemConfigurations.DisableNoShowNotes,''N'') from SystemConfigurations                        
                
  select @disableCancelNotes=ISNULL(SystemConfigurations.DisableCancelNotes,''N'') from SystemConfigurations                        
                      
                           
                           
                     
                                                                      
  SELECT [DocumentId]                                                
      ,[ClientId]                                                
      ,[ServiceId]                          
      ,[DocumentCodeId]                                 
      ,[EffectiveDate]                                                
      ,[DueDate]                                                
      ,[Status]                                                
      ,[AuthorId]                                                
      --,[CurrentVersion]                                                
      ,CurrentDocumentVersionId                                
      ,[DocumentShared]                                                
      ,[SignedByAuthor]                                                
      ,[SignedByAll]                                        
      ,[ToSign]                                                
      ,[ProxyId]                                                
      ,[UnderReview]                                                
      ,[UnderReviewBy]                                                
      ,[RequiresAuthorAttention]                                                                                             
      ,[CreatedBy]                                                
      ,[CreatedDate]                                                
      ,[ModifiedBy]                                         
      ,[ModifiedDate]                                                
      ,[RecordDeleted]                                                
      ,[DeletedDate]                                                
      ,[DeletedBy]                                                
      ,[GroupServiceId]   
      ,EventId
	  ,ProviderId
	  ,InitializedXML
	  ,BedAssignmentId
	  ,ReviewerId
	  ,InProgressDocumentVersionId
	  ,CurrentVersionStatus
	  ,ClientLifeEventId
	  ,AppointmentId      --Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp                                            
      FROM Documents WHERE DocumentID = @DocumentID and ISNULL(RecordDeleted,''N'')=''N''                         
                                                                                                                                           
                                                 
  SELECT [DocumentVersionId]                                                
      ,[DocumentId]                                                
      ,[Version]                                                
      ,[EffectiveDate]                                                
      ,[DocumentChanges]                                                
      ,[ReasonForChanges]                                                
      --,[RowIdentifier]                                                
      --,[ExternalReferenceId]                                                
      ,[CreatedBy]                                                
      ,[CreatedDate]                                                
      ,[ModifiedBy]                                       
      ,[ModifiedDate]                                                
      ,[RecordDeleted]                                                
      ,[DeletedDate]                                                
      ,[DeletedBy] 
	  ,AuthorId
	  ,RevisionNumber  
	  ,[RefreshView] --Task#259                                                                                     
  FROM [DocumentVersions]                                                
  where DocumentID=@DocumentID and Version=@Version  and ISNULL(RecordDeleted,''N'')=''N''                          
                          
  /*******Modification after adding documentlog table in dataSet as per chaning in documents ********/                         
      SELECT [DocumentInitializationLogId]                          
      ,[DocumentId]                          
      ,[TableName]                          
      ,[ColumnName]                          
      ,[InitializationStatus]                          
      ,[ChildRecordId]                          
      ,[RowIdentifier]                          
      ,[CreatedBy]                          
      ,[CreatedDate]                          
      ,[ModifiedBy]                          
      ,[ModifiedDate]                          
      ,[RecordDeleted]                          
      ,[DeletedDate]                   
      ,[DeletedBy]                          
  FROM [DocumentInitializationLog]                              
   WHERE ISNull(RecordDeleted,''N'')=''N'' and DocumentId=@DocumentID                            
                          
  /****** End of modification adding documentlog table **********************************************/                                                    
                     
                                                 
                                                  
                                                                                                                                  
                                                  
  SELECT [AppointmentId]                                                
      ,[StaffId]                                                
      ,[Subject]                                                
      ,[StartTime]                                                
      ,[EndTime]                                                
      ,[AppointmentType]                                                
      ,[Description]                                                
      ,[ShowTimeAs]                                                
      ,[LocationId]                                                
      ,[ServiceId]                                                
    ,[GroupServiceId]                                                
      ,[AppointmentProcedureGroupId]                                                
      ,[RecurringAppointment]                                                
      ,[RecurringDescription]                                                
      ,[RecurringAppointmentId]                                          
      ,[RecurringServiceId]                                                
      ,[RecurringGroupServiceId]                                                
      ,RecurringOccurrenceIndex
      ,[RowIdentifier]                                                
     ,[CreatedBy]                                      
      ,[CreatedDate]                                                
      ,[ModifiedBy]                                                
      ,[ModifiedDate]                                                
      ,[RecordDeleted]                                                
      ,[DeletedDate]                                                
      ,[DeletedBy] 
      ,[SpecificLocation] --Added By Rahul Aneja
      ,[NumberofTimeRescheduled]      --Added By Mmata Gupta                                                      
  FROM [Appointments]                                
  where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                                                                                
                                            
  SELECT [ServiceErrorId]                                                
      ,[ServiceId]                                                
      ,[CoveragePlanId]                                                
   ,[ErrorType]                                                
      ,[ErrorSeverity]                                                
      ,[ErrorMessage]                                      
      ,[NextStep]                                                
      ,[RowIdentifier]                                                
      ,[CreatedBy]                                                
      ,[CreatedDate]                                        
      ,[ModifiedBy]                                                
      ,[ModifiedDate]                                                
      ,[RecordDeleted]                                               
      ,[DeletedDate]                                                
      ,[DeletedBy]                                                
  FROM [ServiceErrors]                                                
  where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                                                                                 
                                                                                                 
--ServiceGoals                                                                                                
  select                                                                                               
 ServiceGoalId,                                                   
 ServiceId,                                                                                              
 NeedId,                                                                         
 StageOfTreatment,                                                                   
 RowIdentifier,                                                                                              
 CreatedBy,                                                                                   
 CreatedDate,                                                                                              
ModifiedBy,                                                                        
 ModifiedDate,                                                                                              
 RecordDeleted,                                                                   
 DeletedDate,                                                                                              
 DeletedBy
                                                                                             
  from ServiceGoals where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                                                                               
                                                                                                                                                                                                                                   
--ServiceObjectives                     
                                                                                           
  select                                                                                               
 ServiceObjectiveId,                                                     
 ServiceId,                                                                                              
 ObjectiveId,                                                                                              
 RowIdentifier,                                                                     
 CreatedBy,                                          
 CreatedDate,                                                                                              
 ModifiedBy,                                                                                              
 ModifiedDate,                                                                                              
 RecordDeleted,                                                                                              
 DeletedDate,                                                              
 DeletedBy 
                                                              
  from ServiceObjectives where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                              
           
--  SELECT [CustomFieldsDataId]          
--      ,[DocumentType]          
--      ,[DocumentCodeId]          
--      ,[PrimaryKey1]          
--      ,[PrimaryKey2]          
--      ,[ColumnVarchar1]          
--      ,[ColumnVarchar2]          
--      ,[ColumnVarchar3]          
--      ,[ColumnVarchar4]          
--      ,[ColumnVarchar5]          
--      ,[ColumnVarchar6]          
--      ,[ColumnVarchar7]          
--      ,[ColumnVarchar8]          
--      ,[ColumnVarchar9]          
--      ,[ColumnVarchar10]          
--      ,[ColumnVarchar11]          
--,[ColumnVarchar12]          
--      ,[ColumnVarchar13]          
--      ,[ColumnVarchar14]          
--      ,[ColumnVarchar15]          
--      ,[ColumnVarchar16]          
--      ,[ColumnVarchar17]          
--      ,[ColumnVarchar18]          
--      ,[ColumnVarchar19]          
--      ,[ColumnVarchar20]          
--      ,[ColumnText1]          
--      ,[ColumnText2]          
--      ,[ColumnText3]          
--      ,[ColumnText4]          
--      ,[ColumnText5]          
--      ,[ColumnText6]          
--      ,[ColumnText7]          
--      ,[ColumnText8]          
--      ,[ColumnText9]          
--      ,[ColumnText10]          
--      ,[ColumnInt1]          
--      ,[ColumnInt2]          
--      ,[ColumnInt3]          
--      ,[ColumnInt4]          
--      ,[ColumnInt5]          
--      ,[ColumnInt6]          
--      ,[ColumnInt7]          
--      ,[ColumnInt8]            ,[ColumnInt9]          
--      ,[ColumnInt10]          
--      ,[ColumnDatetime1]          
--      ,[ColumnDatetime2]          
--      ,[ColumnDatetime3]          
--      ,[ColumnDatetime4]          
--      ,[ColumnDatetime5]          
--      ,[ColumnDatetime6]          
--      ,[ColumnDatetime7]          
--      ,[ColumnDatetime8]          
--      ,[ColumnDatetime9]          
--      ,[ColumnDatetime10]          
--      ,[ColumnDatetime11]          
--      ,[ColumnDatetime12]          
--      ,[ColumnDatetime13]          
--      ,[ColumnDatetime14]          
--      ,[ColumnDatetime15]          
--      ,[ColumnDatetime16]          
--      ,[ColumnDatetime17]          
--      ,[ColumnDatetime18]          
--      ,[ColumnDatetime19]          
--      ,[ColumnDatetime20]          
--      ,[ColumnGlobalCode1]          
--      ,[ColumnGlobalCode2]          
--      ,[ColumnGlobalCode3]          
--      ,[ColumnGlobalCode4]          
--      ,[ColumnGlobalCode5]          
--      ,[ColumnGlobalCode6]          
--      ,[ColumnGlobalCode7]          
--      ,[ColumnGlobalCode8]          
--      ,[ColumnGlobalCode9]          
--      ,[ColumnGlobalCode10]          
--      ,[ColumnGlobalCode11]          
--      ,[ColumnGlobalCode12]          
--      ,[ColumnGlobalCode13]          
--      ,[ColumnGlobalCode14]          
--      ,[ColumnGlobalCode15]          
--      ,[ColumnGlobalCode16]          
--      ,[ColumnGlobalCode17]          
--      ,[ColumnGlobalCode18]          
--      ,[ColumnGlobalCode19]          
--      ,[ColumnGlobalCode20]          
--      ,[ColumnMoney1]          
--      ,[ColumnMoney2]          
--      ,[ColumnMoney3]          
--      ,[ColumnMoney4]          
--      ,[ColumnMoney5]          
--      ,[ColumnMoney6]          
--      ,[ColumnMoney7]          
--      ,[ColumnMoney8]          
--      ,[ColumnMoney9]          
--      ,[ColumnMoney10]          
--      ,[RowIdentifier]          
--      ,[CreatedBy]          
--      ,[CreatedDate]          
--      ,[ModifiedBy]          
--      ,[ModifiedDate]          
--      ,[RecordDeleted]          
--      ,[DeletedDate]          
--      ,[DeletedBy]          
--  FROM [CustomFieldsData] where PrimaryKey1=@ServiceId and ISNULL(CustomFieldsData.RecordDeleted,''N'')=''N''                  
SELECT    [AppointmentMasterId],
			[CreatedBy],
			[CreatedDate],
			[ModifiedBy],
			[ModifiedDate],
			[RecordDeleted],
			[DeletedBy],
			[DeletedDate],
			[Subject],
			[Description],
			[StartTime],
			[EndTime],
			[AppointmentType],
			[ShowTimeAs],
			[ServiceId]
  FROM AppointmentMaster RA  
  WHERE ServiceId= @ServiceId
		AND ISNULL(RA.RecordDeleted,''N'')=''N''
		
  SELECT	AMR.[AppointmentMasterResourceId],
			AMR.[CreatedBy],
			AMR.[CreatedDate],
			AMR.[ModifiedBy],
			AMR.[ModifiedDate],
			AMR.[RecordDeleted],
			AMR.[DeletedBy],
			AMR.[DeletedDate],
			AMR.[AppointmentMasterId],
			AMR.[ResourceId],
			RS.[ResourceName] + '' (''+gsc.SubCodeName+'')'' as ResourceName,
			RS.[ResourceType] as Type,
			AMR.[ResourceId] as OrgResourceId
  FROM AppointmentMasterResources AMR
  join AppointmentMaster AM on AM.AppointmentMasterId= AMR.AppointmentMasterId
  join Resources RS on RS.ResourceId=AMR.[ResourceId]
  join GlobalSubCodes gsc on gsc.GlobalSubCodeId=RS.ResourceSubType
  WHERE AM.ServiceId=@ServiceId
		AND ISNULL(AMR.RecordDeleted,''N'')=''N''
		AND ISNULL(AM.RecordDeleted,''N'')=''N''
		AND ISNULL(RS.RecordDeleted,''N'')=''N'' 
		
 Select AMS.AppointmentMasterStaffId,
		AMS.CreatedBy,
		AMS.CreatedDate,
		AMS.ModifiedBy,
		AMS.ModifiedDate,
		AMS.RecordDeleted,
		AMS.DeletedBy,
		AMS.DeletedDate,
		AMS.AppointmentMasterId,
		AMS.StaffId
 from AppointmentMasterStaff AMS 
 join AppointmentMaster AM on AM.AppointmentMasterId= AMS.AppointmentMasterId  
 join Staff S on S.StaffId=AMS.[StaffId] 
         
--Modified by Davinder Kumar                                                       
IF EXISTS(select PARAMETER_NAME from information_schema.parameters        
 where specific_name=@CustomStoredProcedure        
 and PARAMETER_NAME=''@StaffId'')        
begin                                                                
	--Following added by sonia                                                  
	if(@DocumentType=18 and @FillCustomTablesData=''Y'')    -- Changes by Sonia Ref Task #701                                              
	begin                                                  
	  exec @CustomStoredProcedure  @DocumentVersionId, @FillCustomTablesData                                                  
	  --return                                               
	end                                          
	--Changes end over here                                           
	else                                            
	begin                                          
	   if(@DocumentCodeId > 0)                                     
	   begin                                             
	   exec @CustomStoredProcedure @DocumentVersionId, @StaffId = @AuthorId --@Version                                         
	   end                                           
	end     
end  
Else
begin                                                                
	--Following added by sonia                                                  
	if(@DocumentType=18 and @FillCustomTablesData=''Y'')    -- Changes by Sonia Ref Task #701                                              
	begin                                                  
	  exec @CustomStoredProcedure  @DocumentVersionId,@FillCustomTablesData                                                  
	  --return                                               
	end                                          
	--Changes end over here                                           
	else                                            
	begin                                          
	   if(@DocumentCodeId > 0)                                     
	   begin                                             
	   exec @CustomStoredProcedure @DocumentVersionId --@Version                                         
	   end                                           
	end     
end                                                                          
                                                      
                
                                                    
  END TRY              
                                                
BEGIN CATCH                                                  
 declare @Error varchar(8000)                                                  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetServiceNoteCustomTables120'')                                                   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                    
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                  
                                                    
 RAISERROR                                                   
 (                                                  
  @Error, -- Message text.                                                  
  16,  -- Severity.                                                  
  1  -- State.                                                  
 );                                                  
                                                  
END CATCH 
' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_PMResourceDetailOnLoadData]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMResourceDetailOnLoadData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
   
CREATE Procedure [dbo].[ssp_PMResourceDetailOnLoadData]      
 @ResourceId AS INT      
AS  
-- =============================================
-- Author:		Pradeep A
-- Create date: 03/28/2013
-- Description:	Return the Resources And Resource Availability data.
-- =============================================    
BEGIN      
 BEGIN TRY      
  SELECT  [ResourceId],      
    [CreatedBy],      
    [CreatedDate],      
    [ModifiedBy],      
    [ModifiedDate],      
    [RecordDeleted],      
    [DeletedDate],      
    [DeletedBy],      
    [ResourceName],      
    [LocationId],      
    [Active],      
    [DisplayAs],      
    [ResourceType],      
    [Description],    
    [ResourceSubType]      
  FROM [Resources]      
  WHERE ISNULL(RecordDeleted,''Y'')=''Y'' AND      
  ResourceId=@ResourceId      
        
  SELECT  [ResourceAvailabilityId],      
    [CreatedBy],      
    [CreatedDate],      
    [ModifiedBy],      
    [ModifiedDate],      
    [RecordDeleted],      
    [DeletedDate],      
    [DeletedBy],      
    [ResourceId],      
    [StartDate],      
    [EndDate]      
  FROM [ResourceAvailability]      
  WHERE ISNULL(RecordDeleted,''Y'')=''Y'' AND      
  ResourceId=@ResourceId      
          
 END TRY      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)             
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                  
   + ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''ssp_PMResourceDetailOnLoadData'')                                                                                                   
   + ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                    
   + ''*****'' + CONVERT(VARCHAR,ERROR_STATE())      
  RAISERROR      
  (      
   @Error, -- Message text.      
   16,  -- Severity.      
   1  -- State.      
  );      
 END CATCH      
END 
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_PMResource]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PMResource]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SSP_PMResource]      
 @PageNumber    INT,      
 @PageSize    INT,      
 @SortExpression   VARCHAR(100),      
 @ResourceType     INT,     
 @ResourceSubType INT,     
 @Active     INT,      
 @LocationId    INT,      
 @OtherFilter   INT,      
 @ResourceName     VARCHAR(100)      
AS     
-- =============================================
-- Author:		Pradeep A
-- Create date: 03/28/2013
-- Description:	Return the Resources data for List page based on the filter.
-- ============================================= 
BEGIN      
 BEGIN TRY      
  CREATE TABLE #CustomFilters      
   (      
    ResourceId INT NOT NULL      
   )      
  DECLARE @ApplyFilterClicked  CHAR(1)      
  DECLARE @CustomFilterApplied CHAR(1)      
        
  SET @SortExpression=RTRIM(LTRIM(@SortExpression))      
  IF ISNULL(@SortExpression,'''') = ''''      
   SET @SortExpression=''ResourceName''      
         
  SET @ApplyFilterClicked= ''Y''      
  SET @CustomFilterApplied= ''N''      
        
  IF @OtherFilter > 10000      
   BEGIN      
    SET @CustomFilterApplied= ''Y''      
          
    INSERT INTO #CustomFilters (ResourceId)      
    EXEC SCSP_PMResources      
     @ResourceType   =@ResourceType,    
     @ResourceSubType=@ResourceSubType,      
     @Active   =@Active,      
     @LocationId  =@LocationId,      
     @OtherFilter =@OtherFilter      
   END      
  ;WITH ListPMResources      
  AS      
  (      
   SELECT R.ResourceId,      
       R.ResourceName,      
       G.CodeName as [ResourceType],     
       GS.SubCodeName as [ResourceSubType],    
       Active= CASE ISNULL(R.Active,''Y'')      
        WHEN ''Y'' THEN ''Yes'' ELSE ''No''      
       END      
       ,R.LocationId,      
       L.LocationName      
   FROM Resources AS R      
   JOIN Locations as L on L.LocationId=R.LocationId      
   JOIN GlobalCodes as G on G.GlobalCodeId=R.ResourceType    
   JOIN GlobalSubCodes AS GS  ON GS.GlobalSubCodeId=R.ResourceSubtype     
   WHERE      
   (      
    ISNULL(R.RecordDeleted,''N'')=''N''      
    AND ((@CustomFilterApplied = ''Y'' AND EXISTS(SELECT * FROm #CustomFilters CF WHERE CF.ResourceId = R.ResourceId)) OR      
    (@CustomFilterApplied = ''N''      
    AND (ISNULL(@ResourceType,-1) = -1 OR R.ResourceType=@ResourceType)    
    AND (ISNULL(@ResourceSubType,-1) =-1 OR R.ResourceSubtype=@ResourceSubType)      
    AND (@Active = -1 OR      
      (@Active = 1 AND ISNULL(R.Active,''N'') = ''Y'') OR      
      (@Active = 2 AND ISNULL(R.Active,''N'') = ''N''))      
    AND (ISNULL(@LocationId,-1) = -1 OR R.LocationId=@LocationId)      
    AND (@ResourceName= '''' OR R.ResourceName like ''%''+@ResourceName+''%'')))      
   )      
  ),      
  counts AS (SELECT COUNT(*) AS TotalRows from ListPMResources      
  ),      
  RankResultSet AS      
  (      
   SELECT ResourceId,      
       ResourceName,      
       [ResourceType],    
       [ResourceSubType],    
       Active,      
       LocationId,      
       LocationName,      
       COUNT(*) OVER ( ) AS TotalCount,      
       RANK() OVER( ORDER BY      
       CASE WHEN @SortExpression= ''ResourceName''           THEN [ResourceName] END,      
       CASE WHEN @SortExpression= ''ResourceName DESC''          THEN [ResourceName] END DESC,      
       CASE WHEN @SortExpression= ''ResourceType''           THEN [ResourceType] END,      
       CASE WHEN @SortExpression= ''ResourceType DESC''          THEN [ResourceType] END DESC,      
       CASE WHEN @SortExpression= ''ResourceSubType''           THEN [ResourceSubType] END,      
       CASE WHEN @SortExpression= ''ResourceSubType DESC''          THEN [ResourceSubType] END DESC,      
       CASE WHEN @SortExpression= ''Active''     THEN [Active]   END,      
       CASE WHEN @SortExpression= ''Active DESC''    THEN [Active]   END DESC,      
       CASE WHEN @SortExpression= ''LocationName''   THEN [LocationName] END,      
       CASE WHEN @SortExpression= ''LocationName DESC''  THEN [LocationName] END DESC,      
       ResourceId      
       ) AS RowNumber      
        FROM ListPMResources      
  )      
  SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)      
     ResourceId,      
     ResourceName,      
     [ResourceType],    
     [ResourceSubType],      
     Active,      
     LocationName,      
     TotalCount,      
     RowNumber      
   INTO #FinalResultSet      
   FROM RankResultSet      
   WHERE RowNumber > ( ( @PageNumber - 1 ) * @PageSize )      
         
  IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1      
   BEGIN      
    SELECT 0 AS PageNumber ,      
        0 AS NumberOfPages ,      
                       0 NumberOfRows      
   END      
  ELSE      
   BEGIN      
    SELECT TOP 1      
      @PageNumber AS PageNumber ,      
      CASE (TotalCount % @PageSize) WHEN 0 THEN       
      ISNULL(( TotalCount / @PageSize ), 0)      
      ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,      
      ISNULL(TotalCount, 0) AS NumberOfRows      
    FROM    #FinalResultSet        
   END      
  SELECT ResourceId,      
      ResourceName,      
      [ResourceType],     
      [ResourceSubType],     
      Active,      
      LocationName      
  FROM    #FinalResultSet      
            ORDER BY RowNumber      
 DROP TABLE #CustomFilters      
             
 END TRY      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)             
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                  
   + ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''SSP_PMResource'')                                                                                                   
   + ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                    
   + ''*****'' + CONVERT(VARCHAR,ERROR_STATE())      
  RAISERROR      
  (      
   @Error, -- Message text.      
   16,  -- Severity.      
   1  -- State.      
  );      
 END CATCH      
END 
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SSP_SCGetResourceInfo]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetResourceInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


          
CREATE Procedure [dbo].[SSP_SCGetResourceInfo]       
@ResourceType INT,  
@LocationId int     
AS            
BEGIN            
 BEGIN TRY    
    SELECT  R.[ResourceId],           
   R.[ResourceName]+'' (''+G.[SubCodeName]+'')'' as Name  
    FROM Resources R          
   JOIN GlobalSubCodes G on G.GlobalSubCodeId=R.ResourceSubType          
    WHERE ISNULL(R.RecordDeleted,''N'')!=''Y''           
      AND ISNULL(R.Active,''N'')=''Y''    
      AND (ISNULL(@LocationId,-1) = -1 OR R.LocationId=@LocationId)  
      AND (ISNULL(@ResourceType,-1) = -1 OR R.ResourceType=@ResourceType)  
 END TRY            
 BEGIN CATCH            
  DECLARE @Error varchar(8000)                                                                                                                                        
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                         
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''SSP_SCGetResources'')                                                                                                                                         
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                         
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                                       
        RAISERROR                                                                                
    (                                                                                  
   @Error, -- Message text.                                                                                                      
   16, -- Severity.                           
   1 -- State.                                                                  
  );                 
 END CATCH            
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromSystemConfigurations]    Script Date: 05/02/2013 00:58:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataFromSystemConfigurations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE  [dbo].[ssp_SCGetDataFromSystemConfigurations]                                          
                                          
As                                          
                                                  
Begin                                                  
/*********************************************************************/                                                    
/* Stored Procedure: dbo.ssp_SCGetDataFromSystemConfigurations                */                                           
                                          
/* Copyright: 2005 Provider Claim Management System             */                                                    
                                          
/* Creation Date:  30/10/2006                                    */                                                    
/*                                                                   */                                                    
/* Purpose: Gets Data From SystemConfigurations Table  */                                                   
/*                                                                   */                                                  
/* Input Parameters: None */                                                  
/*                                                                   */                                                     
/* Output Parameters:                                */                                                    
/*                                                                   */                                                    
/* Return:   */                                                    
/*                                                                   */                                                    
/* Called By: getSystemConfigurations() Method in MSDE Class Of DataService  in "Always Online Application"  */                                          
/*      */                                          
                                          
/*                                                                   */                                                    
/* Calls:                                                            */                                                    
/*                                                                   */                                                    
/* Data Modifications:                                               */                                                    
/*                                                                   */                                                    
/*   Updates:                                                          */                                                    
                                          
/*       Date              Author                  Purpose                                    */                                                    
/*  30/10/2006    Piyush Gajrani                   Created       */                                    
/*  25th Nov ,2008 Vikas Vyas                      Prupose:Add New Field CssCustomWebDocuments       */                                                    
/*  11th May ,2009 Anuj                      Prupose:Add New Field TreatmentPlanBannerId ,AssessmentBannerId ,PeriodicReviewBannerId ,DiagnosisBannerId ,GeneralDocumentsBannerId        */                                      
/*  18th May ,2009 Rohit                     Prupose:Added New Field ScannedMedicalRecordAuthorId */                           
                        
/*  15 Jan ,2010 Vikas Monga                     Prupose:Added New Fields (AutoSaveTimeDuration,AutoSaveEnabled) */                           
/* 21 jun 2011 Priya              Added new field AllowMessageToBePartOfClientRecord,  DefaultMessageToBePartOfClientRecord */                   
/* 13/10/2011   Maninder			Added field AllowStaffAuthorizations */
/* 18 Oct 2011 Devi Dayal			Added The COlumn ScreenCustomTabExceptions for the Custom Tab Added on the CUstom Detail Screen #ref 15 Sc Honey Badger*/
/* 22 Nov 2011 Rohit Katoch Added New Column DocumentsDefaultCurrentEffectiveDate,Task#21 in Harbor Development */
/*			Devi Dyal		Added Column UseKeyPhrases */
/* 09 Dec 2011  Karan Garg    Added column DocumentLockCheckProcessFrequency*/ 
/* 12 Dec 2011 Maninder Added New Column HideCustomAuthorizationControls,Task#68,task#69 in Harbor Development */
/* 03 Jan 2012	Shifali		  Modified - Added Fields DocumentsDefaultCurrentEffectiveDate,HideCustomAuthorizationControls while merging Threshold Phase I with PhaseII*/
/* 04 Jan 2012	Shifali	Modified - Added Columns DocumentsInProgressShowWatermark, DocumentsInProgressWatermarkImageLocation*/
/* 23 Jan 2012  Karan Garg    Added column DocumentSignaturesNoPassword*/ 
/* 3 April 2012 Amit Kumar Srivastava    Added column DiagnosisHideAxisIIISpecify,DiagnosisAxisIVShowNone, #17, Diagnosis Document Changes (Development Phase III (Offshore))(THRESHOLDSOFF3),*/ 
/* 18 April 2012 Devi Dayal		Added Column ShowTPGoalsOnServiceTab,ServiceOutTimeNotRequiredOnSave #ref 8 Threshold Phase 3 Service Note CHanges*/
/* 24 April 2012 Vikas Kashyap		Added Column ReleaseReminderDay w.r.t.Task#14 Threshold Phase 3 Client Information*/
/* 29 April 2012 Shifali		Added Column ServiceNoteDoNotDefaultDate*/
/* 2May2012		 Shifali		Replaced ReleaseReminderDay with ReleaseReminderDays*/
/* 11 Dec 2012   Raghum         Added new column name HelpURL in order to get the url for redirecting the page on click of HelpIcon on Application Page as per task#12 in Development Phase IV(Offshore)*/
/* 12Dec2012     Rahul Aneja	Added Column DefaultAppointmentDurationWhenNotSpecified **************************/
/* 14 Jan 2013   Vishant Garg   Added column FlowSheetSpecificToClient     */
/* 12 Jan 2013	 Pradeep			Added UseSignaturePad column */
/* 22 March 2013 Sudhir Singh		Added ScannedDocumentDefaultAssociation column  as per task #746 in SC Web Phase II Bugs/feautres*/
/* 03 April 2013 Rakesh Garg 	 Get Newly added field in Data Model 12.72 in 3.5xMerge "ServiceInTimeNotRequiredOnSave" in Select Statement Ref. to task 274 in 3.5x Issues*/
/* 17Apr2013	 PradeepA		Added AllowedResourceCount,UseResourceForService for Resource Scheduling.
/******************************************************************** */ */                  
                                                
Select                          
OrganizationName,                                        
ClientBannerDocument1,                                        
ClientBannerDocument2,                                        
ClientBannerDocument3,                                        
ClientBannerDocument4,                                   
ClientBannerDocument5,                                        
ClientBannerDocument6,                                        
StateFIPS,									             
LastUserName,                          
FiscalMonth,                                        
DatabaseVersion,                                        
SmartCareVersionMinimum,                                        
SmartCareVersionMaximum,                                        
PracticeManagementVersionMinimum,                                        
PracticeManagementVersionMaximum,                                        
CareManagementVersionMinimum,                                        
CareManagementVersionMaximum,                                        
ProviderAccessVersionMinimum,                           
ProviderAccessVersionMaximum,                                        
CareManagementServer,                                        
CareManagementDatabase,                                  
AutoCreateDiagnosisFromAssessment,                                        
CareManagementInsurerId,                                        
IntializeAssessmentDiagnosis,                                        
CareManagementInsurerName,                                        
CareManagementComment,                                        
ClientStatementSort1,                                        
ClientStatementSort2,                                        
SCDefaultDoNotComplete,                                        
PMDefaultDoNotComplete,                                        
MedicationDaysDefault,                                        
MedicationDatabaseVersion,                                        
RecurringAppointmentsExpandedFromDays,                                        
RecurringAppointmentsExpandedToDays,                                        
RecurringAppointmentsExpandedFrom,                                        
RecurringAppointmentsExpandedTo,                                        
ProgramsBannerText,                                        
ShowGroupsBanner,                                        
ShowBedCensusBanner,                                        
FilterTPAuthorizationCodesByAssigned,                                        
ShowTPProceduresViewMode,                                        
Upper(DisableNoShowNotes) as DisableNoShowNotes,                                        
Upper(DisableCancelNotes) as DisableCancelNotes,                                        
CredentialingExpirationMonths,                                        
CredentialingApproachingExpirationDays,                                
ScannedMedicalRecordAuthorId,                                    
--CssCustomWebDocuments,                                      
CreatedBy,                                        
CreatedDate,                                        
ModifiedBy,                                        
ModifiedDate,TreatmentPlanBannerId,AssessmentBannerId,PeriodicReviewBannerId,                            
GeneralDocumentsBannerId,DiagnosisBannerId                          
--DocumentListPageDefaultDocumentBannerId,ServicesBannerId  //commented by sonia as per DataModel changes these fields were not found                          
,AutoSaveTimeDuration,                        
AutoSaveEnabled,                    
SystemDatabaseId,                
ProxyVerificationMessage ,            
ConsentDurationMonths,            
MedConsentsRequireClientSignature,            
ReleaseListPageDefaultDocumentBannerId,          
NumberOfPrescriberSecurityQuestions,            
ListPageRowsPerPage ,        
EmergencyAccessMinutes,      
AllowMessageToBePartOfClientRecord,      
DefaultMessageToBePartOfClientRecord,    
ClientEducationHealthDataMonths,  
AllowStaffAuthorizations,
ServiceDetailsServicePagePath,
ServiceNoteServicePagePath,
ScreenCustomTabExceptions,
UseKeyPhrases,                             
ISNULL(DocumentLockCheckProcessFrequency,0) as DocumentLockCheckProcessFrequency               
,DocumentsDefaultCurrentEffectiveDate,
HideCustomAuthorizationControls
,DocumentsInProgressShowWatermark
,DocumentsInProgressWatermarkImageLocation 
,DocumentSignaturesNoPassword   
,ShareDocumentOnSave 
,isnull(DiagnosisHideAxisIIISpecify,''N'') as ''DiagnosisHideAxisIIISpecify''
,isnull(DiagnosisAxisIVShowNone,''N'') as ''DiagnosisAxisIVShowNone'' 
,ISNULL(ShowTPGoalsOnServiceTab,''N'') AS ''ShowTPGoalsOnServiceTab''
,ISNULL(ServiceOutTimeNotRequiredOnSave,''N'') AS''ServiceOutTimeNotRequiredOnSave''
,ReleaseReminderDays
,ServiceNoteDoNotDefaultDate
,PopulationTracking 
,HelpURL    
,DefaultAppointmentDurationWhenNotSpecified   
,FlowSheetSpecificToClient
,UseSignaturePad  
,ScannedDocumentDefaultAssociation,
ServiceInTimeNotRequiredOnSave -- Added by Rakesh Added new field in 3.5x Merge in Data Model 12.72   
,AllowedResourceCount
,UseResourceForService               
 from SystemConfigurations                                          
                                          
                                    
                                    
  --Checking For Errors                                  
  If (@@error!=0)                                          
  Begin                                          
   RAISERROR  20006   ''ssp_SCGetDataFromSystemConfigurations: An Error Occured''                                         
   Return                                          
   End                                                   
                                                  
         
End 

' 
END
GO
