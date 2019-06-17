 
/****** Object:  StoredProcedure [dbo].[ssp_SCValidateAppointment]    Script Date: 07/06/2012 15:20:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateAppointment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateAppointment]
GO

 

/****** Object:  StoredProcedure [dbo].[ssp_SCValidateAppointment]    Script Date: 07/06/2012 15:20:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_SCValidateAppointment]      
@ServiceDate datetime,                      
@CurrentServiceId int,                       
@ClientId int,                      
@ClinicianId int,                      
@ServiceEndDate  datetime = null,                      
@ProcedureCodeId int,
@FlagSaveService char(1),
@ServiceIdToIgnore varchar(MAX) =null,  
@ScreenId INT=NULL            
/********************************************************************************          
-- Stored Procedure: dbo.ssp_SCValidateAppointment          
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: validates appointment        
--          
-- Updates:          
-- Date        Author      Purpose       
-- 09.24.2006  Raman       Created      
-- 09.17.2006  Atul Guptal Modified      
-- 12.12.2007  Vikas Vyas  Modified      
-- 06.02.2008  SRF         Modified overlapping client servcie message      
-- 10.27.2010  SFarber     Redesigned to improve performance.    
-- 03.25.2011  dharvey	   Added check to exclude Parent Appoint record for recurring appointments.  
-- 06.08.2012  Davinderk   Cheek the ISNULL value in where condtion "and (ISNULL(a.RecurringAppointment,'N') = 'N' 
		or (ISNULL(a.RecurringAppointment,'N') = 'Y'" for the check validate appointment for team scheduling   
-- 26.06.2012  Davinderk   Added the new parameter @FlagSaveService as per the task #1104 - Scheduling Validation to OmitQuestion from the return result        -- 25Sept2012  Shifali		Modified - Validation Message	   being returned formatted properly for white spaces in b/w, ref task# 493 (Threshold 3.5xMerged Issues)
-- 23.10.2012  Maninder    Added the new parameter @ServiceIdToIgnore as per the task #2107 -Team Scheduling - Cancel Appointment -(Threshold 3.5xMerged Issues)
-- 15.01.2013  Rakesh-II    Only recommitting this ssp as it was not delivered updated for Newaygo & Centra.   
-- Nov 01,2013	Wasif Butt	Changed the parameter @ServiceIdToIgnore from varchar(500) to varchar(max)
-- March 01 2017  vsinha	What:  Length of "Display As" to handle procedure code display as increasing to 75     
--							Why :  Keystone Customizations 69  
-- March 10 2017  PradeepT  What:Prevent to scheduling a service on the day when All day appointment has already been schedule on that day.
--                          Why: Renaissance - Environment Issues Tracking-#26	
/*
06/10/2017  Lakshmi      Implemented systemconfiguratione key to display Batch service validations, As part of Philhaven support #222.1
11/05/2017  Hemant       Performance Improvement on Save.Philhaven-Support #282
08/21/2018  Bibhu        Calling scsp_SCValidateAppointment.CEI-Support Go Live #1016
*/   
 *********************************************************************************/                                                      
AS 
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
   set nocount on     
 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
BEGIN
 BEGIN TRY         
declare @AppointmentId int      
declare @ServiceId int      
declare @DateOfService datetime      
declare @ServiceUnit decimal(18, 2)      
declare @ServiceUnitType int      
declare @ServiceProcedureCodeId int      
declare @StaffId int      
declare @AppointmentType int                      
declare @ClinicianName varchar(100)    
declare @StaffName varchar(100)                  
declare @AppointmentTypeName varchar(50)                      
declare @UnitValue varchar(10)                       
declare @UnitType varchar(12)       
declare @ProcedureName varchar(75)       -- March 01 2017  vsinha              
declare @GroupCode char(1)                      
--Added by vishant to implement message code functionality   
declare @Result nvarchar(max)              
--declare @Result varchar(200)                       

if(@FlagSaveService='y' or @FlagSaveService='Y')
	begin
		set @FlagSaveService='Y'
	end      
set @Result = ''                      

DECLARE @EnableDisablebatchservicevalidations varchar(200)
SELECT @EnableDisablebatchservicevalidations=Value FROM SystemConfigurationKeys WHERE [key] = 'ENABLEDISABLEBATCHSERVICEVALIDATIONS' AND ISNULL(RecordDeleted,'N')='N'   
      
declare @Appointments table (      
AppointmentId          int,       
ServiceId              int,      
ClientId               int,       
StaffId                int,      
AppointmentType        int,      
DateOfService          datetime,      
ServiceUnit            decimal(18, 2),      
ServiceUnitType        int,      
ServiceProcedureCodeId int)      
      
