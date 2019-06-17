/****** Object:  StoredProcedure [CQMSolution].[Participiant]    Script Date: 01-02-2018 12:15:46 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Participiant]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Participiant];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Participiant]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Participiant]
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

declare @CMSCertNumber varchar(max) = 'CQMSolution_CertificationNumber';
select @CMSCertNumber = dbo.ssf_GetSystemConfigurationKeyValue('CQMSolution_CertificationNumber');
    INSERT  INTO [CQMSolution].[StagingCQMData]
            ( [StagingCQMDataBatchId] ,
              [lngId] ,
              [CLIENT_ID] ,
              [REC_TYPE] ,
              [SEC_TYPE] ,
              [D001] ,
              [D002] ,
              [D003] 
            )
            SELECT  distinct @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = a.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'Participiant' ,
                    D001 = @CMSCertNumber ,
                    D002 = NULL ,
                    D003 = NULL 
            FROM    #Services AS a
           
 
GO

