/****** Object:  StoredProcedure [dbo].[csp_DWPMGetClinicalAssignment]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetClinicalAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMGetClinicalAssignment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetClinicalAssignment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */              
/* Stored Procedure: dbo.csp_DWPMGetClinicalAssignment        */              
/* Copyright: 2007 Provider Access Application        */              
/* Creation Date:  21st-Aug-2007            */              
/*                   */              
/* Purpose: This stored procedure is the Retrieve Stored Procedure and is used for Access Center-Clinical Assignment */             
/*                    */            
/* Input Parameters: @UserId ,@DataWizardInstanceId, @PreviousDataWizardInstanceId, @NextStepId,     
     @NextWizardId, @EventId, @ClientID, @ClientSearchGUID */              
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
/*  Updates:                   */              
/*  Date   Author        Purpose                      */              
/*  21st-Aug-2007   Jatinder Singh             SP for Access Center-Clinical Assignment   */              
/****************************************************************************/              
    
CREATE procedure [dbo].[csp_DWPMGetClinicalAssignment]    
 @UserId int,    
 @DataWizardInstanceId int,    
 @PreviousDataWizardInstanceId int,    
 @NextStepId int,    
 @NextWizardId int,    
 @EventId int,    
 @ClientID int,    
 @ClientSearchGUID type_GUID    
as    
Begin Try    
    
 --Checking where record is deleted    
If Exists(SELECT  EventId FROM  CustomRiverwoodAccessCenter where CustomRiverwoodAccessCenter.EventId = @EventId and isnull(RecordDeleted,''N'')=''Y'')    
Begin    
 RAISERROR     
 (    
  ''Record Has been Deleted.'', -- Message text.    
  16, -- Severity.    
  1 -- State.    
 );    
End    
    
 --The following query\queries are for dropdowns    
 Select GlobalCodeId,CodeName from globalCodes where Category=''ASSESSMENTDECLINED'' and isnull(RecordDeleted,''N'')=''N''
 AND Active=''Y''    
  
 Select ProgramId,ProgramName from Programs where isnull(RecordDeleted,''N'')=''N'' and Active = ''Y'' order by ProgramName --av corrected
  
 select Staffid,lastname + '', ''+ firstname  from staff where Clinician=''Y'' and Active=''Y'' and isnull(RecordDeleted,''N'')=''N'' order by lastname + '',''+ firstname
  
 Select Staffid,lastname + '', ''+ firstname  from staff where Clinician=''Y'' and Active=''Y'' and isnull(RecordDeleted,''N'')=''N''    
     
 --Last query will always be for the values in the table    
 if(Exists(SELECT EventId FROM CustomRiverwoodAccessCenter where CustomRiverwoodAccessCenter.EventId = @EventId))  
 Begin  
  SELECT    
  EventId,    
  Convert(varchar,isnull(RequestDate,getDate()),101) as RequestDate, Convert(varchar,AssessmentDateFirstOffered,101) as AssessmentDateFirstOffered,   
  Convert(varchar,ScheduledAssessmentDate,101) as ScheduledAssessmentDate,   
  ReasonFirstOfferDeclined, WalkIn, TimelinessComment,     
  ProgramId, ClinicianId,     
  NotificationOption, NotificationClinicianId,     
  NotificationComment    
  FROM CustomRiverwoodAccessCenter  
  where CustomRiverwoodAccessCenter.EventId = @EventId    
 End  
 Else  
 Begin  
  SELECT    
  '''' as EventId,    
  Convert(varchar,getDate(),101) as RequestDate, '''' as AssessmentDateFirstOffered,   
  '''' as ScheduledAssessmentDate, '''' as ReasonFirstOfferDeclined,     
  '''' as WalkIn, '''' as TimelinessComment,     
  '''' as ProgramId, '''' as ClinicianId,     
  '''' as NotificationOption, '''' as NotificationClinicianId,     
  '''' as NotificationComment  
 End  
   
End Try    
Begin Catch    
 declare @Error varchar(8000)    
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())     
 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMGetClinicalAssignment'')     
 + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())      
 + ''*****'' + Convert(varchar,ERROR_STATE())    
  
 RAISERROR     
 (    
  @Error, -- Message text.    
  16, -- Severity.    
  1 -- State.    
 );    
End Catch
' 
END
GO
