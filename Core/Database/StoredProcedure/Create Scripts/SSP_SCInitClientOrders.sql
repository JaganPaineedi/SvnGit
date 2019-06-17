
/****** Object:  StoredProcedure [dbo].[SSP_SCInitClientOrders]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInitClientOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCInitClientOrders]
GO



/****** Object:  StoredProcedure [dbo].[SSP_SCInitClientOrders]    Script Date: 11/13/2013 17:13:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
                          
CREATE PROCEDURE [dbo].[SSP_SCInitClientOrders]                                                                                                                   
(                                                                                                                                              
  @ClientID int,                      
  @StaffID int,                    
  @CustomParameters xml                                                                                                                                           
)                                                                                                                                              
As                          
/*********************************************************************/                                                                                                                                
/* Stored Procedure: SSP_SCInitClientOrders          */                                                                                                                                
/* Purpose:   To Initialize Client Allergies*/                                                                                                                                
        
/*  Date			Author             Purpose                                    */                     
/*  29 Dec 2014		Ponnin			   Return new datatable with information of client Allergies. Why : For task 213 of Philhaven Development. */  
/*	11 Feb 2015		Chethan N		   What: Record Deleted check for MDAllergenConcepts table.
									   Why: Philhaven - Customization Issues Tracking task# 1232  */
/*	18 Mar 2015		Chethan N		   What: Changes made to display Allergies in tool tip
									   Why:  Philhaven Development task # 230 */
/*	07 Apr 2015		Chethan N		   What: Changes made to display Allergy type along with Allergy Name in tool tip
									   Why:  Philhaven Development task # 239 */
/*  18 Jun 2015		Chethan N		   What: Removed the logic to filter out Allergy - Failed Trials  
									   Why:  Philhaven Development task # 321 */ 
/*  06 Aug 2015		Chethan N		   What: Included Allergy Comments  
									   Why:  Woods - Customizations task # 821.1 */          
/**************************************************************/                                      
                                                                                           
                                                                                 
BEGIN                                                                         
       	BEGIN TRY  

	-- Get Allergies of client Why : For task 213 of Philhaven Development	
		--SELECT 'ClientAllergies' as TableName
		-- ,CA.ClientAllergyId 
		-- ,MDA.ConceptDescription as AllergyName
		-- ,CA.Comment
		--FROM MDAllergenConcepts MDA
		--INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
		--	AND CA.ClientId = @ClientId
		--	AND ISNULL(CA.RecordDeleted, 'N') = 'N'
		--	AND ISNULL(MDA.RecordDeleted, 'N') = 'N'
		--	AND ISNULL(CA.Active, 'Y') = 'Y'
		--ORDER BY MDA.ConceptDescription
	
		-- Get Allergies of client to show in tool tip
		Declare @ToolTip Varchar(MAX)=''    
		
		CREATE TABLE #Allergy(
		ConceptDescription VARCHAR(MAX),
		ALLERGYNAME VARCHAR(100))
		
		INSERT INTO #Allergy 
		SELECT MDA.ConceptDescription + ' (' + CASE 
			WHEN ISNULL(CA.AllergyType, '') = 'A'
				THEN 'Allergy'
			WHEN ISNULL(CA.AllergyType, '') = 'I'
				THEN 'Intolerance'
			WHEN ISNULL(CA.AllergyType, '') = 'F'
				THEN 'Failed Trials'
			ELSE ''
			END + ')' + CASE 
			WHEN CA.Comment IS NOT NULL
				THEN ' - ' + SUBSTRING(CA.Comment, 0, 100)
			ELSE ''
			END + '<br/>'
			, MDA.ConceptDescription
		FROM MDAllergenConcepts MDA
		INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
			AND CA.ClientId = @ClientId
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(MDA.RecordDeleted, 'N') = 'N'
			AND ISNULL(CA.Active, 'Y') = 'Y'
		ORDER BY MDA.ConceptDescription 
		
		SELECT @ToolTip = @ToolTip + ConceptDescription
		FROM #Allergy 
		ORDER BY ALLERGYNAME
			
	  SELECT 'ClientAllergies' AS TableName
		,CASE 
			WHEN NoKnownAllergies = 'Y'
				THEN 'Y'
			ELSE CASE 
					WHEN @ToolTip = ''
						THEN 'U'
					ELSE @ToolTip
					END
			END AS Allergy
		FROM Clients
		WHERE ClientId = @ClientId
		
   END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCInitClientOrders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
                                              
END        
  
  
  
  