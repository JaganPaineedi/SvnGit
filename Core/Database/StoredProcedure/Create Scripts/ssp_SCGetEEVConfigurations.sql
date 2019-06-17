/****** Object:  StoredProcedure [dbo].[ssp_SCGetEEVConfigurations]    Script Date: 03/02/2016 18:02:16 ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetEEVConfigurations]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[ssp_SCGetEEVConfigurations];
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetEEVConfigurations]    Script Date: 03/02/2016 18:02:16 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[ssp_SCGetEEVConfigurations] @ElectronicEligibilityVerificationConfigurationId INT
	
/********************************************************************************                                                            
-- Stored Procedure: ssp_SCGetEEVConfigurations          
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: Get List of Electronic Eligibility Verification Providers List
--          
-- Author:  PradeepA          
-- Date:    Sept 15 2017         
--           
-- *****History****          
-- Author:    Date			Reason          

*********************************************************************************/
AS
     BEGIN
         BEGIN TRY
             Select * from ElectronicEligibilityVerificationConfigurations Where ISNULL(RecordDeleted,'N')='N' AND ElectronicEligibilityVerificationConfigurationId = @ElectronicEligibilityVerificationConfigurationId
		   Select * from ElectronicEligibilityVerificationPayers Where ISNULL(RecordDeleted,'N')='N' AND ElectronicEligibilityVerificationConfigurationId = @ElectronicEligibilityVerificationConfigurationId
         END TRY
         BEGIN CATCH
             DECLARE @Error VARCHAR(8000);
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetEEVConfigurations')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
             RAISERROR(@Error, -- Message text.          
             16, -- Severity.          
             1 -- State.          
             );
         END CATCH;
     END;
GO