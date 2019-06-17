 /********************************************************************************************
Author       :  Sunil.D
CreatedDate  :  31/07/2017
Purpose      :  UPDATE script for  A Renewed Mind Agency.
					What: Updated the address for agency 
					Why: Agency address showing old address instead of New address
					Task -#684 Renewed minds.
**********************************************************************************************************************/
if exists (SELECT 1 FROM agency )
begin

update agency set [PaymentAddress]= '885 Commerce Dr, Perrysburg, OH 43551'  

update agency set [PaymentAddressDisplay]= '885 Commerce Dr, Perrysburg, OH 43551'  


end
 