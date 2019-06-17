/****** Object:  StoredProcedure [dbo].[SSP_SCGetClientOrders]    Script Date: 11/12/2013 17:39:50 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetClientOrders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetClientOrders]
GO


GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetClientOrders]    Script Date: 11/12/2013 17:39:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetClientOrders] @DocumentVersionId INT
AS
/*********************************************************************/  
/*   Date			Author             Purpose                             */                                                                                                 
/*  29 Dec 2014		Ponnin			   Return new datatable with information of client Allergies. Why : For task 213 of Philhaven Development. */                                                                                                                                                                                                                                                                                                                                                                                                                                      
/*	11 Feb 2015		Chethan N		   What: Record Deleted check for MDAllergenConcepts table.
									   Why: Philhaven - Customization Issues Tracking task# 1232  */
/*  19 Feb 2015     Gautam             The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
						               and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */			
/* 16 March 2016  Varun Added Sensitive to ClientOrders */           						   
/*	18 Mar 2015		Chethan N		   What: Changes made to display Allergies in tool tip
									   Why:  Philhaven Development task # 230 */
/*	07 Apr 2015		Chethan N		   What: Changes made to display Allergy type along with Allergy Name in tool tip
									   Why:  Philhaven Development task # 239 */	
/*	07 May 2015		Chethan N		   What: Added new column 'MaxDispense'
									   Why:  Philhaven Development task # 234.2 */	
/*	25 May 2015		Chethan N		   What: Added new column 'RationaleOtherText'
									   Why:  Philhaven Development task # 252 */	
/*	18 Jun 2015		Chethan N		   What: Removed the logic to filter out Allergy - Failed Trials
									   Why:  Philhaven Development task # 321 */
/*	13 Jul 2015		Chethan N		   What: Added new column 'ICD10Code' and 'ICD10Code' to ClientOrdersDiagnosisIIICodes 
									   Why:  Diagnosis Changes (ICD10) task # 1 */	
/*	30 Jul 2015		Chethan N		   What: Added new column 'DaysOfWeek' and 'NumberOfDays'
									   Why:  Philhaven Development task # 258 */
/*  06 Aug 2015		Chethan N		   What: Included Allergy Comments  
									   Why:  Woods - Customizations task # 821.1 */ 
/*  07/12/2015		Chethan N		   What : Added column ClientOrders.LaboratoryId
									   Why : Streamline Administration task #153*/	
/*	21 Dec 2015		Chethan N		   What: Removed hardcoded logic to get NumberOfDays
									   Why:  Key Point - Environment Issues Tracking task # 151    */	
/*  28/Mar/2015		Pradeep A		   What : Added column ClientOrders.DrawFromServiceCenter
									   Why : Streamline Administration task #153*/			
/*	27 Dec 2016		Chethan N		   What: Added new columns DiscontinuedReason, PotencyUnit and ParentClientOrderId to ClientOrders
									   Why:  Renaissance - Dev Items task #5	*/ 	
/*  10 Feb 2017		Chethan N		   What : Added new column 'ClinicalLocation' to ClientOrders table.
									   Why : Key Point - Support Go Live task #365	*/				
/*  28/Mar/2017		Chethan N		   What: Change Time format - ScheduleTime.
									   Why:  Renaissance - Dev Items task #5.1	*/					
/*  04/Jul/2017		Chethan N		   What: Retrieving GlobalCodes.CodeName as Status text instead of 'Active'.
									   Why:  AspenPointe - Support Go Live#  175	*/
/*	02/Jul/2018		Chethan N			What : Added LocationId.
										Why : Engineering Improvement Initiatives- NBL(I) task #667	
	03/Apr/2019		Chethan N			What : Retrieving Staff.DisplayAs.
										Why : AHN-Support Go Live task# 535.*/										   				               
/*********************************************************************/      
BEGIN

