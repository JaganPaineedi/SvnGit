/****** Object:  StoredProcedure [dbo].[csp_PMAuthorizationsUsed]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMAuthorizationsUsed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMAuthorizationsUsed]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMAuthorizationsUsed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[csp_PMAuthorizationsUsed]
@AuthorizationId int

as

select a.ClientId, h.CodeName as Status, a.DateOfService, c.DisplayAs as ProcedureCode, 
a.Unit, d.CodeName as UnitType, f.LastName + '', '' + f.FirstName as Staff,
e.ProgramCode as Program, g.LocationCode as Location, max(b.UnitsUsed) as UnitsUsed, 
max(b.UnitsScheduled) as UnitsScheduled
from Services a
JOIN ServiceAuthorizations b ON (a.ServiceId = b.ServiceId)
JOIN ProcedureCodes c ON (a.ProcedureCodeId = c.ProcedureCodeId)
JOIN GlobalCodes d ON (a.UnitType = d.GlobalCodeId)
JOIN Programs e On (a.ProgramId = e.ProgramId)
LEFT JOIN Staff f ON (a.ClinicianId = f.StaffId)
LEFT JOIN Locations g ON (a.LocationId = g.LocationId)
JOIN GlobalCodes h ON (a.Status = h.GlobalCodeId)
where b.AuthorizationId = @AuthorizationId
and isnull(b.RecordDeleted,''N'') = ''N''
group by a.ClientId, h.CodeName , a.DateOfService, c.DisplayAs, 
a.Unit, d.CodeName , f.LastName + '', '' + f.FirstName,
e.ProgramCode , g.LocationCode
order by a.ClientId, a.DateOfService
' 
END
GO
