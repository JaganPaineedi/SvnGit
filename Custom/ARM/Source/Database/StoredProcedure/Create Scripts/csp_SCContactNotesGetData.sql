/****** Object:  StoredProcedure [dbo].[csp_SCContactNotesGetData]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCContactNotesGetData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCContactNotesGetData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCContactNotesGetData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[csp_SCContactNotesGetData]        
@clientContactNoteId int        
as        
/*********************************************************************/                                                                  
/* Stored Procedure: dbo.csp_SCContactNotesGetData               */                                                                  
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
/* 05/july/2011   Karan Garg      Created     
/* 11/july/2011   Karan Garg      Altered (Modified Table "CustomClientContactNotes" to "ClientContactNotes" */                            */                                                                
                                                           
                                                                
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
ClientId,        
ContactDateTime,        
ContactReason,        
ContactType,        
ContactStatus,        
ContactQuickDetails,        
ContactDetails,        
NotifyTeam,     
NotifyTeamId,     
NotifyStaff,   
NotifyStaffId,        
NotificationSentDateTime,        
--''C'' as ExternalCode1        
GlobalCodes.ExternalCode1     
 from ClientContactNotes        
left outer join GlobalCodes on ClientContactNotes.ContactStatus = GlobalCodes.GlobalCodeId        
 where ClientContactNoteId = @clientContactNoteId        
        
   END TRY                                      
 BEGIN CATCH                   
 DECLARE @Error varchar(8000)                                                                    
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCContactNotesGetData'')                                          
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
