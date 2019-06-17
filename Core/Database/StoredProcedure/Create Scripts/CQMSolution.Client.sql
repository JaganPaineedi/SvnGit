/****** Object:  StoredProcedure [CQMSolution].[Client]    Script Date: 01-02-2018 11:53:13 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Client]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Client];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Client]
    @type VARCHAR(255) ,-- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,-- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,-- start date of the reporting period
    @stopDate DATETIME ,-- end date of the reporting period
    @practiceID VARCHAR(255) ,-- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Client]
**		Desc: 
**
**		Called by: dbo.spGetCQMDataForReport
**
**		Auth: jcarlson
**		Date: 2/1/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:	 		   Description:
**		--------		--------			   ------------------------------------------
**        2/1/2018       jcarlson               created comment header
**									   added batching logic
**									   updated logic to use new ssf_GetServices function instead of type specific functions
**									   Added client Id to AccountNumber
*******************************************************************************/
    WITH    Residence
              AS ( SELECT   c.ClientId ,
                            CASE WHEN CHARINDEX(CHAR(13) + CHAR(10),
                                                ca.Address) > 0
                                 THEN LEFT(ca.Address,
                                           CHARINDEX(CHAR(13) + CHAR(10),
                                                     ca.Address) - 1)
                                 ELSE ca.Address
                            END AS Address1 ,
                            CASE WHEN CHARINDEX(CHAR(13) + CHAR(10),
                                                ca.Address) > 0
                                 THEN SUBSTRING(ca.Address,
                                                CHARINDEX(CHAR(13) + CHAR(10),
                                                          ca.Address) + 2,
                                                LEN(ca.Address)
                                                - CHARINDEX(CHAR(13) + CHAR(10),
                                                            ca.Address) + 2)
                                 ELSE NULL
                            END AS Address2 ,
                            ca.City ,
                            ca.State ,
                            ca.Zip
                   FROM     Clients c
                            JOIN ClientAddresses ca ON ca.ClientId = c.ClientId
                   WHERE    AddressType = 90 -- Home
                            AND ISNULL(ca.RecordDeleted, 'N') = 'N'
							AND EXISTS( SELECT 1
										FROM #Services AS s
										WHERE c.ClientId = s.ClientId
										)
                            AND NOT EXISTS ( SELECT *
                                             FROM   ClientAddresses ca2
                                             WHERE  ca2.ClientId = ca.ClientId
                                                    AND ca2.AddressType = ca.AddressType
                                                    AND ISNULL(ca2.RecordDeleted,
                                                              'N') = 'N'
                                                    AND ca2.ClientAddressId > ca.ClientAddressId )
                 ),
            OneClientPhone
              AS ( SELECT   *
                   FROM     ( SELECT    Rnk = RANK() OVER ( PARTITION BY ClientId ORDER BY CASE
                                                              WHEN cp.IsPrimary = 'Y'
                                                              THEN 1
                                                              ELSE 2
                                                              END ASC
					, gc.SortOrder ASC
					, ClientPhoneId DESC ) ,
                                        cp.ClientId ,
                                        PhoneType = CASE gc.ExternalCode1
                                                      WHEN 'HOME' THEN 'HP'
                                                      WHEN 'BUSINESS'
                                                      THEN 'WP'
                                                      ELSE gc.ExternalCode1
                                                    END ,
                                        cp.PhoneNumber
                              FROM      [dbo].[ClientPhones] cp
                                        INNER JOIN dbo.GlobalCodes gc ON cp.PhoneType = gc.GlobalCodeId
                              WHERE     ISNULL(cp.RecordDeleted, 'N') = 'N'
                                        AND LEN(PhoneNumber) > 3
										
										AND EXISTS( SELECT 1
													FROM #Services AS s
													WHERE cp.ClientId = s.ClientId
													)
                            ) OneClientPhone
                   WHERE    Rnk = 1
                 ),
            Ethnicity
              AS ( SELECT   c.ClientId ,
                            CodeId = CAST(gcethnicity.ExternalCode1 AS VARCHAR(25)) ,
                            CodeName = CAST(gcethnicity.Code AS VARCHAR(50))
                   FROM     Clients c
                            INNER JOIN ClientEthnicities ce ON c.ClientId = ce.ClientId
                                                              AND ISNULL(c.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(ce.RecordDeleted,
                                                              'N') = 'N'
                            INNER JOIN GlobalCodes gcethnicity ON ce.EthnicityId = gcethnicity.GlobalCodeId
                                                              AND gcethnicity.Category = 'Ethnicity'
                   WHERE    NOT EXISTS ( SELECT *
                                         FROM   ClientEthnicities ice
                                         WHERE  ice.ClientId = c.ClientId
                                                AND ISNULL(ice.RecordDeleted,
                                                           'N') = 'N'
                                                AND ice.ClientEthnicityId > ice.ClientEthnicityId )

							AND EXISTS( SELECT 1
										FROM #Services AS s
										WHERE c.ClientId = s.ClientId
										)
                 ),
            CurrentClientRace
              AS ( SELECT   ClientId ,
                            MAX(CASE WHEN Rnk = 1 THEN ExternalCode1
                                END) AS CodeId ,
                            MAX(CASE WHEN Rnk = 1 THEN CodeName
                                END) AS Race ,
                            MAX(CASE WHEN Rnk = 2 THEN CodeName
                                END) AS Race2 ,
                            MAX(CASE WHEN Rnk = 3 THEN CodeName
                                END) AS Race3
                   FROM     ( SELECT    cr.ClientId ,
                                        gc.CodeName ,
                                        ExternalCode1 = CAST(gc.ExternalCode1 AS VARCHAR(25)) ,
                                        ROW_NUMBER() OVER ( PARTITION BY ClientId ORDER BY ClientRaceId ASC ) AS Rnk
                              FROM      ClientRaces cr
                                        INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = cr.RaceId
                                                              AND gc.Category = 'Race'
                                                              AND ISNULL(gc.RecordDeleted,
                                                              'N') = 'N'
                              WHERE     ISNULL(cr.RecordDeleted, 'N') = 'N'
										AND EXISTS( SELECT 1
													FROM #Services AS s
													WHERE cr.ClientId = s.ClientId
													)
                            ) flatrace
                   GROUP BY ClientId
                 )
        SELECT  CLIENT_ID = c.ClientId ,
                NameLast = LastName ,
                NameFirst = FirstName ,
                NameMiddle = MiddleName ,
                DateOfBirth = REPLACE(CONVERT(VARCHAR(8), DOB, 112)
                                      + CONVERT(VARCHAR(8), DOB, 114), ':', '') ,
                Gender = Sex ,
                GenderDesc = CASE WHEN Sex = 'M' THEN 'Male'
                                  WHEN Sex = 'F' THEN 'Female'
                             END ,
                AddressType = 'HP' -- What is valid type for home vs work address?
                ,
                AddressStreet1 = r.Address1 ,
                AddressStreet2 = r.Address2 ,
                AddressCity = r.City ,
                AddressState = r.[State] ,
                AddressZip = r.Zip ,
                AddressCountry = 'US' ,
                Phone1Type = ph.PhoneType ,
                Phone1 = ph.PhoneNumber ,
                Race = rac.CodeId ,
                RaceDesc = rac.Race ,
                Ethnicity = eth.CodeId ,
                EthnicityDesc = eth.CodeName ,
                LanguageDesc = gcLang.Code
        INTO    #Clients
        FROM    dbo.Clients c
                LEFT OUTER JOIN Residence r ON r.ClientId = c.ClientId
                LEFT OUTER JOIN OneClientPhone ph ON r.ClientId = ph.ClientId
                LEFT OUTER JOIN dbo.GlobalCodes gcLang ON c.PrimaryLanguage = gcLang.GlobalCodeId
                LEFT OUTER JOIN Ethnicity eth ON c.ClientId = eth.ClientId
                LEFT OUTER JOIN CurrentClientRace rac ON c.ClientId = rac.ClientId
/* Only pull in clients where there was at least one CQM data item 
   staged*/
        WHERE    EXISTS ( SELECT *
                             FROM   #Services isv
                             WHERE  isv.ClientId = c.ClientId );

    INSERT  INTO [CQMSolution].[StagingCQMData]
            ( [StagingCQMDataBatchId] ,
              [lngId] ,
              [CLIENT_ID] ,
              [REC_TYPE] ,
              [SEC_TYPE] ,
              [D001] ,
              [D002] ,
              [D003] ,
              [D004] ,
              [D005] ,
              [D006] ,
              [D007] ,
              [D008] ,
              [D009] ,
              [D010] ,
              [D011] ,
              [D012] ,
              [D013] ,
              [D014] ,
              [D015] ,
              [D016] ,
              [D017] ,
              [D018] ,
              [D019] ,
              [D020] ,
              [D021] ,
              [D022] ,
              [D023] ,
              [D024] ,
              [D025] ,
              [D026] ,
              [D027] ,
              [D028] ,
              [D029] ,
              [D030] ,
              [D031] ,
              [D032] ,
              [D033] ,
              [D034] ,
              [D035] ,
              [D036] ,
              [D037] ,
              [D038] ,
              [D039] ,
              [D040] ,
              [D041] ,
              [D042] ,
              [D043] ,
              [D044] ,
              [D045] ,
              [D046] ,
              [D047] ,
              [D048] ,
              [D049] ,
              [D050] ,
              [ValueSetOID] ,
              [IDRoot] ,
              [IDExtension] ,
              Account_Number
	        )
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = c.CLIENT_ID ,
                    REC_TYPE = 'ALL' ,
                    SEC_TYPE = 'CLIENT' ,
                    D001 = c.NameLast ,
                    D002 = c.NameFirst ,
                    D003 = c.NameMiddle ,
                    D004 = c.DateOfBirth ,
                    D005 = c.Gender ,
                    D006 = c.GenderDesc ,
                    D007 = c.AddressType ,
                    D008 = c.AddressStreet1 ,
                    D009 = c.AddressStreet2 ,
                    D010 = c.AddressCity ,
                    D011 = c.AddressState ,
                    D012 = c.AddressZip ,
                    D013 = c.AddressCountry ,
                    D014 = c.Phone1Type ,
                    D015 = c.Phone1 ,
                    D016 = c.LanguageDesc ,
                    D017 = c.Race ,
                    D018 = c.RaceDesc ,
                    D019 = c.Ethnicity ,
                    D020 = c.EthnicityDesc ,
                    D021 = NULL -- ReligousCode optional
                    ,
                    D022 = NULL -- ReligousDesc optional
                    ,
                    D023 = c.LanguageDesc ,
                    D024 = c.CLIENT_ID -- Account number same as client id
                    ,
                    D025 = NULL --OrganizationName
                    ,
                    D026 = NULL --OrganizationTel
                    ,
                    D027 = NULL --OrgAddrST1
                    ,
                    D028 = NULL --OrgAddrCity
                    ,
                    D029 = NULL --OrgAddrState
                    ,
                    D030 = NULL --OrgAddrZip
                    ,
                    D031 = NULL --GuarCode
                    ,
                    D032 = NULL --GuarDesc
                    ,
                    D033 = NULL --GuarantorNameFirst
                    ,
                    D034 = NULL --GuarantorNameLast
                    ,
                    D035 = c.CLIENT_ID -- PatientID same as client id
                    ,
                    D036 = NULL --EmailAddress
                    ,
                    D037 = '1.2.1857.2.25' --PatientIdRootId
                    ,
                    D038 = NULL --N/A
                    ,
                    D039 = NULL --N/A
                    ,
                    D040 = c.CLIENT_ID --Patient Identifier Number - Can be MRN or unique number for HQR_EHR submission
                    ,
                    D041 = '2.16.840.1.113883.3.249.15' -- Patient Identifier OID - Required for HQR submission : 2.16.840.1.113883.3.249.15
                    ,
                    D042 = NULL --N/A
                    ,
                    D043 = NULL --N/A
                    ,
                    D044 = NULL --N/A
                    ,
                    D045 = NULL --N/A
                    ,
                    D046 = NULL --N/A
                    ,
                    D047 = NULL --N/A
                    ,
                    D048 = NULL --N/A
                    ,
                    D049 = NULL --N/A
                    ,
                    D050 = NULL --N/A
                    ,
                    ValueSetOID = NULL --N/A
                    ,
                    IDRoot = NULL --N/A
                    ,
                    IDExtension = NULL --N/A
                    ,
                    c.CLIENT_ID AS AccountNumber
            FROM    #Clients c;
GO


