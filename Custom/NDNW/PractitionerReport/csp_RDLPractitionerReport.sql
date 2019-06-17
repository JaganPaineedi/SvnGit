IF EXISTS ( SELECT  *
            FROM    sys.Objects
            WHERE   Object_Id = OBJECT_ID(N'dbo.csp_RDLPractitionerReport')
                    AND Type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE dbo.csp_RDLPractitionerReport
Go


CREATE PROCEDURE [dbo].[csp_RDLPractitionerReport]
    (
      @staffid INT
    )
AS 
    BEGIN
       	
	
        DECLARE @ClinicAffiliations VARCHAR(MAX)
        SET @ClinicAffiliations = 'St.Alphonsus Medical Center'
DECLARE @StartDate DATE, @EndDate DATE
SELECT @StartDate = CONVERT(DATE,GETDATE() - 366)
SELECT @EndDate = CONVERT(DATE,GETDATE() )
	
        SELECT @StartDate AS StartDate,
			 @EndDate AS EndDate,
			  s.FirstName + ' ' + s.LastName AS ProviderName
              , s.staffid
              , s.signingsuffix AS Credentials
              , s.Address
              , dbo.csf_RDLSureScriptsFormatPhone(s.PhoneNumber) AS Phone
              , aa.CodeName AS Staffrole
              , s.DOB
              , s.NationalProviderId
              , s.SSN
              , s.Comment
              , s.Sex
              , ee.CodeName AS LanguagesSpoken
              , @ClinicAffiliations AS ClinicAffiliations
              , s.LicenseNumber
              , s.Degree
              , s.DEANumber
        FROM    staff s
        LEFT JOIN staffroles cc ON cc.staffid = s.staffid
        LEFT JOIN globalcodes aa ON aa.GlobalCodeId = cc.RoleId
        LEFT JOIN stafflanguages xx ON xx.staffid = s.StaffId
        LEFT JOIN globalcodes ee ON ee.globalcodeid = xx.languageid
        WHERE   s.Active = 'Y'
                AND ( ISNULL(s.RecordDeleted , 'N') = 'N'
                      OR ( s.DeletedDate > @StartDate )
                      AND s.RecordDeleted = 'Y'
                    )
                AND ( 1 = ( CASE WHEN @staffid IS NULL THEN 1
                                 ELSE 0
                            END )
                      OR s.Staffid = @staffid
                    )
                AND ISNULL(cc.RecordDeleted , 'N') = 'N'
                AND ISNULL(aa.RecordDeleted , 'N') = 'N'
                AND ISNULL(ee.RecordDeleted , 'N') = 'N'
                AND ISNULL(xx.RecordDeleted , 'N') = 'N'
                ORDER BY s.LastName,s.FirstName asc

    END



GO

