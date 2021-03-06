/****** Object:  StoredProcedure [dbo].[csp_PMClaims837Rounding_Test]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837Rounding_Test]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims837Rounding_Test]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837Rounding_Test]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

      
CREATE procedure [dbo].[csp_PMClaims837Rounding_Test]    
AS    
BEGIN    
    
DECLARE @ErrorNumber int = null, @ErrorMessage varchar(100) = null    

-- Set all claim units to null
update #ClaimLines
set ClaimUnits = null
    
---*** Changed for MACSIS    
-- New MACSIS Codes    
-- Medicaid Coverage Plans    
update a    
set ClaimUnits = CONVERT(int,a.ServiceUnits)/15 + (case when (CONVERT(int,a.ServiceUnits)%15-7) > 0 then 1 else 0 end)    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
/*  
ON (a.BillingCode = b.CPTCode    
and (a.Modifier1 = b.CPTModifier1 or    
(a.Modifier1 is null and b.CPTModifier1 is null))    
and (a.Modifier2 = b.CPTModifier2 or    
(a.Modifier2 is null and b.CPTModifier2 is null)))    
*/  
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''Y'')    
where b.UnitinMinutes = 15 and b.MaxUnits is null    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
    
update a    
set ClaimUnits = convert(decimal(7,1),case when CONVERT(int,a.ServiceUnits) < 8 then 0 else    
CONVERT(int,a.ServiceUnits)/6 + (case when (CONVERT(int,a.ServiceUnits)%6-2) > 0 then 1 else 0 end) end)/10    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''Y'')    
where b.UnitinMinutes = 60 and b.MaxUnits is null    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
    
-- Day Programs    
update a    
set ClaimUnits = case when convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits))/convert(decimal,b.UnitinMinutes)) > b.MaxUnits    
then b.MaxUnits    
else convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits))/convert(decimal,b.UnitinMinutes)) end    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''Y'')    
where b.MaxUnits is not null    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
    
/*    
-- Old MACSIS Codes    
update a    
set ClaimUnits = convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits) + (5 - (CONVERT(int,a.ServiceUnits)-1)%6))/convert(decimal,b.UnitinMinutes))    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON (a.BillingCode = b.CPTCode    
and (a.Modifier1 = b.CPTModifier1 or    
(a.Modifier1 is null and b.CPTModifier1 is null))    
and (a.Modifier2 = b.CPTModifier2 or    
(a.Modifier2 is null and b.CPTModifier2 is null)))    
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''Y'')    
where a.encounter_id <> 0 and b.MaxUnits is null    
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
    
update a    
set ClaimUnits = case when convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits) + (5 - (CONVERT(int,a.ServiceUnits)-1)%6))/convert(decimal,b.UnitinMinutes)) > b.MaxUnits    
then b.MaxUnits     
else convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits) + (5 - (CONVERT(int,a.ServiceUnits)-1)%6))/convert(decimal,b.UnitinMinutes)) end    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON (a.BillingCode = b.CPTCode    
and (a.Modifier1 = b.CPTModifier1 or    
(a.Modifier1 is null and b.CPTModifier1 is null))    
and (a.Modifier2 = b.CPTModifier2 or    
(a.Modifier2 is null and b.CPTModifier2 is null)))    
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''Y'')    
Where a.encounrter_id <> 0b.MaxUnits is not null    
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
*/    
    
/*    
update a    
set adjusted_charge = a.ClaimUnits*b.charge_per_unit,    
amount_owed = a.ClaimUnits*b.charge_per_unit    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON (a.BillingCode = b.CPTCode    
and (a.Modifier1 = b.CPTModifier1 or    
(a.Modifier1 is null and b.CPTModifier1 is null))    
and (a.Modifier2 = b.CPTModifier2 or    
(a.Modifier2 is null and b.CPTModifier2 is null)))    
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''Y'')    
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Calculating adjusted charge''    
 goto error    
end    
*/    
    
-- Non Medicaid Coverage Plans    
update a    
set ClaimUnits = CONVERT(int,a.ServiceUnits)/15 + (case when (CONVERT(int,a.ServiceUnits)%15-7) > 0 then 1 else 0 end)    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomNonMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''N'')    
where b.UnitinMinutes = 15 and b.MaxUnits is null    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
    
