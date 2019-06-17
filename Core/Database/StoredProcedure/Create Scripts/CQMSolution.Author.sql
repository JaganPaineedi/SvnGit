/****** Object:  StoredProcedure [CQMSolution].[Author]    Script Date: 01-02-2018 11:52:49 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Author]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Author];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Author]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Author]
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

    DECLARE @OrganizationName VARCHAR(250), @TaxId varchar(9);

    SELECT  @OrganizationName = AgencyName,
		  @TaxId = TaxId
    FROM    dbo.Agency;

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
                    NULL AS lngId ,
                    d.ClientId AS CLIENT_ID ,
                    'CQM' AS CQM ,
                    'AUTHOR' AS AUTHOR ,
                    st.LastName AS 'D001' ,
                    st.FirstName AS 'D002' ,
                    NULL AS 'D003' ,
                    st.PhoneNumber AS 'D004' ,
                    st.[Address] AS 'D005' ,
                    NULL AS 'D006' ,
                    st.City AS 'D007' ,
                    st.[State] AS 'D008' ,
                    st.Zip AS 'D009' ,
                    'US' AS 'D010' ,
                    @OrganizationName AS 'D011' ,
                    st.NationalProviderId AS 'D012' ,
                    NULL AS 'D013' ,
                    NULL AS 'D014' ,
                    NULL AS 'D015' ,
                    NULL AS 'D016' ,
                    NULL AS 'D017' ,
                    NULL AS 'D018' ,
                    NULL AS 'D019' ,
                    'SmartCare' AS 'D020' ,
                    'SmartCare' AS 'D021' ,
                    NULL AS 'D022' ,
                    NULL AS 'D023' ,
                    NULL AS 'D024' ,
                    NULL AS 'D025' ,
                    isnull(TaxIdentificationNumber,@TaxId) AS 'D026' ,
                    NULL AS 'D027' ,
                    NULL AS 'D028' ,
                    NULL AS 'D029' ,
                    NULL AS 'D030' ,
                    NULL AS 'D031' ,
                    NULL AS 'D032' ,
                    NULL AS 'D033' ,
                    NULL AS 'D034' ,
                    NULL AS 'D035' ,
                    NULL AS 'D036' ,
                    NULL AS 'D037' ,
                    NULL AS 'D038' ,
                    NULL AS 'D039' ,
                    NULL AS 'D040' ,
                    NULL AS 'D041' ,
                    NULL AS 'D042' ,
                    NULL AS 'D043' ,
                    NULL AS 'D044' ,
                    NULL AS 'D045' ,
                    NULL AS 'D046' ,
                    NULL AS 'D047' ,
                    NULL AS 'D048' ,
                    NULL AS 'D049' ,
                    NULL AS 'D050' ,
                    NULL AS 'ValueSetOId' ,
                    NULL AS 'IDRoot' ,
                    NULL AS 'IDExtension' ,
                    d.ServiceId AS Account_Number
            FROM    #Services AS d
				join Locations as l on d.LocationId = l.LocationId
                    JOIN Staff AS st ON d.ClinicianId = st.StaffId;

GO