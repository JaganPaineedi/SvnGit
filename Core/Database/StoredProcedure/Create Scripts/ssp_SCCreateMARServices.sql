IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateMARServices]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCCreateMARServices] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [ssp_SCCreateMARServices] 
@MedAdminRecordIds varchar(max),
@StaffId       INT         
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCCreateMARServices            */ 
/* Creation Date:    24/Apr/2014                */ 
/* Purpose:  To create service for each Medical Administration (MAR)                */ 
/*    Exec ssp_SCCreateMARServices 8930,550                                            */
/* Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 24/Apr/2014		Gautam			Created    task #1103 , Philhaven - Customization Issues Tracking project.          */ 
/* 18/June/2015     Gautam          Added SystemConfigurationKey for Default Location and entry in table MARServiceErrorLog if any error in service creation  */
  /*********************************************************************/ 
  BEGIN 
	DECLARE @UserName VARCHAR(30) 
	DECLARE @LocationId INT
	DECLARE @ServiceId Int
	DECLARE @TotalRecords Int
	DECLARE @RecordCounter Int
	DECLARE @Error VARCHAR(max) 
	DECLARE @ProcedureCodeId int
	DECLARE @ProgramId int
	DECLARE @ErrorMsg as nvarchar(max)	
	DECLARE @ErrorMsgProgram as nvarchar(max)	
	
		SELECT @UserName = UserCode 
        FROM   Staff 
        WHERE  StaffId = @StaffId 
               AND ISNULL(RecordDeleted, 'N') = 'N' 
               
        -- Get the MAR Default Location code       
		Select @LocationId= LocationId from Locations where LocationCode=
				(select [Value] from SystemConfigurationKeys where [key] = 'MARDefaultLocationCode') and  isnull(RecordDeleted,'N')='N'
		
		Create Table #MedAdminRecords(
			MedAdminRecordId int,
			ClientOrderId Int,
			ClientId Int,
			ServiceRequired char(1),
			AdministerDateTime datetime,
			AdministeredDose VARCHAR(25)
			)	
			
		Insert Into #MedAdminRecords
		SELECT item,null,null,'N',null,NULL FROM dbo.FNSPLIT(@MedAdminRecordIds, ',')
		
		Update M
		Set M.ServiceRequired='Y',
			M.ClientOrderId=MA.ClientOrderId,
			M.ClientId= CO.ClientId,
			M.AdministerDateTime=CAST(CAST(MA.AdministeredDate AS DATE) AS DATETIME) + CAST(MA.AdministeredTime AS TIME(0)),
			M.AdministeredDose=MA.AdministeredDose
		From #MedAdminRecords M	Join MedAdminRecords MA On M.MedAdminRecordId=MA.MedAdminRecordId
				Join ClientOrders CO On MA.ClientOrderId=CO.ClientOrderId 
		Where MA.Status in (Select IntegerCodeId from 	dbo.ssf_RecodeValuesCurrent('MARBillableStatus'))	
		
		-- If service already created 
		Update M
		Set M.ServiceRequired='N'
		From #MedAdminRecords M	Join MedAdminRecords MA On M.MedAdminRecordId=MA.MedAdminRecordId
		Where MA.ServiceId is not null
		
		-- IF Location code is not defined then Insert in InpatientServiceErrorLog
		If @LocationId is null and exists(select 1 from #MedAdminRecords where ServiceRequired='Y')
			Begin
				select @ErrorMsg=dbo.Ssf_GetMesageByMessageCode(908,'VALIDATEMARLOCATIONMESSAGE','The default Location for Service is not setup in the SystemConfigurationKeys for [KEY] = MARDefaultLocationCode.')   

				Insert Into InpatientServiceErrorLog(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientId,MedAdminRecordId,MARDateTime,ErrorMessage)
				Select top 1 @UserName,GetDate(),@UserName,GetDate(),ClientId,MedAdminRecordId,AdministerDateTime,@ErrorMsg
				From #MedAdminRecords
				
				Return
			End
		
			
		Create Table #ClientServiceData(
			ID int identity(1,1),
			ClientId int,
			OrderingPhysician int,
			MedicationDosage decimal(10,2),
			ProcedureCodeId int,
			Billable char(1),
			UnitType int,
			ProgramId int,
			MedAdminRecordId Int,
			ClientOrderId Int,
			AdministerDateTime datetime,
			DrugsName varchar(250),
			Strength VARCHAR(25),
			StrengthUnitOfMeasure VARCHAR(25),
			AdministeredDose VARCHAR(25)
		)
		Insert into #ClientServiceData
		Select CO.ClientId,CO.OrderingPhysician, CO.MedicationDosage ,O.ProcedureCodeId,'Y',null,null,MA.MedAdminRecordId,
				CO.ClientOrderId,MA.AdministerDateTime,IM.DrugNDCDescription,MM.Strength,MM.StrengthUnitOfMeasure,
				MA.AdministeredDose
		from ClientOrders CO Join Orders O On CO.OrderId=O.OrderId
			Join #MedAdminRecords MA On MA.ClientOrderId=CO.ClientOrderId
			LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId
										AND ISNULL(IM.RecordDeleted, 'N') = 'N'
			LEFT JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
				AND ISNULL(OS.RecordDeleted, 'N') = 'N'
			LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId
				AND ISNULL(MM.RecordDeleted, 'N') = 'N'
		Where MA.ServiceRequired='Y'	
			
		Update P
		Set P.Billable=case when PC.NotBillable='Y' then 'N' else 'Y' end,P.UnitType=PC.EnteredAs
		From #ClientServiceData P Join ProcedureCodes PC On P.ProcedureCodeId=PC.ProcedureCodeId
		Where isnull(PC.RecordDeleted,'N')='N' 							   
		
		Update CS
		Set CS.ProgramId= (Select top 1 BA.ProgramId From #ClientServiceData CSD Join ClientInpatientVisits CI 
														On CSD.ClientId=CI.ClientId AND isnull(CI.RecordDeleted, 'N') = 'N' 
									JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
											AND isnull(BA.RecordDeleted, 'N') = 'N' 
		Where BA.status=5002 
		and (CSD.AdministerDateTime >= CI.AdmitDate and (CI.DischargedDate is null or CSD.AdministerDateTime <= CI.DischargedDate ))) 	-- 5002 (Occupied)
		From #ClientServiceData CS 
		
		
		select @ErrorMsg=dbo.Ssf_GetMesageByMessageCode(908,'VALIDATEMARPROCEDUREMESSAGE','Procedure Code is not setup for the Medication Order.')   
		select @ErrorMsgProgram=dbo.Ssf_GetMesageByMessageCode(908,'VALIDATEMARPROGRAMMESSAGE','Client is not enrolled to a Program.')   

        Select @TotalRecords=Count(*) From #ClientServiceData
        Set @RecordCounter=1
	-- Insert into Services Table

			While @RecordCounter<=@TotalRecords
				Begin
					BEGIN TRY
						Select @ProcedureCodeId=ProcedureCodeId,@ProgramId=ProgramId From #ClientServiceData where ID=@RecordCounter		
						
						IF (@ProcedureCodeId is not null) and (@ProgramId is not null )
							Begin
								Insert into Services
									(ClientId, ProcedureCodeid, DateOfService, EndDateOfService
										, Unit, UnitType, Status, ClinicianId, ProgramId, LocationId
										, Billable, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
								Select CSD.ClientId,CSD.ProcedureCodeId,CSD.AdministerDateTime, CSD.AdministerDateTime
									, CSD.MedicationDosage, CSD.UnitType, 71, CSD.OrderingPhysician,  CSD.ProgramId, @LocationId -- service status (71 show)
									, CSD.Billable, @UserName, getdate(), @UserName, getdate()
								From #ClientServiceData CSD	where CSD.ID=@RecordCounter					
								
								SET @ServiceId = SCOPE_IDENTITY()
								Update MedAdminRecords set ServiceId=@ServiceId 
								Where MedAdminRecordId=(Select MedAdminRecordId From #ClientServiceData where ID=@RecordCounter)
							End
						Else
							BEGIN
								IF @ProcedureCodeId is null
								BEGIN
									Insert Into InpatientServiceErrorLog(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientId,MedAdminRecordId,MARDateTime,ErrorMessage)
									Select  @UserName,GetDate(),@UserName,GetDate(),ClientId,MedAdminRecordId,AdministerDateTime,@ErrorMsg
									From #ClientServiceData where ID=@RecordCounter
								END
								IF @ProgramId is null
								BEGIN
									Insert Into InpatientServiceErrorLog(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientId,MedAdminRecordId,MARDateTime,ErrorMessage)
									Select  @UserName,GetDate(),@UserName,GetDate(),ClientId,MedAdminRecordId,AdministerDateTime,@ErrorMsgProgram
									From #ClientServiceData where ID=@RecordCounter
								END
							END
					END TRY
					BEGIN catch 
					  SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
								  + '*****' 
								  + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
								  'ssp_SCCreateMARServices' 
								  ) 
								  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
								  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
								  + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 
							Insert Into InpatientServiceErrorLog(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientId,MedAdminRecordId,MARDateTime,ErrorMessage)
							Select  @UserName,GetDate(),@UserName,GetDate(),ClientId,MedAdminRecordId,AdministerDateTime,@Error
							From #ClientServiceData where ID=@RecordCounter
					END catch 
      
					Set @RecordCounter=@RecordCounter + 1
				End	
          

      
  END 

go  