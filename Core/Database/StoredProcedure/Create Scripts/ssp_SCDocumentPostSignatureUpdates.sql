/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentPostSignatureUpdates]    Script Date: 12/15/2015 10:04:01 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentPostSignatureUpdates]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SCDocumentPostSignatureUpdates]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentPostSignatureUpdates]    Script Date: 12/15/2015 10:04:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCDocumentPostSignatureUpdates]
    @CurrentUserId INT ,
    @DocumentId INT
AS /******************************************************************************                                              
**  File: Document.cs(SmartCare - Web)                                              
**  Name:                             
**  Desc:                              
**  Return values:                                              
**  Called by: [DocumentPostSignatureUpdates function in DataService.Document.cs]                                               
**  Parameters:                                              
**  Input @CurrentUserId,@DocumentId    Output                           
**                                                            
**  Auth:  Rakesh                      
                                     
************************************************************************************************************************                                              
**  Change History                                              
************************************************************************************************************************                                              
**  Date:       Author:     Description:  
	--------	-------------	------------------------------------------------ 
	07/11/2011	Rakesh Garg		Now scsp_SCDocumentPostSignatureUpdates wiil be called from this sp Ref to task 140 in 
								SCWeb Phase II Bug/Features    
	10/24/2013	John Sudhakar	Added functionality to set SignatureDate as EffectiveDate when a flag in DocumentCodes 
								table is set.                                    
	12/15/2015  Akwinass		Update ServiceDiagnosis Table on sign of Services (Task #272 in Engineering Improvement 
								Initiatives- NBL(I))                                          
	29-April-2016  Deej			Added the logic to update E&M Procedure CodeId to Service ProcedureCodeId 
	24-Aug-2016 Venkatesh		Added the logic to update E&M Procedure CodeId is billable or not to Service 
								ProcedureCodeId as per task Camino Support Go Live - 96
	02-02-2017  NJain			Updated to also look for signed status when changing effective date to signature date 
								MFS SGL #63
	02/16/2017	Ting-Yu Mu		Added te logic to check for Recodes to see if it is needed to overrride the service
								ProcedureCodeId as per Valley - Support Go Live #1038
	25-APRIL-2017 Akwinass		What:Refreshing charge, if there is a change on service procedure code
								Why: Charge not calculating based on procedure codes (Task #972 in Key Point - Support Go Live).
	30-NOC-2017	Chethan N		What: Moved Post Update logic of Client Orders as Client Orders can be added from Custom document through Client Order Control.
								Why: Engineering Improvement Initiatives- NBL(I) task #585 .
	01-MAR-2018 Pradeep Y		What:I have changed the condition and checked >= because they want to update events table based on latest sign version
								Why :For task #1368 SWMBH Support
	12-MAR-2018 Akwinass        What:Added code to skip custom post update when "NoteReplacement" value is "Y".
								Why:Task #589.1 in Engineering Improvement Initiatives- NBL(I)				
	19-Jun-2018 Chethan N	    What : Avoided calling Client Order PostUpdate SP on co-sign.
								Why : AHN Support GO live Task #307					
	23-July-2018 Vijay P	    What:Updated this sp for Completing the Flag while signing the document
								Why:Engineering Improvement Initiatives- NBL(I) - Task#590
								
	28-August-2018 Mrunali P	What: When a new document is signed it will remove all the to do document that is present for that particular document and client, whose effective date is lesser than the current document's effective date that is being signed
								Why :Porter Starke-Environment Issues Tracking: Task# 167	
	06-Sep-2018   Swatika	    What/Why: Added scsp_SCDocumentPostSignatureCommonUpdate, because MHP has requested to generate DSM5 document after signing any document which has diagnosisdocument = Y set in the documentcodes table  
								as part of MHP - Enhancements: Task# #34. Since this is a custom change I have added the custom change in  SCSP just for MHP. One SCSP is created in core as a stub which no logic													
**  --------	-------------	------------------------------------------------                                              
************************************************************************************************************************/
    BEGIN
        BEGIN TRY
            DECLARE @EventID AS INT
            DECLARE @version AS INT
            DECLARE @SignatureDateAsEffectiveDate AS CHAR(1)
            DECLARE @DocumentVersionId INT
            DECLARE @NotBillable CHAR(1)
            DECLARE @ClientOrderDocument CHAR(1)
            DECLARE @CurrentUser VARCHAR (30)
            DECLARE @CountDocumentSignature INT
			DECLARE @UserCode VARCHAR(30) 
			
            SELECT  @version = v.version ,
                    @EventId = EventId
            FROM    Documents AS d
                    INNER JOIN DocumentVersions V ON d.CurrentDocumentVersionId = V.DocumentVersionId
            WHERE   d.DocumentId = @DocumentId

            IF ( @EventID > 0
                 AND @version >= 1        ---- Pradeep Y
               )							
               
                BEGIN
			--Update events status as completed  whenever document get signed first time 
                    UPDATE  [Events]
                    SET     [Status] = 2063
                    WHERE   EventId = @EventID
                END

		--Check if the SignatureDateAsEffectiveDate is 'Y'. If so, update the SignatureDate As EffectiveDate for the current document.
            SELECT  @SignatureDateAsEffectiveDate = ISNULL(SignatureDateAsEffectiveDate, 'N') ,
                    @DocumentVersionId = D.InProgressDocumentVersionId,
                    @CurrentUser = D.ModifiedBy,
                    @ClientOrderDocument = ISNULL(DC.ClientOrder, 'N')
            FROM    DocumentCodes DC
                    INNER JOIN Documents D ON D.DocumentCodeId = DC.DocumentCodeId
                                              AND D.DocumentId = @DocumentId

            IF ( @SignatureDateAsEffectiveDate = 'Y' )
                BEGIN
                    UPDATE  a
                    SET     EffectiveDate = CAST(GETDATE() AS DATE)
                    FROM    dbo.Documents a
                    WHERE   a.DocumentId = @DocumentId
                            AND a.Status = 22
                            AND ( EXISTS ( SELECT   ds.DocumentId
                                           FROM     dbo.DocumentSignatures ds
                                           WHERE    ds.SignatureDate IS NOT NULL
                                                    AND ds.DocumentId = a.DocumentId
                                                    AND ISNULL(ds.RecordDeleted, 'N') = 'N'
                                                    AND ds.StaffId = a.AuthorId
                                                    AND CAST(ds.SignatureDate AS DATE) = CAST(GETDATE() AS DATE)
                                           GROUP BY ds.DocumentId
                                           HAVING   COUNT(DISTINCT ds.SignatureId) = 1 )
                                  OR EXISTS ( SELECT    ds.DocumentId
                                              FROM      dbo.DocumentSignatures ds
                                              WHERE     ds.SignatureDate IS NOT NULL
                                                        AND ds.DocumentId = a.DocumentId
                                                        AND ISNULL(ds.RecordDeleted, 'N') = 'N'
                                                        AND ds.StaffId = a.ReviewerId
                                                        AND CAST(ds.SignatureDate AS DATE) = CAST(GETDATE() AS DATE)
                                              GROUP BY  ds.DocumentId
                                              HAVING    COUNT(DISTINCT ds.SignatureId) = 1 )
                                )
                END
	 --Changes by Deej 20-April-2016
            IF EXISTS ( SELECT  1
                        FROM    NoteEMCodeOptions
                        WHERE   DocumentVersionId = @DocumentVersionId
                                AND ProcedureCodeId IS NOT NULL
                                AND ISNULL(RecordDeleted, 'N') = 'N' )
                BEGIN
                    DECLARE @ServiceId INT
                    DECLARE @ProcedureCodeId INT
                    SELECT  @ServiceId = s.ServiceId
                    FROM    Documents d
                            JOIN Services s ON s.ServiceId = d.ServiceId
                    WHERE   d.DocumentId = @DocumentId
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                    SELECT TOP 1
                            @ProcedureCodeId = o.ProcedureCodeId
                    FROM    NoteEMCodeOptions o
                    WHERE   DocumentVersionId = @DocumentVersionId
                            AND ISNULL(o.RecordDeleted, 'N') = 'N'
			
			-- Added below code by Venkatesh as per task Camino Support Go Live - 96
		     
                    SELECT  @NotBillable = NotBillable
                    FROM    ProcedureCodes
                    WHERE   Procedurecodeid = @ProcedureCodeId   
                    IF @NotBillable = 'N'
                        BEGIN
                            SET @NotBillable = 'Y'
                        END
                    ELSE
                        BEGIN
                            SET @NotBillable = 'N'
                        END
		     -- End of changes by Venkatesh
			
			-- Changed by TMU 02/16/2017 as per Valley - Support Go Live #1038
			IF NOT EXISTS -- Check if Procedure code should not to be overridden
			(
				SELECT ProcedureCodeId 
				FROM dbo.Services 
				WHERE ServiceId=@ServiceId 
				AND ProcedureCodeId IN 
				(
					SELECT IntegerCodeId FROM dbo.ssf_RecodeValuesCurrent('EMCodeProcCodeOverride')
				)
			)
			BEGIN -- Override the ProcedureCodeId
					
					--25-APRIL-2017 Akwinass
					--Refreshing charge if there is a change on Procedure Codes					
					IF EXISTS(SELECT 1 FROM Services s
                    WHERE   s.ServiceId = @ServiceId
                            AND s.ProcedureCodeId <> @ProcedureCodeId)
                    BEGIN
						DECLARE @Charge MONEY = NULL
						DECLARE @ProcedureRateId INT = NULL
					
						DECLARE @ClientId INT
						DECLARE @DateOfService DATETIME
						DECLARE @ClinicianId INT
						DECLARE @UnitValue DECIMAL(18, 2)
						DECLARE @ProgramId INT
						DECLARE @LocationId INT
						
						SELECT TOP 1 @ClientId = ClientId
							,@DateOfService = DateOfService
							,@ClinicianId = ClinicianId
							,@UnitValue = Unit
							,@ProgramId = ProgramId
							,@LocationId = LocationId
						FROM Services
						WHERE ServiceId = @ServiceId
							AND ISNULL(RecordDeleted,'N') = 'N'
						
						IF @ClientId IS NOT NULL
						BEGIN
							EXEC dbo.ssp_PMServiceCalculateCharge @ClientId = @ClientId, -- int
								@DateOfService = @DateOfService, -- datetime
								@ClinicianId = @ClinicianId, -- int
								@ProcedureCodeId = @ProcedureCodeId, -- int
								@Units = @UnitValue, -- decimal
								@ProgramId = @ProgramId, -- int
								@LocationId = @LocationId, -- int
								@ProcedureRateId = @ProcedureRateId OUTPUT, -- int
								@Charge = @Charge OUTPUT -- money                
		                    
		                    
							UPDATE  dbo.Services
							SET     Charge = @Charge ,
									ProcedureRateId = @ProcedureRateID
							WHERE   ServiceId = @ServiceId
								AND ISNULL(RecordDeleted,'N') = 'N'
						END					
                    END
                    
                    UPDATE  s
                    SET     ProcedureCodeId = @ProcedureCodeId ,
                            Billable = @NotBillable -- Added by Venkatesh
                    FROM    Services s
                    WHERE   s.ServiceId = @ServiceId
                            AND s.ProcedureCodeId <> @ProcedureCodeId
                END
			-- End of change by TMU
		END
		--End of the changes by Deej		
            DECLARE @NoteReplacement CHAR(1)
			DECLARE @AllowAttachmentsToService CHAR(1)

			SELECT TOP 1 @NoteReplacement = S.NoteReplacement
				,@AllowAttachmentsToService = PC.AllowAttachmentsToService
			FROM Documents D
			JOIN Services S ON D.ServiceId = S.ServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N' 
			JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			WHERE D.DocumentId = @DocumentId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'		
			SET @NoteReplacement = ISNULL(@NoteReplacement, 'N')
			IF ISNULL(@AllowAttachmentsToService, 'N') = 'N'
				SET @NoteReplacement = 'N'
			
			IF ISNULL(@NoteReplacement,'N') <> 'Y'
			BEGIN
				-- Custom code for different customers will be written in below scsp_SCDocumentPostSignatureUpdates for PostUpdate Signatures. Now this scsp will not called direclty from application.
				EXEC scsp_SCDocumentPostSignatureUpdates @CurrentUserId, @DocumentId
			END
		
		--12/15/2015   Akwinass
            IF EXISTS ( SELECT  *
                        FROM    sys.objects
                        WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentPostSignatureServiceDiagnosisUpdate]')
                                AND type IN ( N'P', N'PC' ) )
                AND EXISTS ( SELECT 1
                             FROM   SystemConfigurationKeys
                             WHERE  [key] = 'DISABLEBILLINGDXIFSERVICENOTEISDX'
                                    AND ISNULL(RecordDeleted, 'N') = 'N'
                                    AND ISNULL(Value, 'N') = 'Y' )
                BEGIN
                    EXEC ssp_SCDocumentPostSignatureServiceDiagnosisUpdate @CurrentUserId, @DocumentId
                END
                
                
               --09/06/2018   Swatika
               IF EXISTS (SELECT  1  
				FROM    sys.objects  
				WHERE   object_id = OBJECT_ID(N'scsp_SCDocumentPostSignatureCommonUpdate')  
						AND type IN ( N'P', N'PC' ))     
				BEGIN
							EXEC scsp_SCDocumentPostSignatureCommonUpdate @CurrentUserId, @DocumentId
				END
                
        --16/19/2018   Chethan N -- To avoid calling Client Order PostUpdate SP on co-sign.
			SELECT @CountDocumentSignature = COUNT(DS.DocumentId) 
			FROM DocumentSignatures DS
			WHERE DS.DocumentId = @DocumentId and DS.SignatureDate IS NOT NULL
                
		
		--10/25/2015   Chethan N
            IF (@ClientOrderDocument = 'Y' AND @CountDocumentSignature = 1)
                BEGIN
                    EXEC ssp_PostOrderSignature @DocumentId, @CurrentUserId, @CurrentUser, NULL
                END
           
           --Added by Vijay	  07/26/2018 
           IF (@DocumentId > 0)
            BEGIN
				DECLARE @ClientId1 INT
				DECLARE @DocumentCodeId INT
				
				SELECT @ClientId1 = ClientId, @DocumentCodeId = DocumentCodeId, @UserCode = ModifiedBy FROM Documents 
				WHERE DocumentId = @DocumentId AND ISNULL(RecordDeleted, 'N') = 'N'
				
				IF EXISTS (SELECT 1 FROM ClientNotes WHERE ClientId = @ClientId1 AND DocumentCodeId = @DocumentCodeId AND EndDate is null)
				BEGIN	
					--To update ClientNotes.DocumentId column value
					UPDATE ClientNotes SET ModifiedBy=@UserCode, ModifiedDate=GETDATE(), DocumentId = @DocumentId 
					WHERE ClientId = @ClientId1 AND DocumentCodeId = @DocumentCodeId 
					   AND EndDate is null
					   AND DocumentId is null
					   AND Active = 'Y' 
					   AND ISNULL(RecordDeleted, 'N') = 'N'	
					
					--Complete the Flag				
					EXEC ssp_CompleteFlags -1, @UserCode, @ClientId1, @DocumentId, @DocumentCodeId, -1, ''
				END
            END
            
            --Added By Mrunali 21/08/2018 Porter Starke-Environment Issues Tracking: Task# 167
            IF (@DocumentId > 0)
            BEGIN
				DECLARE @ToDoClientId INT
				DECLARE @CurrentDocumentCodeId INT
				DECLARE @EffectiveDate DATETIME
				DECLARE @DeletedUserCode VARCHAR(30) 
				SELECT @ToDoClientId = ClientId, @CurrentDocumentCodeId = DocumentCodeId,@EffectiveDate =EffectiveDate, @DeletedUserCode = ModifiedBy FROM Documents 
				WHERE DocumentId = @DocumentId AND ISNULL(RecordDeleted, 'N') = 'N'
				
				IF EXISTS (SELECT 1 FROM Documents WHERE ClientId = @ToDoClientId AND DocumentCodeId = @CurrentDocumentCodeId AND EffectiveDate <=  @EffectiveDate AND STATUS=20 AND ISNULL(RecordDeleted, 'N') = 'N'  )
				BEGIN	
					--DELETE RECORDS FROM DocumentVersions TABLE
					UPDATE DocumentVersions SET RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@DeletedUserCode
					WHERE DocumentId IN( SELECT DocumentId FROM Documents WHERE ClientId = @ToDoClientId AND DocumentCodeId = @CurrentDocumentCodeId AND EffectiveDate <=  @EffectiveDate AND STATUS=20 AND ISNULL(RecordDeleted, 'N') = 'N'   )
					
					--DELETE RECORDS FROM Documents  TABLE	
					UPDATE Documents SET RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@DeletedUserCode
					WHERE ClientId = @ToDoClientId AND DocumentCodeId = @CurrentDocumentCodeId AND EffectiveDate <=  @EffectiveDate AND STATUS=20 AND ISNULL(RecordDeleted, 'N') = 'N'
					
				END
            END
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCDocumentPostSignatureUpdates]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (@Error,-- Message text.                                            
				16,-- Severity.                                            
				1 -- State.                                            
				);
        END CATCH
    END
GO





