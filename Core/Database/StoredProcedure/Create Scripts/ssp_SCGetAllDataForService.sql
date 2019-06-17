IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetAllDataForService')
	BEGIN
		DROP  Procedure  ssp_SCGetAllDataForService
	END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetAllDataForService]             
 -- Add the parameters for the stored procedure here            
 @ClientId int,           
 @DateOfService DateTime = null,           
 @ProgramId int,           
 @AttendingId int,           
 @ProcedureCodeId int,           
 @LocationId int,           
 @PlaceOfServiceId int ,
 @ClinicianId int           
AS            
BEGIN           
/*********************************************************************/                                                                                    
 /* Stored Procedure: [ssp_SCGetAllDataForService]                         */                                                                           
 /* Creation Date:  24/August/2011                                     */                                                                                    
 /* Purpose: To get The Data  For Service            */                                                                                  
 /* Input Parameters:@ClientId, @DateOfService, @ProgramId, @AttendingId,             
      @ProcedureCodeId, @LocationId, @PlaceOfServiceId  */              
 /* Output Parameters:   Returns The Data  */                                                                                    
 /* Called By:                                                       */                                                                          
 /* Data Modifications:                                              */                                                                                    
 /*   Updates:                                                       */                                                                                    
 /*   Date               Author                                       */                                                                                    
 /*   24/August/2011     Damanpreet    Modified                       */                                                                                  
 /*   26/Sept/2011		 Shifali	   Modified in ref to increase length of spname variables to 100*/      
  /*   25/April/2012	Amit Kumar Srivastava	   Modified in @DateOfService DateTime = null,*/ 
 /*  26 Apr 2016   Dhanil               Added Place Of Service logic why: task #328 Engineering Improvement */                                                                                 
 /********************************************************************/             
BEGIN TRY            
	BEGIN      

		Declare @LocationIdUsesSharedTable as char(1)      
		Declare @ProcedureCodeIdUsesSharedTable as char(1)      
		Declare @ProgramIdUsesSharedTable as char(1)      
		Declare @AttendingIdUsesSharedTable as char(1)      
		Declare @PlaceOfServiceIdUsesSharedTable as char(1)  
		Declare @ClinicianIdUsesSharedTable as char(1)  
		Declare @LocationIdStoredProcedure as varchar(100)      
		Declare @ProcedureCodeIdStoredProcedure  as varchar(100)       
		Declare @ProgramIdStoredProcedure  as varchar(100)       
		Declare @AttendingIdStoredProcedure  as varchar(100)       
		Declare @PlaceOfServiceIdStoredProcedure  as varchar(100) 
		Declare @ClinicianIdStoredProcedure  as varchar(100)       

		Select @ProgramIdUsesSharedTable= ProgramIdUsesSharedTable,
		@AttendingIdUsesSharedTable=AttendingIdUsesSharedTable,      
		@ProcedureCodeIdUsesSharedTable=ProcedureCodeIdUsesSharedTable,
		@LocationIdUsesSharedTable=LocationIdUsesSharedTable,      
		@PlaceOfServiceIdUsesSharedTable=PlaceOfServiceIdUsesSharedTable ,
		@ClinicianIdUsesSharedTable = ClinicianIdUsesSharedTable
		,@LocationIdStoredProcedure = LocationIdStoredProcedure,  
		@ProcedureCodeIdStoredProcedure = ProcedureCodeIdStoredProcedure,
		@ProgramIdStoredProcedure = ProgramIdStoredProcedure,
		@AttendingIdStoredProcedure = AttendingIdStoredProcedure, 
		@PlaceOfServiceIdStoredProcedure = PlaceOfServiceIdStoredProcedure,
		@ClinicianIdStoredProcedure = ClinicianIdStoredProcedure
		From ServiceDropdownConfigurations         

		IF @LocationIdUsesSharedTable ='N'      
		BEGIN      
			exec @LocationIdStoredProcedure @ClientId,@DateOfService,@ProgramId,@AttendingId,
			@ProcedureCodeId,@LocationId
			,@PlaceOfServiceId,@ClinicianId  --For Location       
		END      
		ELSE      
		BEGIN      
			SELECT LocationID,NULL AS LocationName                           
			FROM StaffLocations WHERE staffId=-1                              
			ORDER BY LocationName             
		END         

		IF @ProcedureCodeIdUsesSharedTable ='N'      
		BEGIN      
			exec @ProcedureCodeIdStoredProcedure 
			@ClientId,@DateOfService,@ProgramId,@AttendingId,@ProcedureCodeId,
			@LocationId,@PlaceOfServiceId,@ClinicianId -- For ProcedureCode      
		END      
		ELSE      
		BEGIN      
			SELECT ProcedureCodeID,NULL AS Procedurecode           
			FROM StaffProcedures WHERE staffId=-1       
			ORDER BY Procedurecode        
		END      

		IF @ProgramIdUsesSharedTable ='N'      
		BEGIN      
			EXEC @ProgramIdStoredProcedure @ClientId,@DateOfService,@ProgramId,
			@AttendingId,@ProcedureCodeId,@LocationId,@PlaceOfServiceId,@ClinicianId -- For Program      
		END      
		ELSE      
		BEGIN      
			SELECT ProgramId,
			Null AS ProgramName       
			FROM staffPrograms 
			WHERE staffId=-1           
			ORDER BY ProgramName       
		END      

		IF @AttendingIdUsesSharedTable='N'      
		BEGIN      
			EXEC @AttendingIdStoredProcedure @ClientId,@DateOfService,
			@ProgramId,@AttendingId,@ProcedureCodeId,@LocationId,@PlaceOfServiceId,@ClinicianId 
			-- For Clinician      
		END       
		ELSE      
		BEGIN      
			SELECT Staffid,NULL AS StaffName, Null AS ProgramId,Null AS LocationId 
			--,sp.ProgramId, spr.ProcedureCodeId           
			FROM Staff s        
			WHERE StaffId=-1            
			ORDER BY StaffName       
		END     

		IF @ClinicianIdUsesSharedTable='N'      
		BEGIN      
			EXEC @ClinicianIdStoredProcedure @ClientId,@DateOfService,@ProgramId,@AttendingId,@ProcedureCodeId,
			@LocationId,@PlaceOfServiceId,@ClinicianId -- For Clinician      
		END       
		ELSE      
		BEGIN      
			SELECT Staffid,NULL AS StaffName, Null AS ProgramId,Null AS LocationId 
			/*,sp.ProgramId, spr.ProcedureCodeId*/
			FROM STAFF S        
			WHERE StaffId=-1 ORDER BY StaffName       
		END  
		--26 Apr 2016   Dhanil
		IF @PlaceOfServiceIdUsesSharedTable  ='N'      
		BEGIN      
			exec @PlaceOfServiceIdStoredProcedure @ClientId,@DateOfService,@ProgramId,@AttendingId,
			@ProcedureCodeId,@LocationId
			,@PlaceOfServiceId,@ClinicianId        
		END      
	END            
END TRY                                                                                                              
BEGIN CATCH                                                                                                
	DECLARE @Error varchar(8000)                                                                                     	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                   	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetAllDataForService')                              	+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          	+ '*****' + Convert(varchar,ERROR_STATE())                                                                       	RAISERROR                                                                                
	(                                                                                  
		@Error, /* Message text.*/
		16,     /* Severity.*/                           
		1		/*State.*/                       
	);                                                                                                                                        
  END CATCH                             
 END

GO


