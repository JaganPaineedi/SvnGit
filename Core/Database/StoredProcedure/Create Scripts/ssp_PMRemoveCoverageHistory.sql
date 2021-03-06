

IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMRemoveCoverageHistory]') AND TYPE IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_PMRemoveCoverageHistory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMRemoveCoverageHistory] 
/* Param List */ 
@ClientCoverageHistoryId INT, 
@ClientId                INT, 
@UserCode                VARCHAR(30) 
AS 
  /******************************************************************************  
   **  File: ssp_PMRemoveCoverageHistory.sql 
  **  Name: ssp_PMRemoveCoverageHistory   
  **  Desc: To remove ClientCoveragePlan  
  **   
  **  This template can be customized:   
  **                 
  **  Return values:   
  **    
  **  Called by:      
  **                 
  **  Parameters:   
  **  Input       Output   
  **     ----------       -----------   
  **   
  **  Auth:   MSuma 
  **  Date:   14/11/2011 
  *******************************************************************************  
   **  Change History   
  *******************************************************************************  
  **  Date:				Author:		Description:   
  **  --------			--------	-------------------------------------------   
  **  15/11/2011		MSuma		Included ServiceAreaChanges
   ** 29/11/2011		MSuma		Included Fix for ServiceAreaChanges
   ** 19/02/2015		Akwinass    Included Code for CoveragePlanChangeLog
   ** 09/06/2015        Shruthi.S   Added check to avoid 'Invalid COBOrder.Ref #2 CEI -Customizations.
   ** 09/05/2016		Suneel N	Converted the Error Message Code to make it more User friendly  
									by using ERROR_MESSAGE()- #139 Network180 Env.Issues Tracking.
  *******************************************************************************/
   DECLARE @StartDate     DATETIME, 
          @EndDate       DATETIME, 
          @COBOrder      INT, 
          @ServiceAreaId INT 
   -----------------------------------
   --Modified by SWAPAN MOHAN
   DECLARE @ERRORMGS NVARCHAR(MAX)
   -----------------------------------
  BEGIN 
      BEGIN TRY 
          SELECT @StartDate = startdate, 
                 @EndDate = enddate, 
                 @COBOrder = coborder 
          FROM   clientcoveragehistory 
          WHERE  clientcoveragehistoryid = @ClientCoverageHistoryId 

          SELECT @ServiceAreaId = serviceareaid 
          FROM   clientcoveragehistory 
          WHERE  clientcoveragehistoryid = @ClientCoverageHistoryId 
		  
		  --19/02/2015------Akwinass--------------------------------------------------------------------------------------------------------------------------
		  IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCManageClientCoveragePlanChangeLog]') AND type in (N'P', N'PC')) 
		  BEGIN
			  DECLARE @ClientCoveragePlanId INT
			  SELECT TOP 1 @ClientCoveragePlanId = ClientCoveragePlanId FROM ClientCoverageHistory WHERE ClientCoverageHistoryId = @ClientCoverageHistoryId
			  EXEC ssp_SCManageClientCoveragePlanChangeLog @ClientId,@ClientCoveragePlanId,@StartDate,@EndDate,@COBOrder,@UserCode,@ServiceAreaId,'DELETE',NULL
		  END
		  -----------------------------------------------------------------------------------------------------------------------------------------------------
        
          DELETE FROM clientcoveragehistory 
          WHERE  clientcoveragehistoryid = @ClientCoverageHistoryId 

          UPDATE b 
          SET    coborder = b.coborder - 1, 
                 modifiedby = @UserCode, 
                 modifieddate = Getdate() 
          FROM   clientcoverageplans a 
                 JOIN clientcoveragehistory b 
                   ON b.clientcoverageplanid = a.clientcoverageplanid 
          WHERE  a.clientid = @ClientId 
                 AND Isnull(a.recorddeleted, 'N') = 'N' 
                 AND Isnull(b.recorddeleted, 'N') = 'N' 
                 AND b.startdate = @StartDate 
                 AND b.coborder > @COBOrder 
                 AND b.ServiceAreaId = @ServiceAreaId
                

          -- Add logic for combining Start and End dates   
          EXEC Ssp_pmcombinecoborder
            @ClientId, 
            @StartDate, 
            @EndDate, 
            @UserCode,
            @ServiceAreaId

          IF @@ERROR <> 0 
            GOTO error 

          -- Verify if the COB Order is correct 
          IF EXISTS (SELECT b.startdate, 
                            b.coborder, 
                            COUNT(*) 
                     FROM   clientcoverageplans a 
                            JOIN clientcoveragehistory b 
                              ON ( a.clientcoverageplanid = 
                                 b.clientcoverageplanid ) 
                            JOIN dbo.serviceareas sa 
                              ON( ( b.serviceareaid = sa.serviceareaid ) 
                                  AND ( @ServiceAreaId = b.serviceareaid 
                                         ) ) 
                     WHERE  a.clientid = @ClientId 
                            AND Isnull(a.recorddeleted, 'N') = 'N' 
                            AND Isnull(b.recorddeleted, 'N') = 'N' 
                            AND b.ClientCoverageHistoryId <> @ClientCoverageHistoryId
                     GROUP  BY b.startdate, 
                               b.coborder 
                     HAVING COUNT(*) > 1) 
            BEGIN 
                ------------------------------------------------------------
				--RAISERROR 30001 'Invalid COB Order in Coverage History. Duplicate COB Order. Please contact system administrator'
				--Modified by: SWAPAN MOHAN 
				--Modified on: 4 July 2012
				--Purpose: For implementing the Customizable Message Codes. 
				--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.				
				Set @ERRORMGS=dbo.Ssf_GetMesageByMessageCode(29,'DUPLICATECOBORDER_SSP','Invalid COB Order in Coverage History. Duplicate COB Order. Please contact system administrator.')
				RAISERROR 30001 @ERRORMGS
				------------------------------------------------------------ 
    GOTO error 
