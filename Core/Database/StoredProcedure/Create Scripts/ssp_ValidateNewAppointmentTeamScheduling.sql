IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateNewAppointmentTeamScheduling]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateNewAppointmentTeamScheduling]
GO

 

/****** Object:  StoredProcedure [dbo].[ssp_ValidateNewAppointmentTeamScheduling]    Script Date: 07/06/2012 14:53:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_ValidateNewAppointmentTeamScheduling]     
 @ScreenId INT=NULL
AS    
/**************************************************************/                                                                                            
/* Stored Procedure: [ssp_ValidateNewAppointmentTeamScheduling]   */                                                                                   
/* Creation Date:  04-June-2012                                */                                                                                            
/* Purpose: To valiadate newly created services*/                                                                                           
/* Input Parameters:   @ServiceDate,@CurrentServiceId,@ClientId,@ClinicianId,@ServiceEndDate ,@ProcedureCodeId */                                                                                          
/* Output Parameters:            */                                                                                            
/* Return:               */                                                                                            
/* Called By: Core Team Scheduling Detail screen     */                                                                                  
/* Calls:                                                     */                                                                                            
/*                                                            */                                                                                            
/* Data Modifications:                                        */                                                                                            
/* Updates:                                                   */                                                                                            
/* Date			 Author		Purpose         */        
/* 04-June-2012  Davinderk	Created		To valiadate newly created services */ 
/* 07-June-2012  Davinderk	Created		Add EndDateOfService into table #tempNewAppointmentServices */  
/* 13-June-2012  Davinderk	updated		Add @status variable and check @Status in (70,71,75) in the where condition */ 
/* 13-June-2012  Davinderk	updated		Add new ServiceUnit,ServiceUnitType,Status into table #ServicesForValidate*/ 
/* 19-June-2012  Davinderk	updated		Check @Status in (70) in the where condition*/ 
/* 22-June-2012  Davinderk	updated		Check @CurrentServiceId < 0*/ 
/* 26-June-2012  Davinderk	updated		Removed the string 'Do you want to save this service?' from result*/
/* 18-Oct-2012   Maninder   updated     Added check for DateOfService!='00:00:000' Task#2122 Thresholds - Bugs/Features (Offshore)*/  
/* 19-Oct-2012   Maninder   updated     inserted services into #ValidateNewServices having DateOfService='00:00:000' so that they are treated as Services without error Task#2122 Thresholds - Bugs/Features (Offshore)*/  
/* 05-Aug-2014   Bernardin  Updated     Checking @ServiceDate instead of @DateOfService.So the validation will be skipped if the schedule time is 12:00 AM (as per Thresholds - Bugs/Features (Offshore) Task # 2122) 
                                        for the same staff and same client else will validate.*/  
/* 01-March-2017  vsinha	What:  Length of "Display As" to handle procedure code display as increasing to 75     
--							Why :  Keystone Customizations 69 
   07/31/2017    Hemant     What:Included the show check to prevent the user to save bad data.
                            Why: Philhaven-Support: #222 
/*
06/10/2017  Lakshmi      Implemented systemconfiguratione key to display Batch service validations, As part of Philhaven support #222.1
*/ 
*/
/**************************************************************/      
BEGIN    
---------------------
DECLARE @defaultTime as DateTime
SET @defaultTime=CONVERT(DateTime,'00:00:000')
--------------------
BEGIN TRY 
CREATE TABLE #ValidateNewServices(ServiceId int,ClientId int,result varchar(max))
   
 declare  @ServiceDate VARCHAR(500)
,@CurrentServiceId VARCHAR(500)
,@ClientId VARCHAR(500)
,@ClinicianId VARCHAR(500)
,@ServiceEndDate VARCHAR(500)
,@ProcedureCodeId VARCHAR(500) 
,@ServiceUnit VARCHAR(500)
,@ServiceUnitType VARCHAR(500)
,@Status VARCHAR(500)
--Create Table #tmpTable 
 
declare @UnitValue varchar(10)                       
declare @UnitType varchar(12)  
DECLARE @AppointmentType int 
DECLARE @Result VARCHAR(MAX)
DECLARE @StartTime DATETIME
DECLARE @EndTime DATETIME
declare @ServiceId int      
declare @DateOfService datetime      
--declare @ServiceUnit decimal(18, 2)      
--declare @ServiceUnitType int      
declare @ServiceProcedureCodeId int      
declare @StaffId int  
declare @PrimeryId int 
declare @ClinicianName varchar(100)  
declare @ProcedureName varchar(75)  --01-March-2017  vsinha
declare @GroupCode char(1)  
declare @AppointmentTypeName varchar(50)
set @Result = '' 

