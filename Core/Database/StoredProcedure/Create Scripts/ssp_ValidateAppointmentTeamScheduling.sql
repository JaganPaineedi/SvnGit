
/****** Object:  StoredProcedure [dbo].[ssp_ValidateAppointmentTeamScheduling]    Script Date: 10/23/2012 11:15:19 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_ValidateAppointmentTeamScheduling]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_ValidateAppointmentTeamScheduling]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ValidateAppointmentTeamScheduling]    Script Date: 10/23/2012 11:15:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE PROCEDURE [dbo].[ssp_ValidateAppointmentTeamScheduling]
    @ServiceDate VARCHAR(MAX)   --VARCHAR(500)  
    ,
    @CurrentServiceId VARCHAR(MAX) ,
    @ClientId VARCHAR(MAX) ,
    @ClinicianId VARCHAR(MAX) ,
    @ServiceEndDate VARCHAR(MAX)  --VARCHAR(500)  
    ,
    @ProcedureCodeId VARCHAR(MAX) ,
    @ServiceUnit VARCHAR(MAX) ,
    @ServiceUnitType VARCHAR(MAX) ,
    @Status VARCHAR(MAX) ,
    @ServiceIdToIgnore VARCHAR(MAX) = NULL ,
    @ScreenId INT = NULL
AS /**************************************************************/                                                                                              
/* Stored Procedure: [ssp_ValidateAppointmentTeamScheduling]   */                                                                                     
/* Creation Date:  24-April-2012                                */                                                                                              
/* Purpose: To valiadate services for appointment      */                                                                                             
/* Input Parameters:   @ServiceDate,@CurrentServiceId,@ClientId,@ClinicianId,@ServiceEndDate ,@ProcedureCodeId */                                                                                            
/* Output Parameters:            */                                                                                              
/* Return:               */                                                                                              
/* Called By: Core Team Scheduling Detail screen     */                                                                                    
/* Calls:                                                     */                                                                                              
/*                                                            */                                                                                              
/* Data Modifications:                                        */                                                                                              
/* Updates:                                                   */                                                                                              
/* Date   Author  Purpose         */          
/* 24-April-2012  Davinderk Created  To valiadate services for appointment  */   
/* 08-May-2012   Davinderk Updated  Exec ssp_SCValidateAppointment */   
/* 15-May-2012   Davinderk Updated  Convert varchar to datetime @DateOfService @EndDateService datetime*/   
/* 05-june-2012   Davinderk Updated  Call ssp_ValidateNewAppointmentTeamScheduling - for validate appointments with newly created services */   
/* 12-june-2012   Davinderk Updated  Removed the redundancy from table while insering rows in table - #ValidateNewServices and stored the the rows in new table #FinalResult  */  
/* 13-june-2012   Davinderk Updated  Removed the table #FinalResult  */    
/* 13-June-2012  Davinderk updated  Add new ServiceUnit,ServiceUnitType,Status into table #ServicesForValidate*/   
/* 21-June-2012  Davinderk updated  Remove the check @CurrentServiceId > 0 from check ssp_SCValidateAppointment*/  
/* 21-June-2012  Davinderk updated  Added null check to IsNull(Result,'')*/  
/* 26-June-2012  Davinderk updated  Added the new parameter @FlagSaveService='Y' to ssp_SCValidateAppointment as per the task #1104 - Scheduling Validation*/  
/* 18Oct2012  Shifali Modified Check status in (70,71,75) before calling ssp 'ssp_SCValidateAppointment' as per ref task# 2107   
          - Thresholds Bugs/features (Team Scheduling - Cancel Appointment)*/  
