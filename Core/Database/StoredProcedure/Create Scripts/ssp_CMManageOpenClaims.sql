IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_CMManageOpenClaims')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_CMManageOpenClaims;
    END;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[ssp_CMManageOpenClaims]
@ClaimLineId INT,
@UserCode VARCHAR(30)
/********************************************************************************
-- Stored Procedure: dbo.ssp_CMManageOpenClaims  
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Inserts/deletes from OpenClaims
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 08.09.2011  SFarber     Created.      
-- 01.22.2018  jcarlson	   Heartland SGL 12: Added @UserCode and removed "Check if the claim line is Denied and waiting to be included on RA or Denial letter"
-- 01.25.2019  K.Soujanya  Modified sp to update OpenClaims table if ClaimLineUnderReview check box is checked.
*********************************************************************************/
as

declare @ErrorNo int
declare @ErrorMsg varchar(max)
DECLARE @currentDate DATETIME = GETDATE();

declare @Open table (ClaimLineId int)

-- Determine if the claim line is still open
insert @Open (ClaimLineId)
-- Check if the claim line is not in final status
select cl.ClaimLineId
  from Claims c
       join ClaimLines cl on cl.ClaimId = c.ClaimId
 where cl.ClaimLineId = @ClaimLineId
   and cl.Status in (2021, 2022, 2023, 2025, 2027)
   and isnull(c.RecordDeleted, 'N') = 'N'
   and isnull(cl.RecordDeleted, 'N') = 'N'
union
-- Check if the claim line is Denied/Pended and needs to be readjudicated
select cl.ClaimLineId
  from Claims c
       join ClaimLines cl on cl.ClaimId = c.ClaimId
 where cl.ClaimLineId = @ClaimLineId
   and cl.Status in (2024, 2027)
   and cl.ToReadjudicate = 'Y'
   and isnull(c.RecordDeleted, 'N') = 'N'
   and isnull(cl.RecordDeleted, 'N') = 'N'
union
-- Check if the claim line is Denied/Pended and needs to be worked
select cl.ClaimLineId
  from Claims c
       join ClaimLines cl on cl.ClaimId = c.ClaimId
 where cl.ClaimLineId = @ClaimLineId
   and cl.Status in (2024, 2027)
   and (cl.NeedsToBeWorked = 'Y' or IsNULL(cl.ClaimLineUnderReview,'N') = 'Y')
   and isnull(c.RecordDeleted, 'N') = 'N'
   and isnull(cl.RecordDeleted, 'N') = 'N'


if @@error <> 0
begin
  select @ErrorNo = 50010, @ErrorMsg = 'Failed to insert into @Open'
  goto error
end 

-- If the claim line is not open, delete otherwise insert into OpenClaims
if not exists(select * from @Open)
begin
  delete from OpenClaims where ClaimLineId = @ClaimLineId
  
  if @@error <> 0
  begin
    select @ErrorNo = 50020, @ErrorMsg = 'Failed to delete from OpenClaims'
    goto error
  end 
end
else
begin
  insert into OpenClaims (ClaimLineId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
  select ClaimLineId,@UserCode,@currentDate,@UserCode,@currentDate
    from @Open o
   where not exists(select * from OpenClaims oc where oc.ClaimLineId = o.ClaimLineId)

  if @@error <> 0
  begin
    select @ErrorNo = 50030, @ErrorMsg = 'Failed to insert into OpenClaims'
    goto error
  end 
end

return

error:

set @ErrorMsg = 'Failed to execute ssp_CMManageOpenClaims: ' + @ErrorMsg

RAISERROR(@ErrorMsg,16,1)

GO
