/****** Object:  StoredProcedure [dbo].[ssp_GetMedAdminRecordsById]    Script Date: 04/09/2013******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMedAdminRecordsById]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetMedAdminRecordsById]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************/
/* Stored Procedure: dbo.ssp_GetMedAdminRecordsById            */
/* Creation Date:    04/Sep/2013                  */
/* Purpose:  Used to get med admin records by Id                */
/* Input Parameters:                           */
/*  Date			Author			Purpose              */
/* 04/Sep/2013		PPotnuru		Created              */
/* 05/May/2014		PPotnuru		Modified Added new column ServiceId              */
/* 20/May/2014		Chethan N		What: Added new column 'NoOfDosageForm'
									Why:  Philhaven Development task # 258 	 */		              
/* 09/Feb/2014      Chethan         What : Added column ClientMedicationInstructionId in select statement 
									why : Key Point - Environment Issues Tracking	151 - Changes to Client MAR */
/*********************************************************************/
CREATE PROCEDURE [dbo].[ssp_GetMedAdminRecordsById] @MedAdminRecordIds VARCHAR(max)    
AS    
BEGIN    
 BEGIN TRY    
  Select MedAdminRecordId,     
                    CreatedBy,     
                    CreatedDate,     
                    ModifiedBy,     
                    ModifiedDate,     
                    RecordDeleted,     
                    DeletedDate,     
                    DeletedBy,     
                    ClientOrderId,     
                    ScheduledDate,     
                    ScheduledTime,     
                    DualSignRequired,     
                    AdministeredDate,     
                    AdministeredTime,     
                    AdministeredBy,     
                    Status,     
                    AdministeredDose,     
                    Comment,     
                    PRNReason,     
                    NotGivenReason,     
                    PainId,     
                    DualSignedbyStaffId,     
                    DualSignedDate,     
                    OrigScheduledID,    
                    User2Comments,    
     User2PRNReason,    
     User2NotGivenReason,    
     User2PainId,    
     ClientMedicationId,    
     ServiceId,    
     --AdministeredUnit,    
     NoOfDosageForm,    
     --DosageFormAbbreviation    
     ClientMedicationInstructionId   
               FROM MedAdminRecords WHERE MedAdminRecordId in (SELECT item FROM dbo.FNSPLIT(@MedAdminRecordIds, ','))    
	END TRY

	BEGIN CATCH
		RAISERROR ('ssp_GetMedAdminRecordsById: An Error Occured',16,1)

		RETURN
	END CATCH
END
GO

