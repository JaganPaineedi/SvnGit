/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentValidations]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDocumentValidations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     Procedure [dbo].[csp_ReportDocumentValidations]  
		( @DocumentCodeId int
		  , @DocumentType varchar(10)
		  , @TabOrder int
		  , @StartDate datetime = null
		  , @EndDate datetime = null
		  , @Active char(1) )

AS  
/**********************************************************************
Report Request:
	Details ...

Parameters:
	Start Date, End Date


Modified By		Modified Date	Reason
----------------------------------------------------------------
dharvey			09/07/2010		created

EXEC csp_ReportDocumentValidations 1469,2,NULL,NULL,''Y''
**********************************************************************/

DECLARE @Title varchar(max)
DECLARE @SubTitle varchar(max)
DECLARE @Comment varchar(max)


SET @Title = ''Document Validation Logic Report''
SET @SubTitle = ''All document signature validation logic by Document''
SET @Comment = '' ''


CREATE TABLE #Report (
		DocumentName varchar(100)
		, TabOrder int
		, TabName varchar(100)
		, ColumnName varchar(100)
		, ValidationOrder int
		, ErrorMessage varchar(max)
		, ValidationDescription varchar(max)
		, DocumentType varchar(100)
		, ModifiedBy varchar(30)
		, ModifiedDate datetime
		, RecordDeleted char(1)
		, DeletedBy varchar(30)
		, DeletedDate datetime
		)


INSERT into #Report (
		DocumentName
		, TabOrder
		, TabName
		, ColumnName
		, ValidationOrder
		, ErrorMessage
		, ValidationDescription
		, DocumentType
		, ModifiedBy
		, ModifiedDate
		, RecordDeleted
		, DeletedBy
		, DeletedDate
		)	
SELECT dc.DocumentName, dv.TabOrder, dv.TabName
	, Case When dv.ColumnName = ''DeletedBy'' Then ''Multiple Values'' Else dbo.ReturnTitleCase(dv.ColumnName) End as ColumnName
	, dv.ValidationOrder, dv.ErrorMessage, dv.ValidationDescription
	, Case dv.DocumentType 
		When ''DD'' Then ''DD''
		When ''DDA'' Then ''DD - Annual''
		When ''MHSAA'' Then ''MI/SA Adult''
		When ''MHSAC'' Then ''MI/SA Child''
		When ''MHSAAA'' Then ''MI/SA Adult - Annual''
		When ''MHSACA'' Then ''MI/SA Child - Annual''
		Else dv.DocumentType 
		End as DocumentType
	, Case When dv.ModifiedDate=dv.CreatedDate Then ''Created'' Else dv.ModifiedBy End as ModifiedBy
	, dv.ModifiedDate
	, dv.RecordDeleted
	, dv.DeletedBy
	, dv.DeletedDate
	From DocumentValidations dv with(nolock)
	Join DocumentCodes dc with(nolock) on dc.DocumentCodeId=dv.DocumentCodeId and ISNULL(dc.RecordDeleted,''N'')=''N''
	Where ( dv.Active = @Active or @Active is null )
	and ( (dv.DocumentType = @DocumentType or dv.DocumentType is null) or @DocumentType is null )
	and ( dv.TabOrder = @TabOrder or @TabOrder is null )
	and ISNULL(dv.RecordDeleted,''N'')=''N''
	and ( dv.DocumentCodeId = @DocumentCodeId or @DocumentCodeId is null )
	and ( 
		( dv.ModifiedDate >= isnull(@StartDate,''01/01/1900'') and dv.ModifiedDate <= isnull(@EndDate,getdate()) ) 
		or ( @StartDate is null and @EndDate is null )
		)
	
	Order by dv.DocumentCodeId, dv.TabOrder, dv.TabName, dv.ValidationOrder



-------------------------------------

IF exists (select 1 from #Report)
	BEGIN 
		Select 
		@Title as Title
		, @SubTitle as SubTitle
		, @Comment as Comment
		, DocumentName
		, TabOrder
		, TabName
		, ColumnName
		, ValidationOrder
		, ErrorMessage
		, ValidationDescription
		, DocumentType
		, ModifiedBy
		, ModifiedDate
		, RecordDeleted
		, DeletedBy
		, DeletedDate
		FROM #Report
	END
ELSE
		Select 
		@Title as Title
		, @SubTitle as SubTitle
		, @Comment as Comment
		
		
		Drop Table #Report
' 
END
GO
