/****** Object:  StoredProcedure [CQMSolution].[Device]    Script Date: 01-02-2018 11:54:28 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Device]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Device];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Device]
    @type VARCHAR(255) ,-- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,-- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,-- start date of the reporting period
    @stopDate DATETIME ,-- end date of the reporting period
    @practiceID VARCHAR(255) , -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Device]
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
**									   changed join to ssf_GetServices to exists to prevent duplicates
*******************************************************************************/
    if(@type = 'EP') --this proc is only applicable for EH
    begin
	   return;
    end
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
              [ACCOUNT_NUMBER]
	        )
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = CO.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'DEVICE' ,
                    D001 = NULL --if we need to add value here, add case logic like in D002
                    ,
                    D002 = CASE WHEN [dbo].[smsf_GetClientOrderQnAnswer]('Status',
                                                              CO.ClientOrderId) = 'ORDND'
                                THEN NULL
                                ELSE [dbo].[smsf_GetClientOrderQnAnswer]('Device Code (SNOMED)',
                                                              CO.ClientOrderId)
                           END ,
                    D003 = CASE WHEN [dbo].[smsf_GetClientOrderQnAnswer]('Status',
                                                              CO.ClientOrderId) = 'ORDND'
                                THEN NULL
                                ELSE [dbo].[smsf_GetClientOrderQnAnswer]('Device Description',
                                                              CO.ClientOrderId)
                           END ,
                    D004 = CASE WHEN [dbo].[smsf_GetClientOrderQnAnswer]('Status',
                                                              CO.ClientOrderId) = 'ORDND'
                                THEN NULL
                                ELSE [dbo].[smsf_GetClientOrderQnAnswer]('CodeSystem',
                                                              CO.ClientOrderId)--2.16.840.1.113883.6.96
                           END ,
                    D005 = CASE WHEN [dbo].[smsf_GetClientOrderQnAnswer]('Status',
                                                              CO.ClientOrderId) = 'ORDND'
                                THEN NULL
                                ELSE [dbo].[smsf_GetClientOrderQnAnswer]('CodeSystemName',
                                                              CO.ClientOrderId) --SNOMED-CT
                           END ,
                    D006 = NULL --if we need to add value here, add case logic like in D002
                    ,
                    D007 = NULL --if we need to add value here, add case logic like in D002
                    ,
                    D008 = [dbo].[smsf_GetClientOrderQnAnswer]('Status',
                                                              CO.ClientOrderId) ,
                    D009 = NULL ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = NULL ,
                    D013 = NULL ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = NULL ,
                    D017 = NULL ,
                    D018 = NULL ,
                    D019 = NULL ,
                    D020 = NULL ,
                    D021 = NULL ,
                    D022 = NULL ,
                    D023 = NULL ,
                    D024 = NULL ,
                    D025 = [dbo].[smsf_GetClientOrderQnAnswer]('Not Performed Reason (SNOMED)',
                                                              CO.ClientOrderId) ,
                    D026 = [dbo].[smsf_GetClientOrderQnAnswer]('ReasonCodeSystem',
                                                              CO.ClientOrderId) ,
                    D027 = [dbo].[smsf_GetClientOrderQnAnswer]('Not Performed Reason Description',
                                                              CO.ClientOrderId) ,
                    D028 = CASE WHEN [dbo].[smsf_GetClientOrderQnAnswer]('Status',
                                                              CO.ClientOrderId) = 'ORDND'
                                THEN '2.16.840.1.113883.3.117.1.7.1.93'
                                ELSE NULL
                           END ,
                    D029 = NULL ,
                    D030 = NULL ,
                    D031 = NULL ,
                    D032 = NULL ,
                    D033 = NULL ,
                    D034 = NULL ,
                    D035 = NULL ,
                    D036 = NULL ,
                    D037 = NULL ,
                    D038 = NULL ,
                    D039 = NULL ,
                    D040 = NULL ,
                    D041 = NULL ,
                    D042 = NULL ,
                    D043 = NULL ,
                    D044 = NULL ,
                    D045 = NULL ,
                    D046 = NULL ,
                    D047 = NULL ,
                    D048 = NULL ,
                    D049 = NULL ,
                    D050 = NULL ,
                    ValueSetOID = CASE WHEN [dbo].[smsf_GetClientOrderQnAnswer]('Status',
                                                              CO.ClientOrderId) = 'ORDND'
                                       THEN '2.16.840.1.113883.3.117.1.7.1.214'
                                       ELSE NULL
                                  END ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    ACCOUNT_NUMBER = CO.ClientOrderId
            FROM    ClientOrders CO
                    JOIN Documents D ON D.DocumentId = CO.DocumentId
                    JOIN Orders O ON CO.OrderId = O.OrderId
					JOIN #Clinicians AS st ON co.OrderedBy = st.StaffId
            WHERE   O.OrderType = 8503
                    AND O.OrderName = 'Device'
                    AND ISNULL(CO.RecordDeleted, 'N') = 'N'
                    AND ISNULL(O.RecordDeleted, 'N') = 'N'
                    AND ISNULL(D.RecordDeleted, 'N') = 'N'
                    AND O.Active = 'Y'
                    AND D.Status = 22
                    AND EXISTS ( SELECT 1
                                 FROM   #Services AS a
                                 WHERE  a.ClientId = D.ClientId );


GO