IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAvailableResources]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAvailableResources]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAvailableResources]    Script Date: 04/05/2013 15:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ssp_GetAvailableResources]    
    (    
      @ResourceType  INT,  
      @StartDateTime DATETIME,  
      @EndDateTime  DATETIME,  
      @StaffId   INT,  
      @ServiceID  INT= NULL  
    )    
AS   
  /************************************************************************************/                                                                                
  /* Stored Procedure: dbo.ssp_GetAvailableResources         */                                                                                
  /* Copyright: 2013 Streamline Healthcare Solutions,  LLC       */                                                                                
  /* Creation Date:    07/Mar/2013             */                                                                                   
  /* Purpose:  This will return all available resources on given parameters   */                                                                                                                                                 
  /* Input Parameters:  @ResourceType,@StartDateTime,@EndDateTime,@StaffId,@ServiceID */                                                                              
  /*                      */                                                                                                                                                       
  /*  Date         Author         Purpose            */                                                                                
  /* 07/Mar/2013   Gautam         Created                   
	 JUL-31-2013   dharvey		  Added logic to allow Group service booking    
     27/Nov/2013   Gautam         Linked with Appointments table to show resources closest time
     03/Aug/2018   Ravi			  What: added order by ResourceDisplay ASC to #AvailableResources table
								  why : Harbor - Support > Tasks #1513 Service/Service Note - resource tab issues 
  */                                          
  /************************************************************************************/            
 -- TEST DATA BLOCK  
 -- set @ResourceType=24453 -- room ,24452 - Projector     
 -- set @StartDateTime='2013-03-08 11:00:00.000'     
 -- set @EndDateTime='2013-03-08 12:00:00.000'     
 -- set @StaffId =897       
 --Exec ssp_GetAvailableResources 24453,'2013-03-21 10:00:00.000','2013-03-21 11:00:00.000',897,NULL  
   --Exec ssp_GetAvailableResources 24453,'2013-03-13 10:00:00.000','2013-03-13 11:00:00.000',897,NULL  
   BEGIN  
   BEGIN TRY    
        
   -- STEP  
   -- Create a temporary table that will be used to return the output from this procedure  
            CREATE TABLE #AvailableResources
                (
                  ResourceId INT NULL ,
                  ResourceDisplay VARCHAR(100) NULL ,
                  ResourceSubType VARCHAR(100) NULL ,
                  GroupServiceId INT NULL ,
                  StaffName VARCHAR(100) NULL ,
                  ClosestStartTime TIME NULL ,
                  ClosestEndTime TIME NULL
                )  
   -- STEP   
   -- Grab the list of all resources that are available for the   
   -- @ResourceType , @StartTime , @EndTime and store these to   
   -- a temporary table  
    
   ;WITH AppointmentMaster_CTE
		AS ( SELECT AMR.ResourceId, AM.ServiceId, s.ClinicianId, pc.GroupCode
			 FROM   AppointmentMaster AM
					INNER JOIN AppointmentMasterResources AMR 
						ON AM.AppointmentMasterId = AMR.AppointmentMasterId
					LEFT JOIN dbo.Services s
						ON s.ServiceId = AM.ServiceId
					LEFT JOIN dbo.ProcedureCodes pc
						ON pc.ProcedureCodeId = s.ProcedureCodeId
			 WHERE  -- GlobalCodeID from GLOBALCODES for Category = SHOWTIMEAS & CodeName = Busy  
					AM.ShowTimeAs = 4342 
					AND ( ( AM.StartTime <= @StartDateTime
							AND @StartDateTime < AM.EndTime
						  )
						  OR ( @StartDateTime <= AM.StartTime
							   AND AM.StartTime < @EndDateTime
							 )
						)
					AND ISNULL(AM.recorddeleted, 'N') = 'N'
					AND ISNULL(AMR.recorddeleted, 'N') = 'N' )
					
            INSERT  INTO #AvailableResources
                    ( ResourceId ,
                      ResourceDisplay ,
                      ResourceSubType ,
                      GroupServiceId 
                    )
                    SELECT  RES.ResourceId ,
                            RES.DisplayAs ,
                            GSC.SubCodeName ,
                            am.ServiceId
                    FROM    Resources RES
                            INNER JOIN ResourceAvailability REA 
								ON RES.ResourceId = REA.ResourceId
                            LEFT OUTER JOIN GlobalSubCodes GSC 
								ON RES.ResourceSubType = GSC.GlobalSubCodeId --and GSC.GlobalCodeId=RES.Type  
							LEFT JOIN AppointmentMaster_CTE am
								ON am.ResourceId = RES.ResourceId
								AND ISNULL(am.GroupCode,'N') = 'Y'
								AND am.ClinicianId = @StaffId
                    WHERE   RES.ResourceType = @ResourceType
                            AND CONVERT(VARCHAR(10), REA.StartDate, 101) <= CONVERT(VARCHAR(10), @StartDateTime, 101)
                            AND ( CONVERT(VARCHAR(10), REA.EndDate, 101) >= CONVERT(VARCHAR(10), @EndDateTime, 101)
                                  OR REA.EndDate IS NULL
                                )
                            AND ISNULL(REA.recorddeleted, 'N') = 'N'
                            AND ISNULL(RES.recorddeleted, 'N') = 'N'
                            AND ISNULL(GSC.recorddeleted, 'N') = 'N'
                            AND ISNULL(RES.Active, 'Y') = 'Y'
                            AND NOT EXISTS ( SELECT 1 
												FROM	AppointmentMaster_CTE am2
												WHERE	am2.ResourceId = RES.ResourceId
														AND (ISNULL(am2.GroupCode,'N') = 'N'
															OR am2.ClinicianId <> @StaffId)
												)
              --              AND NOT EXISTS ( SELECT AMR.ResourceId
              --                               FROM   AppointmentMaster AM
              --                                      INNER JOIN AppointmentMasterResources AMR 
														--ON AM.AppointmentMasterId = AMR.AppointmentMasterId
              --                               WHERE  RES.ResourceId = AMR.ResourceId
              --                                      AND AM.ShowTimeAs = 4342 -- GlobalCodeID from GLOBALCODES for Category = SHOWTIMEAS & CodeName = Busy  
              --                                      AND ( ( AM.StartTime <= @StartDateTime
              --                                              AND @StartDateTime < AM.EndTime
              --                                            )
              --                                            OR ( @StartDateTime <= AM.StartTime
              --                                                 AND AM.StartTime < @EndDateTime
              --                                               )
              --                                          )
              --                                      AND ISNULL(AM.recorddeleted, 'N') = 'N'
              --                                      AND ISNULL(AMR.recorddeleted, 'N') = 'N' )  
   -- STEP   
   -- For the resource(s) that are available from previous step to check if    
   -- the any of these resource(s) also have other appointments during the  
   -- same DAY of the @StartTime for the @StaffId. For such resources, get the   
   -- closent appointment information and append this to the ResourceSubType AND ResourceDisplay  
            UPDATE  AR
            SET     AR.StaffName = Final.StaffName ,
                    ClosestStartTime = StartTime ,
                    ClosestEndTime = EndTime--,AR.ResourceSubType=Final.ResourceSubType  
            FROM    #AvailableResources AR
                    LEFT OUTER JOIN ( SELECT    Main.StaffName ,
                                                Main.ResourceId ,
                                                CAST(Main.StartTime AS TIME) AS StartTime ,
                                                CAST(Main.EndTime AS TIME) AS EndTime ,
                                                Main.ResourceSubType
                                      FROM      ( SELECT    SubRecord.StaffName ,
                                                            SubRecord.ResourceId ,
                                                            SubRecord.TimeDiff ,
                                                            SubRecord.StartTime ,
                                                            SubRecord.EndTime ,
                                                            SubRecord.ResourceSubType ,
                                                            ROW_NUMBER() OVER ( PARTITION BY SubRecord.ResourceId 
																				ORDER BY SubRecord.TimeDiff ASC ) AS RowCountNo
                                                  FROM      ( SELECT    S.LastName + ', ' + S.FirstName AS 'StaffName' ,
                                                                        AM.StartTime ,
                                                                        AM.EndTime ,
                                                                        CASE WHEN DATEDIFF(MINUTE, @StartDateTime, AM.StartTime) < 0 
																			THEN ( -1 ) * DATEDIFF(MINUTE, @StartDateTime, AM.StartTime)
                                                                             ELSE DATEDIFF(MINUTE, @StartDateTime, AM.StartTime)
                                                                        END 'TimeDiff' ,
                                                                        AR.ResourceId ,
                                                                        AR.ResourceSubType
                                                              FROM      #AvailableResources AR
                                                                        INNER JOIN AppointmentMasterResources AMR 
																			ON AR.ResourceId = AMR.ResourceId
                                                                        INNER JOIN AppointmentMaster AM 
																			ON AM.AppointmentMasterId = AMR.AppointmentMasterId
                                                                        INNER JOIN AppointmentMasterStaff AMS 
																			ON AM.AppointmentMasterId = AMS.AppointmentMasterId
                                                                        INNER JOIN Staff S ON S.StaffId = AMS.StaffId
                                                              WHERE     AMS.StaffId = @StaffId
                                                                        AND ISNULL(AMR.recorddeleted, 'N') = 'N'
                                                                        AND ISNULL(AM.recorddeleted, 'N') = 'N'
                                                                        AND ISNULL(AMS.recorddeleted, 'N') = 'N'
                                                                        AND ISNULL(S.recorddeleted, 'N') = 'N'
                                                                        AND CONVERT(VARCHAR(10), AM.StartTime, 101) 
																			= CONVERT(VARCHAR(10), @StartDateTime, 101)
															UNION
															 SELECT    S.LastName + ', ' + S.FirstName AS 'StaffName' ,
                                                                        AM.StartTime ,
                                                                        AM.EndTime ,
                                                                        CASE WHEN DATEDIFF(MINUTE, @StartDateTime, AM.StartTime) < 0 
																			THEN ( -1 ) * DATEDIFF(MINUTE, @StartDateTime, AM.StartTime)
                                                                             ELSE DATEDIFF(MINUTE, @StartDateTime, AM.StartTime)
                                                                        END 'TimeDiff' ,
                                                                        AR.ResourceId ,
                                                                        AR.ResourceSubType
                                                              FROM      #AvailableResources AR
                                                                        INNER JOIN AppointmentMasterResources AMR 
																			ON AR.ResourceId = AMR.ResourceId
                                                                        INNER JOIN AppointmentMaster AM 
																			ON AM.AppointmentMasterId = AMR.AppointmentMasterId
                                                                        INNER JOIN Appointments AMS 
																			ON AM.ServiceId = AMS.ServiceId
																			AND ISNULL(AMS.recorddeleted, 'N') = 'N'
                                                                        INNER JOIN Staff S ON S.StaffId = AMS.StaffId
																			AND ISNULL(S.recorddeleted, 'N') = 'N'
                                                              WHERE     AMS.StaffId = @StaffId
																		AND ISNULL(AMR.recorddeleted, 'N') = 'N'
                                                                        AND ISNULL(AM.recorddeleted, 'N') = 'N'
                                                                        AND CONVERT(VARCHAR(10), AM.StartTime, 101) 
																			= CONVERT(VARCHAR(10), @StartDateTime, 101)
                                                            ) SubRecord
                                                ) Main
                                      WHERE     Main.RowCountNo = 1
                                    ) Final ON AR.ResourceId = Final.ResourceId  


	--Group Service Label Update
	UPDATE AR
	SET AR.StaffName = '[Group] '+st.LastName+', '+st.FirstName ,
		AR.ClosestStartTime = CAST(s.DateOfService AS TIME) ,
		AR.ClosestEndTime = CAST(s.EndDateOfService AS TIME) 
	FROM #AvailableResources AR
	JOIN dbo.Services s ON AR.GroupServiceId = s.ServiceId
	JOIN Staff st ON st.StaffId = s.ClinicianId
	WHERE ar.GroupServiceId IS NOT NULL
   
       -- STEP   
       -- Finally  get the available resources returned  
      -- SELECT  ResourceId,  
      --ResourceDisplay  
      --,StaffName,ClosestStartTime,ClosestEndTime       
      -- FROM #AvailableResources  Order by ClosestStartTime Asc  
        
       -- Add the existing resources for the Service   
            INSERT  INTO #AvailableResources
                    ( ResourceId ,
                      ResourceDisplay ,
                      ResourceSubType
                    )
                    SELECT  RES.ResourceId ,
                            RES.DisplayAs ,
                            GSC.SubCodeName
                    FROM    Resources RES
                            LEFT OUTER JOIN GlobalSubCodes GSC 
								ON RES.ResourceSubType = GSC.GlobalSubCodeId --and GSC.GlobalCodeId=RES.Type               
                    WHERE   RES.ResourceType = @ResourceType
                            AND ISNULL(RES.recorddeleted, 'N') = 'N'
                            AND ISNULL(GSC.recorddeleted, 'N') = 'N'
                            AND ISNULL(RES.Active, 'Y') = 'Y'
                            AND EXISTS ( SELECT AMR.ResourceId
                                         FROM   AppointmentMaster AM
                                                INNER JOIN AppointmentMasterResources AMR 
													ON AM.AppointmentMasterId = AMR.AppointmentMasterId
                                         WHERE  AM.ServiceID = @ServiceID
                                                AND AMR.ResourceId = RES.ResourceId
                                                AND ISNULL(AMR.recorddeleted, 'N') = 'N'
                                                AND ISNULL(AM.recorddeleted, 'N') = 'N' )
                            AND NOT EXISTS ( SELECT ResourceId
                                             FROM   #AvailableResources AR
                                             WHERE  RES.ResourceId = AR.ResourceId )
         
         
            SELECT  ResourceId ,
                    CASE WHEN ISNULL(StaffName, 'N') = 'N' 
						THEN ResourceDisplay + ' (' + ISNULL(ResourceSubType, '') + ') '
                         ELSE 
							CASE WHEN ResourceSubType IS NULL 
								THEN ResourceDisplay + ' (' + StaffName + ' ' 
										+ ISNULL(CONVERT(VARCHAR, CAST(ClosestStartTime AS TIME), 100), '') 
										+ ' - ' + ISNULL(CONVERT(VARCHAR, CAST(ClosestEndTime AS TIME), 100), '') + ')'
                                   ELSE ResourceDisplay + ' (' + ISNULL(ResourceSubType, '') + ') ' 
										+ ' (' + StaffName + ' ' + ISNULL(CONVERT(VARCHAR, CAST(ClosestStartTime AS TIME), 100), '') 
										+ ' - ' + ISNULL(CONVERT(VARCHAR, CAST(ClosestEndTime AS TIME), 100), '') + ')'
                              END
                    END 'ResourceDisplay' ,
                    ClosestStartTime ,
                    ClosestEndTime ,
                    ResourceSubType
            FROM    (SELECT DISTINCT 
							ResourceId ,
							ResourceDisplay ,
							ResourceSubType ,
							StaffName ,
							ClosestStartTime ,
							ClosestEndTime
						FROM #AvailableResources ) x
            ORDER BY ResourceDisplay ASC  --03/Aug/2018   Ravi
             ,CASE WHEN ClosestStartTime IS NULL THEN 1
                          ELSE 0
                     END ,
                    ClosestStartTime    
       -- STEP   
       -- Before existing clean up  
            DROP TABLE  #AvailableResources        
         
        END TRY         
                                               
        BEGIN CATCH                                 
            DECLARE @Error VARCHAR(MAX)                                                                                  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetAvailableResources') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                                                                                                           
            RAISERROR                                                                                   
    (                                                 
  @Error, -- Message text.                                                                                  
  16, -- Severity.                                                                                  
  1 -- State.                                                                                  
    );              
        END CATCH                                                
         
    END
GO


