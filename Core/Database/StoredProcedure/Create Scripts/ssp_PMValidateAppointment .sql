/****** Object:  StoredProcedure [dbo].[ssp_PMValidateAppointment ]    Script Date: 11/18/2011 16:25:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMValidateAppointment ]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMValidateAppointment ]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_PMValidateAppointment ]             
@ServiceDate datetime,            
@CurrentServiceID int,             
@ClientID int,            
@ClinicianId int,            
@ServiceEndDate  datetime = null,            
@ProcedureCodeId int,  
@CurrentStatus varchar(30)    
AS          
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED             
/*********************************************************************/                
/* Stored Procedure: ssp_SCValidateProcedureCode                */                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                
/* Creation Date:    9/23/05                                         */                
/*                                                                   */                
/* Purpose:  to validate procedure code*/                
/*                                                                   */              
/* Input Parameters: @Procedurecodeid             */              
/*                                                                   */                
/* Output Parameters:   None                   */                
/*                                                                   */                
/* Return:  0=success, otherwise an error number                     */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                                          
	Date		Author			Purpose     
	----------	-----------		------------------------------------                                               
	9/24/06		Raman			Created                                                    
	9/17/06		Atul Guptal		Modified    
	03/25/2011  dharvey			Added check to exclude Parent Appoint 
								record for recurring appointments. 
	03/01/2017  vsinha			What:  Length of "Display As" to handle procedure code display as increasing to 75     
								Why :  Keystone Customizations 69  						
*/         
/*********************************************************************/               
BEGIN           
 BEGIN TRY           
declare @ClinicianName varchar(100)            
declare @AppointmentType int            
set @AppointmentType = -1            
set @ClinicianName=''            
declare @Result varchar(200)            
declare @CodeName varchar(50)            
declare @UnitValue varchar(10)             
declare @UnitType varchar(12)            
declare @DisplayAs varchar(75)  --03/01/2017  vsinha          
declare @GroupCode char(1)            
declare @sGroupCode char(1)            
declare @DateOfService datetime            
set @Result=''            
            
-- Stored Procedure is changed on 30 March 2007 REF Task # 483 (Bhupinder Bajwa)            
           
SELECT @ClinicianName = st.FirstName + ' ' + st.LastName, @AppointmentType =  AppointmentType,            
	@UnitValue = s.Unit, @UnitType = gc.CodeName, @DisplayAs = pc.DisplayAs,             
	@DateOfService = s.DateOfService, @sGroupCode = IsNull(pc.GroupCode,'N')            
From appointments a      
	left join services s on s.serviceid=a.serviceid and isnull(s.recorddeleted,'N')='N'             
	left join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId            
	left join GlobalCodes gc on gc.GlobalCodeId = s.UnitType            
	join staff st on a.staffid=st.staffid             
Where             
	--(((@ServiceDate > StartTime and @ServiceDate < EndTime) Or (@ServiceEndDate > StartTime and @ServiceEndDate < EndTime))            
	-- Or (@ServiceDate < StartTime and @ServiceEndDate > EndTime))              
	((StartTime <= @ServiceDate and @ServiceDate < EndTime) OR (@ServiceDate <= StartTime and StartTime < @ServiceEndDate)) 
	--Exclude Appointment record for Parent Recurring Appointments - DJH
	and ( a.RecurringAppointment = 'N' 
		or (a.RecurringAppointment = 'Y' 
			and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
			) 
		)            
	and isnull(s.SErviceId,-1)<>@CurrentServiceID             
	and isnull(a.recorddeleted,'N')='N'             
	and a.ShowTimeAs in (4342, 4344)            
	and (s.clientid=@ClientID or s.ClinicianId = @ClinicianId or a.StaffId = @ClinicianId)        
            
            
            
            
            
           
-- fetch GroupCode for service that is being validated            
Select @GroupCode = IsNull(pc.GroupCode,'N') from ProcedureCodes pc where pc.ProcedureCodeId = @ProcedureCodeId            
            
--Print @GroupCode           
--Print @sGroupCode            


