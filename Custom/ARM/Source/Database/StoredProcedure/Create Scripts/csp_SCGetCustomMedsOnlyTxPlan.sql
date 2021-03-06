/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomMedsOnlyTxPlan]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomMedsOnlyTxPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomMedsOnlyTxPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomMedsOnlyTxPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                                                        
 /* Stored Procedure:csp_SCGetCustomMedsOnlyTxPlan                           */                                               
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */             
 /* Author: Pradeep                                                          */                                                       
 /* Creation Date:  Aug 27,2009                                              */                                                        
 /* Purpose: Gets Data for ActEntranceStayCriteria  Document                 */                                                       
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                                      
 /* Output Parameters:None                                                   */                                                        
 /* Return:                                                                  */                                                        
 /* Calls:                                                                   */            
 /* Called From:                                                             */                                                        
 /* Data Modifications:                                                      */                                                        
 /*-------------Modification History--------------------------               */    
 /*-------Date----Author-------Purpose---------------------------------------*/     
 /* 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0      */  
 /* 03/04/2010 Vikas Monga                                                   */  
 /* -- Remove [Documents] and [DocumentVersions]                             */                        
 /****************************************************************************/                                                         

CREATE PROCEDURE  [dbo].[csp_SCGetCustomMedsOnlyTxPlan]                                          
  @DocumentVersionId INT                                           
AS                                          
BEGIN                            
  BEGIN TRY                                
   --For CustomMedsOnlyTxPlan Table                                                               
	SELECT     DocumentVersionId, AreasOfConcernSymptoms, MyGoalsTreatment, ClientMethod, ClinicianMethod, OtherComments, ClientReceivedCopy, ClientRefusedCopy, 
					  AuthorizationRequestorComment, Assigned, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomMedsOnlyTxPlan
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)       
   
   --For TPProcedures         
   DECLARE @Verssion INT        
   SELECT @Verssion=[Version] FROM DocumentVersions WHERE DocumentVersionId=@DocumentVersionId AND ISNull(RecordDeleted,''N'')=''N''        
   
   SELECT DISTINCT '''' AS DeleteButton, ''N'' AS RadioButton,TP.TPProcedureId,TP.DocumentVersionId,        
   TP.AuthorizationCodeId,TP.Units,TP.FrequencyType,TP.ProviderId,        
   TP.SiteId,TP.StartDate,TP.EndDate,TP.TotalUnits,TP.AuthorizationId,        
   TP.CreatedBy,TP.CreatedDate,TP.ModifiedBy,TP.ModifiedDate,TP.RecordDeleted,TP.DeletedDate        
   ,TP.DeletedBy,             
    CASE ISNULL(P.ProviderName ,''N'')WHEN ''N'' THEN '''' ELSE P.ProviderName  END            
    +                      
    CASE ISNULL(Au.ProviderId,''0'') WHEN ''0'' THEN Ag.AgencyName ELSE '''' END                      
    AS  ProviderName,A.AuthorizationCodeName,GCA.CodeName AS FrequencyApprovedName,              
    GCS.CodeName AS FrequencyRequestedName,Au.Units AS UnitsApproved,Au.StartDate AS StartDateApproved,              
    Au.EndDate AS EndDateApproved,Au.Frequency AS FrequencyApproved,Au.TotalUnits AS TotalUnitsApproved,              
    Au.AuthorizationNumber,Au.Status,Glc.CodeName,Au.UnitsUsed               
    From Agency AS Ag, TpProcedures TP              
    LEFT JOIN Providers P ON P.ProviderID = TP.ProviderID and ( P.RecordDeleted=''N'' or  P.RecordDeleted is null)  and ( TP.RecordDeleted=''N'' or  TP.RecordDeleted is null)                      
    INNER JOIN AuthorizationCodes A ON TP.AuthorizationCodeID = A.AuthorizationCodeID and ( A.RecordDeleted=''N'' or  A.RecordDeleted is null)                      
 -- inner join GlobalCodes Gl on TP.UnitType = Gl.GlobalCodeId  Commented by Piyush as Unit Type field is now removed, 18th Jan 2007                      
    LEFT JOIN Authorizations Au ON Au.TpProcedureId = Tp.TpProcedureId  and ( Au.RecordDeleted=''N'' or  Au.RecordDeleted is null)                      
    LEFT JOIN GlobalCodes GCA ON GCA.GlobalCodeId = Au.Frequency  and (GCA.RecordDeleted=''N'' or GCA.RecordDeleted is null)                      
    LEFT JOIN GlobalCodes GCR ON GCR.GlobalCodeId = Au.FrequencyRequested and (GCR.RecordDeleted=''N'' or GCR.RecordDeleted is null)                      
    LEFT JOIN  GlobalCodes Glc ON  Au.Status=Glc.GlobalCodeId and (Glc.RecordDeleted=''N'' or Glc.RecordDeleted is null)                      
    LEFT JOIN GlobalCodes  GCS  ON GCS.GlobalCodeId = TP.FrequencyType and (GCS.RecordDeleted=''N'' or GCS.RecordDeleted is null)  --Add by sandeep trivedi                    
    WHERE Tp.DocumentVersionId =@DocumentVersionId        
                                                            
 END TRY             
 BEGIN CATCH                            
  DECLARE @Error varchar(8000)                                                               
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                              
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomMedsOnlyTxPlan]'')                                                               
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())             
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                              
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
                           
 END CATCH                                          
End
' 
END
GO
