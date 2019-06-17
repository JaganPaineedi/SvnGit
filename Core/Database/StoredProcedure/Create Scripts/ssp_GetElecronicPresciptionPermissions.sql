IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_GetElecronicPresciptionPermissions]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_GetElecronicPresciptionPermissions;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE [dbo].[ssp_GetElecronicPresciptionPermissions] ( @PrescriberId INT ,@PharmacyId INT=0)
/*===========================================================

-Stored Procedure: dbo.ssp_GetElecronicPresciptionPermissions

-Copyright: 2011 Streamline Healthcare Solutions, LLC

-Creation Date: 09/22/2017

-Author : Pranay

-Purpose:To know if the Prescriber is Eligible for ElectronicPrescription or not.

-Input Parameters: @PrescriberId

-Return:Permissions varibles for Electronic Prescription

-Called by:Application method ElectronicPrescriptionPermissions(int PrescriberId)
-Log:
	Date                     Author                             Purpose
	01/30/2018             Pranay                      Added @PharmacyId,SureScriptsPrescriberId

===============================================================*/
AS
    BEGIN 
        SELECT  ISNULL(IsEPCSEnabled, 'N') AS EPCSEnabled ,
                CASE WHEN SP.ActionId = 10023
                          AND S.Prescriber = 'Y'
                          AND TFA.Authenticated = 'Y' THEN 'Y'
                     ELSE 'N'
                END AS DeviceAuthenticated ,
                ISNULL(a.Enabled, 'N') AS EPCSAssigned ,
                CASE WHEN a.[Enabled] = 'Y'
                          AND TFA.Authenticated = 'Y'
                          AND S.Prescriber = 'Y'
                          AND S.IsEPCSEnabled = 'Y'
                          AND SP.ActionId = 10023 THEN 'Y'
                     ELSE 'N'
                END AS ElectronicPrescriptionPermission,
				S.SureScriptsPrescriberId AS SureScriptsPrescriberId
        FROM    Staff S
                LEFT JOIN StaffPermissions SP ON S.StaffId = SP.StaffId
                                                 AND SP.ActionId = 10023
                LEFT JOIN TwoFactorAuthenticationDeviceRegistrations TFA ON S.StaffId = TFA.StaffId
                                                              AND TFA.Authenticated = 'Y'
                LEFT JOIN ( SELECT  *
                            FROM    EPCSAssigment T1
                            WHERE   T1.CreatedDate = ( SELECT MAX(CreatedDate)
                                                       FROM   EPCSAssigment T2
                                                       WHERE  T1.PrescriberStaffId = T2.PrescriberStaffId
                                                     )
                          ) AS a ON a.PrescriberStaffId = S.StaffId
        WHERE   S.StaffId = @PrescriberId
                AND ISNULL(S.RecordDeleted, 'N') = 'N'
                AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                AND ISNULL(TFA.RecordDeleted, 'N') = 'N'
                AND ISNULL(a.RecordDeleted, 'N') = 'N';
				
    END; 

    SELECT  p.SureScriptsPharmacyIdentifier ,
            b.ServiceLevel
    FROM    dbo.Pharmacies p
            JOIN dbo.SureScriptsPharmacyUpdate AS b ON b.NCPDPID = p.SureScriptsPharmacyIdentifier
    WHERE   ISNULL(p.RecordDeleted, 'N') = 'N'
            AND p.PharmacyId = @PharmacyId;


GO

