
If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.csp_InitIndividualServiceNote') 
                  And Type In ( N'P', N'PC' )) 
 Drop Procedure dbo.csp_InitIndividualServiceNote
Go


/****** Object:  StoredProcedure [dbo].[csp_InitIndividualServiceNote]    Script Date: 8/12/2015 2:58:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[csp_InitIndividualServiceNote] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_InitIndividualServiceNote]   */
/*       Date              Author                  Purpose                   */
/*       03/02/2015        Bernardin               To initialize CustomDocumentIndividualServiceNoteGenerals,CustomDocumentIndividualServiceNoteDBTs tabls values */
/*		07/22/2015			TRemisoski				Only initialize from previous document with same author. */
/*      08/09/2017         Himmat                  Column Missmatach in GETSP and INIT SP so Corrected Column NWDW - #687*/
/*      11/09/2017         Hemant                  What:Corrected careplan version logic.
                                                   Why:calculating Latest Document Version Id by selecting top 1 record using order by 
                                                   clause as  EffectiveDate, ModifiedDate DESC.  which is wrong as it will sort record 
                                                   by EffectiveDate in ascending order(default is ASC) and ModifiedDate in descending 
                                                   order and will result wrong document version id.
                                                   Project:New Directions - Support Go Live #737
		11/21/2017			jcarlson				NDNW SGL 737 - Fixed bug where child tables that could contain multiple rows would be initilized with the same primary key value    
		11/21/2017			wbutt					NDNW SGL 737 - setting negative primary key data type to int.
 */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LatestDocumentVersionID INT
		DECLARE @LatestCarePlanDocumentVersionID INT 
		DECLARE @LatestDiagnosisDocumentVersionId INT
		DECLARE @UserCode VARCHAR(300)
		SELECT @UserCode = UserCode FROM Staff WHERE StaffId = @StaffID
