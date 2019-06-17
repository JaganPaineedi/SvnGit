/****** Object:  StoredProcedure [dbo].[ssp_SignReferralDocument]    Script Date: 05/17/2016 18:19:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SignReferralDocument]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SignReferralDocument]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SignReferralDocument]    Script Date: 05/17/2016 18:19:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SignReferralDocument] @FosterReferralId INT
	,@UserCode INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_signReferralDocument      */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    18/Nov/2012                                     */
/* Purpose:  Used to create multiple Referral Documents     */
/* Input Parameters:  @FosterReferralId,@ClientId      */
/* Output Parameters:   Dataset of Newly added Member's Details      */
/*  Date    Author         Purpose          */
/* 18/Nov/2012   MSuma      Created          */
/* 17/Jan/2013   Gautam     Added FosterReferralId as second parameter in     
                                 ssp_CreateOrUpdateDocuments Procedure  */
/* 17/May/2016	 Shankha	Modified the logic before Insert/Update into ClientPhones */
/* 26/Oct/2016	 Anto	    Added a column FosterReferralId in #CreateNewPlacement table - Pathway - Support Go Live #292  */
/* 01/Dec/2016	 Irfan		What: Added call of this StoredProcedure 'scsp_FosterCareReferralDocument' to created ToDo Document 
							'Registration Document' when FosterCare Referral Document is signed.
							Why: Pathway - Support Go Live -#59															*/
