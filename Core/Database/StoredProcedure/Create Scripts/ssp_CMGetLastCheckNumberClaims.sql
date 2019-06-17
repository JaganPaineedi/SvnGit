if object_id('dbo.ssp_CMGetLastCheckNumberClaims') is not null
  drop procedure dbo.ssp_CMGetLastCheckNumberClaims
go  

create procedure dbo.ssp_CMGetLastCheckNumberClaims
@InsurerBankAccountId int
/*********************************************************************                
-- Stored Procedure: dbo.ssp_CMGetLastCheckNumberClaims               
-- Copyright: Streamline Healthcare Solutions         
--                                  
-- Purpose: Gets the last check number	
--                       
-- Updates:                                               
--  Date              Author       Purpose             
-- 09.26.2006		  Kaushal      Created                  
-- 06.26.2014		  Manju		   Modified - CM to SC task #25 
-- 11.05.2014         Rohith Uppin Since InsurerBankAccounts table was not getting update. so getting from check table.
-- 05.01.2015         SFarber      Reverted Rohith's change.
-- 22.May.2015		  Rohith Uppin All columns are added to Select query which was required in .net dataset to update table.
										Task#147 CM to SC.
-- 17.Nov.2015		  Rohith Uppin	Removed ISNull method from LastCheckNumber. Task#86 Valley - Support Go Live
*********************************************************************/                 
as
 
select InsurerBankAccountId,
		InsurerId,
		BankAccountName,
		BankName,
		BankAccountNumber,
		LastCheckNumber,
		CheckType,
		CheckPrinterLocation,
		Active,
		FromDate,
		ToDate,
		Signer1,
		Signer2,
		RowIdentifier,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedDate,
		DeletedBy 
  from InsurerBankAccounts iba
 where iba.InsurerbankAccountId = @InsurerBankaccountId 

return

go
