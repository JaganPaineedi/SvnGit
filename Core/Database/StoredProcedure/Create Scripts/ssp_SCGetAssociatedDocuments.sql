IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAssociatedDocuments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetAssociatedDocuments] --16928
GO

CREATE PROCEDURE [dbo].[ssp_SCGetAssociatedDocuments] (
@NativeDocumentId varchar(30) ,@FromScaned char(2)


)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetAssociatedDocuments] 5457789          */
/* Date              Author                  Purpose                 */
/* 22/09/2017       Sunil.D                 SC: To get data to child grid in Associate Documents
											Thresholds-Enhancements #838  */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/ 
/**  --------  --------    ------------------------------------------- */
BEGIN
	BEGIN TRY
	if(@FromScaned='1')
	  begin
	     select
				AD.AssociateDocumentId
				,AD.CreatedBy
				,AD.CreatedDate
				,AD.ModifiedBy
				,AD.ModifiedDate
				,AD.RecordDeleted
				,AD.DeletedBy
				,AD.DeletedDate
				,AD.ClientId
				,AD.NativeDocumentId
				,AD.DocumentId
				,d.DocumentCodeId
				,d.EffectiveDate as EffectiveDate
				,dc.DocumentName as   DocumentName                                                                 
				,a.LastName + ', ' + a.FirstName  as DocumentAuthorName
				,d.CurrentDocumentVersionId as [Version]
				,C.LastName + ', ' + C.FirstName as ClientName
				,gcs.CodeName as DocumentStatusName 
		   FROM Associatedocuments AD 
				join Documents d on d.DocumentId = AD.DocumentId    
				join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId 
				join GlobalCodes gcs on gcs.GlobalCodeId = d.Status    
				join Staff a on a.StaffId = d.AuthorId   
				join Clients as C on d.ClientId=C.ClientId        
		   WHERE   AD.NativeImageRecordId = @NativeDocumentId 
				AND ISNULL(AD.RecordDeleted,'N') <> 'Y'  
				AND ISNULL(d.RecordDeleted,'N') <> 'Y'  
	  end
	  else
	  begin
       select
				AD.AssociateDocumentId
				,AD.CreatedBy
				,AD.CreatedDate
				,AD.ModifiedBy
				,AD.ModifiedDate
				,AD.RecordDeleted
				,AD.DeletedBy
				,AD.DeletedDate
				,AD.ClientId
				,AD.NativeDocumentId
				,AD.DocumentId
				,d.DocumentCodeId
				,d.EffectiveDate as EffectiveDate
				,dc.DocumentName as   DocumentName                                                                 
				,a.LastName + ', ' + a.FirstName  as DocumentAuthorName
				,d.CurrentDocumentVersionId as [Version]
				,C.LastName + ', ' + C.FirstName as ClientName
				,gcs.CodeName as DocumentStatusName 
		   FROM Associatedocuments AD 
				join Documents d on d.DocumentId = AD.DocumentId    
				join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId 
				join GlobalCodes gcs on gcs.GlobalCodeId = d.Status    
				join Staff a on a.StaffId = d.AuthorId   
				join Clients as C on d.ClientId=C.ClientId        
		   WHERE AD.NativeDocumentId = @NativeDocumentId  
				AND ISNULL(AD.RecordDeleted,'N') <> 'Y'  
				AND ISNULL(d.RecordDeleted,'N') <> 'Y'  
	end			
      
		
	END TRY 
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000) 
		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAssociatedDocuments') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE()) 
		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END