DECLARE @ClientId INT                                                                                                                                               
                                                                                                                                              
                                                                                                                                                
SELECT @ClientId = ClientId FROM Documents WHERE                                                                                                                                               
 CurrentDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N' 
 
	BEGIN TRY
		SELECT Cl.[ClientOrderId]
			,Cl.[CreatedBy]
			,Cl.[CreatedDate]
			,Cl.[ModifiedBy]
			,Cl.[ModifiedDate]
			,Cl.[RecordDeleted]
			,Cl.[DeletedDate]
			,Cl.[DeletedBy]
			,Cl.[ClientId]
			,Cl.[LaboratoryId]
			,Cl.[OrderId]
			,Cl.[DocumentId]
			,Cl.[PreviousClientOrderId]
			,Cl.[MedicationOrderStrengthId]
			,Cl.[MedicationOrderRouteId]
			,Cl.[OrderPriorityId]
			,Cl.[OrderScheduleId]
			,Cl.[OrderTemplateFrequencyId]
			,Cl.[MedicationUseOtherUsage]
			,Cl.[MedicationOtherDosage]
			,Cl.[RationaleText]
			,Cl.[CommentsText]
			,Cl.[Active]
			,Cl.[OrderPended]
			,Cl.[OrderDiscontinued]
			,Cl.[DiscontinuedDateTime]
			,Cl.[OrderStartOther]
			,Cl.[OrderStartDateTime]
			,Cl.[OrderedBy]
			,Cl.[OrderMode]
			,Cl.[OrderStatus]
			,Cl.[AssignedTo]
			,Cl.[OrderFlag]
			,Cl.[DocumentVersionId]
			,Cl.[OrderPendRequiredRoleAcknowledge]
			,Cl.[OrderPendAcknowledge]
			,Cl.[ReleasedBy]
			,Cl.[ReleasedOn]
			,GC.CodeName AS OrderType
			,CASE ISNULL(Cl.[MedicationUseOtherUsage], 'N')
				WHEN 'Y'
					THEN (O.OrderName + ' ' + Cl.[MedicationOtherDosage])
				WHEN 'N'
					THEN (O.OrderName + ' ' + ISNULL(md.StrengthDescription, ''))
				END AS OrderText
			,OTF.DisplayName AS FrequencyText
			,GCP.CodeName AS PriorityText
			,CASE Cl.Active
				WHEN 'Y'
					THEN GCS.CodeName
				WHEN 'N'
					THEN 'Discontinued'
				END AS StatusText
			,CONVERT(VARCHAR(10), Cl.OrderStartDateTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, Cl.OrderStartDateTime, 100), 7) AS StartDateText
			,S.DisplayAs AS OrderedByText
			,CASE Cl.OrderFlag
				WHEN 'Y'
					THEN 'Yes'
				WHEN 'N'
					THEN 'No'
				END AS Signed
			,CONVERT(VARCHAR(10), Cl.OrderStartDateTime, 101) AS ScheduleDate
			,LEFT(RIGHT(CONVERT(VARCHAR, Cl.OrderStartDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, Cl.OrderStartDateTime, 100), 7),2) AS ScheduleTime
			,Cl.OrderingPhysician
			,Cl.OrderEndDateTime
			,Cl.MedicationDosage
			,Cl.MedicationUnits
			,Cl.MedicationDaySupply
			,Cl.MedicationRefill
			,Cl.Legal
			,Cl.LEVEL
			,Cl.DispenseBrand
			,Cl.IsReadBackAndVerified
			,CASE Cl.IsReadBackAndVerified
				WHEN 'Y'
					THEN 'Yes'
				WHEN 'N'
					THEN 'No'
				END AS IsReadBackAndVerifiedText
			,Cl.MayUseOwnSupply
			,Cl.ConsentIsRequired
			,Cl.MaySelfAdminister
			,Cl.IsPRN
			,ISNULL(O.Sensitive,'N') AS Sensitive
			,Cl.MaxDispense
			,Cl.RationaleOtherText
			,Cl.DaysOfWeek
			,CASE 
				WHEN CONVERT(FLOAT,GCF.ExternalCode1) < 1 
					THEN CASE 
						WHEN CONVERT(FLOAT,GCF.ExternalCode1)*7 > 1 
							THEN FLOOR(CONVERT(FLOAT,GCF.ExternalCode1)*7) 
						ELSE 1 
						END
				ELSE '0'
				END AS 'NumberofDays'  
			,Cl.DrawFromServiceCenter
			,Cl.DiscontinuedReason
			,Cl.PotencyUnit
			,Cl.ParentClientOrderId
			,Cl.ClinicalLocation
			,Cl.LocationId
		FROM ClientOrders Cl
		INNER JOIN Orders O ON O.OrderId = Cl.OrderId
			AND ISNULL(Cl.RecordDeleted, 'N') <> 'Y'
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = O.OrderType
			AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
		--LEFT JOIN OrderFrequencies OFC ON OFC.OrderFrequencyId = Cl.OrderFrequencyId
		--	AND ISNULL(OFC.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN OrderTemplateFrequencies OTF ON Cl.OrderTemplateFrequencyId = OTF.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes GCF ON GCF.GlobalCodeId = OTF.RxFrequencyId  
			AND ISNULL(GCF.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(OTF.SelectDays,'N')='Y'
		LEFT JOIN GlobalCodes GCS ON GCS.GlobalCodeId = Cl.OrderStatus
			AND ISNULL(GCS.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes GCP ON GCP.GlobalCodeId = Cl.OrderPriorityId
			AND ISNULL(GCP.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN OrderStrengths OS ON OS.OrderStrengthId = Cl.MedicationOrderStrengthId
			AND ISNULL(OS.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff S ON S.StaffId = Cl.OrderedBy
			AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN MDMedications md ON md.MedicationId = isnull(os.MedicationId, 0)
			AND ISNULL(md.RecordDeleted, 'N') = 'N'
		WHERE Cl.DocumentVersionId = @DocumentVersionId

		--ClientOrderQnAnswers     
		SELECT coq.ClientAnswerId
			,coq.CreatedBy
			,coq.CreatedDate
			,coq.ModifiedBy
			,coq.ModifiedDate
			,coq.RecordDeleted
			,coq.DeletedBy
			,coq.DeletedDate
			,coq.QuestionId
			,coq.ClientOrderId
			,coq.AnswerType
			,coq.AnswerText
			,coq.AnswerValue
			,coq.AnswerDateTime
			,coq.HealthDataAttributeId
		FROM ClientOrderQnAnswers coq
		INNER JOIN ClientOrders CL ON CL.ClientOrderId = coq.ClientOrderId
			AND CL.DocumentVersionId = @DocumentVersionId
		WHERE ISNULL(coq.RecordDeleted, 'N') <> 'Y'

		--ClientOrdersDiagnosisIIICodes  
		SELECT cod.[DiagnosisIIICodeId]
			,cod.[CreatedBy]
			,cod.[CreatedDate]
			,cod.[ModifiedBy]
			,cod.[ModifiedDate]
			,cod.[RecordDeleted]
			,cod.[DeletedBy]
			,cod.[DeletedDate]
			,cod.[ClientOrderId]
			,cod.[ICDCode]
			,cod.[Description]
			,cod.[ICD10CodeId]
			,DICD.[ICD10Code]
		FROM [dbo].[ClientOrdersDiagnosisIIICodes] cod
		INNER JOIN ClientOrders CL ON CL.ClientOrderId = cod.ClientOrderId
			AND CL.DocumentVersionId = @DocumentVersionId
		JOIN DiagnosisICD10Codes DICD ON DICD.ICD10CodeId=cod.ICD10CodeId  
		WHERE ISNULL(cod.RecordDeleted, 'N') <> 'Y'

		SELECT [OrderInteractionId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[DocumentVersionId]
			,[ClientId]
			,[OrderId]
			,[DrugDrugInterractionId]
			,[MedicationId]
			,[SeverityLevel]
			,[DrugInteractionMonographId]
			,[InteractionDescription]
			,[AllergenConceptId]
			,[MedicationNameId]
			,[ConceptDescription]
		FROM.[dbo].[OrdersInteractionDetails]
		WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
			AND DocumentVersionId = @DocumentVersionId

		SELECT [ClientOrderInteractionDetailId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[DocumentVersionId]
			,[ClientOrderId1]
			,[ClientOrderId2]
			,[DrugInteractionMonographId]
			,[InteractionLevel]
			,[OrderIdList]
			,[PrescriberAcknowledged]
		FROM [dbo].[ClientOrdersInteractionDetails]
		WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
			AND DocumentVersionId = @DocumentVersionId
			
		-- Get Allergies of client Why : For task 213 of Philhaven Development	
		--SELECT  
		--     CA.ClientAllergyId 
		--	,MDA.ConceptDescription as AllergyName
		--	,CA.Comment
		--FROM MDAllergenConcepts MDA
		--INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
		--	AND CA.ClientId = @ClientId
		--	AND ISNULL(CA.RecordDeleted, 'N') = 'N'
		--	AND ISNULL(MDA.RecordDeleted, 'N') = 'N'
		--	AND ISNULL(CA.Active, 'Y') = 'Y'
		--ORDER BY MDA.ConceptDescription
		
		-- Get Allergies of client to show in tool tip
		Declare @ToolTip Varchar(MAX)=''  
		CREATE TABLE #Allergy(
		ConceptDescription VARCHAR(MAX),
		ALLERGYNAME VARCHAR(100))
		
		INSERT INTO #Allergy 
		SELECT MDA.ConceptDescription + ' (' + CASE 
			WHEN ISNULL(CA.AllergyType, '') = 'A'
				THEN 'Allergy'
			WHEN ISNULL(CA.AllergyType, '') = 'I'
				THEN 'Intolerance'
			WHEN ISNULL(CA.AllergyType, '') = 'F'
				THEN 'Failed Trials'
			ELSE ''
			END + ')' + CASE 
			WHEN Comment IS NOT NULL
				THEN ' - ' + SUBSTRING(Comment, 0, 100)
			ELSE ''
			END + '<br/>'
			, MDA.ConceptDescription
		FROM MDAllergenConcepts MDA
		INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
			AND CA.ClientId = @ClientId
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(MDA.RecordDeleted, 'N') = 'N'
			AND ISNULL(CA.Active, 'Y') = 'Y'
		ORDER BY MDA.ConceptDescription 

		SELECT @ToolTip = @ToolTip + ConceptDescription
		FROM #Allergy 
		ORDER BY ALLERGYNAME
		
		SELECT 'ClientAllergies' AS TableName
		,CASE 
			WHEN NoKnownAllergies = 'Y'
				THEN 'Y'
			ELSE CASE 
					WHEN @ToolTip = ''
						THEN 'U'
					ELSE @ToolTip
					END
			END AS Allergy
		FROM Clients
		WHERE ClientId = @ClientId 
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetClientOrders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
GO

