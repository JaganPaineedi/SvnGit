/****** Object:  StoredProcedure [dbo].[csp_SCGetAuthDocumentDetails]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetAuthDocumentDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetAuthDocumentDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetAuthDocumentDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/***************************************************************************/                       
/*          
  Stored Procedure: [csp_SCGetAuthDocumentDetails]                                                                        
  Copyright: 2008 Streamline SmartCare                                                                                               
  Creation Date:  September 13,2009                                                                                                 
  Purpose: Gets Data  For Authroziation Document                                                                                
  Input Parameters: @DocumentId,@DocumentVersionID              
  Output Parameters:                                                                                                   
  Return:  0=success, otherwise an error number                                            
  Purpose to show the web document for Diagnosis                                                                        
  Calls:                                                                                                        
  Data Modifications:                                                                                           
  Updates:                                                                                                      
  Date       Author        Purpose                                              
  11/09/2009           Mohit Madaan    Created                        
  28 Sept 2009  Pradeep      Comented selection from SystemConfigurations as it is not in use               
  09 Dec 2009   Ankesh       Modified According to an task# 139                                                             
  03/04/2010 Vikas Monga        
  13-Jan-2010 Rakesh (Modified as to get row from customclientLOC table for UMPart 2 in Authorization Document )                       
  Remove [Documents] and [DocumentVersions]            
*/                                        
/***************************************************************************/                    
           
Create PROCEDURE  [dbo].[csp_SCGetAuthDocumentDetails]        
 @DocumentVersionId int              
AS                
BEGIN                        
                              
 -- Modified by Ankesh               
 SELECT     CAD.DocumentVersionId, CAD.ClientCoveragePlanId, CAD.AuthorizationRequestorComment, CAD.AuthorizationReviewerComment, DC.DocumentName, CAD.Assigned,           
       CAD.CreatedBy, CAD.CreatedDate, CAD.ModifiedBy, CAD.ModifiedDate, CAD.RecordDeleted, CAD.DeletedDate, CAD.DeletedBy          
 FROM         CustomAuthorizationDocuments AS CAD INNER JOIN          
       DocumentVersions AS DV ON CAD.DocumentVersionId = DV.DocumentVersionId INNER JOIN          
       Documents AS D ON D.DocumentId = DV.DocumentId INNER JOIN          
       DocumentCodes AS DC ON DC.DocumentCodeId = D.DocumentCodeId          
 WHERE     (CAD.DocumentVersionId = @DocumentVersionId) AND (ISNULL(CAD.RecordDeleted, ''N'') = ''N'') AND (ISNULL(CAD.RecordDeleted, ''N'') = ''N'') AND           
       (ISNULL(DV.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'') AND (ISNULL(DC.RecordDeleted, ''N'') = ''N'')          
            
  --Checking For Errors                
            
 If (@@error!=0)                
 Begin                
  RAISERROR  20006   ''csp_SCGetAuthDocumentDetails: An Error Occured''                
 Return                
 End                                 
                  
 SELECT     TP.TPProcedureId, TP.DocumentVersionId, TP.AuthorizationCodeId, TP.FrequencyType, TP.Units, TP.ProviderId, 
 cast(p.ProviderId as varchar(10)) +''_''+ CAST(TP.SiteId as varchar(10)) as ProviderIdSiteId, TP.SiteId, TP.StartDate, TP.EndDate, TP.TotalUnits,           
       TP.AuthorizationId, 
       CASE isnull(P.ProviderName, ''N'') WHEN ''N'' THEN '''' ELSE P.ProviderName END + CASE isnull(Tp.ProviderId, ''0'')           
       WHEN ''0'' THEN Ag.AgencyName ELSE '''' END AS ProviderIdSiteIdText, A.AuthorizationCodeName AS AuthorizationCodeIdText, Au.Units AS UnitsApproved,      
       Au.StartDate AS StartDateApproved, Au.EndDate AS EndDateApproved, Au.TotalUnits AS TotalUnitsApproved, GCS.CodeName AS FrequencyTypeText,           
       GCA.CodeName AS FrequencyApprovedName, Au.Frequency AS FrequencyApproved, Au.AuthorizationNumber,''Requested'' as [Status],         
       --Au.Status,         
       Glc.CodeName, Au.UnitsUsed, TP.CreatedBy,           
       TP.CreatedDate, TP.ModifiedBy, TP.ModifiedDate, TP.RecordDeleted, TP.DeletedDate, TP.DeletedBy
               
 FROM         Agency AS Ag CROSS JOIN          
       TPProcedures AS TP LEFT OUTER JOIN          
       Providers AS P ON P.ProviderId = TP.ProviderId AND (P.RecordDeleted = ''N'' OR          
       P.RecordDeleted IS NULL) AND (TP.RecordDeleted = ''N'' OR          
       TP.RecordDeleted IS NULL) INNER JOIN          
       AuthorizationCodes AS A ON TP.AuthorizationCodeId = A.AuthorizationCodeId AND (A.RecordDeleted = ''N'' OR          
       A.RecordDeleted IS NULL) LEFT OUTER JOIN          
       Authorizations AS Au ON Au.TPProcedureId = TP.TPProcedureId AND (Au.RecordDeleted = ''N'' OR          
       Au.RecordDeleted IS NULL) LEFT OUTER JOIN          
       GlobalCodes AS GCA ON GCA.GlobalCodeId = Au.Frequency AND (GCA.RecordDeleted = ''N'' OR          
       GCA.RecordDeleted IS NULL) LEFT OUTER JOIN          
       GlobalCodes AS GCR ON GCR.GlobalCodeId = Au.FrequencyRequested AND (GCR.RecordDeleted = ''N'' OR          
       GCR.RecordDeleted IS NULL) LEFT OUTER JOIN          
       GlobalCodes AS Glc ON Au.Status = Glc.GlobalCodeId AND (Glc.RecordDeleted = ''N'' OR          
       Glc.RecordDeleted IS NULL) LEFT OUTER JOIN          
       GlobalCodes AS GCS ON GCS.GlobalCodeId = TP.FrequencyType AND (GCS.RecordDeleted = ''N'' OR          
       GCS.RecordDeleted IS NULL)          
 WHERE     (TP.DocumentVersionId = @DocumentVersionId)             
                
  --Checking For Errors                
 If (@@error!=0)                
 Begin                
  RAISERROR  20006   ''csp_SCGetAuthDocumentDetails: An Error Occured''                
 Return                
 End       
       
       
       
 -- Added By Rakesh Garg for Getting Custom CLient LOC                                          
 select  CCLoc.ClientLOCId,CCLoc.ClientId, CCLoc.CreatedBy, CCLoc.CreatedDate, CCLoc.ModifiedBy,                             
 CCLoc.ModifiedDate, CCLoc.RecordDeleted, CCLoc.DeletedDate, CCLoc.DeletedBy, CCLoc.LOCId, CCLoc.LOCStartDate, CCLoc.LOCEndDate, CCLoc.LOCBy                 
 from CustomClientLOCs CCLoc                
 inner join Documents d on d.ClientId=CCLoc.ClientId                
 inner join DocumentVersions dv on dv.DocumentId=d.DocumentId                
 where dv.DocumentVersionId = @DocumentVersionId       
 and CCLoc.LOCEndDate IS NULL and Isnull(CCLoc.RecordDeleted,''N'') = ''N''                 
                                 
 If (@@error!=0)    RAISERROR  20006  ''csp_SCGetAuthDocumentDetails: An Error Occured''      
       
                   
              
End ' 
END
GO
