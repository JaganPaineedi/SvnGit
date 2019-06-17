IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[scsp_CMGetChecksFilteredDetail]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_CMGetChecksFilteredDetail] 

GO
CREATE PROC [dbo].[scsp_CMGetChecksFilteredDetail]    
(    
@staffid int,                    
 @insurerid int,                    
 @providerid int,                    
 @taxid varchar(15),  
   
 @voidchecks CHAR(1),                    
-- @printstatus int,                    
 @datefrom varchar(10),                    
 @dateto varchar(10),                    
 @InsurerBankAccountId int,         
 @PageNumber int,                
 @PageSize int,          
 @OtherFilter int , 
 @CheckNumber varchar(100)  ,           
 @SortExpression  varchar(50),              
 @SortOrder varchar(4)  
    
    
)    
    
/********************************************************************************      
-- Stored Procedure: dbo.scsp_ListPageSCSubstanceAbuseScreens       
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: used by Contact Note List page.     
-- Called by: ssp_CMGetChecksFilteredDetail      
--      
-- Updates:                                                             
-- Date        Author      Purpose      
/* 26-Sept-2015 Manikandan Network Customization- Created for Checks Details  List Page under Provider COntracts Detail Page*/    
*********************************************************************************/     
AS   

SELECT NULL AS DocumentId      
      
RETURN 