SET @LatestDiagnosisDocumentVersionId =(SELECT TOP 1 CurrentDocumentVersionId from Documents a                                                                
Inner Join DocumentCodes Dc on Dc.DocumentCodeid=a.DocumentCodeid          
where a.ClientId = @ClientID                                                                
and a.Status = 22  and Dc.DiagnosisDocument='Y'          
AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101))            
and isNull(a.RecordDeleted,'N')<>'Y'           
and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                                  
order by a.EffectiveDate desc,a.ModifiedDate desc) 

 
SET @LatestCarePlanDocumentVersionID =(select top 1 CurrentDocumentVersionId 
                                       from Documents d join DocumentCarePlans DCP on d.CurrentDocumentVersionId = DCP.DocumentVersionId                                             
                                        where d.ClientId = @ClientID                                                       
                                         and d.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
                                         and d.Status = 22                    
										 and d.DocumentCodeId=1620 --Valley Care Plan  
                                         and isNull(d.RecordDeleted,'N')='N' 
                                          and  ISNull(DCP.RecordDeleted,'N')='N'                                                                                            
                                          order by d.EffectiveDate desc,d.ModifiedDate desc ) 
		
			SET @LatestDocumentVersionID = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM CustomDocumentIndividualServiceNoteGenerals CDLS
				INNER JOIN Documents Doc ON CDLS.DocumentVersionId = Doc.CurrentDocumentVersionId
				WHERE Doc.ClientId = @ClientID
					AND Doc.[Status] = 22
					AND Doc.AuthorId = @StaffId
					AND ISNULL(CDLS.RecordDeleted, 'N') = 'N'
					AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				ORDER BY Doc.EffectiveDate DESC
					,Doc.ModifiedDate DESC
				)
		SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)
		
		SELECT 'CustomDocumentIndividualServiceNoteGenerals' AS TableName
			,- 1 AS DocumentVersionId
			,@UserCode AS CreatedBy
			,GETDATE() AS CreatedDate
			,@UserCode AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,Overcome AS PlanLastService
		 FROM systemconfigurations s
	     LEFT OUTER JOIN CustomDocumentIndividualServiceNoteGenerals  CDISNG ON CDISNG.DocumentVersionId = @LatestDocumentVersionID AND ISNULL(CDISNG.RecordDeleted,'N') <> 'Y'
		
		SELECT 'CustomDocumentDBTs' AS TableName
			,- 1 AS DocumentVersionId
			,@UserCode AS CreatedBy
			,GETDATE() AS CreatedDate
			,@UserCode AS ModifiedBy
			,GETDATE() AS ModifiedDate
		FROM systemconfigurations s
	     LEFT OUTER JOIN CustomDocumentDBTs CDDBT ON  CDDBT.DocumentVersionId = @LatestDocumentVersionID AND ISNULL(CDDBT.RecordDeleted,'N') <> 'Y'
		
		
		IF @LatestCarePlanDocumentVersionID > 0
		BEGIN
		SELECT 'CustomIndividualServiceNoteGoals' AS TableName
		       ,-(convert(int, row_number() OVER( ORDER BY(SELECT 0)))) As IndividualServiceNoteGoalId
		       ,- 1 AS DocumentVersionId
			   ,@UserCode AS CreatedBy
			   ,GETDATE() AS CreatedDate
			   ,@UserCode AS ModifiedBy
			   ,GETDATE() AS ModifiedDate
		       ,CarePlanGoalId AS GoalId
			   ,GoalNumber AS GoalNumber
			   ,ClientGoal AS GoalText
		 	   ,'N' AS CustomGoalActive		
		 FROM CarePlanGoals
		 WHERE DocumentVersionId = @LatestCarePlanDocumentVersionID AND ISNULL(RecordDeleted,'N') = 'N'
		 
		 Select 'CustomIndividualServiceNoteObjectives' AS TableName
		       ,-(convert(int, row_number() OVER( ORDER BY(SELECT 0)))) As IndividualServiceNoteObjectiveId 
		       ,- 1 AS DocumentVersionId
			   ,@UserCode AS CreatedBy
			   ,GETDATE() AS CreatedDate
			   ,@UserCode AS ModifiedBy
			   ,GETDATE() AS ModifiedDate
			   ,CPO.CarePlanGoalId AS GoalId
		       ,CPO.ObjectiveNumber AS ObjectiveNumber
		       ,CPO.AssociatedObjectiveDescription AS ObjectiveText
		       ,'N' AS CustomObjectiveActive
			    from CarePlanObjectives AS CPO 
		 Left JOIN  CarePlanGoals CPG  ON CPO.CarePlanGoalId = CPG.CarePlanGoalId   AND  ISNULL(CPG.RecordDeleted,'N')='N'  
		WHERE ISNULL(CPO.RecordDeleted,'N')='N'
		AND CPG.DocumentVersionId = @LatestCarePlanDocumentVersionID
		 
       END
       



IF @LatestDiagnosisDocumentVersionId > 0
BEGIN
SELECT 'CustomIndividualServiceNoteDiagnoses' AS TableName
            , -(convert(int, row_number() OVER( ORDER BY(SELECT 0)))) As IndividualServiceNoteDiagnosisId 
			,- 1 AS DocumentVersionId
			   ,@UserCode AS CreatedBy
			   ,GETDATE() AS CreatedDate
			   ,@UserCode AS ModifiedBy
			   ,GETDATE() AS ModifiedDate 
      ,D.ICD10Code AS ICD10Code
      ,D.ICD9Code AS ICD9Code
      --,D.DiagnosisOrder AS [Order]
      ,DD.ICDDescription AS [Description]--,ISNULL(D.Billable,'N') 
         FROM DocumentDiagnosisCodes D    
			JOIN DiagnosisICD10Codes DD ON D.ICD10Code=DD.ICD10Code
			WHERE DocumentVersionId=@LatestDiagnosisDocumentVersionId and ISNULL(dd.RecordDeleted,'N')='N'
END     
	END TRY
	BEGIN CATCH
DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitIndividualServiceNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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





--exec csp_InitIndividualServiceNote 2384, 550, ''
