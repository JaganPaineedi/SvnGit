 /****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetImmunizationTrasmissionRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetImmunizationTrasmissionRecord]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetImmunizationTrasmissionRecord]    Script Date: 08/28/2012 17:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
  
/********************************************************************************                                                    
-- Stored Procedure: ssp_GetImmunizationTrasmissionRecord 
-- File      : ssp_GetImmunizationTrasmissionRecord.sql  
-- Copyright: Streamline Healthcate Solutions  
--  
--  
-- Date   Author    Purpose  
-- 14/June/2017  Varun   Created   

*********************************************************************************/  
  
CREATE PROCEDURE [dbo].[ssp_GetImmunizationTrasmissionRecord]     
(  
 @ImmunizationTransmissionLogId   INT
)  
AS         
BEGIN                                                                  
 BEGIN TRY
 DECLARE @ActionType VARCHAR(100)
 SELECT @ActionType = GC.Code from GlobalCodes GC JOIN ImmunizationTransmissionLog IT ON IT.ActionType= GC.GlobalCodeId WHERE IT.ImmunizationTransmissionLogId=@ImmunizationTransmissionLogId
 SELECT 
  IT.ImmunizationTransmissionLogId
 ,IT.ClientId
 ,IT.VaccineName
 ,@ActionType AS ActionType
 ,IT.ExportDateTime
 ,IT.AckResponse
 ,CASE @ActionType
	WHEN 'Send' THEN IT.AdministrationHL7Message
	ELSE IT.QueryHL7Message
	END AS [Message]
 ,IT.AckHL7Message
 ,IT.ResponseHL7Message
 FROM ImmunizationTransmissionLog IT
 WHERE IT.ImmunizationTransmissionLogId=@ImmunizationTransmissionLogId
 END TRY     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetImmunizationTrasmissionRecord')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH    
END    