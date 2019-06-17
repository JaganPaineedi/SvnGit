IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCValidateScript]') AND type in (N'P', N'PC'))
DROP PROCEDURE scsp_SCValidateScript
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCValidateScript]    Script Date: 12/3/2013 4:35:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[scsp_SCValidateScript]
	@ClientMedicationScriptId INT
  , @CapNonControlled CHAR(1) = 'N'
  , @CapControlled CHAR(1) = 'N'
--
-- Procedure: scsp_SCValidateScript
--
-- Purpose: Check contents of script and determine whether the script may
-- be allowed to go to the next page.
--
-- Called by: the SmartCareRx
--
-- Change Log:
--  2011.01.30		T Remisoski		Created
--  9 July 2012		Swapan Mohan	For implementing message code functionality
--	July 4 2013		Chuck Blaine	Added validation of ordering quantities based on dbo.SystemConfigurations table values
--	July 8 2013		Chuck Blaine	Added validation of comment length when e-scribing since the Surescripts service
--									restricts comments to 140 characters
--  Nov 6 2013		Chuck Blaine	Moving substance caps logic to app keys in application instead of depending on database objects			
--  Dec 3, 2013     Kneale Alpers   Increased the columns ScriptIntructions and ScriptNote to max
--  Mar 6, 2014		Chuck Blaine	Substance caps initialized to 'N'  
--  Jan 28,2016     Anto Jenkins	Added ClientMedicationId condition along with the session id to get the DEA code.
-- 03/28/2017        Pranay         Added condition to check the deleted records for the client phonenumber and Client address 
AS 
	SET nocount ON

	DECLARE	@ValidationStatus NVARCHAR(MAX)
	DECLARE	@ValidationMessage NVARCHAR(MAX)
	DECLARE	@ClientValidationMessage NVARCHAR(MAX)
	DECLARE	@PrescriberValidationMessage NVARCHAR(MAX)

	DECLARE	@ScriptOutput TABLE
		(
		  ClientMedicationScriptId INT
		, PON VARCHAR(35)
		, RxReferenceNumber VARCHAR(35)
		, DrugDescription VARCHAR(250)
		, SureScriptsQuantityQualifier VARCHAR(3)
		, SureScriptsQuantity DECIMAL(29, 14)
		, TotalDaysInScript INT
		, ScriptInstructions VARCHAR(max)
		, ScriptNote VARCHAR(max)
		, Refills INT
		, DispenseAsWritten CHAR(1)
		, -- Y/N
		  OrderDate DATETIME
		, NDC VARCHAR(35)
		, RelatesToMessageID VARCHAR(35)
		, PotencyUnitCode VARCHAR(35)
		)

	BEGIN
		SET @ValidationStatus = ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'VALID_SCSP',
															  'VALID')
								)
		SET @ValidationMessage = ''
	END

	BEGIN TRY
