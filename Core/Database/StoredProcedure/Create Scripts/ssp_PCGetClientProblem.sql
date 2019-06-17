

/****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PCGetClientProblem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PCGetClientProblem]
GO



/****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================  
-- Author:  Mamta Gupta  
-- Create date: 23/Aug/2012
-- Description: Pulls ClientProblme Detail
-- Task# - 17 - Scheduling - Primary Care - Summit Pointe   
 /*30 oct 2012          Vishant Garg    Replace DiagnosisDSMDescription with DiagnosisicdCodes */
 /*16 Nov 2012          Vishant Garg    Added three new colimns as ther are required for progressnote.*/
 /*29 Nov 2012          Vishant Garg   Added two new colimns ProblemStatus & AdditionalWorkUp as per change in datamodel*/
 /*1/3/2013*            Vishant Garg   Remove parameter clientproblemid and add parameter clientid with ref task#56 primary care*/
 /*1/24/2013			Vishant Garg   Remove all types  as we have no need to show blank row text in parent child grid*/
/* 2014-01-13	Chethan N		Added new column 'Terminal'-- for task#2 FQHC - Custom / Design*/

/*	2015-04-27  Vaibhav Khare Adding logic for displaying Diagnosis Order	*/
--03 Sep  2015  vkhare			Modified for ICD10 changes
   
-- =============================================  
CREATE PROCEDURE [dbo].[ssp_PCGetClientProblem]    
(
    @ClientId INT     
)

AS   
BEGIN    
BEGIN TRY    
   SELECT   
		CP.ClientProblemId,
		CP.ClientId,
		CP.StartDate,
		CP.EndDate,
		CP.StaffId as StaffId,
		CP.ProblemType,
		CP.DSMCode,
		CP.DSMNumber,
		CP.Axis,
		CP.IncludeInCommonList,
		CP.CreatedBy,
		CP.CreatedDate,
		CP.ModifiedBy,
		CP.ModifiedDate,
		CP.RecordDeleted,
		CP.DeletedDate,
		CP.DeletedBy,
		DDD.ICDDescription as 'Description',
		--Added New Columns 
		--By Vishant Garg with ref task # 65 primary care bugs/features
		NewProblem,
		AddToNote,
		Discontinue,
		ProblemStatus,
		AdditionalWorkUp,
		-- Addition Ends Here
		ISNULL(GC.CodeName,'') AS ProblemTypeText,
		isnull(CCP.ClientCommonProblemId,0) as MostCommonProblemId,
		ISNULL(ST.LastName,'')+' '+ISNULL(ST.FirstName,'') AS StaffIdText,
		CP.Terminal,
		CP.DiagnosisOrder,
		CP.ICD10CodeId,
		CP.SNOMEDCODE,
		SNC.SNOMEDCTDescription,
		CP.ICD10Code
   FROM    ClientProblems CP 
   left join DiagnosisICD10Codes DDD on DDD.ICD10CodeId=CP.ICD10CodeId
   LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE      
   left join ClientCommonProblems CCP on CCP.ICD10CodeId=CP.ICD10CodeId  AND CCP.ClientId=CP.ClientId and ISNULL(CCP.RecordDeleted,'N')='N'
   left join GlobalCodes GC on GC.GlobalCodeId=CP.ProblemType and isnull(GC.RecordDeleted,'N')='N'
   left join Staff ST on ST.StaffId=CP.StaffId and ISNULL(ST.RecordDeleted,'N')='N'
   WHERE   CP.ClientId = @ClientId and ISNULL(CP.RecordDeleted,'N')='N'
   ORDER BY CP.ClientProblemId DESC
   
END TRY   
BEGIN CATCH                                  
  DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PCGetClientProblem')                                                                                                             
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


