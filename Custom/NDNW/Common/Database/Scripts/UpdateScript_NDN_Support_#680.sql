/*
Added by Lakshmi kanth on 26/07/2017
*/

declare @ProgramId int 
declare _Findprograms cursor FAST_FORWARD for 
Select ProgramId From Programs where isnull(recorddeleted, 'n') = 'n' order by 1 desc 
open _Findprograms 
fetch _Findprograms into @ProgramId 
while @@FETCH_STATUS = 0 
   begin
;
WITH dulicates AS 
(
   SELECT
      ProgramProcedureId,
      programid,
      ProcedureCodeId,
      createdby,
      recorddeleted,
      deleteddate,
      deletedby,
      Row_number() over (PARTITION BY ProcedureCodeId, createdby 
   ORDER BY
      ProcedureCodeId, createdby) AS num 
   FROM programprocedures 
   WHERE programid = @ProgramId 
   AND isnull(recorddeleted, 'n') = 'n' 
)
--Select * From dulicates WHERE num > 1 	
   UPDATE dulicates
   SET recorddeleted='Y',
       deleteddate=getdate(),
       deletedby='Admin'
   WHERE num>1
   fetch _Findprograms into @ProgramId 
   end
   CLOSE _Findprograms DEALLOCATE _Findprograms