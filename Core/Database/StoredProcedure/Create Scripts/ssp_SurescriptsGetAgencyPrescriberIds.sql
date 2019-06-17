/****** Object:  StoredProcedure [dbo].[ssp_SurescriptsGetAgencyPrescriberIds]    Script Date: 10/30/2012 11:04:06 AM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SurescriptsGetAgencyPrescriberIds' ) 
    DROP PROCEDURE [dbo].[ssp_SurescriptsGetAgencyPrescriberIds]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SurescriptsGetAgencyPrescriberIds]    Script Date: 10/30/2012 11:04:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SurescriptsGetAgencyPrescriberIds]
AS -- Procedure: ssp_SurescriptsGetAgencyPrescriberIds
--
-- Purpose: Returns a list of the Surescripts Prescriber Id's (SPI_Id's) that have been assigned to the
-- prescribers in this instance of SmartCare Rx
--
-- Called by: Surescripts Windows Service
--
-- Change Log:
--      Date - Who - Comments
--      2010.10.04 - TER - Created.


    SELECT DISTINCT
            SureScriptsPrescriberId + SureScriptsLocationId AS SPI_IDs
    FROM    Staff
    WHERE   ISNULL(RecordDeleted, 'N') <> 'Y'
            AND SurescriptsPrescriberId IS NOT NULL
--and usercode = 'dpermelia'


GO


