/****** Object:  StoredProcedure [dbo].[csp_MMGetLastNextMedicationVisits]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_MMGetLastNextMedicationVisits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_MMGetLastNextMedicationVisits]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_MMGetLastNextMedicationVisits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_MMGetLastNextMedicationVisits]    
/*------------------------------------------------------------------------------------------*/    
/* Procedure: csp_MMGetLastNextMedicationVisits            */    
/*                       */    
/* Purpose: called by scsp_SCClientMedicationClientInformation to determine the most  */    
/*  recent and next medication visits.             */    
/*                       */    
/* Created by: TER                   */    
/* Created Dt: 3/10/2009                 */    
/*------------------------------------------------------------------------------------------*/    
    
 @ClientId int,    
 @LastMedicationVisit varchar(1000) output,    
 @NextmedicationVisit varchar(1000) output    
as    
    
-- logic for Summit Pointe    
    
 select @LastMedicationVisit =     
  case when datepart(month, s.DateOfService) < 10 then ''0'' else '''' end + cast(datepart(month, s.DateOfService) as varchar)     
  + ''/'' + case when datepart(day, s.DateOfService) < 10 then ''0'' else '''' end + cast(datepart(day, s.DateOfService) as varchar)     
  + ''/'' + cast(datepart(year, s.DateOfService) as varchar)    
 from Services as s    
 where s.ClientId = @ClientId    
 and isnull(s.RecordDeleted, ''N'') <> ''Y''    
 and s.ProgramId in (9,10,11)    
 and s.status in (71,75)    
 and not exists (    
  select *    
  from Services as s2    
  where s2.ClientId = @ClientId    
  and isnull(s2.RecordDeleted, ''N'') <> ''Y''    
  and s2.ProgramId in (9,10,11)    
  and s2.status in (71,75)    
  and datediff(day, s2.DateOfService, s.DateOfService) < 0    
 )    
    
 select @NextMedicationVisit =     
  case when datepart(month, s.DateOfService) < 10 then ''0'' else '''' end + cast(datepart(month, s.DateOfService) as varchar)     
  + ''/'' + case when datepart(day, s.DateOfService) < 10 then ''0'' else '''' end + cast(datepart(day, s.DateOfService) as varchar)     
  + ''/'' + cast(datepart(year, s.DateOfService) as varchar)    
 from Services as s    
 where s.ClientId = @ClientId    
 and isnull(s.RecordDeleted, ''N'') <> ''Y''    
 and s.ProgramId in (9,10,11)    
 and s.status = 70    
 and not exists (    
  select *    
  from Services as s2    
  where s2.ClientId = @ClientId    
  and isnull(s2.RecordDeleted, ''N'') <> ''Y''    
  and s2.ProgramId in (9,10,11)    
  and s2.status = 70    
  and datediff(day, s2.DateOfService, s.DateOfService) > 0    
 )
' 
END
GO
