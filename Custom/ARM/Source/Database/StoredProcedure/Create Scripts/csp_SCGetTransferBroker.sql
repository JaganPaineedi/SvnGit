/****** Object:  StoredProcedure [dbo].[csp_SCGetTransferBroker]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetTransferBroker]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetTransferBroker]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetTransferBroker]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************/                        
/*   
 Stored Procedure: dbo.csp_SCGetTransferBroker                         
 Copyright: 2009 Streamline SmartCare                                      
 Creation Date:  28/11/2006                                                                    
 Purpose: Gets Data for Transfer/Broker                                                 
 Input Parameters: DocumentID, @DocumentVersionId                                    
 Output Parameters:                                                                     
 Return:                                           
 Called By:                                                                            
 Calls:                                                                                               
 Data Modifications:                                                                                 
 Updates:                                                                                              
 Date              Author              Purpose                                              
 28/11/2006     Prabhakar          Created                                    
 6/11/2009    Umesh Sharma           Modified    
 03/04/2010 Vikas Monga               
    Remove [Documents] and [DocumentVersions]  
  
*/                          
/********************************************************************/                
CREATE PROCEDURE [dbo].[csp_SCGetTransferBroker]            
  @DocumentVersionId INT               
AS              
BEGIN              
 BEGIN TRY            
    /* CustomTransferBroker Table*/            
 SELECT     DocumentVersionId, DocumentType, DateOfRequest, CurrentProgram, ProgramRequested, ServiceRequested, RequestedClinician, VerballyAcceptedDate, Rationale,   
      Findings, NoticeDeliveredDate, NotifyStaff1, NotifyStaff2, NotifyStaff3, NotifyStaff4, NotificationMessage, NotificationSent,   
      NUll AS ServiceRequestedId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate,   
      DeletedBy  
 FROM         CustomTransferBroker  
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)             
             
  /* CustomRequestedServices Table*/            
 SELECT     CustomRequestedServicesId, DocumentVersionId, Requested, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy  
 FROM         CustomRequestedServices  
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)           
             
 END TRY            
 BEGIN CATCH                                    
  DECLARE @Error varchar(8000)                                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                      
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetTransferBroker]'')                                                                       
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                      
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                      
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                    
                                   
 END CATCH               
           
end
' 
END
GO
