/****** Object:  StoredProcedure [dbo].[csp_GetCareManagementIds]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCareManagementIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCareManagementIds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCareManagementIds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_GetCareManagementIds]
as

begin tran

update c
   set CareManagementId = null
  from Clients c
 where CareManagementId is not null

if @@error <> 0 goto error

update c
   set CareManagementId = cmc.ClientId
  from Clients c
       join CustomCareManagementClients cmc on cmc.FirstName = c.FirstName and
                                               cmc.LastName = c.LastName and
                                               cmc.DOB = c.DOB

if @@error <> 0 goto error

update c
   set CareManagementId = cmc.ClientId
  from Clients c
       join CustomCareManagementClients cmc on cmc.SSN = c.SSN and
                                               cmc.DOB = c.DOB
 where c.CareManagementId is null
   and c.SSN not in (replicate(''0'', 9), replicate(''1'', 9), replicate(''2'', 9), replicate(''3'', 9), replicate(''4'', 9),
                     replicate(''5'', 9), replicate(''6'', 9), replicate(''7'', 9), replicate(''8'', 9), replicate(''9'', 9))
   and not exists(select * 
                    from Clients c2
                   where c2.CareManagementId = cmc.ClientId)

if @@error <> 0 goto error


commit tran

return

error:
rollback tran
' 
END
GO