--------------------------------------------------------            
IF(@CurrentServiceID>0)         -- For Existing Service            
	BEGIN            
	 IF exists(select 1 from appointments a
				left join services s on s.serviceid=a.serviceid and isnull(s.recorddeleted,'N')='N'             
				where             
				--   (((@ServiceDate > StartTime and @ServiceDate < EndTime) Or (@ServiceEndDate > StartTime and @ServiceEndDate< EndTime)) Or (@ServiceDate < StartTime and @ServiceEndDate > EndTime))             
				  isnull(s.ServiceId,-1)<>@CurrentServiceID             
					and ((StartTime <= @ServiceDate and @ServiceDate < EndTime) OR (@ServiceDate <= StartTime and StartTime < @ServiceEndDate))            
					--Exclude Appointment record for Parent Recurring Appointments - DJH
					and ( a.RecurringAppointment = 'N' 
						or (a.RecurringAppointment = 'Y' 
							and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
							) 
						) 
					and isnull(a.recorddeleted,'N')='N'             
					and a.ShowTimeAs in (4342, 4344)            
					and s.clientid=@ClientID)              
	           
		 BEGIN    
		  IF @CurrentStatus = 'No Show' OR   @CurrentStatus = 'Error'  OR  @CurrentStatus = 'Cancel'  
			 begin  
				  set @Result = ''  
			 end  
		  ELSE  
			 begin     
				------------------------------------------------------------
				--set @Result = 'Another service is scheduled for this Client on this day. Clinician: '+ @ClinicianName + ' at ' + cast(@DateOfService as varchar) + ' for ' + @DisplayAs + ' ' + @UnitValue + ' ' + @UnitType + '. Do you want to save this service?' 
					--Modified by: SWAPAN MOHAN 
					--Modified on: 4 July 2012
					--Purpose: For implementing the Customizable Message Codes. 
					--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
				set @Result = dbo.Ssf_GetMesageByMessageCode(207,'ANOTHERSERVICEISSCH_SSP','Another service is scheduled for this Client on this day. Clinician:')+ @ClinicianName + dbo.Ssf_GetMesageByMessageCode(207,'AT_SSP',' at ') + cast(@DateOfService as varchar) + dbo.Ssf_GetMesageByMessageCode(29,'FOR_SSP',' for ') + @DisplayAs + ' ' + @UnitValue + ' ' + @UnitType + dbo.Ssf_GetMesageByMessageCode(207,'DOTDOYOUWANTSAVESERVICE_SSP','. Do you want to save this service?')
				------------------------------------------------------------       
			 end  
		     
		 END            
 ELSE IF exists(select 1 from appointments a
				left join services s on s.serviceid=a.serviceid  and isnull(s.recorddeleted,'N')='N'             
				where            
				--    (((@ServiceDate > StartTime and @ServiceDate < EndTime) Or (@ServiceEndDate > StartTime and @ServiceEndDate < EndTime)) Or (@ServiceDate < StartTime and @ServiceEndDate > EndTime))              
				((StartTime <= @ServiceDate and @ServiceDate < EndTime) OR (@ServiceDate <= StartTime and StartTime < @ServiceEndDate))            
				--Exclude Appointment record for Parent Recurring Appointments - DJH
				and ( a.RecurringAppointment = 'N' 
						or (a.RecurringAppointment = 'Y' 
							and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
							) 
						) 
				and isnull(s.SErviceId,-1)<>@CurrentServiceID             
				and isnull(a.recorddeleted,'N')='N'              
				and a.ShowTimeAs in (4342, 4344)               
				and ((s.ClinicianId=@ClinicianId and (@GroupCode='N' or @sGroupCode='N')) 
					or (a.StaffId = @ClinicianId and a.AppointmentType<>4761)))  -- When checking for overlapping services of the clinician, if the Procedure Code bein 

				-- used on the service that is being scheduled is a group code (pc.GroupCode = 'Y') 
				--and the overlapping service's procedure code is also a group code, then do not raise the message.            
              
		 BEGIN             
		  IF @CurrentStatus = 'No Show' OR   @CurrentStatus = 'Error'  OR  @CurrentStatus = 'Cancel'  
			 begin  
			  set @Result = ''  
			 end  
		  ELSE  
			 begin  
				------------------------------------------------------------
				--set @Result = @ClinicianName + ' is busy during this time due to a ' + rtrim(@CodeName)+ '. Do you wish to schedule this service anyway?'
					--Modified by: SWAPAN MOHAN 
					--Modified on: 4 July 2012
					--Purpose: For implementing the Customizable Message Codes. 
					--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
				set @Result = @ClinicianName + dbo.Ssf_GetMesageByMessageCode(207,'ISBUSYDURING_SSP',' is busy during this time due to a ') + rtrim(@CodeName)+ dbo.Ssf_GetMesageByMessageCode(207,'DOTDOYOUWISHSCHSERVICE_SSP','. Do you wish to schedule this service anyway?')
				------------------------------------------------------------	          
			 end  
		 END            
            
	END            


