IF EXISTS(SELECT * FROM Documentcodes WHERE DocumentcodeId=11145 and DocumentName = 'Individual Service Note')
BEGIN
IF NOT EXISTS(SELECT * FROM GroupNoteDocumentCodes WHERE ServiceNoteCodeId=11145)
insert into GroupNoteDocumentCodes (GroupNoteName,Active,GroupNoteCodeId,ServiceNoteCodeId)values
('Individual Service Note','Y',115,11145)
END