insert into @Appointments (      
       AppointmentId,       
       ServiceId,      
       ClientId,      
       StaffId,      
       AppointmentType,      
       DateOfService,      
       ServiceUnit,      
       ServiceUnitType,      
       ServiceProcedureCodeId)      
-- Services for client      
select a.AppointmentId,      
       a.ServiceId,      
       s.ClientId,      
       a.StaffId,      
       a.AppointmentType,      
       s.DateOfService,      
       s.Unit,      
       s.UnitType,      
       s.ProcedureCodeId      
  from Appointments a
       join Services s on s.ServiceId = a.ServiceId      
 where ((a.StartTime <= @ServiceDate and @ServiceDate < EndTime) or (@ServiceDate <= a.StartTime and a.StartTime < @ServiceEndDate))                      
   and s.ClientId = @ClientId  
   -- Exclude Appointment record for Parent Recurring Appointments - DJH
   and (ISNULL(a.RecurringAppointment,'N') = 'N' 
		or (ISNULL(a.RecurringAppointment,'N') = 'Y' 
			and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
			) 
		)    
   and a.ShowTimeAs in (4342, 4344) -- Busy, Out of Office      
   and s.ServiceId <> isnull(@CurrentServiceId, 0)                      
   and s.Status in (70,71,75)      
   and isnull(a.RecordDeleted,'N') = 'N'                 
   and isnull(s.Recorddeleted, 'N') = 'N'                               
union      
-- Services for staff      
select a.AppointmentId,      
       a.ServiceId,      
       s.ClientId,      
       a.StaffId,      
       a.AppointmentType,      
       s.DateOfService,      
       s.Unit,      
       s.UnitType,      
       s.ProcedureCodeId      
  from Appointments a                      
       join Services s on s.ServiceId = a.ServiceId      
 where ((a.StartTime <= @ServiceDate and @ServiceDate < EndTime) or (@ServiceDate <= a.StartTime and a.StartTime < @ServiceEndDate))                      
   and a.StaffId = @ClinicianId    
   -- Exclude Appointment record for Parent Recurring Appointments - DJH
   and (ISNULL(a.RecurringAppointment,'N') = 'N' 
		or (ISNULL(a.RecurringAppointment,'N') = 'Y' 
			and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
			) 
		)  
   and a.ShowTimeAs in (4342, 4344)      
   and s.ServiceId <> isnull(@CurrentServiceId, 0)      
   and s.Status in (70,71,75)      
   and isnull(a.RecordDeleted,'N') = 'N'                 
   and isnull(s.Recorddeleted, 'N') = 'N'                               
union      
-- Non service appointments for staff      
select a.AppointmentId,      
       null,      
       null,      
  a.StaffId,      
       a.AppointmentType,      
       null,      
       null,      
       null,      
       null      
  from Appointments a                      
 where ((a.StartTime <= @ServiceDate and @ServiceDate < EndTime) or (@ServiceDate <= a.StartTime and a.StartTime < @ServiceEndDate))  
   -- Exclude Appointment record for Parent Recurring Appointments - DJH
   and (ISNULL(a.RecurringAppointment,'N') = 'N' 
		or (ISNULL(a.RecurringAppointment,'N') = 'Y' 
			and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
			) 
		)                   
   and a.ShowTimeAs in (4342, 4344)      
   and a.StaffId = @ClinicianId      
   and a.Serviceid is null      
   and isnull(a.RecordDeleted,'N') = 'N' 
   -- Non service appointments for staff for All day appointment March 10 2017  PradeepT 
  UNION    
select a.AppointmentId,      
       null,      
       null,      
       a.StaffId,      
       a.AppointmentType,      
       null,      
       null,      
       null,      
       null      
  from Appointments a                      
 where a.StartTime=a.EndTime
 AND Cast(StartTime AS DATE) = CAST(@ServiceDate AS Date)
 
   -- Exclude Appointment record for Parent Recurring Appointments - DJH
   and (ISNULL(a.RecurringAppointment,'N') = 'N' 
		or (ISNULL(a.RecurringAppointment,'N') = 'Y' 
			and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
			) 
		)                   
   and a.ShowTimeAs in (4342, 4344)      
   and a.StaffId = @ClinicianId      
   and a.Serviceid is null      
   and isnull(a.RecordDeleted,'N') = 'N'               
      
