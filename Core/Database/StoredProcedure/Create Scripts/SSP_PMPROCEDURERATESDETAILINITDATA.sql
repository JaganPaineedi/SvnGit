IF EXISTS ( SELECT  *
            FROM    sys.procedures
            WHERE   NAME = 'SSP_PMPROCEDURERATESDETAILINITDATA' )
    DROP PROCEDURE SSP_PMPROCEDURERATESDETAILINITDATA
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMProcedureRatesDetailInitData]
AS /********************************************************************************                                                  
-- Stored Procedure: ssp_PMProcedureRatesDetailInitData
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Get data to be used to fill the dropdowns in the Plan Details page- Expected Payment
--
-- Author:  Mary Suma
-- Date:    12 May 2011
--
-- *****History****
	Date		User			Description
	-------		----------		---------------------------
	10/25/2011	dharvey			Removed DocumentCodeId 1 from dropdown list to prevent
								Procedure Codes assigned to this dummy Document Code.
	04/18/2014  PPotnuru		Added order by for coverage plan select statement		
	09/25/2017	NJain			Updated to also show Inactive plans that are templates. Core Bugs #2407			
*********************************************************************************/

    BEGIN
        BEGIN TRY
	    
    --Service Note on General Tab Sheet
            SELECT  NULL AS DocumentCodeId ,
                    '' AS DocumentName
            UNION
            SELECT  DocumentCodeId ,
                    DocumentName
            FROM    DocumentCodes
            WHERE   ServiceNote = 'Y'
                    AND Active = 'Y'
                    AND ( ISNULL(RecordDeleted, 'N') = 'N' )
     /* DJH - 10/25/2011 */
                    AND DocumentCodeId <> 1 --Service Note Dummy record	    
            ORDER BY DocumentName     
	
	-- Coverage Plan Templates 
            SELECT  CoveragePlanId ,
                    CASE WHEN ISNULL(Active, 'N') = 'Y' THEN DisplayAs
                         WHEN ISNULL(Active, 'N') = 'N' THEN DisplayAs + ' (Inactive plan)'
                    END AS DisplayAs
            FROM    CoveragePlans
            WHERE   ISNULL(RecordDeleted, 'N') = 'N'
                    --AND Active = 'Y'
                    AND BillingCodeTemplate = 'T'
            ORDER BY DisplayAs ASC --Shows Plan which are used as Template      



        END TRY
              
        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMProcedureRatesDetailInitData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
        END CATCH 
        RETURN
    END	   

GO