DECLARE @EnableDisablebatchservicevalidations varchar(200)
SELECT @EnableDisablebatchservicevalidations=Value FROM SystemConfigurationKeys WHERE [key] = 'ENABLEDISABLEBATCHSERVICEVALIDATIONS' AND ISNULL(RecordDeleted,'N')='N'  

DECLARE @ValidateCounter INT
SELECT @ValidateCounter=COUNT(*) FROM #ServicesForValidate
--SELECT @ValidateCounter  
DECLARE @StartValidateCounter int=1  
 
WHILE (@StartValidateCounter <= @ValidateCounter)
BEGIN
set @Result = '' 

	SELECT @ServiceDate=ServiceDate,@CurrentServiceId=CurrentServiceId,@ClientId=ClientId,@ClinicianId=ClinicianId,@ServiceEndDate=ServiceEndDate,@ProcedureCodeId=ProcedureCodeId,@ServiceUnit=ServiceUnit,@ServiceUnitType=ServiceUnitType,@Status=Status FROM #ServicesForValidate WHERE ID=@StartValidateCounter
  
		--SELECT @ServiceUnit=EnteredAs from ProcedureCodes where ProcedureCodeId=@ProcedureCodeId
		--SELECT @ServiceUnitType=GlobalCodeId from GlobalCodes where GlobalCodeId=@ServiceUnit
