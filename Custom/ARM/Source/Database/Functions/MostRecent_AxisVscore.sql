/****** Object:  UserDefinedFunction [dbo].[MostRecent_AxisVscore]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MostRecent_AxisVscore]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[MostRecent_AxisVscore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MostRecent_AxisVscore]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























CREATE FUNCTION [dbo].[MostRecent_AxisVscore](@ClientID int) 
returns int
as
BEGIN
DECLARE @RecentDiagnosisDate datetime
DECLARE @RecentNotesDate datetime
DECLARE @AxisScore int

select  @RecentDiagnosisDate=max(DV.ModifiedDate) from DiagnosesV DV JOIN 
Documents D on D.DocumentID=DV.DocumentID and D.ClientID=@ClientID

select  @RecentNotesDate=max(N.ModifiedDate) from Notes N JOIN 
Documents D on D.DocumentID=N.DocumentID and D.ClientID=@ClientID

IF @RecentDiagnosisDate IS NULL OR @RecentNotesDate IS NULL
BEGIN
	IF @RecentDiagnosisDate is NOT NULL
		BEGIN
			SELECT @AxisScore=N.AxisV from Notes N JOIN 
			Documents D1 on D1.DocumentID=N.DocumentID and D1.ClientID=@ClientID AND N.ModifiedDate=@RecentDiagnosisDate
		END
	ELSE
		BEGIN
			SELECT @AxisScore=DV1.AxisV from DiagnosesV DV1 JOIN 
			Documents D1 on D1.DocumentID=DV1.DocumentID and D1.ClientID=@ClientID AND DV1.ModifiedDate=@RecentDiagnosisDate
		END
END
ELSE
IF NOT(@RecentDiagnosisDate IS NULL AND @RecentNotesDate IS NULL)
	BEGIN
		IF @RecentDiagnosisDate > @RecentNotesDate
			BEGIN
				SELECT @AxisScore=N.AxisV from Notes N JOIN 
				Documents D1 on D1.DocumentID=N.DocumentID and D1.ClientID=@ClientID AND N.ModifiedDate=@RecentDiagnosisDate
			END
		ELSE
			BEGIN

				SELECT @AxisScore=DV1.AxisV from DiagnosesV DV1 JOIN 
				Documents D1 on D1.DocumentID=DV1.DocumentID and D1.ClientID=@ClientID AND DV1.ModifiedDate=@RecentDiagnosisDate
			END
	END
return(@AxisScore)
END





























' 
END
GO
