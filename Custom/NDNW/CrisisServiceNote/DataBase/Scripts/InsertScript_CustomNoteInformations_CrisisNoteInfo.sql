
delete from CustomNoteInformations where DocumentCodeId=60006

insert into CustomNoteInformations (documentcodeid,informationtext,InformationToolTipStoredProcedure)
values(60006,'Scoring: 0-17','csp_CustomDocumentGetCrisisServiceNoteInformation')

insert into CustomNoteInformations (documentcodeid,informationtext,InformationToolTipStoredProcedure)
values(60006,'Scoring: 18-35','csp_CustomDocumentGetCrisisServiceNoteInformationScore18')

insert into CustomNoteInformations (documentcodeid,informationtext,InformationToolTipStoredProcedure)
values(60006,'Scoring: 36-52','csp_CustomDocumentGetCrisisServiceNoteInformationScore35')