END 

    IF EXISTS (SELECT * 
               FROM   clientcoverageplans a 
                      JOIN clientcoveragehistory b 
                        ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
                      JOIN dbo.serviceareas sa 
                        ON( ( b.serviceareaid = sa.serviceareaid ) 
                            AND ( @ServiceAreaId = b.serviceareaid 
                                   OR @ServiceAreaId IS NULL ) ) 
               WHERE  a.clientid = @ClientId 
                      AND Isnull(a.recorddeleted, 'N') = 'N' 
                      AND Isnull(b.recorddeleted, 'N') = 'N' 
                      AND b.ClientCoverageHistoryId <> @ClientCoverageHistoryId
                      AND b.startdate > b.enddate) 
      BEGIN 
		------------------------------------------------------------
		--RAISERROR 30001 'Invalid COB Order in Coverage History. End date less than start date. Please contact system administrator'
		--Modified by: SWAPAN MOHAN 
		--Modified on: 4 July 2012
		--Purpose: For implementing the Customizable Message Codes. 
		--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.				
		Set @ERRORMGS=dbo.Ssf_GetMesageByMessageCode(29,'ENDDATELESSSTARTDATE_SSP','Invalid COB Order in Coverage History. End date less than start date. Please contact system administrator.')
		RAISERROR 30001 @ERRORMGS
		------------------------------------------------------------    
    GOTO error 
END 

    IF EXISTS (SELECT * 
               FROM   clientcoverageplans a 
                      JOIN clientcoveragehistory b 
                        ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
                      JOIN clientcoveragehistory c 
                        ON ( a.clientcoverageplanid = c.clientcoverageplanid ) 
               WHERE  a.clientid = @ClientId 
                      AND Isnull(a.recorddeleted, 'N') = 'N' 
                      AND Isnull(b.recorddeleted, 'N') = 'N' 
                      AND Isnull(c.recorddeleted, 'N') = 'N' 
                      AND b.ClientCoverageHistoryId <> @ClientCoverageHistoryId
                      AND ( b.startdate <= c.startdate 
                            AND Isnull(b.enddate, Dateadd(yy, 10, Getdate())) > 
                                c.startdate 
                            AND Isnull(b.enddate, Dateadd(yy, 10, Getdate())) <>
                                 Isnull(c.enddate, 
                                Dateadd(yy, 10, Getdate())) ) 
                      --Added by Suma  
                      AND b.serviceareaid = c.serviceareaid) 
      BEGIN 
      	------------------------------------------------------------
		--RAISERROR 30001 'Invalid COB Order in Coverage History. Overlapping date ranges. Please contact system administrator'
		--Modified by: SWAPAN MOHAN 
		--Modified on: 4 July 2012
		--Purpose: For implementing the Customizable Message Codes. 
		--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.				
		Set @ERRORMGS=dbo.Ssf_GetMesageByMessageCode(29,'OVERLAPPINGDATERANGES_SSP','Invalid COB Order in Coverage History. Overlapping date ranges. Please contact system administrator.')
		RAISERROR 30001 @ERRORMGS
		------------------------------------------------------------  
    GOTO error 
END 

    RETURN 0 

    ERROR: 

    RETURN -1 
END TRY 

    BEGIN CATCH 
        DECLARE @Error VARCHAR(8000) 
        /**** 09/05/2016 Suneel N ****/
		SET @Error=CONVERT(VARCHAR(4000),ERROR_MESSAGE())
        RAISERROR ( @Error,-- Message text. 
                    16,-- Severity. 
                    1 -- State. 
        ); 
    END CATCH 
END 

GO  