if @@rowcount = 0 goto result  

 ---------New Code Added to Ignore services validation--------
 -------- Deleting appointments from @Appointments so that validation does not appear for @IgnoredServices------------
declare @IgnoredServices table (        
ServiceId          int)


insert into @IgnoredServices(ServiceId)
select * from fnSplit(@ServiceIdToIgnore,',') 

delete from @Appointments  where ServiceId in (select b.ServiceId from @IgnoredServices b )
-----------ENDS--------------------------------------------------      


select top 1      
       @AppointmentId = a.AppointmentId,      
       @ServiceId = a.ServiceId,      
       @DateOfService = a.DateOfService,      
       @ServiceUnit = a.ServiceUnit,      
       @ServiceUnitType = a.ServiceUnitType,      
       @ServiceProcedureCodeId = a.ServiceProcedureCodeId,      
       @StaffId = a.StaffId      
  from @Appointments a       
 where a.ServiceId is not null       
   and a.ClientId = @ClientId and a.ServiceId > 0        
      
if @AppointmentId is not null      
begin      
  select @StaffName = s.LastName + ', ' + s.FirstName from Staff s where s.StaffId = @StaffId      
  select @ClinicianName = s.LastName + ', ' + s.FirstName from Staff s where s.StaffId = @ClinicianId       
  select @ProcedureName = pc.DisplayAs from ProcedureCodes pc where pc.ProcedureCodeId = @ServiceProcedureCodeId      
  select @UnitType = gc.CodeName from GlobalCodes gc where gc.GlobalCodeId = @ServiceUnitType      
      
  IF (@FlagSaveService='Y')
	  BEGIN
	
	  --Added by vishant to implement message code functionality
	  IF((@ScreenId = 4012 AND @EnableDisablebatchservicevalidations='Y') OR @ScreenId != 4012 )
				BEGIN
				IF EXISTS (SELECT * FROM   sys.objects WHERE  object_id = Object_id(N'[dbo].[scsp_SCValidateAppointment]' ) 
				AND type IN ( N'P', N'PC' )) 
BEGIN 
EXEC scsp_SCValidateAppointment   @ClinicianId,@ScreenId,@StaffName,@EnableDisablebatchservicevalidations,@DateOfService, @ClinicianName ,@ProcedureName,1,@FlagSaveService, @Result= @Result OUTPUT
END 

ELSE
BEGIN

	  select @Result = dbo.Ssf_GetMesageByMessageCode(207,'ANOTHERSERVICESCHEDULED_SSP','Another service is scheduled for this client during this time. Clinician: ') +       
						@StaffName + dbo.Ssf_GetMesageByMessageCode(207,'AT_SSP',' at ') + cast(@DateOfService as varchar) + dbo.Ssf_GetMesageByMessageCode(29,'FOR_SSP',' for ') + @ProcedureName + ' ' +       
						cast(@ServiceUnit as varchar) + ' ' + @UnitType + '.' 
		  --set @Result = 'Another service is scheduled for this client during this time. Clinician: ' +       
				--		@ClinicianName + ' at ' + cast(@DateOfService as varchar) + ' for ' + @ProcedureName + ' ' +       
				--		cast(@ServiceUnit as varchar) + ' ' + @UnitType + '.'       
				END 
				
				END
	  END
  ELSE 
	  BEGIN
	  IF EXISTS (SELECT * FROM   sys.objects WHERE  object_id = Object_id(N'[dbo].[scsp_SCValidateAppointment]' ) 
				AND type IN ( N'P', N'PC' )) 
BEGIN 

EXEC scsp_SCValidateAppointment   @ClinicianId,@ScreenId,@StaffName,@EnableDisablebatchservicevalidations,@DateOfService, @ClinicianName ,@ProcedureName,1,@FlagSaveService, @Result= @Result OUTPUT
END 
ELSE
BEGIN
	
	  --Added by vishant to implement message code functionality
	  select @Result = dbo.Ssf_GetMesageByMessageCode(207,'ANOTHERSERVICESCHEDULED_SSP','Another service is scheduled for this client during this time. Clinician: ') +       
						@StaffName + dbo.Ssf_GetMesageByMessageCode(207,'AT_SSP',' at ')  + cast(@DateOfService as varchar) + dbo.Ssf_GetMesageByMessageCode(29,'FOR_SSP',' for ') + @ProcedureName + ' ' +       
						cast(@ServiceUnit as varchar) + ' ' + @UnitType + dbo.Ssf_GetMesageByMessageCode(207,'DOTDOYOUWANTSAVESERVICE_SSP','. Do you want to save this service?')        
		  --set @Result = 'Another service is scheduled for this client during this time. Clinician: ' +       
				--		@ClinicianName + ' at ' + cast(@DateOfService as varchar) + ' for ' + @ProcedureName + ' ' +       
				--		cast(@ServiceUnit as varchar) + ' ' + @UnitType + '. Do you want to save this service?'        
	  END    
 END     
  goto result      
