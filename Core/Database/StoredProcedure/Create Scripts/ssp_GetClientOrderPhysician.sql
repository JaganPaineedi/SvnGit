IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientOrderPhysician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientOrderPhysician]
GO

/****** Object:  StoredProcedure [dbo].[[ssp_GetClientOrderPhysician]]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                                  
CREATE PROCEDURE  [dbo].[ssp_GetClientOrderPhysician]   
/******************************************************************************                                   
**  File: [ssp_GetClientOrderPhysician]                                            
**  Name: [ssp_GetClientOrderPhysician]                       
**  Desc: Get Data for ClientOrders.
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Pavani                             
**  Date:  1/12/2016
**  Created: For the Task MHP-Customizations#55
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:     
*******************************************************************************/
As                                                                          
BEGIN                                                            
   BEGIN TRY 
		BEGIN
			SELECT    
					distinct S.StaffId
					,ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') AS StaffName  
					FROM Staff  S JOIN ClientOrders CO
					ON CO.OrderingPhysician=S.StaffId
					WHERE CO.OrderFlag='Y' and (ISNULL(CO.RecordDeleted, 'N') ='N')
					AND (ISNULL(S.Active, 'N') ='Y')
				
					
	END
		
		 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetClientOrderPhysician')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO           		