/* 18-Oct-2012   Maninder   updated     Added check for DateOfService!='00:00:000' Task#2122 Thresholds - Bugs/Features (Offshore)*/     
/* 19-Oct-2012   Maninder   updated     inserted services into #ValidateNewServices having DateOfService='00:00:000' so that they are treated as Services without error Task#2122 Thresholds - Bugs/Features (Offshore)*/    
/* 19-Oct-2012   Maninder   updated     Added a new variable @ReturnValidateAppointmentIncreementer to keep track of new primary key in #ReturnValidateAppointment */    
/* 23-Oct-2012   Maninder   updated     Added parameter @ServiceIdToIgnore - which is passed to ssp_SCValidateAppointment so that cancelled services in session dataset are not validated against the saved service appontments */
/* Dec 17,2012	 Manjit Singh			What: Increased parameter size size.    */
/*										Why:  Resolve issue #811 of Threshold 3.5x Merged issues */
/* Nov 01,2013	Wasif Butt				Changed the list parameter from varchar(1000) to varchar(max) */
/*
06/10/2017  Lakshmi      Implemented systemconfiguratione key to display Batch service validations, As part of Philhaven support #222.1
11/05/2017  Hemant       Performance Improvement on Save.Philhaven-Support #282
01/11/2018	NJain		 Added scsp for custom logic. Boundless Support #52
*/ 
/**************************************************************/        
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
    SET nocount ON  
    BEGIN      
        BEGIN TRY      
            DECLARE @Counter INT ,
                @StartCounter INT  
            DECLARE @defaultTime AS DATETIME  
            SET @defaultTime = CONVERT(DATETIME, '00:00:000')  
--Create Table #tmpTable  
            IF OBJECT_ID('tempdb..#tmpTable') IS NOT NULL
                DROP TABLE #tmpTable  
            CREATE TABLE #tmpTable
                (
                  ID INT IDENTITY ,
                  items VARCHAR(100)
                )  
   
            IF OBJECT_ID('tempdb..#ReturnValidateAppointment') IS NOT NULL
                DROP TABLE #ReturnValidateAppointment   
            CREATE TABLE #ReturnValidateAppointment
                (
                  ID INT IDENTITY ,
                  result VARCHAR(MAX)
                )  
   
            IF OBJECT_ID('tempdb..#ServicesForValidate') IS NOT NULL
                DROP TABLE #ServicesForValidate    
            CREATE TABLE #ServicesForValidate
                (
                  ID INT IDENTITY ,
                  ServiceDate VARCHAR(500) ,
                  CurrentServiceId VARCHAR(500) ,
                  ClientId VARCHAR(500) ,
                  ClinicianId VARCHAR(500) ,
                  ServiceEndDate VARCHAR(500) ,
                  ProcedureCodeId VARCHAR(500) ,
                  ServiceUnit VARCHAR(500) ,
                  ServiceUnitType VARCHAR(500) ,
                  Status VARCHAR(500)
                )    
   
   
            IF OBJECT_ID('tempdb..#tempNewAppointmentServices') IS NOT NULL
                DROP TABLE #tempNewAppointmentServices   
            CREATE TABLE #tempNewAppointmentServices
                (
                  ID INT IDENTITY ,
                  ServiceId INT ,
                  ClientId INT ,
                  StaffId INT ,
                  AppointmentType INT ,
                  DateOfService DATETIME ,
                  ServiceUnit DECIMAL(18, 2) ,
                  ServiceUnitType INT ,
                  ServiceProcedureCodeId VARCHAR(500) ,
                  EndDateOfService DATETIME
                )   
  
            IF OBJECT_ID('tempdb..#tempNewAppointments') IS NOT NULL
                DROP TABLE #tempNewAppointments  
            CREATE TABLE #tempNewAppointments
                (
                  ID INT IDENTITY ,
                  ServiceId INT ,
                  StaffId INT ,
                  AppointmentType INT
                )  
   
            IF OBJECT_ID('tempdb..#ValidateAppointments') IS NOT NULL
                DROP TABLE #ValidateAppointments  
            CREATE TABLE #ValidateAppointments
                (
                  ID INT IDENTITY ,
                  ServiceId INT ,
                  ClientId INT ,
                  result VARCHAR(500)
                )  
    
            IF OBJECT_ID('tempdb..#ValidateNewServices') IS NOT NULL
                DROP TABLE #ValidateNewServices  
            CREATE TABLE #ValidateNewServices
                (
                  PRIMERYID INT IDENTITY ,
                  ServiceId INT ,
                  ClientId INT ,
                  result VARCHAR(MAX)
                )  
   
