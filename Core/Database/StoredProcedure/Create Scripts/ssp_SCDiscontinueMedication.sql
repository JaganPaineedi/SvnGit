
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SCDiscontinueMedication' )
    DROP PROCEDURE [dbo].[ssp_SCDiscontinueMedication];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO



CREATE PROCEDURE [dbo].[ssp_SCDiscontinueMedication]
    (
      @ClientMedicationId AS INT ,
      @Discontinue AS CHAR(1) ,
      @ModifiedBy AS VARCHAR(100) ,
      @DiscontinueReason AS VARCHAR(1000) ,
      @DiscontinueReasonCode AS INT ,
      @ClientMedicationConsentId AS INT = NULL ,
      @SureScriptsOutgoingMessageId AS VARCHAR(30) = NULL ,
      @MethodName VARCHAR(1) = '' ,
      @PrescriberId INT = NULL,
	  @PharmacyId INT=NULL
    )
AS /*********************************************************************/                                                          
/* Stored Procedure: [dbo].[ssp_SCDiscontinueMedication]                */                                                          
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                          
/* Creation Date:    6/23/06                                         */                                                          
/*                                                                   */                                                          
/* Purpose:   This procedure is used to Discontinue the Medication for the passed MedicationId  */                                                        
/*                                                                   */                                                        
/* Input Parameters: @ClientMedicationId,@ModifiedBy              */                                                        
/*                                                                   */                                                          
/* Output Parameters:        */                                                          
/*                                                                   */                                                          
/* Return:  0=success, otherwise an error number                     */                                                          
/*                                                                   */                                                          
/* Called By:                                                        */                                                          
/*                                                                   */                                                          
/* Calls:                                                            */                                                          
/*                                                                   */                                                          
/* Data Modifications:                                               */                                                          
/*                                                                   */                                                          
/* Updates:                                                          */                                                          
/*  Date     Author               Purpose                                    */                                                          
                                       
/* 15/11/07      Sonia Dhamija        Created     */                    
/*11th April     2009 Chandan Modified (DiscontinuedReasonCode)  */   
/*12March2010    Loveena Modified(In ref to Task#19 as per the datamodel changes from ClientMedicationID to ClientMedicationInstructionId in clientMedicationConsents)*/     
/*Jan 15,2014    Kalpers added the Method name and prescriber id and added a check for the method name */                                  
/*Nov 13,2017    Wbutt added logic for cancel or discontinue as the cancel status */      
/*April 13,2018  Pranay Added DiscontinuedMethod w.r.t to task#581.1 AspenPonte-SGL */                            
/*********************************************************************/                                                           
                                                      
    DECLARE @OutgoingMessageId INT = -1;

    IF ( @SureScriptsOutgoingMessageId IS NOT NULL
         AND CAST(@SureScriptsOutgoingMessageId AS INT) > 0
       )
        BEGIN 
            SET @OutgoingMessageId = CAST(@SureScriptsOutgoingMessageId AS INT);
        END; 

		
                                                       
    BEGIN TRAN;                                                          
                                                      
                                                   
    BEGIN                                             
         
        UPDATE  ClientMedications
        SET     Discontinued = @Discontinue ,
                DiscontinueDate = GETDATE() ,
                ModifiedDate = GETDATE() ,
                ModifiedBy = @ModifiedBy ,
                DiscontinuedReason = @DiscontinueReason ,
                DiscontinuedReasonCode = @DiscontinueReasonCode,
				DiscontinuedMethod=@MethodName,
			    PharmacyId =@PharmacyId     
        WHERE   ClientMedicationId = @ClientMedicationId;             
      
-- JHB      
-- Terminate consent if exists      
        DECLARE @OffLabel CHAR(1) ,
            @MedicationNameId INT ,
            @ClientId INT;      
      
        SELECT  @ClientId = ClientId ,
                @MedicationNameId = MedicationNameId ,
                @OffLabel = OffLabel
        FROM    ClientMedications
        WHERE   ClientMedicationId = @ClientMedicationId;      
      
        UPDATE  d
        SET     ConsentEndDate = GETDATE() ,
                RevokedByClientRepresentative = CASE WHEN @DiscontinueReasonCode = 5511
                                                     THEN 'Y'
                                                     ELSE NULL
                                                END
        FROM    Documents a
                JOIN DocumentVersions b ON ( a.DocumentId = b.DocumentId )
                JOIN ClientMedicationConsentDocuments c ON ( b.DocumentVersionId = c.DocumentVersionId )
                JOIN ClientMedicationConsents d ON ( c.DocumentVersionId = d.DocumentVersionId )
                JOIN ClientMedicationInstructions CMI ON ( d.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId )
                JOIN ClientMedications CM ON ( CMI.ClientMedicationId = CM.ClientMedicationId )
        WHERE   a.ClientId = @ClientId
                AND DATEADD(yy, 1, c.ConsentStartDate) > GETDATE()
                AND ( ( CM.ClientMedicationId = @ClientMedicationId
                        AND @OffLabel = 'Y'
                      )
                      OR ( d.MedicationNameId = @MedicationNameId
                           AND ISNULL(@OffLabel, 'N') = 'N'
                           AND ( @DiscontinueReasonCode = 5511
                                 OR NOT EXISTS ( SELECT *
                                                 FROM   ClientMedications
                                                 WHERE  ClientId = @ClientId
                                                        AND MedicationNameId = @MedicationNameId
                                                        AND ISNULL(RecordDeleted,
                                                              'N') = 'N'
                                                        AND ISNULL(Discontinued,
                                                              'N') = 'N' )
                               )
                         )
                    );      
      
	  -- write the discontinued recorded to the SureScriptsCancelRx table
        IF ( @OutgoingMessageId > 0
             AND @MethodName IS NOT NULL
             AND @MethodName = 'E'
           )
            BEGIN
                INSERT  INTO dbo.SurescriptsCancelRequests
                        ( OriginalSurescriptsOutgoingMessageId ,
                          --ChangeRequestType ,
                          ChangeOfPrescriptionStatusFlag ,
                          SurescriptsOutgoingMessageId ,
                          PrescriberId,CreatedBy,ModifiedBy
	                    )
                VALUES  ( @OutgoingMessageId ,
                          --'C3' ,
                          CASE WHEN @DiscontinueReasonCode = 5513 THEN 'C'
                               ELSE 'D'
                          END ,
                          NULL ,
                          @PrescriberId,@ModifiedBy,@ModifiedBy
	                    );			
            END;			                          
    

	        
    END;                                               
                
	
                                                   
    COMMIT TRAN;                                 
    RETURN  (0);                                                       
                                              
    error:                                                          
    ROLLBACK TRAN;                                                          
    DECLARE @ErrorMessage NVARCHAR(MAX);
    SELECT  @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29,
                                                           'UNABLETODISCONTINUEMEDIC_ssp_SCDiscontinueMedication',
                                                           'Unable To Discontinue Medication in ssp_SCDiscontinueMedication.Contact tech support.');                                                        
    RAISERROR(@ErrorMessage, 16, 1);




GO


