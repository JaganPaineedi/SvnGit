 /****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InsertImmunizationTransmissionLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InsertImmunizationTransmissionLog]
GO



/****** Object:  StoredProcedure [dbo].[ssp_InsertImmunizationTransmissionLog]    Script Date: 08/28/2012 17:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
  
/********************************************************************************                                                    
-- Stored Procedure: ssp_InsertImmunizationTransmissionLog 
-- File      : ssp_InsertImmunizationTransmissionLog.sql  
-- Copyright: Streamline Healthcate Solutions  
--  
--  
-- Date   Author    Purpose  
-- 13/June/2017  Varun   Created   

*********************************************************************************/  
  
CREATE PROCEDURE [dbo].[ssp_InsertImmunizationTransmissionLog]     
(  
 @ClientId   INT,  
 @ActionType  CHAR(1), 
 @ClientImmunizationIds varchar(max) = NULL
)  
AS         
BEGIN                                                                  
 BEGIN TRY
		DECLARE @ExportDateTime DATETIME
		SET @ExportDateTime=GETDATE()
		IF @ActionType = 'S'
			BEGIN
			DECLARE @ImmunizationTransmissionLogId INT
			DECLARE @ImmunizationAdministrationLog TABLE (
				ClientImmunizationId INT
				,ImmunizationTransmissionLogId INT
				)
			DECLARE @ImmunizationsRaw NVarchar(max)
			EXEC SSP_GetHL7_MU_Immunizations @ClientId,@ClientImmunizationIds,@ImmunizationsRaw Output
			INSERT INTO @ImmunizationAdministrationLog (ClientImmunizationId)
			SELECT *
			FROM dbo.fnSplit(@ClientImmunizationIds, ',')

			INSERT INTO ImmunizationTransmissionLog (
				ClientId
				,ActionType
				,ExportDateTime
				,AdministrationHL7Message
				)
			VALUES (
				@ClientId
				,(
					SELECT GC.GlobalCodeId
					FROM GlobalCodes GC
					WHERE Category = 'ImmunizationAction'
						AND Code = 'Send'
					)
				,@ExportDateTime
				,@ImmunizationsRaw
				)

			SET @ImmunizationTransmissionLogId = @@IDENTITY

			UPDATE @ImmunizationAdministrationLog
			SET ImmunizationTransmissionLogId = @ImmunizationTransmissionLogId

			INSERT INTO ImmunizationAdministrationLog (
				ImmunizationTransmissionLogId
				,ClientImmunizationId
				)
			SELECT @ImmunizationTransmissionLogId, ClientImmunizationId
			FROM @ImmunizationAdministrationLog

			UPDATE ImmunizationTransmissionLog
			SET VaccineName = STUFF((
						SELECT ', ' + GC.CodeName
						FROM GlobalCodes GC
						INNER JOIN ClientImmunizations CI ON GC.GlobalCodeId = CI.VaccineNameId
						WHERE CI.ClientImmunizationId IN (SELECT Token FROM [dbo].[SplitString] (@ClientImmunizationIds,','))
						FOR XML PATH('')
						), 1, 1, '')  WHERE ImmunizationTransmissionLogId=@ImmunizationTransmissionLogId

			UPDATE ClientImmunizations SET ExportedDateTime=@ExportDateTime
			WHERE ClientImmunizationId in (SELECT ClientImmunizationId FROM  @ImmunizationAdministrationLog)
		END
		ELSE IF @ActionType ='Q'
		BEGIN
		    DECLARE @QueryMessageOutput VARCHAR(MAX)
			EXEC  SSP_GetHL7_MU_MessageQBP @ClientId,@QueryMessageOutput OUT 
			INSERT INTO ImmunizationTransmissionLog (
				ClientId
				,ActionType
				,ExportDateTime
				,QueryHL7Message
				)
			VALUES (
				@ClientId
				,(
					SELECT GC.GlobalCodeId
					FROM GlobalCodes GC
					WHERE Category = 'ImmunizationAction'
						AND Code = 'Query'
					)
				,@ExportDateTime
				,@QueryMessageOutput
				)
		END

 END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_InsertImmunizationTransmissionLog')                                                                                                 
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