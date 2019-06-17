IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCProcessADTHL7Message]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCProcessADTHL7Message]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCProcessADTHL7Message] @InboundMessage XML
	,@UserCode VARCHAR(30)
AS
-- =============================================              
-- Author:  Gautam              
-- Create date: 21 Apr, 2017           
-- Description: Parse the Inbound Messages.   SWMBH - Support > Tasks #833.1   
/*              
 Author   Modified Date   Reason              
              
*/
-- =============================================              
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @HL7EncChars CHAR(5) = '|^~\&'
		DECLARE @LastName VARCHAR(50)
		DECLARE @FirstName VARCHAR(30)
		DECLARE @DOB VARCHAR(50)
		DECLARE @DOBClient DATETIME
		DECLARE @AdmitDateTime VARCHAR(50)
		DECLARE @AdmitDateTimeClient DATETIME
		DECLARE @DischargeDateTime VARCHAR(50)
		DECLARE @DischargeDateTimeClient DATETIME
		DECLARE @TransferDateTime VARCHAR(50)
		DECLARE @TransferDateTimeClient DATETIME
		DECLARE @DischargeDisposition VARCHAR(250)
		DECLARE @StreetAddress VARCHAR(200)
		DECLARE @City VARCHAR(100)
			,@StateOrProvince VARCHAR(30)
			,@Zip VARCHAR(30)
		DECLARE @Country VARCHAR(100)
		DECLARE @ADTHospitalizationId INT
		DECLARE @Gender VARCHAR(10)
			,@Race VARCHAR(100)
		DECLARE @PrimaryLanguage VARCHAR(100)
		DECLARE @MaritalStatus VARCHAR(100)
		DECLARE @InsuranceCompName VARCHAR(500)
			,@InsuranceId VARCHAR(100)
		DECLARE @VisitType VARCHAR(150)
		DECLARE @HospitalIdFirst VARCHAR(250)
			,@HospitalIdSecond VARCHAR(250)
		DECLARE @SendingFacilityIdentifier VARCHAR(250)
		DECLARE @HospitalName VARCHAR(500)
			,@PresentProblem VARCHAR(500)
			,@HomePhoneNumber VARCHAR(50)
		DECLARE @DiagnosisCode VARCHAR(100)
			,@DiagnosisDes VARCHAR(500)
		DECLARE @DiagLoop INT
		DECLARE @PreviousBed VARCHAR(50)
			,@NewBed VARCHAR(50)
		DECLARE @EventTypeCode VARCHAR(50)
			,@EventType VARCHAR(50)
			,@EventTypeId INT
		DECLARE @SNNNumber VARCHAR(100)
			,@MRNNumber VARCHAR(100)
		DECLARE @ADTHospitalizationDetailId INT

		CREATE TABLE #DiagnosisADT (
			Id INT identity(1, 1)
			,Code VARCHAR(50)
			,Descriptions VARCHAR(500)
			,DType VARCHAR(25)
			)

		-- EVN
		SELECT @EventTypeCode = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.9[1]/MSH.9.0[1]/ITEM[1]', 'VARCHAR(20)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/MSH') AS T(item)

		SELECT @EventType = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.9[1]/MSH.9.1[1]/ITEM[1]', 'VARCHAR(20)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/MSH') AS T(item)

		IF (@EventTypeCode + @EventType) NOT IN (
				'ADTA01'
				,'ADTA02'
				,'ADTA03'
				,'ADTA08'
				)
			RETURN

		SELECT TOP 1 @EventTypeId = GlobalCodeId
		FROM GlobalCodes
		WHERE Code = @EventType
			AND category = 'HL7EVENTTYPE'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT @LastName = dbo.HL7_INBOUND_XFORM(T.item.value('PID.5[1]/PID.5.0[1]/ITEM[1]', 'VARCHAR(50)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @FirstName = dbo.HL7_INBOUND_XFORM(T.item.value('PID.5[1]/PID.5.1[1]/ITEM[1]', 'VARCHAR(30)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @SNNNumber = dbo.HL7_INBOUND_XFORM(T.item.value('PID.19[1]/PID.19.0[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SET @SNNNumber = replace(@SNNNumber, '-', '')

		SELECT @DOB = dbo.HL7_INBOUND_XFORM(T.item.value('PID.7[1]/PID.7.0[1]/ITEM[1]', 'VARCHAR(50)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SET @DOBClient = cast((
					SELECT [dbo].[SSF_GetHL7ADTEventDate](@DOB)
					) AS DATE)

		SELECT TOP 1 @ClientId = ClientId
		FROM Clients
		WHERE LastName = @LastName
			AND FirstName = @FirstName
			AND DOB = @DOBClient
			AND SSN = @SNNNumber
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF NOT EXISTS (
				SELECT 1
				FROM Clients C
				WHERE ClientId = @ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
				)
			--AND C.Active = 'Y'
		BEGIN
			--Select @LastName + ' ,' + @FirstName + ' ,' + cast (@SNNNumber as varchar(50))
			--SELECT @DOB
			--select @DOBClient
			RAISERROR (
					'ClientID does not exist'
					,16
					,-- Severity.                                                                      
					1 -- State.                                                                      
					);
		END

		SELECT @TransferDateTime = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.7[1]/MSH.7.0[1]/ITEM[1]', 'VARCHAR(50)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/MSH') AS T(item)

		SELECT @TransferDateTimeClient = [dbo].[SSF_GetHL7ADTEventDate](@TransferDateTime)

		SELECT @MRNNumber = dbo.HL7_INBOUND_XFORM(T.item.value('PID.3[1]/PID.3.0[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @StreetAddress = dbo.HL7_INBOUND_XFORM(T.item.value('PID.11[1]/PID.11.0[1]/ITEM[1]', 'VARCHAR(200)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @City = dbo.HL7_INBOUND_XFORM(T.item.value('PID.11[1]/PID.11.2[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @StateOrProvince = dbo.HL7_INBOUND_XFORM(T.item.value('PID.11[1]/PID.11.3[1]/ITEM[1]', 'VARCHAR(30)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @Zip = dbo.HL7_INBOUND_XFORM(T.item.value('PID.11[1]/PID.11.4[1]/ITEM[1]', 'VARCHAR(30)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @Country = dbo.HL7_INBOUND_XFORM(T.item.value('PID.11[1]/PID.11.5[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @MaritalStatus = dbo.HL7_INBOUND_XFORM(T.item.value('PID.16[1]/PID.16.0[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @Gender = dbo.HL7_INBOUND_XFORM(T.item.value('PID.8[1]/PID.8.0[1]/ITEM[1]', 'VARCHAR(5)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @Gender = CASE 
				WHEN @Gender = 'M'
					THEN 'Male'
				WHEN @Gender = 'F'
					THEN 'Female'
				ELSE @Gender
				END

		--SELECT @Race = dbo.HL7_INBOUND_XFORM(T.item.value('PID.10[1]/PID.10.0[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		--FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)
		--SELECT @Race=case when @Race ='' then null else @Race end 
		--SELECT @Race
		SELECT @Race = dbo.HL7_INBOUND_XFORM(T.item.value('PID.10[2]/PID.10.1[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @Race = CASE 
				WHEN @Race = ''
					THEN NULL
				ELSE @Race
				END

		SELECT @PrimaryLanguage = dbo.HL7_INBOUND_XFORM(T.item.value('PID.15[1]/PID.15.0[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @HomePhoneNumber = dbo.HL7_INBOUND_XFORM(T.item.value('PID.13[1]/PID.13.0[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		SELECT @InsuranceCompName = dbo.HL7_INBOUND_XFORM(T.item.value('IN1.4[1]/IN1.4.0[1]/ITEM[1]', 'VARCHAR(500)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/IN1') AS T(item)

		SELECT @InsuranceId = dbo.HL7_INBOUND_XFORM(T.item.value('IN1.49[1]/IN1.49.0[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/IN1') AS T(item)

		SELECT @VisitType = dbo.HL7_INBOUND_XFORM(T.item.value('PV1.4[1]/PV1.4.0[1]/ITEM[1]', 'VARCHAR(50)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PV1') AS T(item)

		SELECT @HospitalIdFirst = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.4[1]/MSH.4.0[1]/ITEM[1]', 'VARCHAR(250)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/MSH') AS T(item)

		SELECT @HospitalIdSecond = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.4[1]/MSH.4.1[1]/ITEM[1]', 'VARCHAR(250)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/MSH') AS T(item)

		SELECT @SendingFacilityIdentifier = @HospitalIdFirst + '^' + @HospitalIdSecond

		SELECT @PresentProblem = dbo.HL7_INBOUND_XFORM(T.item.value('PV2.3[1]/PV2.3.1[1]/ITEM[1]', 'VARCHAR(500)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PV2') AS T(item)

		SELECT @PreviousBed = dbo.HL7_INBOUND_XFORM(T.item.value('PV1.6[1]/PV1.6.2[1]/ITEM[1]', 'VARCHAR(500)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PV1') AS T(item)

		SELECT @NewBed = dbo.HL7_INBOUND_XFORM(T.item.value('PV1.3[1]/PV1.3.2[1]/ITEM[1]', 'VARCHAR(500)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PV1') AS T(item)

		SELECT TOP 1 @HospitalName = HospitalName
		FROM ADTHospitalMaster
		WHERE rtrim(ltrim(SendingFacilityIdentifier)) = @SendingFacilityIdentifier
			AND isnull(RecordDeleted, 'N') = 'N'

		--select @HospitalName	
		-- Insert HospitalName if not exists in ADTHospitalMaster								
		--IF ISNULL(@HospitalName,'')=''
		--BEGIN
		--	Insert into ADTHospitalMaster(HospitalName,SendingFacilityIdentifier,HealthSystem,ADT)
		--	Select '',@SendingFacilityIdentifier,'','Y'
		--END
		SET @DiagLoop = 1

		WHILE @DiagLoop <> 0
		BEGIN
			SET @DiagnosisCode = NULL
			SET @DiagnosisDes = NULL

			SELECT @DiagnosisCode = dbo.HL7_INBOUND_XFORM(T.item.value('DG1.3[1]/DG1.3.0[1]/ITEM[1]', 'Varchar(250)'), @HL7EncChars)
				,@DiagnosisDes = dbo.HL7_INBOUND_XFORM(T.item.value('DG1.3[1]/DG1.3.1[1]/ITEM[1]', 'Varchar(250)'), @HL7EncChars)
			FROM @InboundMessage.nodes('HL7Message/DG1') AS T(item)
			WHERE RTRIM(LTRIM(dbo.HL7_INBOUND_XFORM(T.item.value('DG1.1[1]/DG1.1.0[1]/ITEM[1]', 'Varchar(250)'), @HL7EncChars))) = @DiagLoop

			IF ISNULL(@DiagnosisCode, '') <> ''
			BEGIN
				INSERT INTO #DiagnosisADT (
					Code
					,Descriptions
					,DType
					)
				SELECT @DiagnosisCode
					,@DiagnosisDes
					,CASE 
						WHEN @DiagLoop = 1
							THEN 'Primary'
						ELSE 'Additional'
						END
				WHERE NOT EXISTS (
						SELECT 1
						FROM #DiagnosisADT D
						WHERE D.Code = @DiagnosisCode
							AND D.Descriptions = @DiagnosisDes
						)
					AND ISNULL(@DiagnosisCode, '') <> ''

				SET @DiagLoop = @DiagLoop + 1
			END
			ELSE
			BEGIN
				SET @DiagLoop = 0
			END
		END

		SELECT @AdmitDateTime = dbo.HL7_INBOUND_XFORM(T.item.value('PV1.44[1]/PV1.44.0[1]/ITEM[1]', 'VARCHAR(50)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PV1') AS T(item)

		SELECT @AdmitDateTimeClient = [dbo].[SSF_GetHL7ADTEventDate](@AdmitDateTime)

		IF @EventType = 'A03'
		BEGIN
			SELECT @DischargeDateTime = dbo.HL7_INBOUND_XFORM(T.item.value('PV1.45[1]/PV1.45.0[1]/ITEM[1]', 'VARCHAR(50)'), @HL7EncChars)
			FROM @InboundMessage.nodes('HL7Message/PV1') AS T(item)

			--SELECT @AdmitDateTime
			SELECT @DischargeDateTimeClient = [dbo].[SSF_GetHL7ADTEventDate](@DischargeDateTime)

			SELECT @DischargeDisposition = dbo.HL7_INBOUND_XFORM(T.item.value('PV1.36[1]/PV1.36.0[1]/ITEM[1]', 'VARCHAR(250)'), @HL7EncChars)
			FROM @InboundMessage.nodes('HL7Message/PV1') AS T(item)
		END
		
		IF @EventType = 'A01'
		BEGIN
		IF @AdmitDateTimeClient is null or @AdmitDateTimeClient=''
		BEGIN
			
			RAISERROR (
					'Admit Date does not exist'
					,16
					,-- Severity.                                                                      
					1 -- State.                                                                      
					);
			RETURN
		END
		END
		
		BEGIN TRAN

		IF @EventType = 'A01'
		BEGIN
			IF NOT EXISTS (
					SELECT 1
					FROM ADTHospitalizations
					WHERE ClientId = @ClientId
						AND AdmissionDateTime = @AdmitDateTimeClient
						AND isnull(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				INSERT INTO ADTHospitalizations (
					CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,ClientId
					,AdmissionDateTime
					) --,DischargeDateTime		
				SELECT @UserCode
					,Getdate()
					,@UserCode
					,Getdate()
					,@ClientId
					,@AdmitDateTimeClient

				SET @ADTHospitalizationId = SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				ROLLBACK TRAN

				RAISERROR (
						'Client already Admited.'
						,16
						,-- Severity.                                                                      
						1 -- State.                                                                      
						);

				RETURN
			END
		END

		IF isnull(@ADTHospitalizationId, 0) = 0
		BEGIN
			SELECT TOP 1 @ADTHospitalizationId = ADTHospitalizationId
			FROM ADTHospitalizations
			WHERE ClientId = @ClientId
				AND AdmissionDateTime = @AdmitDateTimeClient
				AND isnull(RecordDeleted, 'N') = 'N'
		END

		IF @EventType = 'A01' -- Admission/ Visit
		BEGIN
			INSERT INTO ADTHospitalizationDetails (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,ADTHospitalizationId
				,MessageType
				,PatientName
				,DateofBirth
				,PatientAddress
				,MaritalStatus
				,MRN
				,SSN
				,Gender
				,Race
				,PrimaryLanguage
				,PhoneNumber
				,InsuranceCompany
				,PolicyId
				,VisitType
				,Hospital
				,PresentingProblem
				,AdmissionDateTime
				)
			SELECT @UserCode
				,Getdate()
				,@UserCode
				,Getdate()
				,@ADTHospitalizationId
				,@EventTypeId
				,@LastName + ' ' + ISNULL(@FirstName, '')
				,cast(@DOBClient AS DATE)
				,@StreetAddress + ' ' + isnull(@City, '') + ', ' + isnull(@StateOrProvince, '') + ' ' + isnull(@Zip, '')
				,@MaritalStatus
				,@MRNNumber
				,@SNNNumber
				,@Gender
				,@Race
				,@PrimaryLanguage
				,@HomePhoneNumber
				,@InsuranceCompName
				,@InsuranceId
				,@VisitType
				,@HospitalName
				,@PresentProblem
				,@AdmitDateTimeClient

			SET @ADTHospitalizationDetailId = SCOPE_IDENTITY()
		END

		IF @EventType = 'A02' -- Transfer
		BEGIN
			IF @ADTHospitalizationId IS NOT NULL
			BEGIN
				INSERT INTO ADTHospitalizationDetails (
					CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,ADTHospitalizationId
					,MessageType
					,PatientName
					,DateofBirth
					,PatientAddress
					,MaritalStatus
					,MRN
					,SSN
					,Gender
					,Race
					,PrimaryLanguage
					,PhoneNumber
					,InsuranceCompany
					,PolicyId
					,VisitType
					,Hospital
					,PresentingProblem
					,TransferDateTime
					,CurrentBed
					,PreviousBed
					)
				SELECT @UserCode
					,Getdate()
					,@UserCode
					,Getdate()
					,@ADTHospitalizationId
					,@EventTypeId
					,@LastName + ' ' + ISNULL(@FirstName, '')
					,cast(@DOBClient AS DATE)
					,@StreetAddress + ' ' + isnull(@City, '') + ', ' + isnull(@StateOrProvince, '') + ' ' + isnull(@Zip, '')
					,@MaritalStatus
					,@MRNNumber
					,@SNNNumber
					,@Gender
					,@Race
					,@PrimaryLanguage
					,@HomePhoneNumber
					,@InsuranceCompName
					,@InsuranceId
					,@VisitType
					,@HospitalName
					,@PresentProblem
					,@TransferDateTimeClient
					,@NewBed
					,@PreviousBed

				SET @ADTHospitalizationDetailId = SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				ROLLBACK TRAN

				RAISERROR (
						'Client Admission Detail does not exist'
						,16
						,-- Severity.                                                                      
						1 -- State.                                                                      
						);

				RETURN
			END
		END

		IF @EventType = 'A08' -- Update
		BEGIN
			IF @ADTHospitalizationId IS NOT NULL
			BEGIN
				INSERT INTO ADTHospitalizationDetails (
					CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,ADTHospitalizationId
					,MessageType
					,PatientName
					,DateofBirth
					,PatientAddress
					,MaritalStatus
					,MRN
					,SSN
					,Gender
					,Race
					,PrimaryLanguage
					,PhoneNumber
					,InsuranceCompany
					,PolicyId
					,VisitType
					,Hospital
					,PresentingProblem
					,UpdateDateTime
					)
				SELECT @UserCode
					,Getdate()
					,@UserCode
					,Getdate()
					,@ADTHospitalizationId
					,@EventTypeId
					,@LastName + ' ' + ISNULL(@FirstName, '')
					,cast(@DOBClient AS DATE)
					,@StreetAddress + ' ' + isnull(@City, '') + ', ' + isnull(@StateOrProvince, '') + ' ' + isnull(@Zip, '')
					,@MaritalStatus
					,@MRNNumber
					,@SNNNumber
					,@Gender
					,@Race
					,@PrimaryLanguage
					,@HomePhoneNumber
					,@InsuranceCompName
					,@InsuranceId
					,@VisitType
					,@HospitalName
					,@PresentProblem
					,@TransferDateTimeClient

				SET @ADTHospitalizationDetailId = SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				ROLLBACK TRAN

				RAISERROR (
						'Client Admission Detail does not exist'
						,16
						,-- Severity.                                                                      
						1 -- State.                                                                      
						);

				RETURN
			END
		END

		IF @EventType = 'A03' -- Discharge
		BEGIN
			IF @ADTHospitalizationId IS NOT NULL
			BEGIN
				UPDATE ADTHospitalizations
				SET DischargeDateTime = @DischargeDateTimeClient
				WHERE ADTHospitalizationId = @ADTHospitalizationId

				INSERT INTO ADTHospitalizationDetails (
					CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,ADTHospitalizationId
					,MessageType
					,PatientName
					,DateofBirth
					,PatientAddress
					,MaritalStatus
					,MRN
					,SSN
					,Gender
					,Race
					,PrimaryLanguage
					,PhoneNumber
					,InsuranceCompany
					,PolicyId
					,VisitType
					,Hospital
					,PresentingProblem
					,DischargeDateTime
					,DischargeDisposition
					)
				SELECT @UserCode
					,Getdate()
					,@UserCode
					,Getdate()
					,@ADTHospitalizationId
					,@EventTypeId
					,@LastName + ' ' + ISNULL(@FirstName, '')
					,cast(@DOBClient AS DATE)
					,@StreetAddress + ' ' + isnull(@City, '') + ', ' + isnull(@StateOrProvince, '') + ' ' + isnull(@Zip, '')
					,@MaritalStatus
					,@MRNNumber
					,@SNNNumber
					,@Gender
					,@Race
					,@PrimaryLanguage
					,@HomePhoneNumber
					,@InsuranceCompName
					,@InsuranceId
					,@VisitType
					,@HospitalName
					,@PresentProblem
					,@DischargeDateTimeClient
					,@DischargeDisposition

				SET @ADTHospitalizationDetailId = SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				ROLLBACK TRAN

				RAISERROR (
						'Client Admission Detail does not exist'
						,16
						,-- Severity.                                                                      
						1 -- State.                                                                      
						);

				RETURN
			END
		END

		IF EXISTS (
				SELECT 1
				FROM #DiagnosisADT
				)
		BEGIN
			INSERT INTO ADTHospitalizationDiagnosis (
				ADTHospitalizationDetailId
				,Code
				,DiagnosisDescription
				,DiagnosisType
				)
			SELECT @ADTHospitalizationDetailId
				,Code
				,Descriptions
				,DType
			FROM #DiagnosisADT
			ORDER BY ID
		END

		INSERT INTO ADTHospitalizationDetailMessages (
			ADTHospitalizationDetailId
			,InboundMessage
			)
		SELECT @ADTHospitalizationDetailId
			,@InboundMessage

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCProcessADTHL7Message') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		IF @@TRANCOUNT > 0 
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
