 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetUnits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetUnits]

GO

CREATE PROCEDURE [dbo].[ssp_SCGetUnits] 
AS
/**************************************************************/                                                                                        
/* Stored Procedure: [ssp_SCGetUnits]						 */                                                                               
/* Creation Date:  20March2012                                */                                                                                        
/* Purpose: To get Units									  */                                                                                       
/* Input Parameters:   None									  */                                                                                      
/* Output Parameters:										  */                                                                                        
/* Return:													  */                                                                                        
/* Called By: Core Admin Units/Rooms/Beds List Page Screen	  */                                                                              
/* Calls:                                                     */                                                                                        
/*                                                            */                                                                                        
/* Data Modifications:                                        */                                                                                        
/* Updates:                                                   */                                                                                        
/* Date			Author        Purpose						  */    
/* 20March2012	Shifali       To get Units					  */
/* 21June2012	Vikas Kashyap Added Active Condition		  */
/*26 May 2015    Veena         Added ShowOnBedBoard,ShowOnBedCensus,ShowOnWhiteBoard columns Philhaven Development #248**/
/**************************************************************/  
BEGIN
BEGIN TRY
	SELECT [UnitId]      
	,[DisplayAs] As UnitName
	 --Added by Veena for  ShowOnBedBoard,ShowOnBedCensus,ShowOnWhiteBoard columns for filtering the units in the list page Philhaven Development #248
	,ShowOnBedBoard
	,ShowOnBedCensus
	,ShowOnWhiteBoard
	FROM Units WHERE ISNULL(RecordDeleted,'N') <> 'Y' AND ISNULL(Active,'Y') <> 'N' 
	ORDER BY DisplayAs
	
END TRY
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetUnits')                                                                                                       
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


