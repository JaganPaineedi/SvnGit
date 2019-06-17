IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateMARNotGivenStatus]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCUpdateMARNotGivenStatus] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [ssp_SCUpdateMARNotGivenStatus] 
@ClientId       INT         
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCUpdateMARNotGivenStatus            */ 
/* Creation Date:    16/Sep/2014                */ 
/* Purpose:  To  update the Status ="Not Given" for all the MedAdminRecordId which is more than 24 hours OverDue               */ 
/*    Exec ssp_SCUpdateMARNotGivenStatus  219                                           */
/* Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 16/Sep/2014		Gautam			Created    task #206 , Philhaven Development - MAR Changes.          */ 
/* 31/Mar/2017		Chethan N		What: Converted Custom 'XMarStatus' to Core 'MarStatus'.
									Why:  Renaissance - Dev Items task #5.1	
	18/Jan/2018		Gautam			What: Added code to check for Rx completion to return NotCompletedInRx ,
									Task#5.5,Renaissance - Dev Items	
    14/May/2018     Gautam          what: Change code to make compatible with SQL 2016. Why:  AHN Support GO live task #195	*/		
  /*********************************************************************/ 
  BEGIN 
	DECLARE @GlobalCodeIdNotGiven int
	DECLARE @OverdueHours INT
	
	BEGIN TRY
	
	-- Get MARoverdueLookbackHours from system config keys.	
	SELECT top 1 @OverdueHours = Value
	FROM SystemConfigurationKeys
	WHERE [Key] = 'MARoverdueLookbackHours'
		AND (ISNULL(RecordDeleted, 'N') = 'N')


	Select Top 1 @GlobalCodeIdNotGiven= GlobalcodeId From GlobalCodes Where category='MARStatus' and CodeName='Not Given (Not filled by Pharmacy)'
							and ISNULL(RecordDeleted, 'N') = 'N'	
	Update MA
	Set MA.Status=@GlobalCodeIdNotGiven,MA.AdministeredDate=getdate(),MA.AdministeredTime=CAST(GETDATE() as Time(0)),
		 MA.ModifiedBy='ADMIN', MA.ModifiedDate= GETDATE(), MA.Comment='Status updated by the System.'
	From MedAdminRecords MA Join ClientOrders CO on MA.ClientOrderId= CO.ClientOrderId and CO.ClientId = @ClientId
	Where MA.AdministeredDate is null and  ISNULL(MA.RecordDeleted, 'N') = 'N' and
		ISNULL(DATEDIFF(hh, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()), 0) > @OverdueHours
		and exists (Select 1 From ClientMedications AS CM where MA.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(CM.RecordDeleted, 'N') = 'N' and ISNULL(CM.Ordered, 'N') = 'Y' and ISNULL(CM.SmartCareOrderEntry, 'N') = 'Y') -- Completed in Rx
   
	END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(max) 
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCUpdateMARNotGivenStatus' 
                      ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
      END catch 
  END 

go  