IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_GetDocumentCodesDetail')
	BEGIN
		DROP  Procedure  ssp_GetDocumentCodesDetail
	END

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure ssp_GetDocumentCodesDetail
(
@DocumentCodeId int
)
as
/************************************************************************************************                        
**  File:                                           
**  Name: ssp_GetDocumentCodesDetail                                          
**  Desc: This Store Procedure Get The Records From Banner Table 
**
**  Parameters: 
**  Input  	@DocumentCodeId INT
**  Output     ----------       ----------- 
**  
**  Author:  Raghu Mohindru
**  Date:  April 17, 2012
*************************************************************************************************
**  Change History  
************************************************************************************************* 
**  Date:			Author:			Description: 
**  --------		--------		-------------------------------------------------------------
   10/24/2013  John Sudhakar      Added functionality to set SignatureDate as EffectiveDate when a flag in DocumentCodes table is set.
   04/23/2014  Chethan N		  Added missing columns RegenerateRDLOnCoSignature, DefaultCoSigner, DefaultGuardian, Need5Columns & FamilyHistoryDocument.
								  Task # 1 CEI - Environment Issues Tracking
   09/22/2014  Venkatesh MR		  Added CoSignerRDL column for Task 78 in Engineering Improvement Initiatives
   10/20/2014  Anto      		  Added ShareDocumentOnSave column for Task 131 in Engineering Improvement Initiatives
   02/07/2015  Bernardin          Added DSMV column. New Direction Env Issue Tracking 42
   10/26/2015  Seema Thakur		  Added ExcludeFromBatchSigning,DaysDocumentEditableAfterSignature column for #225 - Engineering Improvement Initiatives- NBL(I)
   09/13/2016  Nandita		      Added mobile column to DocumentCodes 
   14/02/2017  Arjun K R          Added AllowClientPortalUserAsAuthor column to DocumentCodes
   11/07/2017  Arjun K R          Added PrintOrder and DisclosurePrintOrder column to DocumentCodes. Task #306 BradFord Enhancement. 
   30/06/2017  Pabitra            Added ClientOrder column to DocumentCodes Texas Customizations #104
   18-May-2018 Sachin             What : Added new column AllowVersionAuthorToSign to fetch the column value AllowVersionAuthorToSign='Y' .
                                  Why  : Bradford - Support Go Live #632
	10/9/2018   jcarlson		    Camino SGL 727 - Added new EditableAfterSignature field
   15/Oct/2018 Swatika		      What/Why : Added new column namely "DefaultStaffCosigner" as part of Renaissance - Dev Items Tasks #695
*************************************************************************************************/
BEGIN
BEGIN TRY
SELECT [DocumentCodeId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[DocumentName]
      ,[DocumentDescription]
      ,[DocumentType]
      ,[Active]
      ,[ServiceNote]
      ,[PatientConsent]
      ,[ViewDocument]
      ,[OnlyAvailableOnline]
      ,[ImageFormatType]
      ,[DefaultImageFolderId]
      ,[ImageFormat]
      ,[ViewDocumentURL]
      ,[ViewDocumentRDL]
      ,[StoredProcedure]
      ,[TableList]
      ,[RequiresSignature]
      ,[ViewOnlyDocument]
      ,[DocumentSchema]
      ,[DocumentHTML]
      ,[DocumentURL]
      ,[ToBeInitialized]
      ,[InitializationProcess]
      ,[InitializationStoredProcedure]
      ,[FormCollectionId]
      ,[ValidationStoredProcedure]
      ,[ViewStoredProcedure]
      ,[MetadataFormId]
      ,[TextTemplate]
      ,[RequiresLicensedSignature]
      ,[ReviewFormId]
      ,[NewValidationStoredProcedure]
      ,[AllowEditingByNonAuthors]
      ,[EnableEditValidationStoredProcedure]
      ,[MedicationReconciliationDocument]
      ,[MultipleCredentials]
      ,[RecreatePDFOnClientSignature]
      ,[DiagnosisDocument]
      ,[RegenerateRDLOnCoSignature]
	  ,[DefaultCoSigner]
	  ,[DefaultGuardian]
      ,[Need5Columns]
      ,[SignatureDateAsEffectiveDate]
      ,[FamilyHistoryDocument]
      ,CoSignerRDL
      ,ShareDocumentOnSave -- Added column for task #78
      ,[DSMV]
       --10/26/2015  Seema Thakur
      ,ExcludeFromBatchSigning
	  ,DaysDocumentEditableAfterSignature
	  ,Mobile
	  ,AllowClientPortalUserAsAuthor --14/02/2017  Arjun K R
	  -- 11/07/2017  Arjun K R  
	  ,PrintOrder
	  ,DisclosurePrintOrder
	  ,ClientOrder -- 22/06/2017  Pabitra 
	  ,AllowVersionAuthorToSign -- Added By Sachin
	  ,EditableAfterSignature
	  ,DefaultStaffCosigner --15/Oct/2018 Swatika
  FROM [DocumentCodes] where DocumentCodeId=@DocumentCodeId
END TRY
 BEGIN CATCH        
  DECLARE @Error varchar(8000)                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetDocumentCodesDetail')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                  
  RAISERROR                                                                                     
  (                                                       
   @Error, -- Message text.                                                                                    
   16, -- Severity.                                                                                    
   1 -- State.                                                                                    
   );         
 END CATCH

END