end                
            
-- GroupCode for service that is being validated                      
select @GroupCode = isnull(pc.GroupCode,'N') from ProcedureCodes pc where pc.ProcedureCodeId = @ProcedureCodeId                      
        
select top 1      
       @AppointmentId = a.AppointmentId,      
       @AppointmentType = a.AppointmentType,      
       @ServiceId = a.ServiceId,      
       @DateOfService = a.DateOfService,      
       @ServiceUnit = a.ServiceUnit,      
       @ServiceUnitType = a.ServiceUnitType,      
       @ServiceProcedureCodeId = a.ServiceProcedureCodeId,      
       @StaffId = a.StaffId      
  from @Appointments a      
       left join ProcedureCodes pc on pc.ProcedureCodeId = a.ServiceProcedureCodeId      
 where a.StaffId = @ClinicianId      
   and ((a.ServiceId is not null and (@GroupCode = 'N' or isnull(pc.GroupCode, 'N') = 'N')) or a.ServiceId is null)      
      
if @AppointmentId is not null      
begin   
  select @StaffName = s.LastName + ', ' + s.FirstName from Staff s where s.StaffId = @StaffId   
  select @ClinicianName = s.LastName + ', ' + s.FirstName from Staff s where s.StaffId = @ClinicianId      
  select @AppointmentTypeName = CodeName from GlobalCodes where GlobalCodeId = @AppointmentType    
  select @ProcedureName = pc.DisplayAs from ProcedureCodes pc where pc.ProcedureCodeId = @ServiceProcedureCodeId      
  select @UnitType = gc.CodeName from GlobalCodes gc where gc.GlobalCodeId = @ServiceUnitType
                     
  IF (@FlagSaveService='Y')
	  BEGIN
	  IF((@ScreenId = 4012 AND @EnableDisablebatchservicevalidations='Y') OR @ScreenId != 4012 )
		BEGIN
		IF EXISTS (SELECT * FROM   sys.objects WHERE  object_id = Object_id(N'[dbo].[scsp_SCValidateAppointment]' ) 
				AND type IN ( N'P', N'PC' )) 
BEGIN 
EXEC scsp_SCValidateAppointment  @ClinicianId,@ScreenId,@StaffName,@EnableDisablebatchservicevalidations,@DateOfService, @ClinicianName ,@ProcedureName,2,@FlagSaveService,@Result= @Result OUTPUT
END 
ELSE
BEGIN
		--Added by vishant to implement message code functionality
		select @Result = @ClinicianName + dbo.Ssf_GetMesageByMessageCode(207,'ISBUSYDURING_SSP',' is busy during this time due to a ') + rtrim(@AppointmentTypeName) + '.'                      
		--set @Result = @ClinicianName + ' is busy during this time due to a ' + rtrim(@AppointmentTypeName) + '.'
		END
		END
		
  ELSE 
	  BEGIN
	IF EXISTS (SELECT * FROM   sys.objects WHERE  object_id = Object_id(N'[dbo].[scsp_SCValidateAppointment]' ) 
				AND type IN ( N'P', N'PC' )) 
BEGIN 
EXEC scsp_SCValidateAppointment  @ClinicianId,@ScreenId,@StaffName,@EnableDisablebatchservicevalidations,@DateOfService, @ClinicianName ,@ProcedureName,2,@FlagSaveService,@Result= @Result OUTPUT
END 
ELSE
BEGIN
		--Added by vishant to implement message code functionality
		select @Result = @ClinicianName + dbo.Ssf_GetMesageByMessageCode(207,'ISBUSYDURING_SSP',' is busy during this time due to a ')   + rtrim(@AppointmentTypeName) + dbo.Ssf_GetMesageByMessageCode(207,'DOTDOYOUWISHSCHSERVICE_SSP','. Do you wish to schedule this service anyway?')                      
		--set @Result = @ClinicianName + ' is busy during this time due to a ' + rtrim(@AppointmentTypeName) + '. Do you wish to schedule this service anyway?'                    
	  END   
	  END
	  END
end  

result:      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
select @Result       

                   

END TRY
BEGIN CATCH
DECLARE @Error varchar(8000)                                                                          
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCValidateAppointment')                                                                                                           
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


