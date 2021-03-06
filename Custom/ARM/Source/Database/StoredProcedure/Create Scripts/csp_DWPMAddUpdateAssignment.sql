/****** Object:  StoredProcedure [dbo].[csp_DWPMAddUpdateAssignment]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMAddUpdateAssignment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateAssignment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */            
/* Stored Procedure: dbo.csp_DWPMAddUpdateAssignment       */            
/* Copyright: 2007 Provider Access Application        */            
/* Creation Date:  10th-Aug-2007            */            
/*                   */            
/* Purpose: This Stored procedure is used to add and update the data of   
   CustomRiverwoodAccessCenter from Access Center - Assignment     */           
/*                    */          
/* Input Parameters:   
 @UserId,@DataWizardInstanceId,@PreviousDataWizardInstanceId,@NextStepId,  
 @NextWizardId,@EventId,@ClientID,@ClientSearchGUID,@Validate  
  
 @Val0, @Val1, @Val2, @Val3, @Val4, @Val5,@Val6, @Val7,   
 @Val8 , @Val9, @Val10, @Val11 ,   
/*                      */            
/* Output Parameters:              */            
/*                   */            
/* Return:                 */            
/*                      */            
/* Called By:                */            
/*                      */            
/* Calls:                    */            
/*                      */            
/* Data Modifications:                                                      */            
/*                      */            
/* Updates:                    */            
/*  Date           Author       Purpose                                    */            
/*  10th-Aug-2007   Ranjeet Prasad             Created    
    12th-Sep-2007   Pratap Singh               Modification to enterdata in CustomRiverwoodAccessCenter       */            
/*********************************************************************/  */            
  
CREATE PROCEDURE [dbo].[csp_DWPMAddUpdateAssignment]  
(  
 @UserId int,  
 @DataWizardInstanceId int,  
 @PreviousDataWizardInstanceId int,  
 @NextStepId int,  
 @NextWizardId int,  
 @EventId int,  
 @ClientID int,  
 @ClientSearchGUID type_GUID,  
 @Validate bit=0,  
 @Finish bit=0,  
 @Val1 DATETIME, -- is mapping to RequestDate  
 @Val2 DATETIME, -- is mapping to AssessmentDateFirstOffered  
 @Val3 DATETIME,-- is mapping to ScheduledAssessmentDate  
 @Val4 INT,-- is mapping to ReasonFirstOfferDeclined  
 @Val5 VARCHAR(50),  --map to CustomRiverWoodAccessCenter.walkin(not scheduled)  
 @Val6 TEXT, --is mapping to TimelinessComment   
 @Val7 INT,--is mapping to ProgramId  
 @Val8 INT,--is mapping to ClinicianId  
 @Val9 CHAR(1)=null,--is mapping to NotificationOption  
 @Val10 INT,--is mapping to  NotificationClinicianId  
 @Val11 TEXT --is mapping to NotificationComment  
 --@Val12 VARCHAR(30)--is mapping to CreatedBy  
)  
AS  
  
