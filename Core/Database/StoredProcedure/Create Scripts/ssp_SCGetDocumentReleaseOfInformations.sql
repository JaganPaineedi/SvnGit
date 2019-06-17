/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentReleaseOfInformations]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentReleaseOfInformations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentReleaseOfInformations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentReleaseOfInformations]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                                
**  File: ssp_SCGetDocumentReleaseOfInformations                                            
**  Name: ssp_SCGetDocumentReleaseOfInformations                        
**  Desc: To Get Document ROI                                                  
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  April 20 2016
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          

--*******************************************************************************/                                   
CREATE PROCEDURE  [dbo].[ssp_SCGetDocumentReleaseOfInformations]                                                                   
(                                                                                                                                                           
  @DocumentVersionId int                                                                           
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   
 
		

		SELECT	 DROI.DocumentVersionId
			,DROI.CreatedBy
			,DROI.CreatedDate
			,DROI.ModifiedBy
			,DROI.ModifiedDate
			,DROI.RecordDeleted
			,DROI.DeletedBy
			,DROI.DeletedDate
			,DROI.ProgramId
			,DROI.ReleaseToFromContactId
			,DROI.RecordsStartDate
			,DROI.RecordsEndDate
			,DROI.ReleaseType
			,DROI.ReleaseTo
			,DROI.ObtainFrom
			,DROI.ReleaseToFromOrganization
			,DROI.ReleaseContactType
			,DROI.Organization
			,DROI.ReleaseName
			,DROI.ReleaseAddress
			,DROI.ReleaseCity
			,DROI.ReleaseState
			,DROI.ReleasePhoneNumber
			,DROI.ReleaseZip
			--,DROI.UsedOrDisclosedStartDate
			--,DROI.UsedOrDisclosedEndDate
			,DROI.ROIType
			,DROI.OtherPurposeOfDisclosure
			,DROI.ExpirationStartDate
			,DROI.ExpirationEndDate
			,DROI.OtherInformationTobeUsedText
			,DROI.NoticeToClient
			,DROI.AccessToMyRecord
			,DROI.Attention
			,DROI.ContactAddress
			,DROI.ContactCity
			,DROI.ContactState
			,DROI.ContactPhoneNumber
			,DROI.ContactZip
			,DROI.ContactFax
			,DROI.CopyGivenToClient
			,DROI.AgencyStaff
			,DROI.Restrictions
			,DROI.AlcoholDrugAbuse
			,DROI.AIDSRelatedComplex
			,(SELECT D.Name FROM DisclosedToDetails D WHERE D.DisclosedToDetailId=DROI.ReleaseToFromOrganization AND ISNULL(D.RecordDeleted,'N')='N') AS tempReleaseToFrom
			,(SELECT (CC.LastName + ', ' + CC.FirstName ) AS Name FROM ClientContacts CC WHERE CC.ClientContactId=ReleaseToFromContactId AND ISNULL(CC.RecordDeleted,'N')='N') AS tempContactReleaseToFrom
		FROM  DocumentReleaseOfInformations DROI WHERE DROI.DocumentVersionId = @DocumentVersionId
	AND IsNull(DROI.RecordDeleted, 'N') = 'N' 


		SELECT RPD.ROIPurposeOfDisclosureId
		,RPD.CreatedBy
		,RPD.CreatedDate
		,RPD.ModifiedBy
		,RPD.ModifiedDate
		,RPD.RecordDeleted
		,RPD.DeletedBy
		,RPD.DeletedDate
		,RPD.DocumentVersionId
		,RPD.PurposeOfDisclosure
		FROM  ROIPurposeOfDisclosures RPD WHERE RPD.DocumentVersionId = @DocumentVersionId
		AND IsNull(RPD.RecordDeleted, 'N') = 'N' 
		
		
		SELECT RE.ROIExpirationId
		,RE.CreatedBy
		,RE.CreatedDate
		,RE.ModifiedBy
		,RE.ModifiedDate
		,RE.RecordDeleted
		,RE.DeletedBy
		,RE.DeletedDate
		,RE.DocumentVersionId
		,RE.Expiration	
		FROM  ROIExpirations RE WHERE RE.DocumentVersionId = @DocumentVersionId
		AND IsNull(RE.RecordDeleted, 'N') = 'N' 
		
		
		SELECT	RUI.ROIUsedDisclosedInformationId
		,RUI.CreatedBy
		,RUI.CreatedDate
		,RUI.ModifiedBy
		,RUI.ModifiedDate
		,RUI.RecordDeleted
		,RUI.DeletedBy
		,RUI.DeletedDate
		,RUI.DocumentVersionId
		,RUI.UsedOrDisclosed
		FROM  ROIUsedDisclosedInformations RUI WHERE RUI.DocumentVersionId = @DocumentVersionId
		AND IsNull(RUI.RecordDeleted, 'N') = 'N'
		
		
	SELECT	RID.ROIIDVerifyDetailsId
		,RID.CreatedBy
		,RID.CreatedDate
		,RID.ModifiedBy
		,RID.ModifiedDate
		,RID.RecordDeleted
		,RID.DeletedBy
		,RID.DeletedDate
		,RID.DocumentVersionId
		,RID.IDVerified
		FROM  ROIIDVerifyDetails RID WHERE RID.DocumentVersionId = @DocumentVersionId
		AND IsNull(RID.RecordDeleted, 'N') = 'N'
		
		
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetDocumentReleaseOfInformations]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


