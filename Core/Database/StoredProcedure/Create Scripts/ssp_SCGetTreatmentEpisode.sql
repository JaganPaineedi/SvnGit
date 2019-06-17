IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetTreatmentEpisode]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetTreatmentEpisode] --16928
GO

CREATE PROCEDURE [dbo].[ssp_SCGetTreatmentEpisode] (@TreatmentEpisodeId INT)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetTreatmentEpisode]  4         */
/* Date              Author                  Purpose                 */
/* 4/17/2015        Sunil.D             SC: Treatment Episode New Screen and Banner not Client Episode
											Thresholds - Support  #828                       */
/*11/22/2018        Swatika               What/Why:Added new column in "TreatmentEpisodes" table Thresholds - Enhancements Task#52*/
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */
BEGIN
	BEGIN TRY
		 select
			T.TreatmentEpisodeId
			,T.CreatedBy
			,T.CreatedDate
			,T.ModifiedBy
			,T.ModifiedDate
			,T.RecordDeleted
			,T.DeletedBy
			,T.DeletedDate
			,T.ClientId
			,T.ServiceAreaId
			,T.IntakeStaffId
			,T.StaffAssociatedId
			,(S.LastName+', '+S.FirstName) as  IntakeStaffName
			,(SA.LastName+', '+SA.FirstName) as  StaffAssociatedName
			,T.TreatmentEpisodeType
			,T.TreatmentEpisodeSubType
			,T.TreatmentEpisodeStatus
			,T.RegistrationDate
			,T.DischargeDate
			,T.RequestDate
			,T.AssessmentDate
			,T.AssessmentOfferedDate
			,T.AssessmentDeclineReason
			,T.TxStartDate
			,T.TxStartOfferedDate
			,T.TxStartDeclineReason
			,T.Comments
			,T.ReferralDate
			,T.ReferralType
			,T.ReferralSubtype
			,T.ReferralName
			,T.ReferralDetails
			,T.ReferralAdditionalInformation
			,T.ReferralReason1
			,T.ReferralReason2
			,T.ReferralReason3
			,T.ReferralComment
		   FROM TreatmentEpisodes T
		   full outer  join Staff S on S.Staffid=T.IntakeStaffId  
		   full outer join Staff SA on SA.Staffid=T.StaffAssociatedId
		   WHERE TreatmentEpisodeId = @TreatmentEpisodeId AND ISNULL(T.RecordDeleted,'N') <> 'Y'  
		   
	END TRY 
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000) 
		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetTreatmentEpisode') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE()) 
		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END