DECLARE @AgencyFIPS CHAR(2);
SELECT @AgencyFIPS = [State] FROM dbo.Agency

IF OBJECT_ID('tempdb..#Records') IS NOT NULL
DROP TABLE #Records

CREATE TABLE #Records (
      StaffId INT
    , NPI VARCHAR(10)
    , DEA VARCHAR(25) --30 in staff table
    , PrimaryLicense CHAR(1) DEFAULT 'Y'
    );

--Find DEA and NPI numbers for all staff
INSERT  INTO #Records ( StaffId, DEA, PrimaryLicense )
SELECT  a.StaffId, LEFT(a.DEANumber,30), 'Y'
FROM    Staff AS a
WHERE   ISNULL(a.RecordDeleted, 'N') = 'N'
        AND ISNULL(a.DEANumber, '') <> '';

INSERT  INTO #Records ( StaffId, NPI,PrimaryLicense )
SELECT  a.StaffId, a.NationalProviderId, 'Y'
FROM    Staff AS a
WHERE   ISNULL(a.RecordDeleted, 'N') = 'N'
        AND ISNULL(a.NationalProviderId, '') <> '';

--Create the License Degree Records
INSERT  INTO dbo.StaffLicenseDegrees ( StaffId, LicenseTypeDegree, LicenseNumber, StartDate, EndDate, Billing, Notes, StateFIPS, PrimaryValue )
SELECT  a.StaffId, 9403, a.DEA, NULL, NULL, 'N', NULL, @AgencyFIPS, a.PrimaryLicense
FROM    #Records AS a
WHERE   NOT EXISTS ( SELECT 1
                     FROM   dbo.StaffLicenseDegrees AS b
                     WHERE  a.StaffId = b.StaffId
                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
                            AND b.LicenseTypeDegree = 9403
                            AND b.LicenseNumber = a.DEA )
        AND ISNULL(a.NPI, '') = ''
        AND ISNULL(a.DEA, '') <> ''
UNION ALL
SELECT  a.StaffId, 9408, a.NPI, NULL, NULL, 'N', NULL, @AgencyFIPS, a.PrimaryLicense
FROM    #Records AS a
WHERE   NOT EXISTS ( SELECT 1
                     FROM   dbo.StaffLicenseDegrees AS b
                     WHERE  a.StaffId = b.StaffId
                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
                            AND b.LicenseTypeDegree = 9408
                            AND b.LicenseNumber = a.NPI )
        AND ISNULL(a.NPI, '') <> ''
        AND ISNULL(a.DEA, '') = '';


UPDATE b
SET b.StaffLicenseDegreeId = a.StaffLicenseDegreeId,
b.ModifiedBy = 'EPCS Data Fix',
b.ModifiedDate = GETDATE()
FROM dbo.ClientMedicationScripts  AS b
JOIN dbo.StaffLicenseDegrees AS a ON a.StaffId = b.OrderingPrescriberId
AND ISNULL(a.PrimaryValue,'N') = 'Y'
AND ISNULL(a.RecordDeleted,'N')='N'
WHERE b.StaffLicenseDegreeId IS NULL



--SELECT * FROM #Records
--SELECT * FROM dbo.StaffLicenseDegrees ORDER BY 1 DESC 
