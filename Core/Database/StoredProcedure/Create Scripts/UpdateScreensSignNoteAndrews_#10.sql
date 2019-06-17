---Update script for Sccrens and Documentcodes table Required for task.
---Added By sunil.D  
---16/11/2017
---Andrews Center - Customizations Project #10

IF  EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=750)
begin
   update Screens set   ScreenURL='/ActivityPages/Client/Detail/PrimaryCare/ProgressNotes/ProgressNoteSign.ascx'  WHERE ScreenId=750 
   and ScreenURL='/ActivityPages/Client/Detail/PrimaryCare/ProgressNotes/SignNote.ascx'
 end
 
-- IF  EXISTS( SELECT 1 FROM documentcodes where DocumentCodeId=300)
--begin
--   update documentcodes set   TableList='DocumentProgressNotes,NoteEMCodeOptions' WHERE DocumentCodeId=300
--    and TableList='DocumentProgressNotes,NoteEMCodeOptions'
-- end
 