--
-- check for key information in the client record
--

		SELECT Top 1	@ClientValidationMessage = CASE	WHEN LEN(ISNULL(LTRIM(RTRIM(c.FirstName)),
															  '')) = 0
												THEN ( SELECT dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTFNAMEREQ_SCSP',
															  'Client first name required on all scripts. ')
													 )
												ELSE ''
										   END
				+ CASE WHEN LEN(ISNULL(LTRIM(RTRIM(c.LastName)), '')) = 0
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTLNAMEREQ_SCSP',
															  'Client last Name required on all scripts. ')
							)
					   ELSE ''
				  END
				+ CASE WHEN DATEDIFF(day, GETDATE(), c.DOB) > 0
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTDOBINVALID_SCSP',
															  'Client date of birth is invalid. ')
							)
					   ELSE ''
				  END
				+ CASE WHEN c.DOB IS NULL
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTDOBREQ_SCSP',
															  'Client date of birth is required on all scripts. ')
							)
					   ELSE ''
				  END
				+ CASE WHEN ISNULL(c.Sex, '') NOT IN ( 'M', 'F' )
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTSEXREQ_SCSP',
															  'Client sex is required on all scripts. ')
							)
					   ELSE ''
				  END
				  + CASE WHEN CA.Address IS NULL
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTSEXREQ_SCSP',
															  'Client address is required on all scripts. ')
							)
					   ELSE ''
				  END
				  + CASE WHEN CP.PhoneNumber IS NULL
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTSEXREQ_SCSP',
															  'Client phone number is required on all scripts. ')
							)
					   ELSE ''
				  END
		FROM	Clients AS c
				LEFT JOIN ClientMedicationScriptsPreview AS cms ON cms.ClientId = c.ClientId
				LEFT JOIN ClientAddresses CA ON CA.ClientId = c.ClientId
				LEFT JOIN ClientPhones CP ON CP.ClientId = c.ClientId 
				AND 
				cp.PhoneType = 30  
				AND CA.AddressType=90 AND 
				ISNULL(ca.RecordDeleted,'N')='N'
				AND ISNULL(cp.RecordDeleted,'N')='N'
				Where cms.ClientMedicationScriptId =@ClientMedicationScriptId

		-- Based on dbo.SystemConfiguration values, determine if this order has exceeded the 6 month/12 month order limits
		-- for Controlled or Non-controlled substances, respectively

		DECLARE	@DEACode VARCHAR(100)
		DECLARE	@ScriptContainsControlledMedications VARCHAR(3) = 'N'
		DECLARE	@SessionId VARCHAR(30)
		DECLARE @ClientMedicationId int
		SELECT	@SessionId = SessionId
		FROM	dbo.ClientMedicationScriptDrugsPreview
		WHERE	ClientMedicationScriptId = @ClientMedicationScriptId
		
		
		SELECT @ClientMedicationId = CM.ClientMedicationId FROM  ClientMedicationScriptsPreview CMS  
                        INNER JOIN ClientMedicationScriptDrugsPreview CMSD ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId
                        INNER JOIN ClientMedicationInstructionsPreview CMI ON CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId                                 INNER JOIN ClientMedicationsPreview CM ON CM.ClientMedicationId = CMI.ClientMedicationId AND ISNULL(CM.Discontinued,'N') <> 'Y'      
                WHERE   
                         CMS.ClientMedicationScriptId = @ClientMedicationScriptId

		SELECT	@DEACode = ISNULL(MAX(dbo.[ssf_SCClientMedicationC2C5Drugs](cmi.StrengthId)),
								  '')
		FROM	ClientMedicationInstructionsPreview AS cmi
		WHERE	cmi.SessionId = @SessionId and cmi.ClientMedicationId = @ClientMedicationId
				AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'

		IF @DEACode IN ( '1', '2', '3', '4', '5' ) 
			SET @ScriptContainsControlledMedications = 'Y'

		IF ( @CapControlled = 'Y' )
			-- Validate controlled substance amounts
			BEGIN
				SELECT	@ClientValidationMessage = ISNULL(@ClientValidationMessage,
														  '')
						+ ' Ordering greater than a 180 day supply of controlled substances is prohibited.'
				FROM	dbo.ClientMedicationScriptDrugsPreview
				WHERE	ClientMedicationScriptId = @ClientMedicationScriptId
						AND ( ISNULL(Days, 0) * ISNULL(Refills + 1, 1) > 180 )
						AND @ScriptContainsControlledMedications = 'Y'
			END        
		IF ( @CapNonControlled = 'Y' )
			-- Validate non-controlled substance amounts
			BEGIN
				SELECT	@ClientValidationMessage = ISNULL(@ClientValidationMessage,
														  '')
						+ ' Ordering greater than a year supply of non-controlled substances is prohibited.'
				FROM	dbo.ClientMedicationScriptDrugsPreview
				WHERE	ClientMedicationScriptId = @ClientMedicationScriptId
						AND ( ISNULL(Days, 0) * ISNULL(Refills + 1, 1) > 365 )
						AND @ScriptContainsControlledMedications = 'N'
			END
			
		-- If script is going out via E-scribing, then the comment needs to be less than or equal to 140 characters
		SELECT	@ClientValidationMessage = ISNULL(@ClientValidationMessage, '')
				+ ' Prescription comments cannot be longer than 140 characters when sending via Surescripts.'
		FROM	dbo.ClientMedicationScriptsPreview cmsp
				JOIN dbo.ClientMedicationScriptDrugStrengthsPreview cmsdsp ON cmsdsp.ClientMedicationScriptId = cmsp.ClientMedicationScriptId
				JOIN dbo.ClientMedicationsPreview cmp ON cmp.ClientMedicationId = cmsdsp.ClientMedicationId
		WHERE	cmsp.ClientMedicationScriptId = @ClientMedicationScriptId
				AND cmsp.OrderingMethod = 'E'
				AND LEN(cmp.Comments) > 140    
				
 --Added by Nandita EPCS Task#44 validation for NA DEA for the given list of drugs
	  DECLARE @MedicationNameId INT
	  SELECT @MedicationNameId=MedName.MedicationNameId FROM	ClientMedicationScriptsPreview AS cms
							JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
															  AND ISNULL(cmsd.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
															  AND ISNULL(cmi.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
															  AND ISNULL(cm.RecordDeleted,'N') <> 'Y'
							JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
												AND ISNULL(MedName.RecordDeleted,
														   'N') <> 'Y'
							WHERE @ClientMedicationScriptId = cms.ClientMedicationScriptId AND 
							ISNULL(cms.RecordDeleted, 'N') <> 'Y'

		CREATE TABLE #tempMedicationName 
		(MedicationNameId int not null primary key,      
		MedicationName varchar(100))

		INSERT INTO #tempMedicationName EXEC ssp_MMGetAlternativeMedicationNames @MedicationNameId

		DECLARE @NADEA VARCHAR(25)
		SET @NADEA = ''
		IF EXISTS (SELECT #tempMedicationName.MedicationNameId FROM #tempMedicationName WHERE #tempMedicationName.MedicationName LIKE '%Xyrem%' OR #tempMedicationName.MedicationName LIKE '%Subutex%' OR #tempMedicationName.MedicationName like '%Gamma-Hydroxybutyric Acid%' OR 
		#tempMedicationName.MedicationName like  '%Suboxone%' OR #tempMedicationName.MedicationName like '%Zubsolv%' OR #tempMedicationName.MedicationName like '%Bunavail%')
		BEGIN
		SELECT @NADEA=sldForNADEA.LicenseNumber FROM	ClientMedicationScriptsPreview AS cms
									JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
																	  AND ISNULL(cmsd.RecordDeleted,
																	  'N') <> 'Y'
									JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
																	  AND ISNULL(cmi.RecordDeleted,
																	  'N') <> 'Y'
									JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
																	  AND ISNULL(cm.RecordDeleted,'N') <> 'Y'
									JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
														AND ISNULL(MedName.RecordDeleted,
																   'N') <> 'Y'
									JOIN Staff AS st ON st.StaffId = cm.PrescriberId
														AND ISNULL(st.RecordDeleted,
																   'N') <> 'Y'
									JOIN StaffLicenseDegrees as sldForNADEA  ON sldForNADEA.StaffId=st.StaffId
									WHERE 
									sldForNADEA.LicenseTypeDegree =9404 AND sldForNADEA.PrimaryValue='Y' AND
									(sldForNADEA.EndDate is null or getdate() BETWEEN sldForNADEA.StartDate AND (DATEADD(day,1,sldForNADEA.EndDate)) ) and
									@ClientMedicationScriptId = cms.ClientMedicationScriptId AND 
									ISNULL(cms.RecordDeleted, 'N') <> 'Y'
		IF(@NADEA='')
		BEGIN
			SET @ClientValidationMessage =ISNULL(@ClientValidationMessage, '')
				+  ' NA DEA number is required for this prescription.'
		end
		END		
		
		DECLARE @PresciberId INT

SELECT @PresciberId=cm.PrescriberId FROM	ClientMedicationScriptsPreview AS cms
									JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
																	  AND ISNULL(cmsd.RecordDeleted,
																	  'N') <> 'Y'
									JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
																	  AND ISNULL(cmi.RecordDeleted,
																	  'N') <> 'Y'
									JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
																	  AND ISNULL(cm.RecordDeleted,'N') <> 'Y'
									JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
														AND ISNULL(MedName.RecordDeleted,
																   'N') <> 'Y'
									JOIN Staff AS st ON st.StaffId = cm.PrescriberId
														AND ISNULL(st.RecordDeleted,
																   'N') <> 'Y'
								WHERE 
									@ClientMedicationScriptId = cms.ClientMedicationScriptId AND 
									ISNULL(cms.RecordDeleted, 'N') <> 'Y'

								
SELECT	@PrescriberValidationMessage = CASE	WHEN LEN(ISNULL(LTRIM(RTRIM(St.FirstName)),
															  '')) = 0
												THEN ( SELECT dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTFNAMEREQ_SCSP',
															  'Prescriber first name required on all scripts. ')
													 )
												ELSE ''
										   END
				+ CASE WHEN LEN(ISNULL(LTRIM(RTRIM(St.LastName)), '')) = 0
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTLNAMEREQ_SCSP',
															  'Prescriber last Name required on all scripts. ')
							)
					   ELSE ''
				  END
				  + CASE WHEN St.Address IS NULL
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTSEXREQ_SCSP',
															  'Prescriber address is required on all scripts. ')
							)
					   ELSE ''
				  END
				  + CASE WHEN St.PhoneNumber IS NULL OR St.PhoneNumber=''
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTSEXREQ_SCSP',
															  'Prescriber phone number is required on all scripts. ')
							)
					   ELSE ''
				  END
				   + CASE WHEN SLD.LicenseNumber IS NULL OR SLD.LicenseNumber=''
					   THEN ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'CLIENTSEXREQ_SCSP',
															  'Prescriber DEA number is required on all scripts. ')
							)
					   ELSE ''
				  END
		FROM	staff AS St 
				LEFT JOIN StaffLicenseDegrees SLD ON SLD.StaffId = St.StaffId WHERE ISNULL(SLD.RecordDeleted,'N') <> 'Y' AND SLD.LicenseTypeDegree=9403 AND St.StaffId=@PresciberId
		
		SET @ClientValidationMessage =ISNULL(@ClientValidationMessage, '')
				+  @PrescriberValidationMessage		
				   

		IF LEN(@ClientValidationMessage) > 0 
			BEGIN
				SET @ValidationStatus = ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'INVALID_SCSP',
															  'INVALID')
										)
				SET @ValidationMessage = ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'SCRIPTNOTCOMPLETED_SCSP',
															  'Script cannot be completed: ')
										 ) + @ClientValidationMessage
			END
		ELSE 
			BEGIN
				INSERT	INTO @ScriptOutput
						( ClientMedicationScriptId
						, PON
						, RxReferenceNumber
						, DrugDescription
						, SureScriptsQuantityQualifier
						, SureScriptsQuantity
						, TotalDaysInScript
						, ScriptInstructions
						, ScriptNote
						, Refills
						, DispenseAsWritten
						, OrderDate
						, NDC
						, RelatesToMessageID
						, PotencyUnitCode 
                        )
						EXEC scsp_SureScriptsScriptOutput 
							@ClientMedicationScriptId
						  , 'Y'
			END          

