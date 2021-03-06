/****** Object:  StoredProcedure [dbo].[csp_validateDocument24HourAccessReport]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocument24HourAccessReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateDocument24HourAccessReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocument24HourAccessReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_validateDocument24HourAccessReport]      
@DocumentVersionId Int      
as      
BEGIN
BEGIN TRY     



CREATE TABLE [#CustomDocument24HourAccess] (      
	[DocumentVersionId] [int] null,
	[CreatedBy] varchar(100) null,
	[CreatedDate] datetime null,
	[ModifiedBy] varchar(100) null,
	[ModifiedDate] datetime null,
	[RecordDeleted] char(1) null,
	[DeletedBy] varchar(100) null,
	[DeletedDate] [datetime] null,
	[TimeOfCall] [datetime] null,
	[TimeSpentMinutes] [int] null,
	[PersonResponding] [int] null,
	[PersonCalling] [varchar](250) null,
	[PhoneNumber] varchar(100) null,
	[IssueConcern] varchar(max) null,
	[ActionTaken] varchar(max) null,
	[ResolvedNoFurtherAction] char(1) null,
	[ResolvedNeedsFollowup] char(1) null,
	[ReferredRescue] char(1) null,
	[ResultedInpatientAdmission] char(1) null,
	[Crisis911] char(1) null,
	[OtherAction] char(1) null,
	[OtherActionDescription] [varchar](250) null,
	[DangerSelfOthers] char(1) null,
	[DangerDescription] varchar(max) null,
	[Plan] varchar(max) null,
)      
      
INSERT INTO [#CustomDocument24HourAccess](      
	DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	TimeOfCall,
	TimeSpentMinutes,
	PersonResponding,
	PersonCalling,
	PhoneNumber,
	IssueConcern,
	ActionTaken,
	ResolvedNoFurtherAction,
	ResolvedNeedsFollowup,
	ReferredRescue,
	ResultedInpatientAdmission,
	Crisis911,
	OtherAction,
	OtherActionDescription,
	DangerSelfOthers,
	DangerDescription,
	[plan]
)      
select      
	DocumentVersionId,
	a.CreatedBy,
	a.CreatedDate,
	a.ModifiedBy,
	a.ModifiedDate,
	a.RecordDeleted,
	a.DeletedBy,
	a.DeletedDate,
	a.TimeOfCall,
	a.TimeSpentMinutes,
	a.PersonResponding,
	a.PersonCalling,
	a.PhoneNumber,
	a.IssueConcern,
	a.ActionTaken,
	a.ResolvedNoFurtherAction,
	a.ResolvedNeedsFollowup,
	a.ReferredRescue,
	a.ResultedInpatientAdmission,
	a.Crisis911,
	a.OtherAction,
	a.OtherActionDescription,
	a.DangerSelfOthers,
	a.DangerDescription,
	a.[plan]
from CustomDocument24HourAccess a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')<>''Y''      
    
insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select ''CustomDocument24HourAccess'', ''DeletedBy'', ''Time of call must be specified.'', 1, 1
from #CustomDocument24HourAccess
where (TimeOfCall is null)
union
select ''CustomDocument24HourAccess'', ''DeletedBy'', ''Person responding must be specified.'', 1, 2
from #CustomDocument24HourAccess
where (PersonResponding is null)
union
select ''CustomDocument24HourAccess'', ''DeletedBy'', ''Person calling must be specified.'', 1, 3
from #CustomDocument24HourAccess
where (PersonCalling is null)
union
select ''CustomDocument24HourAccess'', ''DeletedBy'', ''Action taken must be specified.'', 1, 4
from #CustomDocument24HourAccess
where (ActionTaken is null)
union
select ''CustomDocument24HourAccess'', ''DeletedBy'', ''Action taken type must be specified.'', 1, 5
from #CustomDocument24HourAccess
where (
	isnull(ResolvedNoFurtherAction, ''N'') = ''N'' and
	isnull(ResolvedNeedsFollowup, ''N'') = ''N'' and
	isnull(ReferredRescue, ''N'') = ''N'' and
	isnull(ResultedInpatientAdmission, ''N'') = ''N'' and
	isnull(Crisis911, ''N'') = ''N'' and
	isnull(OtherAction, ''N'') = ''N'' 
)
or (
	isnull(OtherAction, ''N'') = ''Y'' 
	and LEN(LTRIM(RTRIM(isnull(OtherActionDescription, '''')))) = 0
)
union
select ''CustomDocument24HourAccess'', ''DeletedBy'', ''Danger to self/others must be specified.'', 1, 6
from #CustomDocument24HourAccess
where (DangerSelfOthers is null)
union
select ''CustomDocument24HourAccess'', ''DeletedBy'', ''Danger to self/others details must be specified.'', 1, 7
from #CustomDocument24HourAccess
where DangerSelfOthers = ''Y''
and len(LTRIM(RTRIM(ISNULL(DangerDescription, '''')))) = 0



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
          
END TRY

BEGIN CATCH     
   DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_validateDocument24HourAccessReport'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH

return  

END
' 
END
GO
