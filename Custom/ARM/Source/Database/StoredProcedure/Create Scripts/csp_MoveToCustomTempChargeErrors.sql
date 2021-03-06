/****** Object:  StoredProcedure [dbo].[csp_MoveToCustomTempChargeErrors]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_MoveToCustomTempChargeErrors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_MoveToCustomTempChargeErrors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_MoveToCustomTempChargeErrors]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_MoveToCustomTempChargeErrors]
as
--
-- This a short term solution!!!!
--

insert into CustomTempChargeErrors(
       ChargeErrorId, 
       ChargeId, 
       ErrorType, 
       ErrorDescription, 
       RowIdentifier, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate, 
       RecordDeleted, 
       DeletedDate, 
       DeletedBy)
select ChargeErrorId, 
       ChargeId, 
       ErrorType, 
       ErrorDescription, 
       RowIdentifier, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate, 
       RecordDeleted, 
       DeletedDate, 
       DeletedBy
  from ChargeErrors ce
 where not exists(select * from OpenCharges oc where oc.ChargeId = ce.ChargeId)

delete ce
  from ChargeErrors ce
 where not exists(select * from OpenCharges oc where oc.ChargeId = ce.ChargeId)

return
' 
END
GO