update a    
set ClaimUnits = convert(decimal(7,1),case when CONVERT(int,a.ServiceUnits) < 8 then 0 else    
CONVERT(int,a.ServiceUnits)/6 + (case when (CONVERT(int,a.ServiceUnits)%6-2) > 0 then 1 else 0 end) end)/10    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomNonMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''N'')    
where b.UnitinMinutes = 60 and b.MaxUnits is null    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
    
-- Day Programs    
update a    
set ClaimUnits = case when convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits))/convert(decimal,b.UnitinMinutes)) > b.MaxUnits    
then b.MaxUnits    
else convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits))/convert(decimal,b.UnitinMinutes)) end    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomNonMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''N'')    
where b.MaxUnits is not null    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
/*    
-- Old MACSIS Codes    
update a    
set ClaimUnits = convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits) + (5 - (CONVERT(int,a.ServiceUnits)-1)%6))/convert(decimal,b.UnitinMinutes))    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON (a.BillingCode = b.CPTCode    
and (a.Modifier1 = b.CPTModifier1 or    
(a.Modifier1 is null and b.CPTModifier1 is null))    
and (a.Modifier2 = b.CPTModifier2 or    
(a.Modifier2 is null and b.CPTModifier2 is null)))    
JOIN CustomNonMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''N'')    
where a.encounter_id <> 0 b.MaxUnits is null    
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
    
update a    
set ClaimUnits = case when convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits) + (5 - (CONVERT(int,a.ServiceUnits)-1)%6))/convert(decimal,b.UnitinMinutes)) > b.MaxUnits    
then b.MaxUnits     
else convert(decimal(7,1),convert(decimal,CONVERT(int,a.ServiceUnits) + (5 - (CONVERT(int,a.ServiceUnits)-1)%6))/convert(decimal,b.UnitinMinutes)) end    
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON (a.BillingCode = b.CPTCode    
and (a.Modifier1 = b.CPTModifier1 or    
(a.Modifier1 is null and b.CPTModifier1 is null))    
and (a.Modifier2 = b.CPTModifier2 or    
(a.Modifier2 is null and b.CPTModifier2 is null)))    
JOIN CustomNonMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
and b.medicaid = ''N'')    
where a.encounter_id <> 0 b.MaxUnits is not null    
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Updating Units of Service''    
 goto error    
end    
*/    
-- Send the charge amount as the medicaid amount    
-- THe amount owed is non-medicaid charge in case of non-medicaid    
/*
update a    
set ChargeAmount = case when a.ClaimUnits*b.ChargePerUnit > ChargeAmount 
	then  a.ClaimUnits*b.ChargePerUnit else a.ChargeAmount end 
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
)    
where b.medicaid = ''Y''    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Calculating adjusted charge''    
 goto error    
end    
    
update a    
set ChargeAmount = case when a.ClaimUnits*b.ChargePerUnit > ChargeAmount 
	then  a.ClaimUnits*b.ChargePerUnit else a.ChargeAmount end 
from #ClaimLines a    
JOIN CustomMACSISCPTUnits b    
ON a.BillingCode = b.CPTCode  
and ( ( a.Modifier1 is null   
  and  b.CPTModifier1 is null  
  )   
 or  ( a.Modifier1 is not null   
  and b.CPTModifier1 is not null   
  and a.Modifier1 = b.CPTModifier1  
  )  
 )  
and ( ( a.Modifier2 is null   
  and  b.CPTModifier2 is null  
  )   
 or  ( a.Modifier2 is not null   
  and b.CPTModifier2 is not null   
  and a.Modifier2 = b.CPTModifier2  
  )  
 )  
JOIN CustomNonMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId    
)    
where b.medicaid = ''N''    
and a.DateOfService >= b.EffectiveFrom  
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)  
    
if @@error <> 0    
begin    
 select @ErrorNumber = @@error, @ErrorMessage = ''Error Calculating amount owed''    
 goto error    
end    
--*/
      
SET ANSI_WARNINGS ON    
    
return    
    
error:    
    
raiserror @ErrorNumber @ErrorMessage    
    
    
END 

' 
END
GO
