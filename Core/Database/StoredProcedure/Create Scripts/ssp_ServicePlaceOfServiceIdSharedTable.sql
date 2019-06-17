
/****** Object:  StoredProcedure [dbo].[ssp_ServicePlaceOfServiceIdSharedTable]    Script Date: 11/16/2011 11:52:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ServicePlaceOfServiceIdSharedTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ServicePlaceOfServiceIdSharedTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO    
CREATE PROCEDURE [dbo].[ssp_ServicePlaceOfServiceIdSharedTable]        
AS        
        
/*********************************************************************/                      
/* Stored Procedure: dbo.ssp_ServicePlaceOfServiceIdSharedTable      */                      
/* Updates:                                                          */                      
/* Date            Author    Purpose                                 */      
/* April 25 2016   Dhanil    Created to get the place of service list from Glbal codes for service dropdowns */

/*********************************************************************/                    
begin        
  select GlobalCodeId as PlaceOfServiceId, CodeName as PlaceOfServiceName         
 from dbo.GlobalCodes where   Category = 'PLACEOFSERVICE' AND ISNULL(RecordDeleted,'N')<> 'Y'  and isnull(Active,'Y') <> 'N' order by CodeName  
end
    
 IF (@@error != 0)
BEGIN
      RAISERROR ('ssp_ServicePlaceOfServiceIdSharedTable: An Error Occured While fetching the data',16,1);
END
 
    
