IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMobileHomePageScreens]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMobileHomePageScreens]
GO

/****** Object:  StoredProcedure [dbo].[[ssp_GetMobileHomePageScreens]]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                   
**  File: [ssp_GetMobileHomePageScreens]                                            
**  Name: [ssp_GetMobileHomePageScreens]                       
**  Desc: Get Data for Home Page Screens.
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Pavani                             
**  Date:  10/19/2016
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:     
*******************************************************************************/  

                                  
CREATE PROCEDURE  [dbo].[ssp_GetMobileHomePageScreens]                                                               

As                                                                          
BEGIN                                                            
   BEGIN TRY 
		BEGIN
			SELECT    
					 MD.MobileDashboardId
					 ,MD.CreatedBy
	                 ,MD.CreatedDate
	                 ,MD.ModifiedBy
	                 ,MD.ModifiedDate
	                ,MD.RecordDeleted
	                ,MD.DeletedBy
	                ,MD.DeletedDate
					,MD.DashboardName
					,DashboardImage
	                ,MD.RedirectUrl
	                ,MD.ShowInMyPreference
	                ,MD.Active
					FROM MobileDashboards MD
					--WHERE (ISNULL(MD.RecordDeleted, 'N') ='N')
					--AND (ISNULL(MD.ShowInMyPreference, 'N') = 'Y')
					--AND (ISNULL(MD.Active, 'N') = 'Y')

	END
		
		 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetMobileHomePageScreens')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO           		