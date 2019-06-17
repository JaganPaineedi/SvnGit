
/****** Object:  StoredProcedure [dbo].[csp_PAValidateCustomASAMPlacements]    Script Date: 06/18/2013 14:22:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAValidateCustomASAMPlacements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAValidateCustomASAMPlacements]
GO

/****** Object:  StoredProcedure [dbo].[csp_PAValidateCustomASAMPlacements]    Script Date: 06/18/2013 14:22:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
CREATE PROCEDURE [dbo].[csp_PAValidateCustomASAMPlacements]               
@DocumentVersionId INT       
as               
/******************************************************************************                                      
**  File: csp_PAValidateCustomASAMPlacements                                  
**  Name: csp_PAValidateCustomASAMPlacements              
**  Desc: For Validation  on CustomASAMPlacements document(For Prototype purpose, Need modification)              
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Jitender Kumar Kamboj                    
**  Date:  March 12 2010                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date         Author             Description
	08/29/2011   Sonia Dhamija      Add the validation On CustomASAMPlacements for Dimensions field
	01/Sept/2011   Shifali			amendments for 'Note' text with TabName and Insertion of PageIndex field                                       
    18/June/2013  Manju Padmanabhan ARM Customizations Task #16                                    
*******************************************************************************/                                    
      
BEGIN                                                    
          
	 BEGIN TRY      
		 --*TABLE CREATE*--               
		CREATE TABLE #CustomASAMPlacements (                
		DocumentVersionId INT,              
		Dimension1LevelOfCare INT,                 
		Dimension2LevelOfCare INT,  
		Dimension3LevelOfCare INT,  
		Dimension4LevelOfCare INT,  
		Dimension5LevelOfCare INT,  
		Dimension6LevelOfCare INT,  
		FinalPlacement Varchar(max),
		FinalPlacementComment  Varchar(max)  
		    
		)                 
		--*INSERT LIST*--               
		INSERT INTO #CustomASAMPlacements (                
		DocumentVersionId,                 
		Dimension1LevelOfCare,                 
		Dimension2LevelOfCare,  
		Dimension3LevelOfCare,  
		Dimension4LevelOfCare,  
		Dimension5LevelOfCare,  
		Dimension6LevelOfCare,    
		FinalPlacement,  
		FinalPlacementComment               
		)                 
		--*Select LIST*--               
		SELECT DocumentVersionId,                 
		Dimension1LevelOfCare,                 
		Dimension2LevelOfCare,  
		Dimension3LevelOfCare,  
		Dimension4LevelOfCare,  
		Dimension5LevelOfCare,  
		Dimension6LevelOfCare,
		FinalPlacement,
		FinalPlacementComment                    
		FROM CustomASAMPlacements WHERE DocumentVersionId = @DocumentVersionId                
		               
		               
		INSERT INTO #validationReturnTable (  TableName, ColumnName, ErrorMessage,PageIndex )                
		SELECT 'CustomASAMPlacements', 'Dimension1LevelOfCare', 'LOC One - Please choose any one level from Dimension1.',0 FROM #CustomASAMPlacements WHERE isnull(Dimension1LevelOfCare,'')=''                
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension2LevelOfCare', 'LOC One - Please choose any one level from Dimension2.',0 FROM #CustomASAMPlacements WHERE isnull(Dimension2LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension3LevelOfCare', 'LOC Two - Please choose any one level from Dimension3.',1 FROM #CustomASAMPlacements WHERE isnull(Dimension3LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension4LevelOfCare', 'LOC Two - Please choose any one level from Dimension4.',1 FROM #CustomASAMPlacements WHERE isnull(Dimension4LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension5LevelOfCare', 'LOC Three - Please choose any one level from Dimension5.',2 FROM #CustomASAMPlacements WHERE isnull(Dimension5LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension6LevelOfCare', 'LOC Three - Please choose any one level from Dimension6.',2 FROM #CustomASAMPlacements WHERE isnull(Dimension6LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'FinalPlacement', 'LOC-Four - Suggested Placement is required.',3 FROM #CustomASAMPlacements WHERE isnull(FinalPlacement,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'FinalPlacementComment', 'LOC-Four - Final Placement Determination is required.',3 FROM #CustomASAMPlacements WHERE isnull(FinalPlacementComment,'')=''     
		     
	END TRY                                                                                      
	BEGIN CATCH        
		DECLARE @Error varchar(8000)                                                     
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
			+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_PAValidateCustomASAMPlacements')                                                                                   
			+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                    
			+ '*****' + Convert(varchar,ERROR_STATE())                                 
		 RAISERROR                                                                                   
		 (                                                     
		  @Error, -- Message text.                                                                                  
		  16, -- Severity.                                                                                  
		  1 -- State.                                                                                  
		 );                                                                    
	END CATCH                              
END       


GO


