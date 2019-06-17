

/****** Object:  StoredProcedure [dbo].[ssp_PCGetClientCommonProblem]    Script Date: 08/28/2012 18:00:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PCGetClientCommonProblem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PCGetClientCommonProblem]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PCGetClientCommonProblem]    Script Date: 08/28/2012 18:00:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================  
-- Author:  Mamta Gupta  
-- Create date: 23/Aug/2012
-- Description: Pulls Client Common Problems to fill Most Common Prblmes according to client
-- Task# - 17 - Scheduling - Primary Care - Summit Pointe   
 /*30 oct 2012          Vishant Garg                Replace DiagnosisDSMDescription with DiagnosisicdCodes */
--03 Sep  2015  vkhare			Modified for ICD10 changes 
--12 Dec  2017	Chethan N	What : Removed ClientId check as the Common Diagnosis should be available for All Clients.
--							Why : Core Bugs task #2464
-- =============================================  
CREATE PROCEDURE [dbo].[ssp_PCGetClientCommonProblem]   
(
    @ClientId INT     
)
AS   
BEGIN    
BEGIN TRY    
   SELECT   
		CCP.ClientCommonProblemId,
		(DDD.ICD10Code+ '- '+DDD.ICDDescription) as DSMDescription
   FROM    ClientCommonProblems  CCP
   INNER JOIN DiagnosisICD10Codes   DDD on DDD.ICD10CodeId=CCP.ICD10CodeId 
   WHERE   ISNULL(CCP.RecordDeleted,'N')='N' -- and ClientId = @ClientId    
   
END TRY   
BEGIN CATCH                                  
  DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PCGetClientCommonProblem')                                                                                                             
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


