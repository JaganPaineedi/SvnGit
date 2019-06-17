IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPatientName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPatientName]
GO
   
CREATE  PROCEDURE [dbo].[ssp_GetPatientName]    
/*********************************************************************************/    
-- Copyright: Streamline Healthcate Solutions    
--    
--    
-- Author:  Varun    
-- Date:    30 June 2014       
-- Purpose: Created SP to fetch Patient Name      
-- Modified By:  Revathi     
	-- Date:    OCT 15 2015       
	-- Purpose:  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
	--									why:task #609, Network180 Customization  */    
/*********************************************************************************/    
    
   
 @ClientId INT,
 @DocumentId INT ,
 @EffectiveDate DATETIME
     
AS    
BEGIN     
    DECLARE @Name VARCHAR (Max)
 Select @Name  = CASE 
			WHEN ISNULL(ClientType, 'I') = 'I'
				THEN ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
			ELSE ISNULL(OrganizationName, '')
			END
		    from Clients where clientId=@ClientId  
   
     SELECT  ISNULL(@Name,'')+''    
END 





