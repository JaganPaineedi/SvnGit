/****** Object:  StoredProcedure [dbo].[csp_ConvertScannedDatabase]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ConvertScannedDatabase]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ConvertScannedDatabase]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ConvertScannedDatabase]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_ConvertScannedDatabase]
AS
DECLARE @IDSeparator	varchar(10)


select @IDSeparator = IDseparator from CustomScannedFormConversionConfig

update a
set a.IFIELD1 = c.LastName + '', ''+c.FirstName + @IDSeparator +convert(varchar(24),c.ClientId)
from customScannedFormConversionStage a
join cstm_conv_map_clients b on b.patient_id = Left(LTrim(Substring(a.IFIELD1, CharIndex (@IdSeparator, a.IFIELD1) + Len(@IdSeparator), 
                       Len(a.IFIELD1) - CharIndex (@IdSeparator, a.IFIELD1) + 1)), 10)
join clients c on b.clientId = c.clientId and isnull(c.RecordDeleted,''N'') = ''N''

--Convert Document Codes
update a
set a.IFIELD2 = b.DocumentDescription +@IdSeparator+b.DocumentName
from customScannedFormConversionStage a
join DocumentCodes b on b.DocumentName = Left(LTrim(Substring(a.IFIELD2, CharIndex (@IdSeparator, a.IFIELD2) + Len(@IdSeparator), 
                       Len(a.IFIELD2) - CharIndex (@IdSeparator, a.IFIELD2) + 1)), 10)

' 
END
GO