IF (@CurrentServiceId < 0)
BEGIN
		SELECT @StartTime=@ServiceDate,@EndTime=@ServiceEndDate, @AppointmentType=4761
		-- Modification starts here [Bernardin]		
		-- Checking @ServiceDate instead of @DateOfService.
		-- So the validation will be skipped if the schedule time is 12:00 AM (as per Thresholds - Bugs/Features (Offshore) Task # 2122) for the same staff and same client else will validate.

		--if( CONVERT(time(0), @defaultTime)<>CONVERT(time(0), @DateOfService)) -- Commentted (This condition is skipping for all scheduled time,because perameter @DateOfService declared but the values are not set)
		if( CONVERT(time(0), @defaultTime)<>CONVERT(time(0), @ServiceDate)) -- Modified
		-- Modification ends here [Bernardin]
		BEGIN
			INSERT INTO #tempNewAppointments (
			ServiceId,
			StaffId,
			AppointmentType)

			SELECT CurrentServiceId,
			ClinicianId,
			@AppointmentType 
			FROM #ServicesForValidate where ID=@StartValidateCounter

			INSERT INTO #tempNewAppointmentServices(ServiceId,
			ClientId,
			StaffId,
			AppointmentType,
			DateOfService,
			ServiceUnit,
			ServiceUnitType,
			ServiceProcedureCodeId,
			EndDateOfService)

			select TA.ServiceId,SI.ClientId,TA.StaffId,TA.AppointmentType,SI.ServiceDate,
			SI.ServiceUnit,SI.ServiceUnitType,SI.ProcedureCodeId,SI.ServiceEndDate from #tempNewAppointments TA
			INNER JOIN #ServicesForValidate SI ON SI.CurrentServiceId=TA.ServiceId


			WHERE (CAST(SI.ServiceDate as datetime) <= @ServiceDate and @ServiceDate < (CAST(SI.ServiceEndDate as datetime)) or (@ServiceDate <= CAST(SI.ServiceDate as datetime) and CAST(SI.ServiceDate as datetime) < @ServiceEndDate))                      
			and SI.ClientId = @ClientId AND  SI.Status in (70,71) 
			and SI.CurrentServiceId <> isnull(@CurrentServiceId, 0)  


			union      
			-- Services for staff      
			select TA.ServiceId,SI.ClientId,TA.StaffId,TA.AppointmentType,SI.ServiceDate,
			SI.ServiceUnit,SI.ServiceUnitType,SI.ProcedureCodeId,SI.ServiceEndDate from #tempNewAppointments TA
			INNER JOIN #ServicesForValidate SI ON SI.CurrentServiceId=TA.ServiceId      
			where (CAST(SI.ServiceDate as datetime) <= @ServiceDate and @ServiceDate < (CAST(SI.ServiceEndDate as datetime)) or (@ServiceDate <= CAST(SI.ServiceDate as datetime) and CAST(SI.ServiceDate as datetime) < @ServiceEndDate))                       
			and TA.StaffId = @ClinicianId AND  SI.Status in (70,71) 
			and SI.CurrentServiceId <> isnull(@CurrentServiceId, 0)      


			union      
			-- Non service appointments for staff      
			select null,      
			null,      
			TA.StaffId,      
			TA.AppointmentType,      
			null,      
			null,      
			null,      
			null,
			null      
			from #tempNewAppointments TA
			INNER JOIN #ServicesForValidate SI ON SI.CurrentServiceId=TA.ServiceId                      
			where (CAST(SI.ServiceDate as datetime) <= @ServiceDate and @ServiceDate < (CAST(SI.ServiceEndDate as datetime)) or (@ServiceDate <= CAST(SI.ServiceDate as datetime) and CAST(SI.ServiceDate as datetime) < @ServiceEndDate))                                           
			and TA.StaffId = @ClinicianId AND  SI.Status in (70,71)    
			and SI.CurrentServiceId is null      

			set @PrimeryId=0
			select top 1 
			   @PrimeryId=TAS.ID,  
			   @ServiceId = TAS.ServiceId,      
			   @DateOfService = TAS.DateOfService,      
			   @ServiceUnit = TAS.ServiceUnit,      
			   @ServiceUnitType = TAS.ServiceUnitType,      
			   @ServiceProcedureCodeId = TAS.ServiceProcedureCodeId,      
			   @StaffId = TAS.StaffId      
			from #tempNewAppointmentServices TAS       
			where TAS.ServiceId is not null       
			and TAS.ClientId = @ClientId      



			if @PrimeryId > 0  
			begin      
			select @ClinicianName = s.LastName + ', ' + s.FirstName from Staff s where s.StaffId = @StaffId      
			select @ProcedureName = pc.DisplayAs from ProcedureCodes pc where pc.ProcedureCodeId = @ServiceProcedureCodeId      
			select @UnitType = gc.CodeName from GlobalCodes gc where gc.GlobalCodeId = @ServiceUnitType      
			  IF((@ScreenId = 4012 AND @EnableDisablebatchservicevalidations='Y') OR @ScreenId != 4012 )
				BEGIN
			set @Result = 'Another service is scheduled for this client during this time. Clinician: ' +       
						@ClinicianName + ' at ' + cast(@DateOfService as varchar) + ' for ' + @ProcedureName + ' ' +       
						cast(@ServiceUnit as varchar) + ' ' + @UnitType + '.' 
			    END       
			  
			     
			end



			select @GroupCode = isnull(pc.GroupCode,'N') from ProcedureCodes pc where pc.ProcedureCodeId = @ProcedureCodeId                      
			    
			select top 1      
			   @PrimeryId = TAS.ID,      
			   @AppointmentType = TAS.AppointmentType      
			from #tempNewAppointmentServices TAS      
			   left join ProcedureCodes pc on pc.ProcedureCodeId = TAS.ServiceProcedureCodeId      
			where TAS.StaffId = @ClinicianId      
			and ((TAS.ServiceId is not null and (@GroupCode = 'N' or isnull(pc.GroupCode, 'N') = 'N')) or TAS.ServiceId is null)      
			  
			if @PrimeryId > 0   
			begin      
			select @ClinicianName = s.LastName + ', ' + s.FirstName from Staff s where s.StaffId = @ClinicianId      
			select @AppointmentTypeName = CodeName from GlobalCodes where GlobalCodeId = @AppointmentType                       
			if(@Result is null or @Result='')
				begin
				IF((@ScreenId = 4012 AND @EnableDisablebatchservicevalidations='Y') OR @ScreenId != 4012 )
				BEGIN
					set @Result = @ClinicianName + ' is busy during this time due to a ' + rtrim(@AppointmentTypeName) + '.'                              END
				end
			end 
			
			--INSERT RESULT INTO #ValidateNewServices	 
			 insert into #ValidateNewServices (ServiceId,ClientId,result)
			 select @CurrentServiceId,@ClientId,@Result  
		END	
		ELSE
		BEGIN --Services without error having time 12:00 am
			insert into #ValidateNewServices (ServiceId,ClientId,result)
			select @CurrentServiceId,@clientId,''
		END
	END		 
		 
		SET  @StartValidateCounter = @StartValidateCounter + 1
END
	
select * from #ValidateNewServices 

END TRY    
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                          
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ValidateNewAppointmentTeamScheduling')                                                                                                           
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
+ '*****' + Convert(varchar,ERROR_STATE())                                                        
RAISERROR                                                                                                           
(                                                                             
@Error, -- Message text.         
16, -- Severity.         
1 -- State.                                                           
);                                                                                                        
END CATCH     
END 
GO


