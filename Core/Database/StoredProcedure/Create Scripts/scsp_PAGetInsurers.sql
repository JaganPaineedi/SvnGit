

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT *
                FROM sys.objects
                WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PAGetInsurers]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[scsp_PAGetInsurers]
GO

/************************************************************************************************
 Stored Procedure: dbo.scsp_PAGetInsurers                                
                                                                                                 
 Created By: Jay                                                                                    
 Purpose:  To pass the butter                      
                                                                                                 
 Test Call:  
      Exec scsp_PAGetInsurers 550
                                                                                                 
                                                                                                 
 Change Log:                                                                                     
                                                                                                 
                                                                                                 
****************************************************************************************************/


CREATE PROCEDURE [dbo].scsp_PAGetInsurers @LoggedInStaffId INT
AS
    BEGIN
        DECLARE @ErrorMessage VARCHAR(MAX) = ''

        BEGIN TRY
            
            DECLARE @AllInsurers CHAR(1)
            DECLARE @AllProviders CHAR(1)

            SELECT @AllInsurers = ISNULL(AllInsurers, 'N')
                ,   @AllProviders = ISNULL(AllProviders, 'N')
                FROM Staff
                WHERE StaffId = @LoggedInStaffId
            
            SELECT i.InsurerId
                ,   i.InsurerName
                FROM Insurers i
                    JOIN StaffInsurers SI ON ( SI.InsurerId = i.InsurerId
                                               OR @AllInsurers = 'Y' )
                    JOIN Staff s ON s.StaffId = SI.StaffId
                    JOIN StaffProviders SP ON ( SP.StaffId = s.StaffId
                                                OR @AllProviders = 'Y' )
                    JOIN Providers P ON SP.ProviderId = P.ProviderId
                                        AND P.SubstanceUseProvider = 'Y'
                WHERE ISNULL(i.RecordDeleted, 'N') = 'N'
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                    AND ISNULL(SI.RecordDeleted, 'N') = 'N'
                    AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(P.RecordDeleted, 'N') = 'N'
                    AND s.StaffId = @LoggedInStaffId
                GROUP BY i.InsurerId
                ,   i.InsurerName
                ORDER BY i.InsurerId
           
 
        END TRY
        BEGIN CATCH
            IF @@Trancount > 0
                ROLLBACK TRAN
            DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
            DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName))
            SET @ErrorMessage = @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + CHAR(13)

            SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') + CHAR(13) + @ThisProcedureName + ' Variable dump:' + CHAR(13) + '@LoggedInStaffId:' + ISNULL(@LoggedInStaffId, 'Null')


            RAISERROR(@ErrorMessage, -- Message.   
             16, -- Severity.   
             1 -- State.   
             );
        END CATCH
    END

GO


RETURN

;
WITH    firststaff
          AS ( SELECT s.StaffId
                ,   SUM(1) AS numinsurers
                FROM StaffInsurers SI
                    JOIN Staff s ON s.StaffId = SI.StaffId
                WHERE s.Active = 'y' AND ISNULL(s.AllInsurers,'N') <> 'Y'  AND ISNULL(s.AllProviders,'N') <> 'Y'
                GROUP BY s.StaffId)
      
    SELECT 'Exec scsp_PAGetInsurers ' + CAST(fs.StaffId AS VARCHAR) + '-- ' + CAST(FS.numinsurers AS VARCHAR) AS cmd, *
        FROM firststaff fs
        WHERE NOT EXISTS ( SELECT 1
                            FROM firststaff fs2
                            WHERE fs2.numinsurers = fs.numinsurers
                                AND fs2.StaffId > fs.StaffId )
                                ORDER BY fs.numinsurers 

Exec scsp_PAGetInsurers 2812-- 1
Exec scsp_PAGetInsurers 2804-- 2
Exec scsp_PAGetInsurers 2725-- 3
Exec scsp_PAGetInsurers 1979-- 4
Exec scsp_PAGetInsurers 2579-- 5
Exec scsp_PAGetInsurers 2618-- 6
Exec scsp_PAGetInsurers 2767-- 7
Exec scsp_PAGetInsurers 2815-- 8