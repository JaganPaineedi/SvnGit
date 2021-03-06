/****** Object:  UserDefinedFunction [dbo].[ISC_GetAlternativeMedicationNames]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ISC_GetAlternativeMedicationNames]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ISC_GetAlternativeMedicationNames]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ISC_GetAlternativeMedicationNames]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[ISC_GetAlternativeMedicationNames]       
      
  (@MedicationNameId int)   
 
--returns @MedList table (MedicationNameId int,
--                        MedicationName varchar(100)) 
returns @results table (      
   MedicationNameId int not null primary key,      
   MedicationType int,      
 MedicationName varchar(100)      
)  
as      
begin      
declare @STATUSCURRENT int, @GENERICTYPE int      
      
select @STATUSCURRENT = 4881, @GENERICTYPE = 2      
      
--declare @results table (      
--   MedicationNameId int not null primary key,      
--   MedicationType int,      
-- MedicationName varchar(100)      
--)      
      
      
-- get all medications for clinical formulations under the specific medication name      
insert into @results (MedicationNameId, MedicationType, MedicationName)      
select distinct n.MedicationNameId, n.MedicationType, n.MedicationName      
from MDMedications as m      
join MDMedications as m2 on m2.ClinicalFormulationId = m.ClinicalFormulationId      
join MDMedicationNames as n on n.MedicationNameId = m2.MedicationNameId      
where m.MedicationNameId = @MedicationNameId      
--and n.MedicationNameId <> @MedicationNameId      
and m.Status = @STATUSCURRENT      
and m2.Status = @STATUSCURRENT      
and n.Status = @STATUSCURRENT      
and isnull(m.RecordDeleted, ''N'') <> ''Y''      
and isnull(m2.RecordDeleted, ''N'') <> ''Y''      
and isnull(n.RecordDeleted, ''N'') <> ''Y''      
      
-- find other meds based on any generics in the result set      
insert into @results (MedicationNameId, MedicationType, MedicationName)      
select distinct n.MedicationNameId, n.MedicationType, n.MedicationName      
from MDMedications as m      
join MDMedications as m2 on m2.ClinicalFormulationId = m.ClinicalFormulationId      
join MDMedicationNames as n on n.MedicationNameId = m2.MedicationNameId      
join @results as r on r.MedicationNameId = m.MedicationNameId      
where r.MedicationType = @GENERICTYPE      
--and n.MedicationNameId <> @MedicationNameId      
and m.Status = @STATUSCURRENT      
and m2.Status = @STATUSCURRENT      
and n.Status = @STATUSCURRENT      
and isnull(m.RecordDeleted, ''N'') <> ''Y''      
and isnull(m2.RecordDeleted, ''N'') <> ''Y''      
and isnull(n.RecordDeleted, ''N'') <> ''Y''      
and not exists (      
   select * from @results as r2 where r2.MedicationNameId = n.MedicationNameId      
)      
--insert @MedList     
--select r.MedicationNameId, r.MedicationName      
--from @results as r      
--order by r.MedicationName      
return 

END
' 
END
GO
