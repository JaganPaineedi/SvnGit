 /****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateImmunizationAckResponseHL7Message]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_UpdateImmunizationAckResponseHL7Message]
GO



/****** Object:  StoredProcedure [dbo].[ssp_UpdateImmunizationAckResponseHL7Message]    Script Date: 08/28/2012 17:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
  
/********************************************************************************                                                    
-- Stored Procedure: ssp_UpdateImmunizationAckResponseHL7Message 
-- File      : ssp_UpdateImmunizationAckResponseHL7Message.sql  
-- Copyright: Streamline Healthcate Solutions  
--  
--  
-- Date   Author    Purpose  
-- 14/June/2017  Varun   Created   

*********************************************************************************/  
  
CREATE PROCEDURE [dbo].[ssp_UpdateImmunizationAckResponseHL7Message]     
(  
 @ImmunizationTransmissionLogId   INT,
 @HL7Message VARCHAR(MAX) 
)  
AS         
BEGIN                                                                  
 BEGIN TRY
 DECLARE @ActionType VARCHAR(25)
		SELECT @ActionType=GC.CodeName from GlobalCodes GC JOIN ImmunizationTransmissionLog IT on GC.GlobalCodeId=IT.ActionType
		WHERE IT.ImmunizationTransmissionLogId=@ImmunizationTransmissionLogId
		IF @ActionType = 'Send'
		BEGIN
			UPDATE ImmunizationTransmissionLog SET
			AckResponse=GETDATE(),
			AckHL7Message=@HL7Message
			WHERE ImmunizationTransmissionLogId=@ImmunizationTransmissionLogId
		END
		ELSE IF @ActionType ='Query'
		BEGIN
			UPDATE ImmunizationTransmissionLog SET
			AckResponse=GETDATE(),
			ResponseHL7Message=@HL7Message
			WHERE ImmunizationTransmissionLogId=@ImmunizationTransmissionLogId
		END

 END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_UpdateImmunizationAckResponseHL7Message')                                                                                                 
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