IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[scsp_ListPageClaimBundles]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_ListPageClaimBundles] 

GO
CREATE PROC [dbo].[scsp_ListPageClaimBundles]    
(    
    @OtherFilter VARCHAR(10)        
    
    
)    
    
/********************************************************************************      
 
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: used by Contact Note List page.     
-- Called by: ssp_SCListPageSubstanceAbuseScreen      
--      
-- Updates:                                                             
-- Date        Author      Purpose      
/*SuryaBalan 09-Oct-2015 Claim Bundles List Page Network 180 - Customizations Task #608*/           
*********************************************************************************/     
AS   

SELECT NULL AS DocumentId      
      
RETURN 