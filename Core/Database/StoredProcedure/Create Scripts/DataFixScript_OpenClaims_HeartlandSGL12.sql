/*
pulled logic from ssp_CMManageOpenClaims and removed constraint on @ClaimlineId for faster performance for bulk update vs a cursor
*/

DECLARE @userCode VARCHAR(30) = 'HeartlandSGL12';
DECLARE @currentDate DATETIME = GETDATE();

declare @Open table (ClaimLineId int)

-- Determine if the claim line is still open
insert @Open (ClaimLineId)
-- Check if the claim line is not in final status
select cl.ClaimLineId
  from Claims c
       join ClaimLines cl on cl.ClaimId = c.ClaimId
 where cl.[Status] in (2021, 2022, 2023, 2025, 2027)
   and isnull(c.RecordDeleted, 'N') = 'N'
   and isnull(cl.RecordDeleted, 'N') = 'N'
union
-- Check if the claim line is Denied/Pended and needs to be readjudicated
select cl.ClaimLineId
  from Claims c
       join ClaimLines cl on cl.ClaimId = c.ClaimId
 where  cl.[Status] in (2024, 2027)
   and cl.ToReadjudicate = 'Y'
   and isnull(c.RecordDeleted, 'N') = 'N'
   and isnull(cl.RecordDeleted, 'N') = 'N'
union
-- Check if the claim line is Denied/Pended and needs to be worked
select cl.ClaimLineId
  from Claims c
       join ClaimLines cl on cl.ClaimId = c.ClaimId
 where  cl.[Status] in (2024, 2027)
   and cl.NeedsToBeWorked = 'Y'
   and isnull(c.RecordDeleted, 'N') = 'N'
   and isnull(cl.RecordDeleted, 'N') = 'N'

---Remove all claimlines that should not be in the table
  delete from oc 
  FROM OpenClaims AS oc
  WHERE NOT EXISTS (SELECT 1
					FROM @Open AS o 
					WHERE o.ClaimLineId = oc.ClaimLineId
				   )
  --make sure open claims contains all the records it should
  insert into OpenClaims (ClaimLineId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
  select ClaimLineId,@userCode,@currentDate,@userCode,@currentDate
    from @Open o
   where not exists(select * from OpenClaims oc where oc.ClaimLineId = o.ClaimLineId)
GO