--------------------------------------------------------             
ELSE            -- For New Service created            
            
	BEGIN            
	 IF exists(select 1 from appointments a
				left join services s on s.serviceid=a.serviceid   and isnull(s.recorddeleted,'N')='N'             
				--    (((@ServiceDate > StartTime and @ServiceDate < EndTime) Or (@ServiceEndDate > StartTime and @ServiceEndDate< EndTime))Or (@ServiceDate < StartTime and @ServiceEndDate > EndTime))             
				where             
				((StartTime <= @ServiceDate and @ServiceDate < EndTime) OR (@ServiceDate <= StartTime and StartTime < @ServiceEndDate))            
				--Exclude Appointment record for Parent Recurring Appointments - DJH
				and ( a.RecurringAppointment = 'N' 
						or (a.RecurringAppointment = 'Y' 
							and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
							) 
						) 
				and isnull(a.recorddeleted,'N')='N'             
				and a.ShowTimeAs in (4342, 4344)            
				and s.clientid=@ClientID)            
	 
		 begin            
			------------------------------------------------------------
			--set @Result = 'Another service is scheduled for this Client on this day. Clinician: '+ @ClinicianName + ' at ' + cast(@DateOfService as varchar) + ' for ' + @DisplayAs + ' ' + @UnitValue + ' ' + @UnitType + '. Do you want to save this service?' 
				--Modified by: SWAPAN MOHAN 
				--Modified on: 4 July 2012
				--Purpose: For implementing the Customizable Message Codes. 
				--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
			set @Result = dbo.Ssf_GetMesageByMessageCode(207,'ANOTHERSERVICEISSCH_SSP','Another service is scheduled for this Client on this day. Clinician:')+ @ClinicianName + dbo.Ssf_GetMesageByMessageCode(207,'AT_SSP',' at ') + cast(@DateOfService as varchar) + dbo.Ssf_GetMesageByMessageCode(29,'FOR_SSP',' for ') + @DisplayAs + ' ' + @UnitValue + ' ' + @UnitType + dbo.Ssf_GetMesageByMessageCode(207,'DOTDOYOUWANTSAVESERVICE_SSP','. Do you want to save this service?')
			------------------------------------------------------------       
		 end   
		          
	 ELSE IF exists(select 1 from appointments a
					left join services s on s.serviceid=a.serviceid and isnull(s.recorddeleted,'N')='N'             
					and isnull(a.recorddeleted,'N')='N'  where             
					--   (((@ServiceDate > StartTime and @ServiceDate < EndTime) Or (@ServiceEndDate > StartTime and @ServiceEndDate < EndTime)) Or (@ServiceDate < StartTime and @ServiceEndDate > EndTime))             
					((StartTime <= @ServiceDate and @ServiceDate < EndTime) OR (@ServiceDate <= StartTime and StartTime < @ServiceEndDate))            
					--Exclude Appointment record for Parent Recurring Appointments - DJH
					and ( a.RecurringAppointment = 'N' 
						or (a.RecurringAppointment = 'Y' 
							and (a.RecurringAppointmentId is not null or a.RecurringServiceId is not null or a.RecurringGroupServiceId is not null)
							) 
						) 
					and isnull(a.recorddeleted,'N')='N'             
					and a.ShowTimeAs in (4342, 4344)            
					and ((s.ClinicianId=@ClinicianId and (@GroupCode='N' or @sGroupCode='N')) 
						or (a.StaffId = @ClinicianId and a.AppointmentType<>4761)))            
	               
		 begin            
			------------------------------------------------------------
			--set @Result = @ClinicianName + ' is busy during this time due to a ' + rtrim(@CodeName)+ '. Do you wish to schedule this service anyway?'
				--Modified by: SWAPAN MOHAN 
				--Modified on: 4 July 2012
				--Purpose: For implementing the Customizable Message Codes. 
				--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
			set @Result = @ClinicianName + dbo.Ssf_GetMesageByMessageCode(207,'ISBUSYDURING_SSP',' is busy during this time due to a ') + rtrim(@CodeName)+ dbo.Ssf_GetMesageByMessageCode(207,'DOTDOYOUWISHSCHSERVICE_SSP','. Do you wish to schedule this service anyway?')
			------------------------------------------------------------	         
		 end            

	END   

--Output
SELECT @Result  
         
------------IF (@@error!=0)              
------------	BEGIN              
------------	RAISERROR  20002 'ssp_SCValidateServiceNote: An Error Occured'                       
------------	RETURN(1)                    
------------	END  
END TRY
BEGIN CATCH
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PMValidateAppointment')                                        
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
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 