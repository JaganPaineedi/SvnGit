if object_id('dbo.ssp_CMInsertOverrideClaimLineHistory') is not null
  drop procedure dbo.ssp_CMInsertOverrideClaimLineHistory
go

create procedure dbo.ssp_CMInsertOverrideClaimLineHistory
  @ClaimlineId int,
  @StaffId int,
  @Usercode varchar(30)
/*********************************************************************                          
-- Stored Procedure: dbo.ssp_CMInsertOverrideClaimLineHistory                
-- Creation Date:  10/Sep/2018                                     
--                                                                 
-- Purpose: Created SP.Update ClaimLines (OverridePendedReason='Y') when user overring the ClaimLines.         
--          Task #13 - Partner Solutions - Enhancements                                                                                        
-- Input Parameters:   
--                                 
-- Updates                                                                   
-- Modified Date    Modified By       Purpose                
-- 01.24.2018       SFarber           Modified to set ToReadjudicate to 'Y'; to do nothing if OverridePendedReason is alreay 'Y'
****************************************************************************/
as
if exists ( select  *
            from    ClaimLines cl
            where   cl.ClaimLineId = @ClaimlineId
                    and cl.Status = 2027
                    and isnull(cl.OverridePendedReason, 'N') = 'N' )
  begin
    update  ClaimLines
    set     OverridePendedReason = 'Y',
            ToReadjudicate = 'Y',
            ModifiedBy = @Usercode,
            ModifiedDate = getdate()
    where   ClaimLineId = @ClaimlineId

	
    insert  into ClaimLineHistory
            (ClaimLineId,
             Activity,
             ActivityDate,
             Status,
             ActivityStaffId,
             CreatedBy,
             CreatedDate,
             ModifiedBy,
             ModifiedDate)
    select  @ClaimlineId,
            2014,
            getdate(),
            2027,
            @StaffId,
            @Usercode,
            getdate(),
            @Usercode,
            getdate()
  end


go