--IF OBJECT_ID('tempdb..#FinalResult') IS NOT NULL      
 --DROP TABLE #FinalResult  
 --CREATE TABLE #FinalResult(ID INT Identity,ServiceId int,ClientId int, result VARCHAR(500))   
   
--INSERT into #ServicesForValidate  
            INSERT  INTO #ServicesForValidate
                    ( ClientId
                    )
                    SELECT  *
                    FROM    fnSplit(@ClientId, ',')    
  
  
--For @ServiceDate  
  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@ServiceDate, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     ServiceDate = ( SELECT  items
                                            FROM    #tmpTable
                                            WHERE   ID = @StartCounter
                                          )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END    
  
--For @CurrentServiceId  
  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@CurrentServiceId, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     CurrentServiceId = ( SELECT items
                                                 FROM   #tmpTable
                                                 WHERE  ID = @StartCounter
                                               )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END   
  
  
--For @ClientId  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@ClientId, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     ClientId = ( SELECT items
                                         FROM   #tmpTable
                                         WHERE  ID = @StartCounter
                                       )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END   
  
--For @ClinicianId  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@ClinicianId, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     ClinicianId = ( SELECT  items
                                            FROM    #tmpTable
                                            WHERE   ID = @StartCounter
                                          )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END    
  
  
