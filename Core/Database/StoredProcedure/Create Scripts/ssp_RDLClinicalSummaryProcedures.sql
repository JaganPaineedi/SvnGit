/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryProcedures]    Script Date: 06/19/2015 10:50:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryProcedures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryProcedures]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryProcedures]    Script Date: 06/19/2015 10:50:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryProcedures]
	 @ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
AS
/******************************************************************************                            
**  File: ssp_RDLClinicalSummaryProcedures.sql          
**  Name: ssp_RDLClinicalSummaryProcedures 863,459743572,NULL         
**  Desc:           
**                            
**  Return values: <Return Values>                           
**                             
**  Called by: <Code file that calls>                              
**                                          
**  Parameters:                            
**  Input   Output                            
**  ServiceId      -----------                            
**                            
**  Created By: Veena S Mani         
**  Date:  Feb 25 2014          
*******************************************************************************                            
**  Change History                            
*******************************************************************************                            
**  Date:  Author:    Description:                            
**  -------- --------   -------------------------------------------       
**  02/05/2014  Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18                  
**  19/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.                    
**  09/11/2014  Naveen P            Added Location and Clinician columns to the SELECT statement  
**  03/09/2015  Revathi				what: Get  ServiceBilling Diagnosis
									why:  task#18 Post Certification   
** 02/03/2016	Ravichandra			why: Commented   SNOMEDCTCode, SNOMEDCTDescription ,Clinician fields not using in RDL 
									why: Showing Duplicate records for Diagnosis, Meaningful Use Stage 2 Tasks#48 Clinial Summary - PDF Issues             
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF (@ServiceId IS NOT NULL)
		BEGIN
			
				SELECT DISTINCT pc.ProcedureCodeName AS Description	
				--,NULL AS BillingCodeModifiers			
				,(CONVERT(VARCHAR(10), s.DateofService, 101) + ' ' + SUBSTRING(CONVERT(VARCHAR(20), s.DateofService, 9), 13, 5) + ' ' + SUBSTRING(CONVERT(VARCHAR(30), s.DateofService, 9), 25, 2)) AS ServiceDate                       
				,ISNULL(DDM.ICD10Code + ' ' + DDM.ICDDescription, 'Not Known')  AS Diagnosis
				,Loc.LocationName + isnull(',' + Loc.Address, '') AS Location     
				--02/03/2016	Ravichandra	               
				 --,G.SNOMEDCTCode  AS SNOMEDCTCode
				 --,G.SNOMEDCTDescription AS SNOMEDCTDescription				
				--, Staff.DisplayAs AS Clinician      
				FROM dbo.Services AS s
				INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId
				INNER JOIN serviceDiagnosis SD ON SD.ServiceId=S.ServiceId 
				LEFT JOIN Locations Loc ON s.LocationId = Loc.LocationId     AND ISNULL(Loc.RecordDeleted,'N')='N' 
				 LEFT JOIN ProcedureRates PR ON pr.ProcedureCodeId = pc.ProcedureCodeId     AND ISNULL(PR.RecordDeleted,'N')='N'
				--Added By Revathi
				INNER JOIN dbo.DiagnosisICD10Codes AS DDM ON DDM.ICD10Code = SD.ICD10Code AND ISNULL(DDM.RecordDeleted,'N')='N' 
				--02/03/2016	Ravichandra	
				--LEFT JOIN ICD10SNOMEDCTMapping F on F.ICD10CodeId = DDM.ICD10Code --Join with ICD10Code from DiagnosisICD10Codes
				--LEFT JOIN dbo.SNOMEDCTCodes G ON G.SNOMEDCTCodeId = F.SNOMEDCTCodeId   
				WHERE s.ServiceId = @ServiceId				
				AND ISNULL(S.RecordDeleted,'N')='N'
				AND ISNULL(PC.RecordDeleted,'N')='N'
				AND ISNULL(SD.RecordDeleted,'N')='N'

		END
		ELSE
		BEGIN
			IF EXISTS (
					SELECT *
					FROM ClientInpatientVisits
					WHERE clientId = @ClientId
					)
			BEGIN	
				SELECT NULL AS Description
					--,NULL AS BillingCodeModifiers
					,NULL AS ServiceDate
					,NULL AS Diagnosis
					,NULL AS Location
					--02/03/2016	Ravichandra	
					--,NULL as SNOMEDCTCode
					--,NULL AS SNOMEDCTDescription
				FROM ClientInpatientVisits CI
				WHERE CI.ClientId = @ClientId
					AND isnull(CI.RecordDeleted, 'N') = 'N'
				
			END
			ELSE
			BEGIN
			
			SELECT  DISTINCT
				Description
				--,NULL AS BillingCodeModifiers
				,ServiceDate
				,Diagnosis
				,Location
				
				--02/03/2016	Ravichandra	
				--, SNOMEDCTCode
				--, SNOMEDCTDescription
				FROM
				(
				SELECT DISTINCT pc.ProcedureCodeName AS Description,S.ServiceId,
				RANK()Over(order by S.ServiceId desc) as row
				,ISNULL(PR.BillingCode, '') + ' ' + ISNULL(PR.Modifier1, '') + ' ' + ISNULL(PR.Modifier2, '') + ' ' + ISNULL(PR.Modifier3, '') + ' ' + ISNULL(PR.Modifier4, '') AS BillingCodeModifiers
				,(CONVERT(VARCHAR(10), s.DateofService, 101) + ' ' + SUBSTRING(CONVERT(VARCHAR(20), s.DateofService, 9), 13, 5) + ' ' + SUBSTRING(CONVERT(VARCHAR(30), s.DateofService, 9), 25, 2)) AS ServiceDate 
				,ISNULL(DDM.ICD10Code + ' ' + DDM.ICDDescription, 'Not Known')  AS Diagnosis
				,Loc.LocationName + isnull(',' + Loc.Address, '') AS Location    
				
				--02/03/2016	Ravichandra	                
				--,G.SNOMEDCTCode  AS SNOMEDCTCode				                
			 --   ,G.SNOMEDCTDescription AS SNOMEDCTDescription				
				--, Staff.DisplayAs AS Clinician      
				FROM dbo.Services AS s
				INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId
				INNER JOIN serviceDiagnosis SD ON SD.ServiceId=S.ServiceId 
				LEFT JOIN Locations Loc ON s.LocationId = Loc.LocationId     AND ISNULL(Loc.RecordDeleted,'N')='N' 
				 LEFT JOIN ProcedureRates PR ON pr.ProcedureCodeId = pc.ProcedureCodeId     AND ISNULL(PR.RecordDeleted,'N')='N'
				--Added By Revathi
				INNER JOIN dbo.DiagnosisICD10Codes AS DDM ON DDM.ICD10Code = SD.ICD10Code AND ISNULL(DDM.RecordDeleted,'N')='N'
				
				--02/03/2016	Ravichandra	
				--LEFT JOIN ICD10SNOMEDCTMapping F on F.ICD10CodeId = DDM.ICD10Code --Join with ICD10Code from DiagnosisICD10Codes
				--LEFT JOIN dbo.SNOMEDCTCodes G ON G.SNOMEDCTCodeId = F.SNOMEDCTCodeId   
				WHERE s.ClientId = @ClientId					
				AND ISNULL(S.RecordDeleted,'N')='N'
				AND ISNULL(PC.RecordDeleted,'N')='N'
				AND ISNULL(SD.RecordDeleted,'N')='N') as t 
				where t.row=1
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryProcedures') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


