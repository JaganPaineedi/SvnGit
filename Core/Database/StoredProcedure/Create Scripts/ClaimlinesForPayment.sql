
If Exists (select 1 from sys.types where name = 'ClaimlinesForPayment')
Begin
-- Added drop statement for 2 SPs since table type will not get dropped untill we drop the dependent stored procedures. After dropping we need to re-create the SPs
 Drop procedure dbo.ssp_CMUpdateClaimLineCredits
 Drop procedure dbo.ssp_CMUpdateClaimLines
Drop Type ClaimlinesForPayment
End
Go

CREATE TYPE ClaimlinesForPayment AS TABLE 

--*********************************************************************            
-- Table Type: ClaimlinesForPayment
-- Copyright: 2017 Provider Claim Management System  
-- Creation Date:  11/30/2017                        
--                                                   
-- Purpose: processes claim line payment credits during check printing
--                                                                                    
-- Modified Date   Modified By       Purpose 
-- 11.Dec.2017     Kiran Kumar	    Created         
(
	ClaimLineID int NOT NULL, 
	Amount money NOT NULL,
	Status int
)




