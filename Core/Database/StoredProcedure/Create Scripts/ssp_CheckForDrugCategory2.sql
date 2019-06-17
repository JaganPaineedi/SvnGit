IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckForDrugCategory2]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_CheckForDrugCategory2
GO
 

/****** Object:  StoredProcedure [dbo].[ssp_CheckForDrugCategory2]    Script Date: 1/29/2014 1:37:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Kalpers
-- Create date: October 14, 2013
-- Description:	Used to validate a medication name id to see if it has a drug category of 2
--  Jun-9-2015		njain			Changed the csf_SCClientMedicationC2C5Drugs call to ssf_SCClientMedicationC2C5Drugs. The csf was converted to ssf, but this ssp was not updated and the csf doesn't exist in new environments
-- =============================================
CREATE PROCEDURE [dbo].[ssp_CheckForDrugCategory2]
    @MedicationNameId BIGINT
AS 
    BEGIN
        DECLARE @ContainsDrugCategory2 CHAR(1) = 'Y'  
        SELECT  @ContainsDrugCategory2 = CASE WHEN 2 IN (
                                                   SELECT   [dbo].[ssf_SCClientMedicationC2C5Drugs](MedicationId) AS drugcategory
                                                   FROM     dbo.MDMedications
                                                   WHERE    MedicationNameId = @MedicationNameId )
                                              THEN 'Y'
                                              ELSE 'N'
                                         END 

        SELECT  @ContainsDrugCategory2
    END


GO


