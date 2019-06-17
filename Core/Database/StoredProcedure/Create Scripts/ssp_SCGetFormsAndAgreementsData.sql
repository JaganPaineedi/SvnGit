/****** Object:  StoredProcedure [dbo].[ssp_SCGetFormsAndAgreementsData]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFormsAndAgreementsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFormsAndAgreementsData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetFormsAndAgreementsData]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                                
**  File: ssp_SCGetFormsAndAgreementsData	2,1                                          
**  Name: ssp_SCGetFormsAndAgreementsData                        
**  Desc: To Get Forms And Agreement tab data for Registrations document
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Alok Kumar                              
**  Date:  January 12 2018
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
--*******************************************************************************/                                   
CREATE PROCEDURE  [dbo].[ssp_SCGetFormsAndAgreementsData]                                                                   
(                                                                                                                                                           
  @ClientID INT, 
  @DocumentVersionId INT = NULL                                                                          
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   

		Declare @RegistrationPacketTypeId Int
		Set @RegistrationPacketTypeId = ( SELECT Top 1 GC.GlobalCodeId  FROM GlobalCodes GC Where GC.Category='DOCUMENTPACKETTYPES'
										AND GC.Code = 'Registration Packet' AND ISNULL(GC.Active,'')='Y' AND ISNULL(GC.RecordDeleted,'N')='N' )
		
		

	IF OBJECT_ID('tempdb..#TempRegistrationPackets') IS NULL
	BEGIN
		CREATE TABLE #TempRegistrationPackets ( TableName varchar(50),
											   DocumentAssignmentDocumentId int,
											   DocumentAssignmentId int,
											   DocumentCodeId int,
											   DocumentName varchar(100),
											   ScreenId int,
											   DocumentId int,
											   DocumentStatus varchar(20),
											   EffectiveDate varchar(20),
											   Author varchar(100),
											   SignedStaff varchar(50),
											   SignedByClientOrGuardian varchar(100)
											 )
	END


	IF (@ClientID > 0)
	BEGIN
		INSERT INTO #TempRegistrationPackets 
		SELECT		'DocumentRegistrationFormAndAgreement' AS TableName
					,DAD.[DocumentAssignmentDocumentId]
					,DAD.[DocumentAssignmentId]
					,DAD.[DocumentCodeId]
					,DC.DocumentName as DocumentName
					,S.ScreenId AS ScreenId
					,NULL AS DocumentId
					,NULL AS DocumentStatus
					,NULL AS EffectiveDate
					,NULL AS Author
					,NULL AS SignedStaff
					,NULL AS SignedByClientOrGuardian
				FROM [DocumentAssignmentDocuments] DAD
				INNER JOIN DocumentAssignments DA ON DA.DocumentAssignmentId=DAD.DocumentAssignmentId
				--INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = DA.PacketType AND ISNULL(GC.RecordDeleted, 'N') <> 'Y' 
				--							AND ISNULL(GC.Active, 'N') = 'Y' AND GC.Category = 'DOCUMENTPACKETTYPES'
				INNER JOIN DocumentCodes DC ON DC.DocumentCodeId=DAD.DocumentCodeId AND ISNULL(DC.RecordDeleted,'N')='N'
				INNER JOIN Screens S ON S.DocumentCodeId = DC.DocumentCodeId AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
				WHERE ISNULL(DAD.RecordDeleted,'N')='N' AND ISNULL(DA.RecordDeleted,'N')='N' 
				AND DA.PacketType IS NOT NUll AND DA.PacketType = @RegistrationPacketTypeId

	END


	--Updating DocumentId from Document table
	UPDATE TRP
	SET  TRP.DocumentId = ( Select Top 1 D.DocumentId 
							From Documents D Where ISNULL(D.RecordDeleted,'N')='N' AND D.DocumentCodeId = TRP.DocumentCodeId
							AND D.ClientID = @ClientID ORDER BY D.EffectiveDate DESC,D.ModifiedDate DESC )
	FROM #TempRegistrationPackets TRP
	
	
	--Updating data from Document table
	UPDATE TRP
	SET  TRP.DocumentStatus = GC1.CodeName
		,TRP.EffectiveDate = Convert(varchar(10), D.EffectiveDate, 101)
		,TRP.Author = ST1.FirstName + ' '+ ST1.LastName
	FROM #TempRegistrationPackets TRP
	LEFT JOIN Documents D On D.DocumentCodeId = TRP.DocumentCodeId AND ISNULL(D.RecordDeleted,'N')='N'
	LEFT JOIN Screens S ON S.DocumentCodeId = TRP.DocumentCodeId AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = D.[Status] AND ISNULL(GC1.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN Staff ST1 ON ST1.StaffId = D.AuthorId AND ISNULL(ST1.RecordDeleted, 'N') <> 'Y'
	Where D.ClientID = @ClientID
	
	
	--Updating data from DocumentSignatures table
	UPDATE TRP
	SET  TRP.SignedStaff = ( Select Top 1 DS.SignerName 
								From DocumentSignatures DS Where ISNULL(DS.RecordDeleted, 'N') <> 'Y' AND DS.DocumentId = TRP.DocumentId
								Order By DS.SignatureDate DESC )
		,TRP.SignedByClientOrGuardian = ( Select Top 1 DS.SignerName 
								From DocumentSignatures DS Where ISNULL(DS.RecordDeleted, 'N') <> 'Y' AND DS.DocumentId = TRP.DocumentId
								AND ISNULL(DS.IsClient, 'N') = 'Y' Order By DS.SignatureDate DESC )
	FROM #TempRegistrationPackets TRP 


	IF @DocumentVersionId IS NULL
	BEGIN
		SELECT
			   TableName,
			   DocumentAssignmentDocumentId,
			   DocumentAssignmentId,
			   DocumentCodeId,
			   DocumentName,
			   ScreenId,
			   DocumentId,
			   DocumentStatus,
			   EffectiveDate,
			   Author,
			   SignedStaff,
			   SignedByClientOrGuardian 
			FROM
			   #TempRegistrationPackets
	END
	ELSE
	BEGIN
		SELECT
			   DocumentAssignmentDocumentId,
			   DocumentAssignmentId,
			   DocumentCodeId,
			   DocumentName,
			   ScreenId,
			   DocumentId,
			   DocumentStatus,
			   EffectiveDate,
			   Author,
			   SignedStaff,
			   SignedByClientOrGuardian 
			FROM
			   #TempRegistrationPackets
	END


	IF OBJECT_ID('tempdb..#TempRegistrationPackets') IS NOT NULL
	BEGIN
		DROP TABLE #TempRegistrationPackets
	END

		
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetFormsAndAgreementsData]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