/*********************************************************************/
BEGIN
	DECLARE @Count INT
	DECLARE @TotalChild INT
	DECLARE @UserName VARCHAR(30)

	SELECT @UserName = UserCode
	FROM Staff
	WHERE StaffId = @UserCode

	SET @Count = (
			SELECT COUNT(*)
			FROM FosterChildren CFC
			INNER JOIN dbo.ssf_RecodeValuesCurrent('XFosterReferralsTYPE') AS rel ON rel.IntegerCodeId = CFC.ReferralStatus
			WHERE FosterReferralId = @FosterReferralId
			)

	IF (@Count = 0)
	BEGIN
		SELECT 'Atleast One Child Referral Status should be accepted.';

		RETURN
	END

	SET @Count = (
			SELECT COUNT(*)
			FROM FosterReferralPlacementChildren
			WHERE FosterReferralId = @FosterReferralId
				AND ISNULL(RecordDeleted, 'N') = 'N'
			)

	IF (@Count = 0)
	BEGIN
		SELECT 'Child has not been Placed';

		RETURN
	END

	BEGIN TRAN

	BEGIN TRY
		CREATE TABLE #CreateNewPlacement (
			ClientId INT NULL
			,--              
			FosterChildId INT NULL
			,DocumentId INT NULL
			,DocumentVersion INT NULL
			,AuthorId INT NULL
			,EffectiveDate DATETIME NULL
			,NextReviewDate DATETIME NULL
			,LastName VARCHAR(100)
			,FirstName VARCHAR(100)
			,DOB DATETIME
			,SSN INT
			,FosterReferralId INT
			)

		DECLARE @CreateNewPlacements AS DOCLevelType
		DECLARE @DocumentCodeId INT
		DECLARE @FosterPlacementId INT
		DECLARE @GlobalCodeId INT
		DECLARE @PendOpen INT
		DECLARE @Open INT
		DECLARE @StatusYes INT
		DECLARE @StatusNo INT
		DECLARE @SibsSplitStatus INT
		DECLARE @CanSibsbeSplit INT

		CREATE TABLE #NewlyAddedClients (
			ClientId INT
			,FosterChildId INT
			)

		SELECT @DocumentCodeId = DocumentCOdeId
		FROM DocumentCodes
		WHERE DocumentName = 'Foster Care Referral'

		SELECT @GlobalCodeId = GlobalCOdeId
		FROM GlobalCodes
		WHERE Category = 'XLEGALSTATUS'
			AND Code = 'Temporary Ward'

		SELECT @PendOpen = GlobalCOdeId
		FROM GlobalCodes
		WHERE Category = 'XPLACEMENTSTATUS'
			AND Code = 'Pend Open'

		SELECT @Open = GlobalCOdeId
		FROM GlobalCodes
		WHERE Category = 'XPLACEMENTSTATUS'
			AND Code = 'Open'

		SELECT @StatusNo = GlobalCOdeId
		FROM GlobalCodes
		WHERE Category = 'XCanSibsBeSplit'
			AND Code = 'No'

		SELECT @StatusYes = GlobalCOdeId
		FROM GlobalCodes
		WHERE Category = 'XCanSibsBeSplit'
			AND Code = 'Yes'

		-- To find whether sibs are split or not     
		SET @TotalChild = (
				SELECT COUNT(*)
				FROM FosterChildren
				WHERE FosterReferralId = @FosterReferralId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		SET @Count = (
				SELECT COUNT(*)
				FROM FosterReferralPlacementChildren
				WHERE FosterReferralId = @FosterReferralId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)

		-- All child are not placed in Placement Family some in InProgress state or not accepted          
		IF ISNULL(@TotalChild, 0) <> ISNULL(@Count, 0)
		BEGIN
			SET @SibsSplitStatus = @StatusYes
		END
		ELSE
		BEGIN
			SELECT @CanSibsbeSplit = CanSibsBeSplit
			FROM FosterReferrals
			WHERE FosterReferralId = @FosterReferralId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF @CanSibsbeSplit IS NULL
			BEGIN
				SET @SibsSplitStatus = @StatusNo
			END
			ELSE
			BEGIN
				IF @CanSibsbeSplit = @StatusYes
				BEGIN
					IF (
							SELECT Count(DISTINCT PlacementFamilyId)
							FROM FosterReferralPlacementChildren
							WHERE FosterReferralId = @FosterReferralId
								AND ISNULL(RecordDeleted, 'N') = 'N'
							) = 1
					BEGIN
						SET @SibsSplitStatus = @StatusNo -- All child is placed in same family    
					END
					ELSE
					BEGIN
						SET @SibsSplitStatus = @StatusYes -- Child are placed in more than one family    
					END
				END
				ELSE
				BEGIN
					SET @SibsSplitStatus = @StatusNo
				END
			END
		END

		--Select @SibsSplitStatus     
		--List if children who are not not yet placed              
		--List all children who are Accepted              
		INSERT INTO #CreateNewPlacement (
			FosterChildId
			,DocumentId
			,DocumentVersion
			,AuthorId
			,EffectiveDate
			,NextReviewDate
			,LastName
			,FirstName
			,SSN
			,DOB
			,ClientId
			,FosterReferralId
			)
		OUTPUT INSERTED.FosterChildId
		INTO #NewlyAddedClients(FosterChildId)
		SELECT DISTINCT CFRC.FosterChildId
			,NULL
			,NULL
			,CFR.FosterCareSpecialist
			,GETDATE()
			,NULL
			,CFC.LastName
			,CFC.FirstName
			,CFC.SSN
			,CFC.DOB
			,CFC.ClientId
			,CFC.FosterReferralId
		FROM FosterReferrals CFR
		JOIN FosterREferralPlacements CFRP ON CFR.FosterReferralId = CFRP.FosterReferralId
		JOIN FosterReferralPlacementChildren CFRC ON CFRC.FosterReferralPlacementId = CFRP.FosterReferralPlacementId
		JOIN FosterChildren CFC ON CFC.FosterChildId = CFRC.FosterChildId
		INNER JOIN dbo.ssf_RecodeValuesCurrent('XFosterReferralsTYPE') AS rel ON rel.IntegerCodeId = CFC.ReferralStatus
		WHERE CFC.FosterReferralId = @FosterReferralId
			AND NOT EXISTS (
				SELECT *
				FROM FosterPlacements CFP
				WHERE CFP.FosterChildId = CFRC.FosterChildId
				)
			AND CFRP.Accepted = 'Y'
			AND ISNULL(CFR.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFRP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFRC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
			AND CFC.ClientId IS NOT NULL

		IF @@error <> 0
			GOTO rollback_tran

		INSERT INTO FosterPlacements (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,AreSibsSplit
			,LegalStatus
			,TerminationPetitionFiled
			,PermanencyGoal
			,STATUS
			,PlacementStart
			,PlacementEnd
			,FosterCareSpecialist
			,Comment
			,IndianChildWelfare
			,TakenON
			,UploadImage
			,FosterChildId
			,ClientID
			,FosterReferralId
			,PlacementFamilyId
			,SibsSplitReason
			,PreviousPlacementId
			)
		OUTPUT INSERTED.FosterPlacementId
		INTO @CreateNewPlacements(FosterPlacementId)
		SELECT DISTINCT @UserName
			,--CreatedBy              
			GETDATE()
			,--CreatedDate              
			@UserName
			,--ModifiedBy              
			GETDATE()
			,--ModifiedDate              
			NULL
			,--RecordDeleted              
			NULL
			,--DeletedBy              
			NULL
			,--DeletedDate              
			@SibsSplitStatus
			,--AreSibsSplit              
			@GlobalCodeId
			,--LegalStatus              
			'N'
			,--TerminationPetitionFiled              
			CFR.PermanancyGoal
			,--PermanencyGoal              
			CASE 
				WHEN CAST(CFRP.StartDate AS DATE) > GETDATE()
					THEN @PendOpen
				ELSE @Open
				END
			,--Status              
			CFRP.StartDate
			,--PlacementStart              
			NULL
			,--PlacementEnd              
			CFR.FosterCareSpecialist
			,--FosterCareSpecialist              
			CFR.AdditionalInformation
			,--Comment              
			CFC.IndianChildWelfare
			,--IndianChildWelfare              
			NULL
			,--TakenON              
			NULL
			,--UploadImage              
			NC.FosterChildId
			,-- FosterChildId              
			CFC.ClientId
			,CFR.FosterReferralId
			,--  FosterReferralId      
			CFRPC.PlacementFamilyId
			,-- PlacementFamilyId      
			NULL
			,--SibsSplitReason         
			NULL --PreviousPlacementId    
		FROM #CreateNewPlacement NC
		JOIN FosterReferralPlacementChildren CFRPC ON NC.FosterChildId = CFRPC.FosterChildId
		JOIN FosterChildren CFC ON CFC.FosterChildId = CFRPC.FosterChildId
		JOIN FosterReferrals CFR ON CFR.FosterReferralId = CFC.FosterReferralId
		JOIN FosterReferralPlacements CFRP ON CFRP.FosterReferralId = CFC.FosterReferralId
			AND CFRP.PlacementFamilyId = CFRPC.PlacementFamilyId
		WHERE ISNULL(CFRPC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFR.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFRP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFRP.Accepted, 'N') = 'Y'

		UPDATE P
		SET FosterChildId = CFP.FosterChildId
		FROM FosterPlacements CFP
		JOIN @CreateNewPlacements P ON P.FosterPlacementId = CFP.FosterPlacementId

		IF @@error <> 0
			GOTO rollback_tran

		--Create Documents and DocumentVersions            
		--For Existing Clients only DocumentVersion is added            
		EXEC ssp_CreateOrUpdateDocuments @DocumentCodeId
			,@FosterReferralId
			,@UserName

		IF @@error <> 0
			GOTO rollback_tran

		--List all children who are already placed and create a new document version for the same            
		--               
		DELETE
		FROM #CreateNewPlacement

		INSERT INTO #CreateNewPlacement (
			ClientId
			,FosterChildId
			,DocumentId
			,DocumentVersion
			,AuthorId
			,EffectiveDate
			,NextReviewDate
			,LastName
			,FirstName
			,SSN
			,DOB
			,FosterReferralId
			)
		SELECT DISTINCT CFC.ClientId
			,CFRC.FosterChildId
			,NULL
			,NULL
			,CFR.FosterCareSpecialist
			,GETDATE()
			,NULL
			,CFC.LastName
			,CFC.FirstName
			,CFC.SSN
			,CFC.DOB
			,CFC.FosterReferralId
		FROM FosterReferrals CFR
		JOIN FosterREferralPlacements CFRP ON CFR.FosterReferralId = CFRP.FosterReferralId
		JOIN FosterReferralPlacementChildren CFRC ON CFRC.FosterReferralPlacementId = CFRP.FosterReferralPlacementId
		JOIN FosterChildren CFC ON CFC.FosterChildId = CFRC.FosterChildId
		WHERE CFC.FosterReferralId = @FosterReferralId
			AND EXISTS (
				SELECT *
				FROM FosterPlacements CFP
				WHERE CFP.FosterChildId = CFRC.FosterChildId
				)
			AND NOT EXISTS (
				SELECT *
				FROM #NewlyAddedClients NC
				WHERE NC.FosterChildId = CFRC.FosterChildId
				)
			AND ISNULL(CFR.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFRP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFRC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CFC.RecordDeleted, 'N') = 'N'

		-- select * from #CreateNewPlacement             
		IF @@error <> 0
			GOTO rollback_tran

		EXEC ssp_CreateOrUpdateDocuments @DocumentCodeId
			,@FosterReferralId
			,@UserName

		IF @@error <> 0
			GOTO rollback_tran

		--Update the Document AS Signed            
		UPDATE FosterReferrals
		SET DocumentSigned = 'Y'
		WHERE FosterReferralId = @FosterReferralID

		IF @@error <> 0
			GOTO rollback_tran

		--UPDATE CurrentVeHtisrsion for the  FosterChildren            
		UPDATE CFC
		SET CurrentVersion = D.CurrentDocumentVersionId
		FROM FosterChildren CFC
		JOIN Documents D ON D.ClientId = CFC.ClientId
			AND D.DocumentCodeId = @DocumentCodeId

		--Update clients table with latest data from  FosterChildren table    
		UPDATE C
		SET C.DOB = CFC.DOB
			,C.Sex = CASE 
				WHEN CFC.Sex = 5555
					THEN 'M'
				ELSE 'F'
				END
			,C.SSN = CFC.SSN
			,C.PrimaryClinicianId = CFC.CaseWorker
		FROM Clients C
		INNER JOIN FosterChildren CFC ON C.ClientId = CFC.ClientId
			AND CFC.FosterReferralId = @FosterReferralID
			AND ISNULL(CFC.RecordDeleted, 'N') = 'N'

		-- Update client Phone number     
		IF EXISTS (
				SELECT CP.ClientId
				FROM ClientPhones CP
				INNER JOIN FosterChildren CFC ON CP.ClientId = CFC.ClientId
					AND CFC.FosterReferralId = @FosterReferralID
					AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
					AND CFC.AttorneyPhoneNumber IS NOT NULL
				)
		BEGIN
			UPDATE CP
			SET CP.PhoneNumber = CFC.AttorneyPhoneNumber
			FROM ClientPhones CP
			INNER JOIN FosterChildren CFC ON CP.ClientId = CFC.ClientId
				AND CFC.FosterReferralId = @FosterReferralID
				AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			IF EXISTS (
					SELECT CFC.AttorneyPhoneNumber
					FROM Clients CP
					INNER JOIN FosterChildren CFC ON CP.ClientId = CFC.ClientId
						AND CFC.FosterReferralId = @FosterReferralID
						AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
						AND CFC.AttorneyPhoneNumber IS NOT NULL
					)
			BEGIN
				INSERT INTO ClientPhones (
					ClientId
					,PhoneType
					,PhoneNumber
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				SELECT CP.ClientId
					,30
					,CFC.AttorneyPhoneNumber
					,@UserName
					,GetDate()
					,@UserName
					,GetDate()
				FROM Clients CP
				INNER JOIN FosterChildren CFC ON CP.ClientId = CFC.ClientId
					AND CFC.FosterReferralId = @FosterReferralID
					AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
			END
		END

		-- Update client Races     
		IF EXISTS (
				SELECT CR.ClientId
				FROM ClientRaces CR
				INNER JOIN FosterChildren CFC ON CR.ClientId = CFC.ClientId
					AND CFC.FosterReferralId = @FosterReferralID
					AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
				)
		BEGIN
			UPDATE CR
			SET CR.RaceId = CFC.Race
			FROM ClientRaces CR
			INNER JOIN FosterChildren CFC ON CR.ClientId = CFC.ClientId
				AND CFC.FosterReferralId = @FosterReferralID
				AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			IF EXISTS (
					SELECT CFC.Race
					FROM Clients CR
					INNER JOIN FosterChildren CFC ON CR.ClientId = CFC.ClientId
						AND CFC.FosterReferralId = @FosterReferralID
						AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
						AND CFC.Race IS NOT NULL
					)
			BEGIN
				INSERT INTO ClientRaces (
					ClientId
					,RaceId
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				SELECT CR.ClientId
					,CFC.Race
					,@UserName
					,GetDate()
					,@UserName
					,GetDate()
				FROM Clients CR
				INNER JOIN FosterChildren CFC ON CR.ClientId = CFC.ClientId
					AND CFC.FosterReferralId = @FosterReferralID
					AND ISNULL(CFC.RecordDeleted, 'N') = 'N'
			END
		END

		IF @@error <> 0
			GOTO rollback_tran

		--Create new record in  FosterHistoryReferrals and  FosterHistoryChildren table     
		-- to maintain updated version of records       
		EXEC dbo.ssp_MaintainHistoryForReferralAndChild @FosterReferralId

		IF @@error <> 0
			GOTO rollback_tran

		EXEC [ssp_CreateStandardDOCLevels] @CreateNewPlacements
			,@UserName

		SET @Count = (
				SELECT COUNT(*)
				FROM FosterReferralPlacements
				WHERE Accepted = 'Y'
					AND FosterReferralId = @FosterReferralId
				)

		IF (@Count > 0)
		BEGIN
			SELECT 'Atleast one Child is placed';
		END
		ELSE
		BEGIN
			UPDATE FosterReferrals
			SET DocumentSigned = 'N'
			WHERE FosterReferralId = @FosterReferralID

			SELECT 'Child has not been Placed';
		END

		-- Added on 1/Dec/2016 by Irfan
		IF EXISTS (
				SELECT 1
				FROM sys.objects
				WHERE type = 'P'
					AND NAME = 'scsp_FosterCareReferralDocument'
				)
		BEGIN
			EXEC scsp_FosterCareReferralDocument @FosterReferralId
				,@UserCode
		END

		COMMIT TRAN

		IF @@error <> 0
			GOTO rollback_tran

		RETURN

		rollback_tran:

		ROLLBACK TRANSACTION
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(MAX)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SignReferralDocument') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		ROLLBACK TRANSACTION

		RAISERROR (
				@Error
				,-- Message text.                                                                                    
				16
				,-- Severity.                                                                                    
				1 -- State.                                                                                    
				);
	END CATCH
END
GO

