/****** Object:  StoredProcedure [dbo].[ssp_SCMedicationStrength]    Script Date: 10/8/2013 10:36:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCMedicationStrength]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_SCMedicationStrength]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCMedicationStrength]    Script Date: 10/8/2013 10:36:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_SCMedicationStrength]
    @MedicationNameId INT = 0
AS /*********************************************************************/                      
/* Stored Procedure: dbo.[ssp_SCMedicationStrength]                */                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                      
/* Creation Date:    21/Aug/07                                         */                     
/*                                                                   */                      
/* Purpose:  Populate Strength combobox   */                      
/*                                                                   */                    
/* Input Parameters: none       */                    
/*                                                                   */                      
/* Output Parameters:   None                           */                      
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
/*   Date     Author       Purpose                                    */                      
/* 21/Aug/07   Rishu    Created										*/
/* 15th Nov 2008   Chandan Fill Dropdown - Oral show first and then rest */  
/*Task #96 MM -1.6.5 - Strength Drop-Down: Sort Logically            */         
/* 26-Nov-08	TER		where clause should use MDExternalRouteId		*/
/* 26-Nov-08	TER		Added Sorting by numeric value of Strength dosage */
/* Oct 8, 2013  Kalpers Added PotencyUnitCode from Surescriptcodes */
/* 7/29/2015	Wasif	Merging formulary changes				  	 */
/*********************************************************************/                         
    BEGIN          

        CREATE TABLE #temp
            (
              MedicationId INT ,
			  ExternalMedicationId INT,
              Strength VARCHAR(200) ,
              RouteId INT ,
              RouteAbbreviation VARCHAR(20) ,
              SortOrder1 INT DEFAULT 0 ,
              SortOrder2 DECIMAL(18, 6) ,
              PotencyUnitCode VARCHAR(35) NULL
            )
--For Inserting Oral RouteAbbreviation First 
        INSERT  INTO #temp
                ( MedicationId ,
				  ExternalMedicationId,
                  Strength ,
                  RouteId ,
                  RouteAbbreviation ,
                  SortOrder1
                )
                SELECT  MD.MedicationId ,
						md.ExternalMedicationId,
                        StrengthDescription AS Strength ,
                        MDR.RouteId ,
                        RouteAbbreviation ,
                        1
                FROM    MDMedications MD
                        JOIN MDRoutes MDR ON ( MD.RouteId = MDR.RouteId
                                               AND ISNULL(MD.RecordDeleted,
                                                          'N') <> 'Y'
                                               AND MDR.MDExternalRouteId = 24
                                             )
                        JOIN MDRoutedDosageFormMedications MDRD ON ( MD.RoutedDosageFormMedicationId = MDRD.RoutedDosageFormMedicationId
                                                              AND ISNULL(MDRD.RecordDeleted,
                                                              'N') <> 'Y'
                                                              )
                        JOIN MDDosageForms MDF ON ( MDF.DosageFormId = MDRD.DosageFormId
                                                    AND ISNULL(MDF.RecordDeleted,
                                                              'N') <> 'Y'
                                                  )
                WHERE   MD.MedicationNameId = @MedicationNameId  /*and MD.status = 4881*/
                ORDER BY RouteAbbreviation ASC ,
                        MD.Strength ASC            
         
--For Inserting other than Oral RouteAbbreviation  
        INSERT  INTO #temp
                ( MedicationId ,
				  ExternalMedicationId,
                  Strength ,
                  RouteId ,
                  RouteAbbreviation ,
                  SortOrder1
                )
                SELECT  MD.MedicationId ,
						md.ExternalMedicationId,
                        StrengthDescription AS Strength ,
                        MDR.RouteId ,
                        RouteAbbreviation ,
                        2
                FROM    MDMedications MD
                        JOIN MDRoutes MDR ON ( MD.RouteId = MDR.RouteId
                                               AND ISNULL(MD.RecordDeleted,
                                                          'N') <> 'Y'
                                               AND MDR.MDExternalRouteId <> 24
                                             )
                        JOIN MDRoutedDosageFormMedications MDRD ON ( MD.RoutedDosageFormMedicationId = MDRD.RoutedDosageFormMedicationId
                                                              AND ISNULL(MDRD.RecordDeleted,
                                                              'N') <> 'Y'
                                                              )
                        JOIN MDDosageForms MDF ON ( MDF.DosageFormId = MDRD.DosageFormId
                                                    AND ISNULL(MDF.RecordDeleted,
                                                              'N') <> 'Y'
                                                  )
                WHERE   MD.MedicationNameId = @MedicationNameId  /*and MD.status = 4881*/
                ORDER BY RouteAbbreviation ASC ,
                        MD.Strength ASC          

        UPDATE  #temp
        SET     PotencyUnitCode = ISNULL(map.SureScriptsCode, 'C38046')
        FROM    MDMedications AS mdm
                LEFT JOIN MDClinicalFormulations AS mdcf ON mdcf.ClinicalformulationId = mdm.ClinicalformulationId
                LEFT JOIN MDDosageFormCodes AS mddfc ON mddfc.DosageFormCodeId = mdcf.DosageFormCodeId
                LEFT JOIN surescriptscodes AS map ON ( mddfc.DosageFormCode = LTRIM(RTRIM(map.SmartCareRxCode))
                                                       AND map.Category = 'PotencyUnitCode'
                                                     )
        WHERE   mdm.Medicationid = #temp.MedicationId

        UPDATE  #temp
        SET     SortOrder2 = CASE WHEN PATINDEX('%[^0-9.]%', Strength) > 1
                                  THEN CASE WHEN ISNUMERIC(SUBSTRING(Strength,
                                                              1,
                                                              PATINDEX('%[^0-9.]%',
                                                              Strength) - 1)) = 1
                                            THEN CAST(SUBSTRING(Strength, 1,
                                                              PATINDEX('%[^0-9.]%',
                                                              Strength) - 1) AS DECIMAL(18,
                                                              6))
                                            ELSE 99
                                       END
                                  ELSE 99
                             END

        SELECT  MedicationId ,
				ExternalMedicationId,
                Strength ,
                RouteId ,
                RouteAbbreviation,
				PotencyUnitCode
        FROM    #temp
        ORDER BY SortOrder1 ,
                SortOrder2

                  
        IF ( @@error != 0 ) 
            BEGIN                      
                RAISERROR  20002 'ssp_SCMedicationStrength : An error  occured'                      
                     
                RETURN(1)               
                       
            END                           
                    
    END

GO
