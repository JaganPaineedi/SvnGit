/****** Object:  StoredProcedure [dbo].[csp_RDLDiscontinueMedicationNotice]    Script Date: 07/13/2012 08:40:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLDiscontinueMedicationNotice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLDiscontinueMedicationNotice]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLDiscontinueMedicationNotice]    Script Date: 07/13/2012 08:40:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLDiscontinueMedicationNotice]
/*
   Stub procedure for Venture FY10 task #1.
   The final procedure will take the same parameters and return a different data set.  Only one data set will be returned.
*/  @ClientMedicationId INT ,
    @Method CHAR(1) , -- 'F' for fax, 'P' for print
    @InitiatedBy INT , -- StaffId of person who is creating the letter
    @PharmacyId INT = NULL  -- not required when printing
AS /*
Modified By		Modified Date	Reason
avoss			12/02/2009		Modified result set to contain infomation requested by summit
Kneale          July 13, 2012   Created a left join on locations
Kneale          Oct 25, 2013    Added check for active medication list
Vithobha		Aug	02, 2015	Corrected poor wording of Dosage, to give more information, Camino - Environment Issues Tracking: #228   
*/
    DECLARE @Message1 VARCHAR(MAX) ,
        @Message2 VARCHAR(MAX) ,
        @Message3 VARCHAR(MAX)

    DECLARE @i FLOAT
    SELECT  @i = RAND()

    DECLARE @RandomId VARCHAR(18)
    SELECT  @RandomId = CONVERT(VARCHAR(20), @i)
    SELECT  @RandomId = REPLACE(@RandomId, '0.', '')

    DECLARE @StrengthInstructionList VARCHAR(MAX) ,
        @StrengthId INT ,
        @MaxStrengthId INT        
    DECLARE @StrengthInstructionListTable TABLE
        (
          StrengthId INT IDENTITY ,
          StrengthDescription VARCHAR(200)
        )    

    DECLARE @LocationId INT
    SELECT TOP 1
            @LocationId = cms.LocationId
    FROM    ClientMedicationScripts AS cms
            JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
                                                        AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
            JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                                        AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y'
            JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                            AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
            JOIN locations l ON l.LocationId = cms.LocationId
    WHERE   @ClientMedicationId = cm.ClientMedicationId
    ORDER BY cms.ClientMedicationScriptId DESC

    SELECT  @StrengthId = 1       
  
    INSERT  INTO @StrengthInstructionListTable
            ( StrengthDescription
            )
            --Vithobha		Aug	02, 2015
            SELECT DISTINCT    
                    MDMeds.StrengthDescription + ' ' + dbo.ssf_RemoveTrailingZeros(cmi.Quantity)   
                    + ' ' + CONVERT(VARCHAR, GC.CodeName) + ' ' + CONVERT(VARCHAR, GC1.CodeName)  +  ' '  AS InstructionStrengthDescription    
            FROM    ClientMedications AS cm    
                    JOIN ClientMedicationInstructions AS cmi ON (cmi.ClientMedicationId = cm.ClientMedicationId    
                                                              AND ISNULL(cmi.RecordDeleted,    
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y') = 'Y')    
                    JOIN MDMedicationNames AS mn ON mn.MedicationNameId = cm.MedicationNameId    
                    JOIN MDMedications AS MDMeds ON MDMeds.MedicationId = cmi.StrengthId  
                    LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = cmi.Unit ) AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'   
                    LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule ) AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'     
            WHERE   cm.ClientMedicationId = @ClientMedicationId    
                    AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'    
            ORDER BY InstructionStrengthDescription 
            

    --Find Max Strength in temp table for while loop      
    SET @MaxStrengthId = ( SELECT   MAX(StrengthId)
                           FROM     @StrengthInstructionListTable
                         )      
       
    --Begin Loop to create Strength Instruction List      
    WHILE @StrengthId <= @MaxStrengthId 
        BEGIN      
            SET @StrengthInstructionList = ISNULL(@StrengthInstructionList, '')
                + CASE WHEN @StrengthId <> 1 THEN '; '
                       ELSE ''
                  END + ( SELECT    ISNULL(StrengthDescription, '')
                          FROM      @StrengthInstructionListTable t
                          WHERE     t.StrengthId = @StrengthId
                        )      
            SET @StrengthId = @StrengthId + 1      
        END       
    --End Loop      

    DECLARE @AllergyList VARCHAR(MAX) ,
        @AllergyId INT ,
        @MaxAllergyId INT        
    DECLARE @AllergyListTable TABLE
        (
          AllergyId INT IDENTITY ,
          ConceptDescription VARCHAR(200)
        )

    SELECT  @AllergyId = 1 
