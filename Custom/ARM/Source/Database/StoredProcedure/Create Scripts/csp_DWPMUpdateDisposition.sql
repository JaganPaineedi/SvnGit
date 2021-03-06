/****** Object:  StoredProcedure [dbo].[csp_DWPMUpdateDisposition]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMUpdateDisposition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMUpdateDisposition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMUpdateDisposition]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */            
/* Stored Procedure: dbo.csp_DWPMUpdateDisposition        */            
/* Copyright: 2007 Provider Access Application        */            
/* Creation Date:  31st-Aug-2007            */            
/*                   */            
/* Purpose: This stored procedure is the Retrieve Stored Procedure and is used for Access Center-Disposition */           
/*                    */          
/* Input Parameters: @UserId ,@DataWizardInstanceId, @PreviousDataWizardInstanceId, @NextStepId,   
     @NextWizardId, @EventId, @ClientID, @ClientSearchGUID  
     @val1,@val2,@val3,@val4 */            
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
/* 31st-Aug-2007   Pramod            SP for Access Center-Disposition   */            
--  21st-Sep-2007   Jatinder Singh			 Changed for Task "Access Center: Disposition" Task#42
-- 8-29-2008	avoss	added logic to update client id for previously non selected clients or changed clientids
/****************************************************************************/            
  
CREATE procedure [dbo].[csp_DWPMUpdateDisposition]  
 @UserId int,  
 @DataWizardInstanceId int,  
 @PreviousDataWizardInstanceId int,  
 @NextStepId int,  
 @NextWizardId int,  
 @EventId int,  
 @ClientID int,  
 @ClientSearchGUID type_GUID,  
 @Validate bit=0,  
 @Finish bit=0,--this will use for set status to finish 
 @val1 int,--Disposition  
 @val2 text--DispositionComment  
-- @val3 datetime,--CallStartTime  
-- @val4 datetime--CallEndTime  
as  
declare @NextStepIdOutPut int  
Begin Try  
 --Checking whether record has been deleted  
 If Exists(SELECT  EventId FROM    EventScreens where EventScreens.EventId = @EventId and isnull(RecordDeleted,''N'')=''Y'')  
  Begin    
  RAISERROR   
  (  
   ''Record Has been Deleted.'', -- Message text.  
    16, -- Severity.  
   1 -- State.  
  );  
  End   
 --Last query will always be for the values in the table  
 if(isnull(@EventId,0)=0)  
 Begin  
  RAISERROR   
  (  
   ''EventId Can Not Be null.'', -- Message text.  
    16, -- Severity.  
   1 -- State.  
  );  
 End  
 if(not Exists(select EventId  FROM    EventScreens  where EventScreens.EventId = @EventId))  
      Begin  
   insert into EventScreens  
   (  
    EventId,   
    Disposition,  
    DispositionComment--,  
--    CallStartTime,  
--    CallEndTime  
   )  
   Values  
   (  
    @EventId,  
    @val1,--Disposition  
    @val2--DispositionComment  
--    @val3,--CallStartTime  
--    @val4--CallEndTime  
  
   )  
   End  
Else  
Begin  
 update EventScreens   
 set  
  Disposition=@val1,  
  DispositionComment=@val2--,  
--  CallStartTime=@val3,  
--  CallEndTime=@val4  
 where EventId=@EventId  

--Update the Events table with a new clientId --av 8/29/2008
	if isnull(@ClientId,0)<>0 
	and exists ( select * from events e where e.EventId = @EventId 
		and isnull(e.ClientId,0) <> @ClientId )
	Begin  
		Update Events   
		Set ClientId=@ClientId  
		where EventId=@EventId  
	End   

-- Update Primary Clinician  srf 9-29-2007
	IF Exists (Select * from EventScreens e
				Join CustomRiverwoodAccessCenter a on a.EventId = e.EventId
				
				Where e.EventId = @EventId 
				and isnull(e.EligibleForTreatment, ''N'')= ''Y''
				and isnull(a.ClinicianId, 0) <> 0
				and isnull(e.RecordDeleted, ''N'') = ''N''
				and isnull(a.RecordDeleted, ''N'') = ''N'')
	BEGIN 
	Exec csp_DWPMUpdatePrimaryClinician @ClientId, @EventId

	END


-- Create Program for where program doesnt exist  srf 9-29-2007
	IF Exists (Select * from EventScreens e
				Join CustomRiverwoodAccessCenter a on a.EventId = e.EventId
				Where e.EventId = @EventId 
				and isnull(e.EligibleForTreatment, ''N'')= ''Y''
				and isnull(a.ProgramId, 0) <> 0
				and isnull(e.RecordDeleted, ''N'') = ''N''
				and isnull(a.RecordDeleted, ''N'') = ''N'')
	BEGIN 
	Exec csp_DWPMUpdateRequestedProgram @ClientId, @EventId

	END
  
End  
  if( @Finish=1)
	Begin
	 update Events  
	 set  
	 Status=2063 --this is for Completed where category=''EventStatus''  
	 where EventId=@EventId  
  end
 if(@Validate=1)  
 Begin   
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
  
End Try  
Begin Catch  
 declare @Error varchar(8000)  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMAddUpdateDisposition'')   
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
