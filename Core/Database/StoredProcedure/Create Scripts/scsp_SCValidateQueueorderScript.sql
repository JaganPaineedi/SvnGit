IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCValidateQueueorderScript]') AND type in (N'P', N'PC'))
DROP PROCEDURE scsp_SCValidateQueueorderScript
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCValidateQueueorderScript]    Script Date: 12/3/2013 4:35:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[scsp_SCValidateQueueorderScript]
	@ClientId INT  ,
	@MedicationNameId INT =NULL ,
	@PrescriberId INT =NULL
--
-- Procedure: scsp_SCValidateQueueorderScript  
--  
-- Purpose: Check contents of script and determine whether the script may  
-- be allowed to go to the next page.  
--  
-- Called by: the SmartCareRx  
--  
-- Change Log:  
--  05/05/2017  Anto         Created			Task : AspenPointe-Environment Issues #167
--  09/10/2018 Pranay        Added            Validation ' NA DEA number is required for this prescription' w.r.t  Journey-Support Go Live: #276 Rx 

AS 
	SET nocount ON

	DECLARE	@ValidationStatus NVARCHAR(MAX)
	DECLARE	@ValidationMessage NVARCHAR(MAX)
	DECLARE	@ClientValidationMessage NVARCHAR(MAX)
	DECLARE	@PrescriberValidationMessage NVARCHAR(MAX)


	BEGIN
		SET @ValidationStatus = ( SELECT	dbo.Ssf_GetMesageByMessageCode(29,
															  'VALID_SCSP',
															  'VALID')
								)
		SET @ValidationMessage = ''
	END

	BEGIN TRY

        CREATE TABLE #tempMedicationName
            (
              MedicationNameId INT NOT NULL
                                   PRIMARY KEY ,
              MedicationName VARCHAR(100)
            );

        INSERT  INTO #tempMedicationName
                EXEC ssp_MMGetAlternativeMedicationNames @MedicationNameId;

        DECLARE @NADEA VARCHAR(25);
        SET @NADEA = '';
        IF EXISTS ( SELECT  #tempMedicationName.MedicationNameId
                    FROM    #tempMedicationName
                    WHERE   #tempMedicationName.MedicationName LIKE '%Xyrem%'
                            OR #tempMedicationName.MedicationName LIKE '%Subutex%'
                            OR #tempMedicationName.MedicationName LIKE '%Gamma-Hydroxybutyric Acid%'
                            OR #tempMedicationName.MedicationName LIKE '%Suboxone%'
                            OR #tempMedicationName.MedicationName LIKE '%Zubsolv%'
                            OR #tempMedicationName.MedicationName LIKE '%Bunavail%'
                            OR #tempMedicationName.MedicationName LIKE '%Buprenorphine%'
                            OR #tempMedicationName.MedicationName LIKE '%Buprenex%'
                            OR #tempMedicationName.MedicationName LIKE '%Belbuca%'
                            OR #tempMedicationName.MedicationName LIKE '%Sublocade%'
                            OR #tempMedicationName.MedicationName LIKE '%Probuphine%'
                            OR #tempMedicationName.MedicationName LIKE '%Butrans%' )
            BEGIN
                SELECT  @NADEA = sldForNADEA.LicenseNumber
                FROM    Staff st
                        JOIN StaffLicenseDegrees AS sldForNADEA ON sldForNADEA.StaffId = st.StaffId
                WHERE   sldForNADEA.LicenseTypeDegree = 9404
                        AND sldForNADEA.PrimaryValue = 'Y'
                        AND ( sldForNADEA.EndDate IS NULL
                              OR GETDATE() BETWEEN sldForNADEA.StartDate
                                           AND     ( DATEADD(DAY, 1,
                                                             sldForNADEA.EndDate) )
                            )
                        AND ISNULL(st.RecordDeleted, 'N') <> 'Y'
                        AND ISNULL(sldForNADEA.RecordDeleted, 'N') <> 'Y'
						AND st.StaffId=@PrescriberId;
                IF ( @NADEA = '' )
                    BEGIN
                        SET @ClientValidationMessage = ISNULL(@ClientValidationMessage,
                                                              '')
                            + ' NA DEA number is required for this prescription.';
                    END;
            END;		

		SELECT @ClientValidationMessage = CASE	WHEN LEN(ISNULL(LTRIM(RTRIM(c.FirstName)),
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
				  END + 	@ClientValidationMessage			
		FROM	Clients AS c					
				Where C.ClientId  = @ClientId

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

	END TRY


BEGIN CATCH                  
 DECLARE @Error varchar(8000)                                                                 
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_SCValidateQueueorderScript')                                                                                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                
    + '*****' + Convert(varchar,ERROR_STATE())                                            
 RAISERROR                                                                                               
 (                     
   @Error, -- Message text.                                                                                              
   16, -- Severity.                                                                                              
   1 -- State.                                                                                              
  );                   
END CATCH  

	SELECT	@ValidationStatus AS ValidationStatus
		  , @ValidationMessage AS ValidationMessage

GO