--For @ServiceEndDate  
            TRUNCATE TABLE #tmpTable  
            SET IDENTITY_INSERT [#tmpTable] ON  
            INSERT  INTO #tmpTable
                    ( ID ,
                      items
                    )
                    SELECT  *
                    FROM    SplitString(@ServiceEndDate, ',')   
            SET IDENTITY_INSERT [#tmpTable] OFF  
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     ServiceEndDate = ( SELECT   items
                                               FROM     #tmpTable
                                               WHERE    ID = @StartCounter
                                             )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END   
  
--For @ProcedureCodeId  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@ProcedureCodeId, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     ProcedureCodeId = ( SELECT  items
                                                FROM    #tmpTable
                                                WHERE   ID = @StartCounter
                                              )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END   
   
  
--For @ServiceUnit  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@ServiceUnit, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     ServiceUnit = ( SELECT  items
                                            FROM    #tmpTable
                                            WHERE   ID = @StartCounter
                                          )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END   
   
--For @ServiceUnitType  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@ServiceUnitType, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     ServiceUnitType = ( SELECT  items
                                                FROM    #tmpTable
                                                WHERE   ID = @StartCounter
                                              )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END    
   
   
--For @Status  
            TRUNCATE TABLE #tmpTable  
            INSERT  INTO #tmpTable
                    SELECT  *
                    FROM    fnSplit(@Status, ',')   
  
            SELECT  @Counter = COUNT(*)
            FROM    #tmpTable  
            SET @StartCounter = 1  
            WHILE ( @StartCounter <= @Counter )
                BEGIN    
                    UPDATE  #ServicesForValidate
                    SET     Status = ( SELECT   items
                                       FROM     #tmpTable
                                       WHERE    ID = @StartCounter
                                     )
                    WHERE   ID = @StartCounter  
                    SET @StartCounter = @StartCounter + 1  
                END        
  
--SELECT * FROM #ServicesForValidate  
  
  
            DECLARE @ValidateCounter INT  
            SELECT  @ValidateCounter = COUNT(*)
            FROM    #ServicesForValidate  
--SELECT @ValidateCounter    
            DECLARE @StartValidateCounter INT= 1  
            DECLARE @DateOfService DATETIME  
            DECLARE @EndDateService DATETIME  
            DECLARE @Result VARCHAR(MAX)  
            DECLARE @UnitValue VARCHAR(10)                         
            DECLARE @UnitType VARCHAR(12)    
            DECLARE @AppointmentType INT   
   
            DECLARE @StartTime DATETIME  
            DECLARE @EndTime DATETIME  
            DECLARE @ServiceId INT        
         
--declare @ServiceUnit decimal(18, 2)        
--declare @ServiceUnitType int        
            DECLARE @ServiceProcedureCodeId INT        
            DECLARE @StaffId INT    
            DECLARE @PrimeryId INT   
            DECLARE @ClinicianName VARCHAR(100)    
            DECLARE @ProcedureName VARCHAR(20)   
            DECLARE @GroupCode CHAR(1)    
            DECLARE @AppointmentTypeName VARCHAR(50)  
   
            SET @Result = ''   
  
            DECLARE @ReturnValidateAppointmentIncreementer AS INT  
            SET @ReturnValidateAppointmentIncreementer = 1  
  
            WHILE ( @StartValidateCounter <= @ValidateCounter )
                BEGIN   
  
                    SELECT  @ServiceDate = ServiceDate ,
                            @CurrentServiceId = CurrentServiceId ,
                            @ClientId = ClientId ,
                            @ClinicianId = ClinicianId ,
                            @ServiceEndDate = ServiceEndDate ,
                            @ProcedureCodeId = ProcedureCodeId ,
                            @ServiceUnit = ServiceUnit ,
                            @ServiceUnitType = ServiceUnitType ,
                            @Status = Status
                    FROM    #ServicesForValidate
                    WHERE   ID = @StartValidateCounter   
                    SET @DateOfService = CAST(@ServiceDate AS DATETIME)  
                    SET @EndDateService = CAST(@ServiceEndDate AS DATETIME)  
     
                    IF ( @Status IN ( 70, 71, 75 ) )
                        BEGIN  
   --print @DateOfService  
   --print  @EndDateService  
                            IF ( CONVERT(TIME(0), @defaultTime) <> CONVERT(TIME(0), @DateOfService) )
                                BEGIN  
        
                                    INSERT  INTO #ReturnValidateAppointment  
    
   --Call ssp_SCValidateAppointment - for validate appointments  
   --passed parameter @ServiceIdToIgnore
                                            EXEC ssp_SCValidateAppointment @DateOfService, @CurrentServiceId, @ClientId, @ClinicianId, @EndDateService, @ProcedureCodeId, 'Y', @ServiceIdToIgnore, @ScreenId
     
    
   --delete from #ReturnValidateAppointment where (result='' or result is null) and  ID=@StartValidateCounter  
     
   --select @Result=isnull(result,'') from #ReturnValidateAppointment where ID=@StartValidateCounter  
      
   --if(@Result <> '' and @Result is not null)  
   --BEGIN  
                                    INSERT  INTO #ValidateAppointments
                                            ( ServiceId ,
                                              ClientId ,
                                              result
                                            )  
    --select @CurrentServiceId,@clientId,IsNull(Result,'') FROM  #ReturnValidateAppointment  where ID=@StartValidateCounter  
                                            SELECT  @CurrentServiceId ,
                                                    @clientId ,
                                                    ISNULL(Result, '')
                                            FROM    #ReturnValidateAppointment
                                            WHERE   ID = @ReturnValidateAppointmentIncreementer  
      
                                    SET @ReturnValidateAppointmentIncreementer = @ReturnValidateAppointmentIncreementer + 1  
   --END  
                                END  
                            ELSE
                                BEGIN --Services without error having time 12:00 am  
                                    INSERT  INTO #ValidateAppointments
                                            ( ServiceId ,
                                              ClientId ,
                                              result
                                            )
                                            SELECT  @CurrentServiceId ,
                                                    @clientId ,
                                                    ''  
                                END  
                        END  
                    SET @StartValidateCounter = @StartValidateCounter + 1   
    
                END    
   
 --SELECT ServiceId,ClientId,result from #ValidateAppointments group by ServiceId,ClientId,result  
   
            INSERT  INTO #ValidateNewServices  
   
 --Call ssp_ValidateNewAppointmentTeamScheduling - for validate appointments with newly created services  
                    EXEC ssp_ValidateNewAppointmentTeamScheduling @ScreenId 
   
--Below code is used to combine tow tables result into one table - #ValidateNewServices  
            DECLARE @TotalCountRows INT= 0  
            SELECT  @TotalCountRows = COUNT(*)
            FROM    #ValidateAppointments   
            DECLARE @CountCounter INT= 1  
            WHILE ( @CountCounter <= @TotalCountRows )
                BEGIN  
                    INSERT  INTO #ValidateNewServices
                            SELECT  ServiceId ,
                                    ClientId ,
                                    ISNULL(Result, '')
                            FROM    #ValidateAppointments
                            WHERE   ID = @CountCounter  
                    SET @CountCounter = @CountCounter + 1    
                END  
   
            DELETE  VNS1
            FROM    #ValidateNewServices VNS
                    INNER JOIN ( SELECT *
                                 FROM   #ValidateNewServices
                                 WHERE  result = ''
                               ) VNS1 ON VNS.ServiceId = VNS1.ServiceId
                                         AND VNS.result <> ''  
   
   
            DECLARE @Result1 VARCHAR(MAX)  
            DECLARE @FinalTotalCountRows INT= 0 ,
                @PId INT= 0  
            SELECT  @TotalCountRows = COUNT(*)
            FROM    #ValidateNewServices  
   
            SELECT TOP 1
                    @PId = PRIMERYID
            FROM    #ValidateNewServices
            ORDER BY PRIMERYID  
  
            WHILE ( @FinalTotalCountRows <= ( SELECT    COUNT(*)
                                              FROM      #ValidateNewServices
                                            ) )
                BEGIN  
                    SELECT  @CurrentServiceId = ServiceId ,
                            @ClientId = ClientId ,
                            @Result1 = result
                    FROM    #ValidateNewServices
                    WHERE   PRIMERYID = @PId  
    
                    DELETE  FROM #ValidateNewServices
                    WHERE   ServiceId = @CurrentServiceId
                            AND ClientId = @ClientId
                            AND result = @Result1
                            AND PRIMERYID <> @PId  
    
                    SELECT TOP 1
                            @PId = PRIMERYID
                    FROM    #ValidateNewServices
                    WHERE   PRIMERYID > @PId
                    ORDER BY PRIMERYID  
    
                    SET @FinalTotalCountRows = @FinalTotalCountRows + 1  
                END  
			
			
			-- scsp
            IF EXISTS ( SELECT  *
                        FROM    sys.procedures
                        WHERE   NAME = 'scsp_ValidateAppointmentTeamScheduling' )
                BEGIN 
			
                    EXEC scsp_ValidateAppointmentTeamScheduling @ServiceDate, @CurrentServiceId, @ClientId, @ClinicianId, @ServiceEndDate   --VARCHAR(500)  
                        , @ProcedureCodeId, @ServiceUnit, @ServiceUnitType, @Status, @ServiceIdToIgnore = NULL, @ScreenId = NULL
			
                END
			
            SELECT  *
            FROM    #ValidateNewServices   
   
 --select * from #ValidateNewServices  
   
--DECLARE @FinalTotalCountRows INT=0  
--SELECT @TotalCountRows=COUNT(*) FROM #ValidateNewServices   
   
--DECLARE @FinalCountCounter int=1  
  
--SELECT @FinalTotalCountRows=COUNT(*) FROM #ValidateNewServices   
  
--DECLARE @Result1 varchar(MAX)    
  
--WHILE (@FinalCountCounter <= @FinalTotalCountRows)  
--BEGIN  
  
-- SELECT @CurrentServiceId=ServiceId,@ClientId=ClientId,@Result1=result FROM #ValidateNewServices WHERE PRIMERYID=@FinalCountCounter  
   
-- if not exists(select ServiceId,ClientId,Result from #FinalResult   
-- where ServiceId=@CurrentServiceId and ClientId=@ClientId and result=@Result1)  
   
-- BEGIN  
--   insert into #FinalResult  
--   select ServiceId,ClientId,Result from #ValidateNewServices where PRIMERYID=@FinalCountCounter   
-- END  
   
-- SET  @FinalCountCounter = @FinalCountCounter + 1  
   
   
--END  
  
--select * from #FinalResult  
   
   
  
  
        END TRY      
        BEGIN CATCH                                  
            DECLARE @Error VARCHAR(8000)                                                                            
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ValidateAppointmentTeamScheduling') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                          
            RAISERROR                                                                                                             
(                                                                               
@Error, -- Message text.           
16, -- Severity.           
1 -- State.                                                             
);                                                                                                          
        END CATCH       
    END   
  
  
  
  
GO


