IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InsertMedAdministrationHistory]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InsertMedAdministrationHistory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************/
/* Stored Procedure: dbo.ssp_InsertMedAdministrationHistory            */
/* Creation Date:    23/Dec/2014                  */
/* Purpose:  Used to get med admin records by Id                */
/* Input Parameters:                           */
/*  Date			Author			Purpose              */
/* 23/Dec/2014		PPotnuru		Created              */
/*********************************************************************/
CREATE PROCEDURE [dbo].[ssp_InsertMedAdministrationHistory] @MedAdminRecordIds VARCHAR(max)
	
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.MedAdminRecordHistory (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,MedAdminRecordId
			,ClientOrderId
			,AdministeredBy
			,DualSignedbyStaffId
			,ClientMedicationId
			,ServiceId
			,ScheduledDate
			,ScheduledTime
			,DualSignRequired
			,AdministeredDate
			,AdministeredTime
			,STATUS
			,AdministeredDose
			,Comment
			,PRNReason
			,NotGivenReason
			,PainId
			,DualSignedDate
			,User2Comments
			,User2PRNReason
			,User2NotGivenReason
			,User2PainId
			)
		SELECT ModifiedBy
			,ModifiedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,MedAdminRecordId
			,ClientOrderId
			,AdministeredBy
			,DualSignedbyStaffId
			,ClientMedicationId
			,ServiceId
			,ScheduledDate
			,ScheduledTime
			,DualSignRequired
			,AdministeredDate
			,AdministeredTime
			,STATUS
			,AdministeredDose
			,Comment
			,PRNReason
			,NotGivenReason
			,PainId
			,DualSignedDate
			,User2Comments
			,User2PRNReason
			,User2NotGivenReason
			,User2PainId
		FROM MedAdminRecords
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND MedAdminRecordId IN (
				SELECT item
				FROM dbo.FNSPLIT(@MedAdminRecordIds, ',')
				)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max) 
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_InsertMedAdministrationHistory' 
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
	END CATCH
END
GO