Declare @NextStepIdOutPut int  
Declare @CreatedBy varchar(100)   
BEGIN TRY  
 --Getting usercode   
 set @CreatedBy=(select usercode from staff where staffid=@userid and isnull(RecordDeleted,''N'')=''N'')  
 --Checking for null  
 if @CreatedBy is null  
  Begin  
   RAISERROR   
   (  
    ''UserId Does Not exist or Deleted'', -- Message text.  
     16, -- Severity.  
    1 -- State.  
   );   
  end    
  
 --Checking for @EventId if it is null or 0 then rasing error  
  IF(isnull(@EventId,0)=0)  
  begin  
   RAISERROR   
   (  
    ''EventId can not be null'', -- Message text.  
     16, -- Severity.  
    1 -- State.  
   );  
  
  end  
  
 --Checking for @DataWizardInstanceId if it is null or 0 then rasing error  
  IF(isnull(@DataWizardInstanceId,0)=0)  
  begin  
   RAISERROR   
   (  
    ''DataWizardInstanceId can not be null'', -- Message text.  
     16, -- Severity.  
    1 -- State.  
   );  
  
  end  
  
 --Checking for Eventid in CustomRiverwoodAccessCenter table if EventId not exit in this table then inserting record  
 IF NOT EXISTS( SELECT EventId FROM CustomRiverwoodAccessCenter WHERE EventId = @EventId)  
 BEGIN   
  --Add the record   
  INSERT INTO CustomRiverwoodAccessCenter  
  (  
   EventId,  
   RequestDate,   
   AssessmentDateFirstOffered ,  
   ScheduledAssessmentDate,  
   ReasonFirstOfferDeclined,   
   Walkin,  
   TimelinessComment,   
   ProgramId,   
   ClinicianId,   
   NotificationOption,   
   NotificationClinicianId,   
   NotificationComment,   
   CreatedBy,   
   createdDate  
  )  
  VALUES  
  (  
   @EventId, --EventId  
   @Val1,  --RequestDate  
   @Val2,  --AssessmentDateFirstOffered  
   @Val3,  --ScheduledAssessmentDate  
   @Val4,  --ReasonFirstOfferDeclined  
   @Val5,  --Walkin  
   @Val6,  --TimelinessComment  
   @Val7,  --ProgramId  
   @Val8,  --ClinicianId  
   @Val9,  --NotificationOption  
   @Val10,  --NotificationClinicianId  
   @Val11,  --NotificationComment  
   @CreatedBy,  --CreatedBy  
   getdate() --createdDate  
  )  
 END  
 ELSE  
 BEGIN  
  --Checking for EventId record has deleted property on if yes then rasing error  
  IF  EXISTS(SELECT EventId FROM CustomRiverwoodAccessCenter WHERE EventId = @EventId AND ISNULL(RecordDeleted,''N'')=''Y'')  
   begin  
     
    RAISERROR   
    (  
     ''Record Has been Deleted.'', -- Message text.  
      16, -- Severity.  
     1 -- State.  
    );  
   end  
  
  --Update the record   
  UPDATE  CustomRiverwoodAccessCenter    
  SET   
   RequestDate = @Val1,   
   AssessmentDateFirstOffered = @Val2,   
   ScheduledAssessmentDate = @Val3,   
   ReasonFirstOfferDeclined = @Val4,   
   Walkin = @Val5,   
   TimelinessComment = @Val6,   
   ProgramId = @Val7,   
   ClinicianId = @Val8,   
   NotificationOption = @Val9,   
   NotificationClinicianId = @Val10,   
   NotificationComment = @Val11,   
   ModifiedBy = @CreatedBy,   
   ModifiedDate = GetDate()   
  WHERE EventId = @EventId   
     
 END  
  
 if(@Validate=1)  
 Begin  
  --Executing ssp_PAGetNextStepId it will return NextStepId  
  EXEC [ssp_PAGetNextStepId]  
    @DataWizardInstanceId = @DataWizardInstanceId,  
    @NextStepId =@NextStepId,  
    @NextStepIdOutPut = @NextStepIdOutPut OUTPUT  
  
  select @NextStepIdOutPut as NextStepId  
 End  
 else  
 Begin  
  select @NextStepId as NextStepId  
 End  
  
 select @EventId as EventId,@ClientId as ClientId  
  
END TRY  
BEGIN CATCH  
 declare @Error varchar(8000)  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMAddUpdateAssignment'')   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())    
    + ''*****'' + Convert(varchar,ERROR_STATE())  
    
 RAISERROR   
 (  
  @Error, -- Message text.  
  16, -- Severity.  
  1 -- State.  
 );  
--SELECT    
--    ERROR_NUMBER() AS ErrorNumber,    
--    ERROR_SEVERITY() AS ErrorSeverity,    
--    ERROR_STATE() AS ErrorState,    
--    ERROR_PROCEDURE() AS ErrorProcedure,    
--    ERROR_LINE() AS ErrorLine,    
--    ERROR_MESSAGE() AS ErrorMessage;    
END CATCH
' 
END
GO
