 /****** Object:  StoredProcedure [dbo].[SSP_PCGETDIAGNOSISBYCLIENTCOMMONPROBLEMID]    Script Date:27/Aug/2012  ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PCGETDIAGNOSISBYCLIENTCOMMONPROBLEMID]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_PCGETDIAGNOSISBYCLIENTCOMMONPROBLEMID];
GO

/****** Object:  StoredProcedure [dbo].[SSP_PCGETDIAGNOSISBYCLIENTCOMMONPROBLEMID]    ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
-- =============================================  
-- Author:  Mamta Gupta  
-- Create date: 27/Aug/2012
-- Description: Pull Diagnosis Accoding to MostCommonProblem
-- Task# - 17 - Scheduling - Primary Care - Summit Pointe   
 /*30 oct 2012          Vishant Garg                Replace DiagnosisDSMDescription with DiagnosisicdCodes
  29/11/2018             Neethu                   What:Fields of 'problem detail' section value was binding incorrectly  to the custom grid.So modified sp to get all fields to bind correctly to custom grid.
                                                  Why:Harbor - Support1750.1,Error occurred when saving  Primary Care module
  */
-- =============================================  
CREATE PROCEDURE [DBO].[SSP_PCGETDIAGNOSISBYCLIENTCOMMONPROBLEMID] 
(
    @ClientCommonProblemId INT     
)
AS   
BEGIN    
BEGIN TRY    
   SELECT   
		CCP.ClientCommonProblemId,
		CCP.ICD10Code AS ICD10Code,
		DDD.ICDDescription as DSMDescription
		,CCP.DSMCODE as DSMCODE
		,CCP.ICD10CodeId as ICD10CodeId
		,CCP.SNOMEDCODE as SNOMEDCODE
		,SNC.SNOMEDCTDescription as SNOMEDCTDescription
		--0 AS Axis,
		--0 AS DSMNumber,
		--DDD.Billable
   FROM    ClientCommonProblems  CCP
   INNER JOIN DiagnosisICDCodes DDD on DDD.ICDCode=CCP.DSMCode 
    LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CCP.SNOMEDCODE      
 
   WHERE   ClientCommonProblemId = @ClientCommonProblemId   and ISNULL(CCP.RecordDeleted,'N')='N'
   
END TRY   
BEGIN CATCH                                  
  DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PCGetDiagnosisByClientCommonProblemId')                                                                                                             
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
  
  