----
---- move this to paper-only validation
----
--if exists(select * from @ScriptOutput where datediff(day, getdate(), OrderDate) > 0)
--begin
--   set @ValidationStatus = 'INVALID'
--   set @ValidationMessage = substring(@ValidationMessage + 'Electronic scripts cannot be post-dated;', 1, 200)
--end


	END TRY


	BEGIN CATCH

		DECLARE	@error_no INT
		DECLARE	@error_message NVARCHAR(4000)

		SET @error_no = ERROR_NUMBER()
		SET @error_message = ERROR_MESSAGE()

		IF @error_no = 8152  -- string or binary data truncation
			BEGIN
				SET @ValidationStatus = ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'INVALID_SCSP',
															  'INVALID')
										)
				SET @ValidationMessage = ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  '#OFCHAREXCEED_SCSP',
															  'The number of characters in "Instructions" and/or "Note" exceed the limits established for e-Prescribing systems. Please revise or break up the script.')
										 )
			END
		ELSE 
			BEGIN
				SET @ValidationStatus = ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'INVALID_SCSP',
															  'INVALID')
										)
				SET @ValidationMessage = SUBSTRING(( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'UNEXPERROR_SCSP',
															  'Unexpected error:')
												   )
												   + CAST(@error_no AS VARCHAR)
												   + ( SELECT dbo.Ssf_GetMesageByMessageCode(29,
															  'ENCOUNTEREDPCTS_SCSP',
															  'encountered. Please contact tech support. Additional Information:')
													 ) + @error_message, 1,
												   200)
			END



	END CATCH

	SELECT	@ClientMedicationScriptId AS ClientMedicationScriptId
		  , @ValidationStatus AS ValidationStatus
		  , @ValidationMessage AS ValidationMessage




GO