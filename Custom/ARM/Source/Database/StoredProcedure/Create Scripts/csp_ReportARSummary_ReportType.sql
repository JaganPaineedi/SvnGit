/****** Object:  StoredProcedure [dbo].[csp_ReportARSummary_ReportType]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportARSummary_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportARSummary_ReportType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportARSummary_ReportType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_ReportARSummary_ReportType] (
@ReportType int)
as
begin

 
IF @ReportType=1
  Select -1 As ID  ,'' All Payer Types'' As Value 
  Union
  SELECT ID=GlobalCodeId, Value=CodeName
  FROM GlobalCodes
  WHERE Category = ''PAYERTYPE''
  AND IsNull(RecordDeleted,''N'') <> ''Y''
  ORDER BY Value
  ELSE If @ReportType=2
    Select -1 As ID  ,'' All Payers'' As Value 
    Union
    SELECT ID=PayerId, Value=PayerName
    FROM Payers
    WHERE IsNull(RecordDeleted,''N'') <> ''Y''
    Order By Value
    ELSE If @ReportType=3
       Select -1 As ID  ,'' All Coverage Plans            '' As Value 
       Union
       SELECT ID=CoveragePlanId, Value=DisplayAs
       FROM CoveragePlans
       WHERE IsNull(RecordDeleted,''N'') <> ''Y''
       Order By Value
       ELSE SELECT NULL,NULL
end' 
END
GO
