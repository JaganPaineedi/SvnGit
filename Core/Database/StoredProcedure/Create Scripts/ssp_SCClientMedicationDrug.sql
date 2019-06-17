/****** Object:  StoredProcedure [dbo].[ssp_SCClientMedicationDrug]    Script Date: 1/17/2017 4:08:33 PM ******/
DROP PROCEDURE [dbo].[ssp_SCClientMedicationDrug]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCClientMedicationDrug]    Script Date: 1/17/2017 4:08:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_SCClientMedicationDrug]
	@MedicationName VARCHAR(30)
  , @UseSoundexMedicationSearch CHAR(1) -- Yes/No Values
  , @ShowDosages CHAR(1) = 'N'
AS /*********************************************************************/                  
/* Stored Procedure: dbo.[ssp_SCClientMedicationDrug]                */                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                  
/* Creation Date:    20/Aug/07                                         */                 
/*                                                                   */                  
/* Purpose:  Populate the list of ClientMedicationDrug    */                  
/*                                                                   */                
/* Input Parameters: @MedicationName         */                
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
/*  20/Aug/07   Rishu    Created                                    */ 
/*  01/Sep/09  T Remisoski Allow for user preference on soundex() search. */           
/*  Jun 21 2013		Chuck Blaine	Added MedicationId to select list in order to implement new functionality*/             
/*										(Listing of dosages in drug popup per dbo.SystemConfigurations.ShowDosagesInDrugList)*/    
/*  Feb 24, 2014    Kalpers  added Original Medication Name and added ExternalMedicationId */  
/*  1/17/2017  Robert Caffrey - Added check on MdMedications table to make sure the Medication is Active - Harbor Support #1183 */
/*  4/26/2018  Anto - Modified the RAISERROR syntax as it is throwing error in Azure server  - Pines Build Cycle Tasks #12 */
/*********************************************************************/                     
	DECLARE	@SoundExSearchCriteria VARCHAR(30)    
	SET @SoundExSearchCriteria = SOUNDEX(@MedicationName)    
	BEGIN               
		IF ( ISNULL(@ShowDosages,'N') != 'Y' ) 
			BEGIN
				SELECT	MedicationName
					  , MedicationName AS OriginalMedicationName
					  , MedicationNameId
					  , ExternalMedicationNameId
					  , -1 AS MedicationId
					  , -1 AS ExternalMedicationId
				FROM	MdMedicationNames
				WHERE	( ( MedicationName LIKE @MedicationName + '%' )
						  OR ( ( @UseSoundexMedicationSearch = 'Y' )
							   AND ( MedicationNameSoundEx LIKE @SoundExSearchCriteria
									 + '%' )
							 )
						)
						AND ISNULL(RecordDeleted, 'N') <> 'Y'
						AND status = 4881
				ORDER BY MedicationName
			END
		ELSE 
			BEGIN      
				SELECT  
						m.MedicationDescription AS MedicationName
					  , MedicationName AS OriginalMedicationName
					  , mn.MedicationNameId
					  , mn.ExternalMedicationNameId
					  , m.MedicationId
					  , m.ExternalMedicationId
				FROM	MdMedicationNames mn
						JOIN MDMedications m ON m.MedicationNameId = mn.MedicationNameId
				WHERE	( ( mn.MedicationName LIKE @MedicationName + '%' )
						  OR ( ( @UseSoundexMedicationSearch = 'Y' )
							   AND ( mn.MedicationNameSoundEx LIKE @SoundExSearchCriteria
									 + '%' )
							 )
						)
						AND ISNULL(mn.RecordDeleted, 'N') <> 'Y'
						AND ISNULL(m.RecordDeleted, 'N') <> 'Y'
						AND mn.status = 4881
						AND m.Status = 4881
				ORDER BY mn.MedicationName      
			END          
        
		IF ( @@error != 0 ) 
			BEGIN                  				
				RAISERROR ('ssp_SCClientMedicationDrug : An error  occured',16,1);                                           
				RETURN(1)                  
                       
			END                       
                
	END

GO


