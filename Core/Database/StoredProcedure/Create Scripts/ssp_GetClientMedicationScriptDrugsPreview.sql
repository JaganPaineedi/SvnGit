/****** Object:  StoredProcedure [dbo].[ssp_GetClientMedicationScriptDrugsPreview]   ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_GetClientMedicationScriptDrugsPreview]')
					AND type IN ( N'P', N'PC' ) )
	DROP PROCEDURE dbo.ssp_GetClientMedicationScriptDrugsPreview
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientMedicationScriptDrugsPreview]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Stored Procedure

CREATE PROCEDURE [dbo].[ssp_GetClientMedicationScriptDrugsPreview]          
    @ClientMedicationScriptIds varchar(max)         
AS 
  BEGIN TRY

  select * from ClientMedicationScriptDrugsPreview where ClientMedicationScriptId in (select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')) order by ClientMedicationScriptId asc

  END TRY          
  BEGIN CATCH          
    DECLARE @errMessage NVARCHAR(4000)          
    SET @errMessage = ERROR_MESSAGE()          
          
    RAISERROR(@errMessage, 16, 1)          
  END CATCH    

GO