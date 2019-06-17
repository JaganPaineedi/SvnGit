/****** Object:  StoredProcedure [dbo].[csp_RDLDemographics]    Script Date: 08/05/2015 15:54:59 ******/
IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'[dbo].[csp_RDLDemographics]')
                    AND type IN ( N'P' , N'PC' ) )
    DROP PROCEDURE dbo.csp_RDLDemographics;
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLDemographics]    Script Date: 08/05/2015 15:54:59 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO




CREATE PROCEDURE [dbo].[csp_RDLDemographics]
    @ClientGender varCHAR(MAX) ,
    @ClientEthnicity varCHAR(MAX) ,
    @TribalAffiliation varCHAR(MAX) ,
    @DateRangeStart DATETIME ,
    @DateRangeEnd DATETIME ,
    @ClientAgeRangeStart INT ,
    @ClientAgeRangeEnd INT ,
    @ReportMode CHAR(1) --(T)ribal,(C)lientsAge,(E)thnic
AS
    CREATE TABLE #Results
        (
          EnrolledDate DATETIME ,
          ClientFirstName VARCHAR(250) ,
          ClientLastName VARCHAR(250) ,
          ClientId INT ,
          TribalAffiliation VARCHAR(250) ,
          Race VARCHAR(250) ,
          AgeRange VARCHAR(50),
          Gender CHAR(1)
        );
    IF @ReportMode = 'T'
        BEGIN
            INSERT INTO #Results
                    ( EnrolledDate ,
                      ClientFirstName ,
                      ClientLastName ,
                      ClientId ,
                      TribalAffiliation 
	               )
                SELECT DISTINCT
                        ce.RegistrationDate ,
                        c.LastName ,
                        c.FirstName ,
                        c.ClientId ,
                        gc2.CodeName AS TribalAffiliation
                    FROM
                        dbo.Clients c
                    JOIN dbo.Documents d ON c.ClientId = d.ClientId
                                            AND d.DocumentCodeId = 10500 --registraion document
                                            AND d.Status = 22
                                            AND d.CurrentVersionStatus = 22
                                            AND d.EffectiveDate >= @DateRangeStart
                                            AND d.EffectiveDate <= @DateRangeEnd
                                            AND NOT EXISTS ( SELECT
                                                                    *
                                                                FROM
                                                                    dbo.Documents d2
                                                                WHERE
                                                                    d2.ClientId = d.ClientId
                                                                    AND d2.EffectiveDate >= @DateRangeStart
                                                                    AND d2.EffectiveDate <= @DateRangeEnd
                                                                    AND ISNULL(d2.RecordDeleted , 'N') = 'N'
                                                                    AND d2.CurrentVersionStatus = d.CurrentVersionStatus
                                                                    AND d.DocumentCodeId = d2.DocumentCodeId
                                                                    AND ISNULL(d.RecordDeleted , 'N') = 'N'
                                                                    AND ( ( DATEDIFF(DAY , d2.EffectiveDate , d.EffectiveDate) < 0 )
                                                                          OR ( DATEDIFF(DAY , d2.EffectiveDate , d.EffectiveDate) = 0
                                                                               AND d2.DocumentId > d.DocumentId
                                                                             )
                                                                        ) )
                    JOIN dbo.CustomDocumentRegistrations cdr ON d.CurrentDocumentVersionId = cdr.DocumentVersionId
                                                                AND ISNULL(cdr.RecordDeleted , 'N') = 'N'
                    JOIN dbo.GlobalCodes gc2 ON gc2.GlobalCodeId = cdr.TribalAffiliation
                    JOIN dbo.ClientEpisodes AS ce ON ce.ClientId = c.ClientId
                                                     AND ce.RegistrationDate <= @DateRangeEnd
                                                     AND ( ce.DischargeDate IS NULL
                                                           OR ce.DischargeDate >= @DateRangeStart
                                                         )
                                                     AND ISNULL(ce.RecordDeleted , 'N') = 'N'
                    WHERE
                        ISNULL(c.RecordDeleted , 'N') = 'N'
				 AND EXISTS( SELECT item 
				    FROM dbo.fnSplit(@TribalAffiliation,',') AS a
				    WHERE CONVERT(INT,a.item) = gc2.GlobalCodeId
				    );

        END;
            

    IF @ReportMode = 'E'
        BEGIN
            INSERT INTO #Results
                    ( EnrolledDate ,
                      ClientFirstName ,
                      ClientLastName ,
                      ClientId ,
                      Race 
                    )
                SELECT DISTINCT
                        ce.RegistrationDate ,
                        c.LastName ,
                        c.FirstName ,
                        c.ClientId ,
                        gc.CodeName AS Race
                    FROM
                        dbo.Clients c
                    JOIN dbo.ClientRaces AS cr ON cr.ClientId = c.ClientId
                                                  AND ISNULL(cr.RecordDeleted , 'N') = 'N'
                    JOIN dbo.GlobalCodes AS gc ON cr.RaceId = gc.GlobalCodeId
                    JOIN dbo.ClientEpisodes AS ce ON ce.ClientId = c.ClientId
                                                     AND ce.RegistrationDate <= @DateRangeEnd
                                                     AND ( ce.DischargeDate IS NULL
                                                           OR ce.DischargeDate >= @DateRangeStart
                                                         )
                                                     AND ISNULL(ce.RecordDeleted , 'N') = 'N'
                    WHERE
                        ISNULL(c.RecordDeleted , 'N') = 'N'
				AND EXISTS( SELECT item 
				    FROM dbo.fnSplit(@ClientEthnicity,',') AS a
				    WHERE a.item = cr.RaceId
				    );
            
        END;

    IF @ReportMode = 'C'
        BEGIN

            INSERT INTO #Results
                    ( ClientFirstName ,
                      ClientLastName ,
                      ClientId ,
                      AgeRange,
                      Gender
		          )
                SELECT DISTINCT
                        c.LastName ,
                        c.FirstName ,
                        c.ClientId ,
                        CASE WHEN dbo.GetAge(c.DOB , GETDATE()) <= 4 THEN '0-4 age range'
                             
                        WHEN dbo.GetAge(c.DOB , GETDATE()) BETWEEN 5 AND 11 THEN '5-11 age range'
                             
                        WHEN dbo.GetAge(c.DOB , GETDATE()) BETWEEN 12 AND 14 THEN '12-14 age range'
                             
                        WHEN dbo.GetAge(c.DOB , GETDATE()) BETWEEN 15 AND 17 THEN '15-17 age range'
                             
                        WHEN dbo.GetAge(c.DOB , GETDATE()) BETWEEN 18 AND 20 THEN '18-20 age range'
                             
                        WHEN dbo.GetAge(c.DOB , GETDATE()) >= 21 THEN '21 and above'
                             ELSE NULL
                             
					    END,
                             
                        ISNULL(c.Sex,'Unknown')
                    FROM
                        dbo.Clients c
                    WHERE
                        ISNULL(c.RecordDeleted , 'N') = 'N'
				    AND ( dbo.GetAge(c.DOB,GETDATE()) >= @ClientAgeRangeStart OR @ClientAgeRangeStart IS NULL )
				    AND ( dbo.GetAge(c.DOB,GETDATE()) <= @ClientAgeRangeEnd OR @ClientAgeRangeEnd IS NULL )
				    AND EXISTS( SELECT item 
				    FROM dbo.fnSplit(@ClientGender,',') AS a
				    WHERE a.item = c.Sex
				    )
                        AND EXISTS ( SELECT
                                            1
                                        FROM
                                            dbo.Services AS s
                                        WHERE
                                            s.ClientId = c.ClientId
                                            AND ISNULL(c.RecordDeleted , 'N') = 'N'
                                            AND CONVERT(DATE , s.DateOfService) >= DATEADD(YEAR , -1 , GETDATE()) );
     
        END;


    SELECT
            EnrolledDate ,
            ClientFirstName ,
            ClientLastName ,
            ClientId ,
            TribalAffiliation ,
            Race ,
            AgeRange,
            Gender
        FROM
            #Results; 
GO


