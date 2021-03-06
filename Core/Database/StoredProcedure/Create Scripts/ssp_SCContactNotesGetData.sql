/****** Object:  StoredProcedure [dbo].[csp_SCContactNotesGetData]    Script Date: 11/18/2011 16:25:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCContactNotesGetData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCContactNotesGetData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCContactNotesGetData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[ssp_SCContactNotesGetData]        
@clientContactNoteId int        
as        
/*********************************************************************/                                                                  
/* Stored Procedure:[ssp_SCContactNotesGetData] 31              */                                                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                  
/* Creation Date:    05/July/2011                                         */                                                                  
/*                                                                   */                                                                  
/* Purpose:  Used in getdata() for ContactNotes  */                                                                 
/*                                                                   */                                                                
/* Input Parameters:     @clientContactNoteId   */                                                                
/*                                                                   */                                                                  
/* Output Parameters:   None                */                                                                  
/*                                                                   */                                                                  
/* Return:  0=success, otherwise an error number                     */                                                                  
/*                                                                   */                                                                  
/* Called By:                                                        */                                                                  
/*                                                                   */                                                                  
/* Calls:                                                            */                                                                  
/*                                                                   */                                                                  
/* Data Modifications:                                               */                                                                  
/*                                                                   */                                                                  
/* Updates:                                                          */                                                                  
/*  Date         Author          Purpose                             */                                                                  
/* 05/july/2011   Karan Garg      Created     */
/* 11/july/2011   Karan Garg      Altered (Modified Table "CustomClientContactNotes" to "ClientContactNotes" */                                                                                            
/* 05/Feb/2014   Munish      Changed Custom CSP to Core SSP */  
/* 05/Apr/2016   Venkatesh   Get the  ReferenceType,ReferenceId,AssignedTo - As per task Renaissance - Dev Items - #780*/ 

/* 13/Dec/2016   Ajay        Get the IndividualOrganization - As per task Woods - Support Go Live - #143                   */                                                                                          
/* 17/July/2017	 Malathi Shiva  Retrieving RWQM tab details - AHN - Customizations: Task# 44	*/                                                      
/*********************************************************************/                                                                       
BEGIN                                                   
 BEGIN TRY          
select ClientContactNoteId,        
ClientContactNotes.CreatedBy,        
ClientContactNotes.CreatedDate,        
ClientContactNotes.ModifiedBy,        
ClientContactNotes.ModifiedDate,        
ClientContactNotes.RecordDeleted,        
ClientContactNotes.DeletedBy,        
ClientContactNotes.DeletedDate,        
ClientContactNotes.ClientId,        
ClientContactNotes.ContactDateTime,        
ClientContactNotes.ContactReason,        
ClientContactNotes.ContactType,        
ClientContactNotes.ContactStatus,        
ClientContactNotes.ContactQuickDetails,        
ClientContactNotes.ContactDetails,        
ClientContactNotes.NotifyTeam,     
ClientContactNotes.NotifyTeamId,     
ClientContactNotes.NotifyStaff,   
ClientContactNotes.NotifyStaffId,        
ClientContactNotes.NotificationSentDateTime,        
--''C'' as ExternalCode1        
GlobalCodes.ExternalCode1,
--Added by 05/Apr/2016   Venkatesh
   ClientContactNotes.ReferenceType,
ClientContactNotes.ReferenceId,
ClientContactNotes.AssignedTo,  
ClientContactNotes.IndividualOrganization    --Added by Ajay 
 from ClientContactNotes        
left outer join GlobalCodes on ClientContactNotes.ContactStatus = GlobalCodes.GlobalCodeId        
 where ClientContactNoteId = @clientContactNoteId  
 
 SELECT 
	 RWQM.RWQMWorkQueueId
	,RWQM.CreatedBy
	,RWQM.CreatedDate
	,RWQM.ModifiedBy
	,RWQM.ModifiedDate
	,RWQM.RecordDeleted
	,RWQM.DeletedBy
	,RWQM.DeletedDate
	,RWQM.ChargeId
	,RWQM.FinancialAssignmentId
	,RWQM.RWQMRuleId
	,RWQM.RWQMActionId
	,RWQM.ClientContactNoteId
	,RWQM.CompletedBy
	,RWQM.DueDate
	,RWQM.OverdueDate
	,RWQM.CompletedDate
	,RWQM.ActionComments
	--,Ac.ActionName    
	,(Select top 1 ActionName from RWQMActions AC where Ac.RWQMActionId = RWQM.RWQMActionId AND ISNULL(Ac.RecordDeleted, ''N'') = ''N''  AND ISNULL(Ac.Active, ''N'') = ''Y'') as ActionName
    ,S.ServiceId   
    ,S.DateOfService    AS DOS   
    ,RR.RWQMRuleName   
    ,S.ClientId 
FROM   RWQMWorkQueue RWQM 
       INNER JOIN Charges CH 
               ON RWQM.ChargeId = CH.ChargeId 
       INNER JOIN Services S 
               ON S.ServiceId = CH.ServiceId 
       INNER JOIN Clients C 
               ON S.ClientId = C.ClientId 
       INNER JOIN RWQMRules RR 
               ON RR.RWQMRuleId = RWQM.RWQMRuleId 
       INNER JOIN ClientContactNotes CCN 
              ON RWQM.ClientContactNoteId = CCN.ClientContactNoteId --AND ISNULL(ReferenceType,0)= 9466
       INNER JOIN RWQMClientContactNotes RWQMCCN 
			  ON RWQMCCN.ClientContactNoteId = CCN.ClientContactNoteId AND RWQMCCN.RWQMWorkQueueId = RWQM.RWQMWorkQueueId 
			  
				
       --LEFT JOIN RWQMActions Ac 
       --       ON Ac.RWQMActionId = RWQM.RWQMActionId AND ISNULL(Ac.RecordDeleted, ''N'') = ''N''  
       --LEFT JOIN Staff St
       --       ON St.StaffId = RWQM.CompletedBy AND ISNULL(S.RecordDeleted, ''N'') = ''N''  
       WHERE
       ISNULL(C.RecordDeleted, ''N'') = ''N''
       AND ISNULL(CCN.RecordDeleted, ''N'') = ''N''
       AND ISNULL(CH.RecordDeleted, ''N'') = ''N''
       AND ISNULL(RR.RecordDeleted, ''N'') = ''N''
        AND ISNULL(RWQMCCN.RecordDeleted, ''N'') = ''N''
       AND CCN.ClientContactNoteId = @clientContactNoteId
       ORDER BY RWQM.CreatedDate

     
        
   END TRY                                      
 BEGIN CATCH                   
 DECLARE @Error varchar(8000)                                                                    
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCContactNotesGetData'')                                          
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                      
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                                    
                                                                   
    RAISERROR                                                                     
    (                                                          
  @Error, -- Message text.                                                                    
  16, -- Severity.                                                                    
  1 -- State.                                                                    
    );                                                     
 End CATCH                                                                                                           
                                               
End         ' 
END
GO
