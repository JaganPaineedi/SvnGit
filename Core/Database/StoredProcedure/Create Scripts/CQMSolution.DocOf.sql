/****** Object:  StoredProcedure [CQMSolution].[DocOf]    Script Date: 01-02-2018 11:55:06 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[DocOf]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[DocOf];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[DocOf]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[DocOf]
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
*******************************************************************************/
 Create Table #StaffInfo (
 StaffId int,
 AnyMissing bit -- if 1 then use Agency info other wise use Staff info
 )
 insert into #StaffInfo ( StaffId, AnyMissing)
 select a.StaffId, case 
				    when nullif(LTRIM(RTRIM(a.[Address])),'') is null 
					   or nullif(LTRIM(RTRIM(a.City)),'') is null 
					   or nullif(LTRIM(RTRIM(a.[State])),'') is null 
					   or nullif(LTRIM(RTRIM(a.Zip)),'') is null then 1
				    else 0
				end
 from Staff as a
 where exists( select 1
			 from #Services as s
			 where a.StaffId = s.ClinicianId
		   )
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
                    NULL AS 'lngId' ,
                    s.ClientId AS 'CLIENT_ID' ,
                    'CQM' AS 'REC_TYPE' ,
                    'DocOf' AS 'SEC_TYPE' ,
                    st.LastName AS 'D001' ,
                    st.FirstName AS 'D002' ,
                    NULL AS 'D003' ,
                    isnull(l.PhoneNumber,a.MainPhone) AS 'D004' ,
                    case si.AnyMissing
				    when 1 then a.[Address]
				    else st.[Address] 
				end AS 'D005' ,
                    NULL AS 'D006' ,
                    case si.AnyMissing
				    when 1 then a.City
				    else st.City
				end AS 'D007' ,
                    case si.AnyMissing
				    when 1 then a.[State]
				    else st.[State]
				end AS 'D008' ,
                    case si.AnyMissing
				    when 1 then a.ZipCode
				    else st.Zip
				end AS 'D009' ,
                    NULL AS 'D010' ,
                    NULL AS 'D011' ,
                    st.NationalProviderId AS 'D012' ,
                    NULL AS 'D013' ,
                    NULL AS 'D014' ,
                    a.AgencyName AS 'D015' ,
                    a.[Address] AS 'D016' ,
                    a.City AS 'D017' ,
                    a.[State] AS 'D018' ,
                    a.ZipCode AS 'D019' ,
                    '' AS 'D020' , --a.MainPhone AS 'D020', a.MainPhone AS 'D020',
                    REPLACE(CONVERT(VARCHAR(10), s.DateOfService, 112)
                            + CONVERT(VARCHAR(8), s.DateOfService, 114), ':',
                            '') AS 'D021' ,
                    REPLACE(CONVERT(VARCHAR(10), s.EndDateOfService, 112)
                            + CONVERT(VARCHAR(8), s.EndDateOfService, 114),
                            ':', '') AS 'D022' ,
                    NULL AS 'D023' ,
                    NULL AS 'D024' ,
                    NULL AS 'D025' ,
                    NULL AS 'D026' ,
                    NULL AS 'D027' ,
                    NULL AS 'D028' ,
                    NULL AS 'D029' ,
                    NULL AS 'D030' ,
                    '2.16.840.1.113883.4.6' AS 'D031' ,
                    NULL AS 'D032' ,
                    '2.16.840.1.113883.6.101' AS 'D033' ,
                    'Healthcare Provider Taxonomy (HIPAA)' AS 'D034' ,
                    'WP' AS 'D035' ,
                    'HP' AS 'D036' ,
                    'US' AS 'D037' ,
                    NULL AS 'D038' ,
                    NULL AS 'D039' ,
                    NULL AS 'D040' ,
                    NULL AS 'D041' ,
                    '2.16.840.1.113883.4.6' AS 'D042' ,
                    'PRF' AS 'D043' ,
                    NULL AS 'D044' ,
                    NULL AS 'D045' ,
                    NULL AS 'D046' ,
                    NULL AS 'D047' ,
                    NULL AS 'D048' ,
                    NULL AS 'D049' ,
                    NULL AS 'D050' ,
                    NULL AS 'ValueSetOID' ,
                    NULL AS 'IDRoot' ,
                    NULL AS 'IDExtension' ,
                    s.ServiceId AS 'Account_Number'
            FROM   #Services AS s
                    JOIN Staff AS st ON s.ClinicianId = st.StaffId
				Join #StaffInfo as si on st.StaffId = si.StaffId
				Join Locations as l on s.LocationId = l.LocationId
                    CROSS APPLY dbo.Agency AS a;

GO

