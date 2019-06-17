IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_SCGetAllDataForService]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_SCGetAllDataForService]
GO
 
  
CREATE PROCEDURE [dbo].[smsp_SCGetAllDataForService]                               
@ClientId         INT,  
@DateOfService    DATETIME = NULL,  
@ProgramId        INT      = -1,  
@AttendingId      INT      = 0,  
@ProcedureCodeId  INT      = 0,  
@LocationId       INT      = 0,  
@PlaceOfServiceId INT      = 0,  
@ClinicianId      INT  
AS  
     BEGIN                     
   
/***********************************************************************************************************/  
  
/* Stored Procedure: [smsp_SCGetAllDataForService]                                                         */  
  
/* Creation Date:  28/May/2018                                                                             */  
  
/* Purpose: To get The Data  For Service                                                                   */  
  
/* Input Parameters:@ClientId, @DateOfService, @ProgramId, @AttendingId,                                   */  
  
/*     @ProcedureCodeId, @LocationId, @PlaceOfServiceId                                                    */  
  
/* Output Parameters:   Returns The Data                                                                   */  
  
/* CreatedBy : Vishnu Narayanan                                                                            */  
  
/***********************************************************************************************************/  
  
         BEGIN TRY  
             BEGIN  
                 DECLARE @LocationIdUsesSharedTable AS CHAR(1);  
                 DECLARE @ProcedureCodeIdUsesSharedTable AS CHAR(1);  
                 DECLARE @ProgramIdUsesSharedTable AS CHAR(1);  
                 DECLARE @AttendingIdUsesSharedTable AS CHAR(1);  
                 DECLARE @PlaceOfServiceIdUsesSharedTable AS CHAR(1);  
                 DECLARE @ClinicianIdUsesSharedTable AS CHAR(1);  
                 DECLARE @LocationIdStoredProcedure AS VARCHAR(100);  
                 DECLARE @LocationIdSharedTableStoredProcedure AS VARCHAR(100);  
                 DECLARE @ProcedureCodeIdStoredProcedure AS VARCHAR(100);  
                 DECLARE @ProcedureCodeIdSharedTableStoredProcedure AS VARCHAR(100);  
                 DECLARE @ProgramIdStoredProcedure AS VARCHAR(100);  
                 DECLARE @ProgramIdSharedTableStoredProcedure AS VARCHAR(100);  
                 DECLARE @AttendingIdStoredProcedure AS VARCHAR(100);  
                 DECLARE @AttendingSharedTableStoredProcedure AS VARCHAR(100);  
                 DECLARE @PlaceOfServiceIdStoredProcedure AS VARCHAR(100);  
                 DECLARE @PlaceOfServiceIdSharedTableStoredProcedure AS VARCHAR(100);       
              

  
                 SELECT @ProgramIdUsesSharedTable = ProgramIdUsesSharedTable,  
                        @AttendingIdUsesSharedTable = AttendingIdUsesSharedTable,  
                        @ProcedureCodeIdUsesSharedTable = ProcedureCodeIdUsesSharedTable,  
                        @LocationIdUsesSharedTable = LocationIdUsesSharedTable,  
                        @PlaceOfServiceIdUsesSharedTable = PlaceOfServiceIdUsesSharedTable,  
                        @ClinicianIdUsesSharedTable = ClinicianIdUsesSharedTable,  
                        @LocationIdStoredProcedure = LocationIdStoredProcedure,  
                        @ProcedureCodeIdStoredProcedure = ProcedureCodeIdStoredProcedure,  
                        @ProgramIdStoredProcedure = ProgramIdStoredProcedure,  
                        @AttendingIdStoredProcedure = AttendingIdStoredProcedure,  
                        @PlaceOfServiceIdStoredProcedure = PlaceOfServiceIdStoredProcedure,  
                        @LocationIdSharedTableStoredProcedure = LocationIdSharedTableStoredProcedure,  
                        @ProcedureCodeIdSharedTableStoredProcedure = ProcedureCodeIdSharedTableStoredProcedure,  
                        @ProgramIdSharedTableStoredProcedure = ProgramIdSharedTableStoredProcedure,  
                        @AttendingSharedTableStoredProcedure = AttendingIdSharedTableStoredProcedure,  
                        @PlaceOfServiceIdSharedTableStoredProcedure = PlaceOfServiceIdSharedTableStoredProcedure      
          
                 FROM ServiceDropdownConfigurations;  
                 IF @LocationIdUsesSharedTable = 'N'  
                     BEGIN  
                         EXEC @LocationIdStoredProcedure  
                              @ClientId,  
                              @DateOfService,  
                              @ProgramId,  
                              @AttendingId,  
                              @ProcedureCodeId,  
                              @LocationId,  
                              @PlaceOfServiceId,  
                              @ClinicianId;  --For Location                 
                     END;  
                     ELSE  
                     BEGIN  
                         EXEC @LocationIdSharedTableStoredProcedure;  
                     END;  
                 IF @ProcedureCodeIdUsesSharedTable = 'N'  
                     BEGIN  
                         EXEC @ProcedureCodeIdStoredProcedure  
                              @ClientId,  
                              @DateOfService,  
                              @ProgramId,  
                              @AttendingId,  
                              @ProcedureCodeId,  
                              @LocationId,  
                              @PlaceOfServiceId,  
                              @ClinicianId; -- For ProcedureCode                
                     END;  
                     ELSE  
                     BEGIN  
                         EXEC @ProcedureCodeIdSharedTableStoredProcedure;  
                     END;  
                 IF @ProgramIdUsesSharedTable = 'N'  
                     BEGIN  
                         EXEC @ProgramIdStoredProcedure  
                              @ClientId,  
                              @DateOfService,  
                              @ProgramId,  
                              @AttendingId,  
                              @ProcedureCodeId,  
                              @LocationId,  
                              @PlaceOfServiceId,  
                              @ClinicianId; -- For Program                
                     END;  
                     ELSE  
                     BEGIN  
                         EXEC @ProgramIdSharedTableStoredProcedure;  
                     END;  
                 IF @AttendingIdUsesSharedTable = 'N'  
                     BEGIN  
                         EXEC @AttendingIdStoredProcedure  
                              @ClientId,  
                              @DateOfService,  
                              @ProgramId,  
                              @AttendingId,  
                              @ProcedureCodeId,  
                              @LocationId,  
                              @PlaceOfServiceId,  
                              @ClinicianId;           
   -- For Clinician                
                     END;  
                     ELSE  
                     BEGIN  
                         EXEC @AttendingSharedTableStoredProcedure;  
                     END;               
        
                 IF @PlaceOfServiceIdStoredProcedure IS NOT NULL  
                    OR @PlaceOfServiceIdSharedTableStoredProcedure IS NOT NULL  
                     BEGIN  
                         IF @PlaceOfServiceIdUsesSharedTable = 'N'  
                             BEGIN  
                                 EXEC @PlaceOfServiceIdStoredProcedure  
                                      @ClientId,  
                                      @DateOfService,  
                                      @ProgramId,  
                                      @AttendingId,  
                                      @ProcedureCodeId,  
                                      @LocationId,  
                                      @PlaceOfServiceId,  
                                      @ClinicianId;  
                             END;  
                             ELSE  
                             BEGIN  
                                 EXEC @PlaceOfServiceIdSharedTableStoredProcedure;  
                             END;  
                     END;  
                     ELSE  
                     BEGIN  
                         SELECT '' AS placeofserviceid,  
                                '' AS placeofservicename  
                         FROM GlobalCodes  
                         WHERE 1 = 2;  
                     END;  
             END;  
         END TRY  
         BEGIN CATCH  
             DECLARE @Error VARCHAR(8000);  
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAllDataForService')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());  
             RAISERROR(@Error,   
  
/* Message text.*/  
          
             16,   
  
/* Severity.*/  
                                     
             1    
  
/*State.*/  
                                 
             );  
         END CATCH;  
     END; 