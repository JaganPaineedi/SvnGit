/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Created script to Update Screens.PostUpdateStoredProcedure ='ssp_PostUpdateInternalCollections' to Internal Collections Detail screen.
	Why:	Aspen Pointe - Implementation -#184
   
-- Author:  IRFAN
-- Date:    13-Jan-2017

*********************************************************************************/
IF EXISTS (
		SELECT 1
		FROM Screens
		WHERE ScreenId = 1155
			AND Screenname = 'Internal Collections Detail'
		)
BEGIN
	UPDATE Screens
	SET PostUpdateStoredProcedure = 'ssp_PostUpdateInternalCollections'
	WHERE ScreenId = 1155
		AND Screenname = 'Internal Collections Detail'
END