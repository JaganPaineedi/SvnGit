IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCSubstanceUse]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLSCSubstanceUse]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLSCSubstanceUse] 
@DocumentVersionId INT
/********************************************************************************      
-- Stored Procedure: dbo.csp_RDLSCInfectiousDiseaseRiskAssessments        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date			Author		Purpose      
-- 24-mar-2015  Revathi		What:Get Substance Use
--							Why:task #8 New Direction - Customization  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY	  

		SELECT 
		dbo.csf_GetGlobalCodeNameById(CDS.PreferredUsage1) AS PreferredUsage1
		,dbo.csf_GetGlobalCodeNameById(CDS.DrugName1) AS DrugName1
		,dbo.csf_GetGlobalCodeNameById(CDS.Severity1) AS Severity1        
		,dbo.csf_GetGlobalCodeNameById(CDS.Frequency1) AS Frequency1
		,dbo.csf_GetGlobalCodeNameById(CDS.Route1) AS Route1
		,CDS.AgeOfFirstUseText1
		,CASE WHEN CDS.AgeOfFirstUse1='N' THEN 'No' ELSE CASE WHEN CDS.AgeOfFirstUse1='U' THEN 'Unknown' ELSE '' END END AS AgeOfFirstUse1
		,dbo.csf_GetGlobalCodeNameById(CDS.PreferredUsage2) AS PreferredUsage2
		,dbo.csf_GetGlobalCodeNameById(CDS.DrugName2) AS DrugName2
		,dbo.csf_GetGlobalCodeNameById(CDS.Severity2) AS Severity2        
		,dbo.csf_GetGlobalCodeNameById(CDS.Frequency2) AS Frequency2
		,dbo.csf_GetGlobalCodeNameById(CDS.Route2) AS Route2
		,CDS.AgeOfFirstUseText2
		,CASE WHEN CDS.AgeOfFirstUse2='N' THEN 'No' ELSE CASE WHEN CDS.AgeOfFirstUse2='U' THEN 'Unknown' ELSE '' END END AS AgeOfFirstUse2
		,dbo.csf_GetGlobalCodeNameById(CDS.PreferredUsage3) AS PreferredUsage3
		,dbo.csf_GetGlobalCodeNameById(CDS.DrugName3) AS DrugName3
		,dbo.csf_GetGlobalCodeNameById(CDS.Severity3) AS Severity3        
		,dbo.csf_GetGlobalCodeNameById(CDS.Frequency3) AS Frequency3
		,dbo.csf_GetGlobalCodeNameById(CDS.Route3) AS Route3
		,CDS.AgeOfFirstUseText3
		,CASE WHEN CDS.AgeOfFirstUse3='N' THEN 'No' ELSE CASE WHEN CDS.AgeOfFirstUse3='U' THEN 'Unknown' ELSE '' END END AS AgeOfFirstUse3
		FROM 
		CustomDocumentSUDischarges CDS
		WHERE CDS.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(CDS.RecordDeleted,'N')='N'

	END TRY
	BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'csp_RDLSCSubstanceUse')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH  
END
GO