--Select distinct AllergyType from ClientAllergies
    INSERT  INTO @AllergyListTable
            ( ConceptDescription
            )
            SELECT  ISNULL(ConceptDescription,
                           'No Known Medication/Other Allergies')
                    + CASE WHEN ISNULL(ConceptDescription,
                                       'No Known Medication/Other Allergies') <> 'No Known Medication/Other Allergies'
                                AND ISNULL(AllergyType, 'A') = 'A'
                           THEN ' (Allergy)'
                           WHEN ISNULL(ConceptDescription,
                                       'No Known Medication/Other Allergies') <> 'No Known Medication/Other Allergies'
                                AND ISNULL(AllergyType, 'A') = 'I'
                           THEN ' (Intolerance)'
                           ELSE ''
                      END
            FROM    ClientMedications AS cm
                    JOIN Clients AS c ON c.ClientId = cm.ClientId
                                         AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                    LEFT JOIN ClientAllergies AS cla ON cla.ClientId = c.ClientId
                                                        AND ISNULL(cla.RecordDeleted,
                                                              'N') <> 'Y'
                    LEFT JOIN MDAllergenConcepts AS MDAl ON MDAl.AllergenConceptId = cla.AllergenConceptId
            WHERE   ISNULL(cm.RecordDeleted, 'N') <> 'Y'
                    AND @ClientMedicationId = cm.ClientMedicationId
                    AND ISNULL(AllergyType, 'A') <> 'F'
            ORDER BY ISNULL(ConceptDescription,
                            'No Known Medication/Other Allergies')      
       
    --Find Max Allergy in temp table for while loop      
    SET @MaxAllergyId = ( SELECT    MAX(AllergyId)
                          FROM      @AllergyListTable
                        )      
       
    --Begin Loop to create Allergy List      
    WHILE @AllergyId <= @MaxAllergyId 
        BEGIN      
            SET @AllergyList = ISNULL(@AllergyList, '')
                + CASE WHEN @AllergyId <> 1 THEN ', '
                       ELSE ''
                  END + ( SELECT    ISNULL(ConceptDescription, '')
                          FROM      @AllergyListTable t
                          WHERE     t.AllergyId = @AllergyId
                        )      
            SET @AllergyId = @AllergyId + 1      
        END       
    --End Loop     


    SELECT  @ClientMedicationId AS ClientMedicationId ,
            sc.OrganizationName AS OrganizationName
