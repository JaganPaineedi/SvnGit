/****** Object:  StoredProcedure [dbo].[csp_validateCustomDDAssessment]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDDAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDDAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDDAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_validateCustomDDAssessment]  
@DocumentVersionId Int  
as  
  


CREATE TABLE [#CustomDDAssessment] (  
DocumentVersionId int null, 
CommunicationStyle int null,  
SupportNature int null,  
SupportStatus int null,  
LevelVision int null,  
LevelHearing int null,  
LevelOther int null,  
LevelBehavior int null,  
AssistanceMobility char(1) null,  
AssistanceMedication char(1) null,  
AssistancePersonal char(1) null,  
AssistanceHousehold char(1) null,  
AssistanceCommunity char(1) null  
)  
  
INSERT INTO [#CustomDDAssessment](  
DocumentVersionId,
CommunicationStyle,  
SupportNature,  
SupportStatus,  
LevelVision,  
LevelHearing,  
LevelOther,  
LevelBehavior,  
AssistanceMobility,  
AssistanceMedication,  
AssistancePersonal,  
AssistanceHousehold,  
AssistanceCommunity  
)  
select   
a.DocumentVersionId, 
a.CommunicationStyle,  
a.SupportNature,  
a.SupportStatus,  
a.LevelVision,  
a.LevelHearing,  
a.LevelOther,  
a.LevelBehavior,  
a.AssistanceMobility,  
a.AssistanceMedication,  
a.AssistancePersonal,  
a.AssistanceHousehold,  
a.AssistanceCommunity  
from CustomDDAssessment a   
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')<>''Y''  


--
-- DECLARE VARIABLES
--
declare @Variables varchar(max)
declare @DocumentType varchar(20)
Declare @DocumentCodeId int


--
-- DECLARE TABLE SELECT VARIABLES
--
set @Variables = ''Declare @DocumentVersionId int
					Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId)				


Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)
set @DocumentType = NULL

--
-- Exec csp_validateDocumentsTableSelect to determine validation list
--
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables


/*
Insert into #validationReturnTable  
(TableName,  
ColumnName,  
ErrorMessage  
)  
--This validation returns three fields  
--Field1 = TableName  
--Field2 = ColumnName  
--Field3 = ErrorMessage  
  
  
Select ''CustomDDAssessment'', ''CommunicationStyle'', ''Predominant Communication Style must be specified''
Union
Select ''CustomDDAssessment'', ''SupportNature'', ''Family and/or friends must be specified''
Union
Select ''CustomDDAssessment'', ''SupportStatus'', ''Status of existing support system must be specified''
Union
Select ''CustomDDAssessment'', ''LevelVision'', ''Level of vision assistance must be selected.''
Union
Select ''CustomDDAssessment'', ''LevelHearing'', ''Level of hearing assistance must be selected.''
Union
Select ''CustomDDAssessment'', ''LevelOther'', ''Level of other physical/medical characteristics assistance must be selected.''
Union
Select ''CustomDDAssessment'', ''LevelBehavior'', ''Level of assistance for accomodating challenging behaviors must be selected.''
Union
Select ''CustomDDAssessment'', ''AssistanceMobility'', ''Mobility assistance needed must be indicated''
Union
Select ''CustomDDAssessment'', ''AssistanceMedication'', ''Medication administration assistance needed must be indicated''
Union
Select ''CustomDDAssessment'', ''AssistancePersonal'', ''Personal assistance needed must be indicated''
Union
Select ''CustomDDAssessment'', ''AssistanceHousehold'', ''Household assistance needed must be indicated''
Union
Select ''CustomDDAssessment'', ''AssistanceCommunity'', ''Community assistance needed must be indicated''  

if @@error <> 0 goto error  
  
*/ 
  
  
return  
  
error:  
raiserror 50000 ''csp_validateCustomDDAssessment failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
