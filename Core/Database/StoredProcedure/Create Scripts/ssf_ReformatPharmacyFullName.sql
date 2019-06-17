IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssf_ReformatPharmacyFullName]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [dbo].[ssf_ReformatPharmacyFullName]
GO


set QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[ssf_ReformatPharmacyFullName] ( @SureScriptsPharmacyId INT )
RETURNS VARCHAR(100)
AS 
    BEGIN
	
        DECLARE @PharmacyName VARCHAR(100)
		
        SELECT  @PharmacyName = LEFT(PharmacyName
                                     + CASE WHEN SureScriptsPharmacyIdentifier IS NOT NULL
                                            THEN ISNULL(' - '
                                                        + CASE
                                                              WHEN LTRIM(City) = ''
                                                              THEN NULL
                                                              ELSE City
                                                          END + ', '
                                                        + CASE
                                                              WHEN LTRIM(State) = ''
                                                              THEN NULL
                                                              ELSE State
                                                          END, '')
                                                 + ISNULL(' - '
                                                          + CASE
                                                              WHEN LTRIM(Address) = ''
                                                              THEN NULL 
												--DJH 10.14.2012 removed line feed and carriage return
                                                              ELSE REPLACE(REPLACE(REPLACE(LTRIM(Address),
                                                              CHAR(13), '~'),
                                                              CHAR(10), '~'),
                                                              '~', ' ')
                                                            END, '')
                                            ELSE ''
                                       END, 100)
        FROM    Pharmacies
        WHERE   SureScriptsPharmacyIdentifier = convert(varchar(50), @SureScriptsPharmacyId)


        RETURN(@PharmacyName)
    END

GO