--	,'Summit Pointe' as OrganizationName
            ,
            ISNULL(l.LocationName, '') AS LocationName ,
            l.Address AS LocationAddress ,
            l.phoneNumber AS LocationPhone
	/*
	,case when isnull(l.PhoneNumber,space(13)) = '' then space(13) 
	 else case len(rtrim(l.PhoneNumber))
		when 10 then '(' +  substring(rtrim(l.PhoneNumber), 1, 3) + ') ' + substring(rtrim(l.PhoneNumber), 4, 3) + '-' + substring(rtrim(l.PhoneNumber), 7, 4)
		when 7 then '() ' + substring(rtrim(l.PhoneNumber), 1, 3) + '-' + substring(rtrim(l.PhoneNumber), 4, 4)
		else ltrim(rtrim(l.PhoneNumber)) end end as LocationPhone 
	*/ ,
            CASE WHEN ISNULL(l.FaxNumber, SPACE(13)) = '' THEN SPACE(13)
                 ELSE CASE LEN(RTRIM(l.FaxNumber))
                        WHEN 10
                        THEN '(' + SUBSTRING(RTRIM(l.FaxNumber), 1, 3) + ') '
                             + SUBSTRING(RTRIM(l.FaxNumber), 4, 3) + '-'
                             + SUBSTRING(RTRIM(l.FaxNumber), 7, 4)
                        WHEN 7
                        THEN '() ' + SUBSTRING(RTRIM(l.FaxNumber), 1, 3) + '-'
                             + SUBSTRING(RTRIM(l.FaxNumber), 4, 4)
                        ELSE LTRIM(RTRIM(l.FaxNumber))
                      END
            END AS LocationFax ,
            c.LastName + ', ' + c.FirstName AS ClientName ,
            c.DOB AS ClientDOB ,
            dbo.RemoveTimestamp(cm.DiscontinueDate) AS DiscontinueDate ,
            @AllergyList AS AllergyList ,
            mn.MedicationName ,
            @StrengthInstructionList AS StrengthInstructionList ,
            cm.PrescriberName AS PrescriberName ,
            ISNULL(p.PharmacyName, '') AS PharmacyName ,
            CASE WHEN ISNULL(p.Address, '') <> ''
                 THEN p.Address + CHAR(13) + CHAR(10)
                      + CASE WHEN ISNULL(p.City, '') <> ''
                             THEN p.City
                                  + CASE WHEN ISNULL(p.State, '') <> ''
                                         THEN ', ' + p.State + SPACE(2)
                                              + ISNULL(p.ZipCode, '')
                                         ELSE '' + ISNULL(p.ZipCode, '')
                                    END
                             ELSE CASE WHEN ISNULL(p.State, '') <> ''
                                       THEN ', ' + p.State + SPACE(2)
                                            + ISNULL(p.ZipCode, '')
                                       ELSE '' + ISNULL(p.ZipCode, '')
                                  END
                        END
                 ELSE CASE WHEN ISNULL(p.City, '') <> ''
                           THEN p.City
                                + CASE WHEN ISNULL(p.State, '') <> ''
                                       THEN ', ' + p.State + SPACE(2)
                                            + ISNULL(p.ZipCode, '')
                                       ELSE '' + ISNULL(p.ZipCode, '')
                                  END
                           ELSE CASE WHEN ISNULL(p.State, '') <> ''
                                     THEN ', ' + p.State + SPACE(2)
                                          + ISNULL(p.ZipCode, '')
                                     ELSE '' + ISNULL(p.ZipCode, '')
                                END
                      END
            END AS PharmacyAddress ,
            CASE WHEN ISNULL(p.PhoneNumber, SPACE(13)) = '' THEN SPACE(13)
                 ELSE CASE LEN(RTRIM(REPLACE(p.PhoneNumber, '+', '')))
                        WHEN 10
                        THEN '(' + SUBSTRING(REPLACE(p.PhoneNumber, '+', ''),
                                             1, 3) + ') '
                             + SUBSTRING(REPLACE(p.PhoneNumber, '+', ''), 4, 3)
                             + '-' + SUBSTRING(REPLACE(p.PhoneNumber, '+', ''),
                                               7, 4)
                        WHEN 7
                        THEN '() ' + SUBSTRING(REPLACE(p.PhoneNumber, '+', ''),
                                               1, 3) + '-'
                             + SUBSTRING(REPLACE(p.PhoneNumber, '+', ''), 4, 4)
                        ELSE LTRIM(RTRIM(REPLACE(p.PhoneNumber, '+', '')))
                      END
            END AS PharmacyPhone ,
            CASE WHEN ISNULL(p.FaxNumber, SPACE(13)) = '' THEN SPACE(13)
                 ELSE CASE LEN(RTRIM(REPLACE(p.FaxNumber, '+', '')))
                        WHEN 11
                        THEN '(' + SUBSTRING(REPLACE(p.FaxNumber, '+1', ''), 1,
                                             3) + ') '
                             + SUBSTRING(REPLACE(p.FaxNumber, '+1', ''), 4, 3)
                             + '-' + SUBSTRING(REPLACE(p.FaxNumber, '+1', ''),
                                               7, 4)
                        WHEN 10
                        THEN '(' + SUBSTRING(REPLACE(p.FaxNumber, '+', ''), 1,
                                             3) + ') '
                             + SUBSTRING(REPLACE(p.FaxNumber, '+', ''), 4, 3)
                             + '-' + SUBSTRING(REPLACE(p.FaxNumber, '+', ''),
                                               7, 4)
                        WHEN 7
                        THEN '() ' + SUBSTRING(REPLACE(p.FaxNumber, '+', ''),
                                               1, 3) + '-'
                             + SUBSTRING(REPLACE(p.FaxNumber, '+', ''), 4, 4)
                        ELSE LTRIM(RTRIM(REPLACE(p.FaxNumber, '+', '')))
                      END
            END AS PharmacyFax ,
            st.FirstName + ' ' + st.LastName
            + CASE WHEN st.Degree IS NOT NULL THEN ', ' + gcd.CodeName
                   ELSE ''
              END AS InitiatedBy ,
            @Message1 AS Message1 ,
            @Message2 AS Message2 ,
            @Message3 AS Message3 ,
            CASE @Method
              WHEN 'F' THEN 'Transmission ID: '
              ELSE 'Activity ID: '
            END + @RandomId + 'ZZ' + CONVERT(VARCHAR(12), @ClientMedicationId)
            + 'ZZ' + ISNULL(CONVERT(VARCHAR(12), @PharmacyId), '0') + 'ZZ'
            + CONVERT(VARCHAR(12), @InitiatedBy) + 'ZZ' + @Method + 'ZZ' AS TransmissionID
    FROM    ClientMedications AS cm
            JOIN MDMedicationNames AS mn ON mn.MedicationNameId = cm.MedicationNameId
            JOIN Clients AS c ON c.ClientId = cm.ClientId
            LEFT JOIN locations AS l ON l.LocationId = @LocationId
            CROSS JOIN Staff AS st
            CROSS JOIN SystemConfigurations AS sc
            LEFT OUTER JOIN GlobalCodes AS gcd ON gcd.GlobalCodeId = st.Degree
            LEFT OUTER JOIN Pharmacies AS p ON p.PharmacyId = @PharmacyId
    WHERE   cm.ClientMedicationId = @ClientMedicationId
            AND st.StaffId = @InitiatedBy
            AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
            AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
GO


