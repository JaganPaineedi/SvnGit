/****** Object:  StoredProcedure [dbo].[ssp_SCPeerRecordReviewFormDetails]    Script Date: 08/24/2012 19:10:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPeerRecordReviewFormDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCPeerRecordReviewFormDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCPeerRecordReviewFormDetails]    Script Date: 08/24/2012 19:10:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCPeerRecordReviewFormDetails] --391,     407233 
	@RecordReviewId INT
	,@DocumentVersionId1 INT = NULL
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCPeerRecordReviewFormDetails                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    03/June/2011                                         */
/*                                                                   */
/* Purpose:  Used to display records for any RecordReviewTemplate in order to insert new review  */
/*                                                                   */
/* Input Parameters:   @RecordReviewTemplateId , @RecordReviewId      */
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
/* 03/june/2011   Karan Garg      Created                             */
/*  09/July/2012  Jadeep          Modify as per task # 1457 Record review: Client name dosen't get changed when doc oened from hyperlin-Thresholds - Bugs/Features (Offshore)        */
/*                                  added new col clientname1,clientname2,clientname3      */
/*11July2012 Shifali        Section Order rectified as it should be as per ItemNumber not per SectionName as its already (Ref task# 1523 Thresholds Bugs/Features)*/
/*26July2012 Vikas Kashyap  Added New Column "CalculateStoredProcedure" w.r.t. Task#1607 */
/*13Aug2012  Maninder        Added New table #tempDocumentVersion for DocumentVersionId1 */
/* 24/Mar/2014    Ponnin		  Moved from Threshold's 'Record Review' and changed to Core SP - For task #22 of Customization Bugs */
/*  21 Oct 2015   Revathi    what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
/							  why:task #609, Network180 Customization  */
/*********************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #tempDocumentVersion (DocumentVersionId INT)

		INSERT INTO #tempDocumentVersion
		SELECT DocumentVersionId
		FROM DocumentVersions
		WHERE DocumentId = (
				SELECT DocumentId
				FROM DocumentVersions
				WHERE DocumentVersionId = @DocumentVersionId1
					AND isnull(RecordDeleted, 'N') <> 'Y'
				)

		DECLARE @RecordReviewTemplateId INT

		SET @RecordReviewTemplateId = (
				SELECT RecordReviewTemplateId
				FROM RecordReviews
				WHERE RecordReviewId = @RecordReviewId
				)

		SELECT RecordReviewId
			,RecordReviews.[CreatedBy]
			,RecordReviews.[CreatedDate]
			,RecordReviews.[ModifiedBy]
			,RecordReviews.[ModifiedDate]
			,RecordReviews.[RecordDeleted]
			,RecordReviews.[DeletedDate]
			,RecordReviews.[DeletedBy]
			,RecordReviews.[RecordReviewTemplateId]
			,[ReviewingStaff]
			,[ClinicianReviewed]
			,RecordReviews.[ClientId]
			,[Status]
			,[AssignedDate]
			,[CompletedDate]
			,[ReviewComments]
			,[Results]
			,[RequestQIReview]
			,
			--Added by Revathi 21 Oct 2015
			CASE 
				WHEN ISNULL(Clients.ClientType, 'I') = 'I'
					THEN ISNULL(ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, ''), 'N/A')
				ELSE ISNULL(Clients.OrganizationName, 'N/A')
				END AS ClientName
			,
			--ISNULL((Clients.LastName+', '+Clients.FirstName),'N/A') as ClientName,                                    
			RecordReviewTemplates.RecordReviewTemplateName AS TemplateName
			,s1.LastName + ', ' + s1.FirstName AS ReviewingStaffName
			,ISNULL((s2.LastName + ', ' + s2.FirstName), 'N/A') AS ClinicianReviewedName
			,RecordReviewTemplates.CalculateStoredProcedure
		FROM RecordReviews
		INNER JOIN RecordReviewTemplates ON RecordReviews.RecordReviewTemplateId = RecordReviewTemplates.RecordReviewTemplateId
		INNER JOIN Staff s1 ON RecordReviews.ReviewingStaff = s1.StaffId
		LEFT JOIN Staff s2 ON RecordReviews.ClinicianReviewed = s2.StaffId
		LEFT JOIN Clients ON Clients.ClientId = RecordReviews.ClientId
		WHERE RecordReviewId = @RecordReviewId
			AND ISNULL(RecordReviews.RecordDeleted, 'N') <> 'Y'

		SELECT CRI.RecordReviewItemId
			,CRI.CreatedBy
			,CRI.CreatedDate
			,CRI.ModifiedBy
			,CRI.ModifiedDate
			,CRI.RecordDeleted
			,CRI.DeletedDate
			,CRI.DeletedBy
			,CONVERT(INT, ROW_number() OVER (
					ORDER BY CRI.RecordReviewId
					)) AS srno
			,CRI.RecordReviewTemplateItemId
			,CRI.RecordReviewId
			,CRI.Answer
			,CRI.ServiceId
			,CRI.AnswerYesNoNA
			,CRI.AnswerDate
			,CRI.AnswerInteger
			,CRI.AnswerComment
			,CRI.DocumentVersionId1
			,
			--(Case  when exists( select top 1 DocumentVersionId from #tempDocumentVersion where #tempDocumentVersion.DocumentVersionId =CRI.DocumentVersionId1)     
			--    then @DocumentVersionId1    
			--else CRI.DocumentVersionId1 end ) as DocumentVersionId1,    
			CRI.DocumentVersionId2
			,CRI.DocumentVersionId3
			,CRRTI.Section
			,CRRTI.SummaryOrDocumentSpecific
			,CRRTI.Prompt
			,CRRTI.HelpText
			,CRRTI.NAResponseAllowed
			,GC.CodeName AS ResponseType
			,d.ClientId AS ClientId1
			,d.DocumentId AS DocumentId1
			,isnull(d.ServiceId, 0) AS ServiceId1
			,d.DocumentCodeId AS DocumentCodeId1
			,sr.ScreenId AS ScreenId1
			,CASE 
				WHEN pc.DisplayDocumentAsProcedureCode = 'Y'
					THEN pc.DisplayAs
				WHEN dc.DocumentCodeId = 2
					AND tp.PlanOrAddendum = 'A'
					THEN 'TxPlan Addendum'
				ELSE dc.DocumentName
				END AS DocumentName1
			,ISNULL((dc1.LastName + ', ' + dc1.FirstName), '') AS ClientName1
			,d2.ClientId AS ClientId2
			,d2.DocumentId AS DocumentId2
			,isnull(d2.ServiceId, 0) AS ServiceId2
			,d2.DocumentCodeId AS DocumentCodeId2
			,sr2.ScreenId AS ScreenId2
			,CASE 
				WHEN pc2.DisplayDocumentAsProcedureCode = 'Y'
					THEN pc2.DisplayAs
				WHEN dc2.DocumentCodeId = 2
					AND tp2.PlanOrAddendum = 'A'
					THEN 'TxPlan Addendum'
				ELSE dc2.DocumentName
				END AS DocumentName2
			,ISNULL((d2c2.LastName + ', ' + d2c2.FirstName), '') AS ClientName2
			,d3.ClientId AS ClientId3
			,d3.DocumentId AS DocumentId3
			,isnull(d3.ServiceId, 0) AS ServiceId3
			,d3.DocumentCodeId AS DocumentCodeId3
			,sr3.ScreenId AS ScreenId3
			,CASE 
				WHEN pc3.DisplayDocumentAsProcedureCode = 'Y'
					THEN pc3.DisplayAs
				WHEN dc3.DocumentCodeId = 2
					AND tp3.PlanOrAddendum = 'A'
					THEN 'TxPlan Addendum'
				ELSE dc3.DocumentName
				END AS DocumentName3
			,ISNULL((d3c3.LastName + ', ' + d3c3.FirstName), '') AS ClientName3
		FROM RecordReviewItems CRI
		INNER JOIN RecordReviewTemplateItems CRRTI ON CRI.RecordReviewTemplateItemId = CRRTI.RecordReviewTemplateItemId
		INNER JOIN GlobalCodes GC ON CRRTI.ResponseType = GC.GlobalCodeId
		----------------------------------------------------------                            
		LEFT JOIN Documents d ON d.CurrentDocumentVersionId = CRI.DocumentVersionId1
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		--Left join #tempDocumentVersion on   CRI.DocumentVersionId1=#tempDocumentVersion.DocumentVersionId                       
		LEFT JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		LEFT JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.STATUS
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		LEFT JOIN Staff a ON a.StaffId = d.AuthorId
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		LEFT JOIN DocumentSignatures dsc ON dsc.DocumentId = d.DocumentId
			AND dsc.IsClient = 'Y'
			AND isnull(dsc.RecordDeleted, 'N') = 'N'
		LEFT JOIN Services s ON s.ServiceId = d.ServiceId
			AND d.STATUS IN (
				20
				,21
				,22
				,23
				)
			AND dc.ServiceNote = 'Y'
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeID
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		LEFT JOIN TpGeneral tp ON tp.DocumentVersionId = d.CurrentDocumentVersionId
			AND (CRI.DocumentVersionId1 IS NOT NULL)
		LEFT JOIN Clients dc1 ON dc1.ClientId = d.ClientId
		-----------------------------------------------------------------                             
		LEFT JOIN Documents d2 ON d2.CurrentDocumentVersionId = CRI.DocumentVersionId2
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN DocumentCodes dc2 ON dc2.DocumentCodeId = d2.DocumentCodeId
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN Screens sr2 ON sr2.DocumentCodeId = d2.DocumentCodeId
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN GlobalCodes gcs2 ON gcs2.GlobalCodeId = d2.STATUS
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN Staff a2 ON a2.StaffId = d2.AuthorId
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN DocumentSignatures dsc2 ON dsc2.DocumentId = d2.DocumentId
			AND dsc2.IsClient = 'Y'
			AND isnull(dsc2.RecordDeleted, 'N') = 'N'
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN Services s2 ON s2.ServiceId = d2.ServiceId
			AND d2.STATUS IN (
				20
				,21
				,22
				,23
				)
			AND dc2.ServiceNote = 'Y'
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN ProcedureCodes pc2 ON pc2.ProcedureCodeId = s2.ProcedureCodeID
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN TpGeneral tp2 ON tp2.DocumentVersionId = d2.CurrentDocumentVersionId
			AND (CRI.DocumentVersionId2 IS NOT NULL)
		LEFT JOIN Clients d2c2 ON d2c2.ClientId = d2.ClientId
		-----------------------------------------------------------------                             
		LEFT JOIN Documents d3 ON d3.CurrentDocumentVersionId = CRI.DocumentVersionId3
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN DocumentCodes dc3 ON dc3.DocumentCodeId = d3.DocumentCodeId
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN Screens sr3 ON sr3.DocumentCodeId = d3.DocumentCodeId
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN GlobalCodes gcs3 ON gcs3.GlobalCodeId = d3.STATUS
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN Staff a3 ON a3.StaffId = d3.AuthorId
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN DocumentSignatures dsc3 ON dsc3.DocumentId = d3.DocumentId
			AND dsc3.IsClient = 'Y'
			AND isnull(dsc3.RecordDeleted, 'N') = 'N'
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN Services s3 ON s3.ServiceId = d3.ServiceId
			AND d3.STATUS IN (
				20
				,21
				,22
				,23
				)
			AND dc3.ServiceNote = 'Y'
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN ProcedureCodes pc3 ON pc3.ProcedureCodeId = s3.ProcedureCodeID
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN TpGeneral tp3 ON tp3.DocumentVersionId = d3.CurrentDocumentVersionId
			AND (CRI.DocumentVersionId3 IS NOT NULL)
		LEFT JOIN Clients d3c3 ON d3c3.ClientId = d3.ClientId
		WHERE RecordReviewId = @RecordReviewId
			AND ISNULL(CRI.RecordDeleted, 'N') <> 'Y'
		ORDER BY CRRTI.Section
			,CRRTI.ItemNumber

		--********* Section ***********--          
		DECLARE @Section TABLE (
			SectionId INT PRIMARY KEY identity(1, 1)
			,Section VARCHAR(250)
			,Type VARCHAR(10)
			)

		INSERT INTO @Section
		--select Convert(INT,ROW_NUMBER() over(order by Type asc )) as SectionId,Section,Type from (select distinct section as Section,'S' as Type from RecordReviewTemplateItems  CRRTI                 
		SELECT Section
			,Type
		FROM (
			SELECT DISTINCT section AS Section
				,'S' AS Type
			FROM RecordReviewTemplateItems CRRTI
			INNER JOIN RecordReviewItems CRI ON CRI.RecordReviewTemplateItemId = CRRTI.RecordReviewTemplateItemId
			WHERE RecordReviewTemplateId = ISNULL(@RecordReviewTemplateId, RecordReviewTemplateId)
				AND CRI.RecordReviewId = @RecordReviewId
				AND SummaryOrDocumentSpecific = 'S'
			
			UNION
			
			SELECT DISTINCT section AS Section
				,'D' AS Type
			FROM RecordReviewTemplateItems CRRTI
			INNER JOIN RecordReviewItems CRI ON CRI.RecordReviewTemplateItemId = CRRTI.RecordReviewTemplateItemId
			WHERE RecordReviewTemplateId = ISNULL(@RecordReviewTemplateId, RecordReviewTemplateId)
				AND CRI.RecordReviewId = @RecordReviewId
				AND SummaryOrDocumentSpecific = 'D'
				--and CRI.DocumentVersionId1 = ISNULL(@DocumentVersionId1,CRI.DocumentVersionId1 )          
				AND CRI.DocumentVersionId1 IN (
					SELECT DocumentVersionId
					FROM #tempDocumentVersion
					) --(select DocumentVersionId from DocumentVersions where DocumentId=(select DocumentId from DocumentVersions where DocumentVersionId=@DocumentVersionId1 and isnull(RecordDeleted,'N')<>'Y'))    
			) AS Section
		ORDER BY Section ASC

		--select SectionId, Section, Type from @Section as Section           
		--select * FROM @Section      
		DECLARE @SectionOrder TABLE (
			SectionId INT
			,OrderNumber INT
			)

		INSERT INTO @SectionOrder
		SELECT S.SectionId
			,MIN(ItemNumber)
		FROM @Section S
		LEFT JOIN RecordReviewTemplateItems CRI ON CRI.Section = S.Section
		INNER JOIN RecordReviews CRR ON CRR.RecordReviewTemplateId = CRI.RecordReviewTemplateId
			AND CRR.RecordReviewId = @RecordReviewId
			AND ISNULL(CRI.RecordDeleted, 'N') <> 'Y'
		GROUP BY S.SectionId

		--select * FROM @SectionOrder        
		SELECT Section.SectionId
			,Section.Section
			,Section.Type
		FROM @Section AS Section
		LEFT JOIN @SectionOrder SO ON SO.SectionId = Section.SectionId
		ORDER BY SO.OrderNumber

		DROP TABLE #tempDocumentVersion
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCPeerRecordReviewFormDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                      
				16
				,-- Severity.                                                                                      
				1 -- State.                                                                                          
				);
	END CATCH
END
GO

