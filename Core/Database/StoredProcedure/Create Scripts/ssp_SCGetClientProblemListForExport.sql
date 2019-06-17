

/****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientProblemListForExport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientProblemListForExport]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientProblemListForExport]    Script Date: 08/28/2012 17:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================  
-- Author:  Vishant Garg 
-- Create date: 23/Aug/2012
-- Description: Pulls ClientProblme Detail
-- Task# - 328 - - Primary Care - Summit Pointe   
 /*30 oct 2012          Vishant Garg    Created */
--03 Sep  2015   Vkhare Modified for ICD10 changes

-- =============================================  
CREATE PROCEDURE [dbo].ssp_SCGetClientProblemListForExport    
(
    @ClientId INT   ,
    @Active varchar(1)  
)
AS   
BEGIN    
BEGIN TRY    
		if(@Active ='Y')
		begin
				SELECT 
				CP.StartDate AS 'Start Date',
				CP.EndDate AS 'End Date',
				CP.DSMCode AS 'DSM IV/ICD 9',  
				CP.ICD10Code AS 'DSM 5/ICD 10',
				CP.SNOMEDCODE AS 'SNOMED',
				DDD.ICDDescription AS 'ICD/DSM Description',
				SNC.SNOMEDCTDescription as 'SNOMED Description',
				ISNULL(GC.CodeName,'') AS 'Type Of Problem',
				ISNULL(ST.LastName,'')+' '+ISNULL(ST.FirstName,'') AS 'Staff'
				FROM    ClientProblems CP 
				left join DiagnosisICD10Codes DDD on DDD.ICD10CodeId=CP.ICD10CodeId
				LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE 
				left join ClientCommonProblems CCP on CCP.ICD10CodeId=CP.ICD10Codeid  AND CCP.ClientId=CP.ClientId and ISNULL(CCP.RecordDeleted,'N')='N'
				left join GlobalCodes GC on GC.GlobalCodeId=CP.ProblemType and isnull(GC.RecordDeleted,'N')='N'
				left join Staff ST on ST.StaffId=CP.StaffId and ISNULL(ST.RecordDeleted,'N')='N'
				WHERE   CP.ClientId = @ClientId and ISNULL(CP.RecordDeleted,'N')='N'
				AND isnull(CP.EndDate,GETDATE()) >=GETDATE() 
				ORDER BY CP.ClientProblemId DESC
		end
		else
		begin
				SELECT   
				CP.StartDate AS 'Start Date',
				CP.EndDate AS 'End Date',
				CP.DSMCode AS 'DSM IV/ICD 9',  
				CP.ICD10Code AS 'DSM 5/ICD 10',
				CP.SNOMEDCODE AS 'SNOMED',
				DDD.ICDDescription AS 'ICD/DSM Description',
				SNC.SNOMEDCTDescription as 'SNOMED Description',
				ISNULL(GC.CodeName,'') AS 'Type Of Problem',
				ISNULL(ST.LastName,'')+' '+ISNULL(ST.FirstName,'') AS 'Staff'
				FROM    ClientProblems CP 
				left join DiagnosisICD10Codes DDD on DDD.ICD10CodeId=CP.ICD10CodeId
				LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE 
				left join ClientCommonProblems CCP on CCP.ICD10Codeid=CP.ICD10Codeid  AND CCP.ClientId=CP.ClientId and ISNULL(CCP.RecordDeleted,'N')='N'
				left join GlobalCodes GC on GC.GlobalCodeId=CP.ProblemType and isnull(GC.RecordDeleted,'N')='N'
				left join Staff ST on ST.StaffId=CP.StaffId and ISNULL(ST.RecordDeleted,'N')='N'
				WHERE   CP.ClientId = @ClientId and ISNULL(CP.RecordDeleted,'N')='N'
				ORDER BY CP.ClientProblemId DESC
		end
   
END TRY   
BEGIN CATCH                                  
  DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientProblemListForExport')                                                                                                             
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
  
  
GO


