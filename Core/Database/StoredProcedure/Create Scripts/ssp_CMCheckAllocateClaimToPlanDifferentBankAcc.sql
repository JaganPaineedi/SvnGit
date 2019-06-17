  
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

IF EXISTS ( SELECT  1
            FROM    sys.procedures
            WHERE   name = 'ssp_CMCheckAllocateClaimToPlanDifferentBankAcc' ) 
    BEGIN
        DROP PROCEDURE ssp_CMCheckAllocateClaimToPlanDifferentBankAcc
    END
GO
create procedure [dbo].[ssp_CMCheckAllocateClaimToPlanDifferentBankAcc]  
@InsurerId       int,  
@AllocatedPlanId int,    
@ToAllocate int    
/*********************************************************************            
-- Stored Procedure: dbo.ssp_CMCheckAllocateClaimToPlanDifferentBankAcc  
-- Copyright: 2007 Provider Claim Management System  
-- Creation Date:  05/03/2008                        
--                                                   
-- Purpose: In the 'Modify Plan Allocation' screen, a user may not allocate $  
--          to a plan that is associated with a different bank account than the   
--          original plan  
--                                                                                    
-- Modified Date    Modified By       Purpose  
-- 05.03.2007       Neelam Prasad     Created.  
-- 07.14.2008       SFarber           Modified to properly handle the RecordDeleted flag.  
-- 07.16.2014		Manju P			  What/Why:Care Management to SmartCare Task #25                
****************************************************************************/             
as    
begin  
  
declare @AllocatedBankAccountNumber varchar(100)  
declare @AllocateBankAccountNumber varchar(100)  
  
select top 1 @AllocatedBankAccountNumber = a.BankAccountNumber  
  from InsurerBankAccounts a  
       inner join InsurerBankAccountPlans b on a.InsurerBankAccountId = b.InsurerBankAccountId   
 where a.InsurerId = @InsurerId   
   and a.Active='Y'   
   and b.PlanId = @AllocatedPlanId  
   and isnull(a.RecordDeleted, 'N') = 'N'  
   and isnull(b.RecordDeleted, 'N') = 'N'  
  
  
select top 1 @AllocateBankAccountNumber = a.BankAccountNumber  
  from InsurerBankAccounts a  
       inner join InsurerBankAccountPlans b on a.InsurerBankAccountId = b.InsurerBankAccountId   
 where a.InsurerId = @InsurerId   
   and a.Active = 'Y'   
   and b.PlanId = @ToAllocate  
   and isnull(a.RecordDeleted, 'N') = 'N'  
   and isnull(b.RecordDeleted, 'N') = 'N'  
  
  
if @AllocatedBankAccountNumber = @AllocateBankAccountNumber  
  select 'Y'  
else  
  select 'N'  
  
end  
  