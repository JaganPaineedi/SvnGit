/****** Object:  StoredProcedure [dbo].[csp_DWPMGetDisposition]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetDisposition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMGetDisposition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetDisposition]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */            
/* Stored Procedure: dbo.csp_DWPMGetDisposition        */            
/* Copyright: 2007 Provider Access Application        */            
/* Creation Date:  21st-Aug-2007            */            
/*                   */            
/* Purpose: This stored procedure is the Retrieve Stored Procedure and is used for Access Center-Disposition */           
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
/*  21st-Aug-2007   Jatinder Singh             SP for Access Center-Disposition */            
--  21st-Sep-2007   Jatinder Singh			 Changed for Task "Access Center: Disposition" Task#42
/****************************************************************************/            
  
CREATE procedure [dbo].[csp_DWPMGetDisposition]  
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

 --The following query\queries are for dropdowns  
 Select GlobalCodeId,CodeName from globalCodes where Category=''SCREENDISPOSITION'' and isnull(RecordDeleted,''N'')=''N'' 
 and Active=''Y'' 
 Order by SortOrder
 
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
  
 SELECT  EventId,  
   Disposition,   
   DispositionComment --,  
--   (select Convert(varchar,CallStartTime,101)) as CallStartTime,  
--   (select Convert(varchar,CallEndTime,101)) as CallEndTime  
 FROM    EventScreens   
 where EventScreens.EventId = @EventId  
   
End Try  
Begin Catch  
 declare @Error varchar(8000)  
  set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
     + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMGetDisposition'')   
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
