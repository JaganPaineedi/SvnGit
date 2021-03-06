/****** Object:  UserDefinedFunction [dbo].[GetLeftDaysAppeal]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLeftDaysAppeal]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetLeftDaysAppeal]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLeftDaysAppeal]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetLeftDaysAppeal](@appealId int,@PassDate datetime)  
RETURNS Int AS  
BEGIN 
DECLARE @MedicID as varchar(50)
DECLARE @Expedite as Char(1) 
DECLARE @Total as integer
DECLARE @DateReceived as datetime

	SET @Expedite=(SELECT     ExpeditedAppeal
	FROM         Appeals
	WHERE     (AppealId = @appealId))

	SET @DateReceived=(SELECT     DateReceived
	FROM         Appeals
	WHERE     (AppealId = @appealId))

	IF(IsNull(@Expedite, ''N'') = ''N'')
		BEGIN
			SET @MedicID=(SELECT MedicaidId
							FROM Appeals A
							INNER JOIN ClientCoveragePlans CCP ON A.MedicaidId = CCP.InsuredId AND CCP.ClientId = A.ClientId AND ISNULL(CCP.RecordDeleted, ''N'') <> ''Y'' AND  ISNULL(A.RecordDeleted, ''N'') <> ''Y'' 
							INNER JOIN Clients C ON A.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, ''N'') <> ''Y'' 
							INNER JOIN ClientCoverageHistory CCH ON CCP.ClientCoveragePlanId = CCH.ClientCoverageHistoryId AND  ISNULL(CCH.RecordDeleted, ''N'') <> ''Y''  
							WHERE     AppealId = @appealId AND CCH.COBOrder = 1
							 AND (CCH.StartDate <=  A.DateReceived AND (CCH.EndDate >= A.DateReceived OR CCH.EndDate is Null)))
	
			IF(LEN(@MedicID)>0)
				BEGIN
					SET @Total=datediff(d,@DateReceived,@PassDate)
					SET @Total=45-@Total	
				END	
			ELSE
			BEGIN
				SET @Total=datediff(d,@DateReceived,@PassDate)
				SET @Total=15-@Total		
			END	
		END
	ELSE
		BEGIN
			SET @Total=datediff(d,@DateReceived,@PassDate)
			SET @Total=3-@Total		
		END
	IF(@Total is null OR @Total < 0)
		BEGIN
			SET @Total = 0
		END
	
	RETURN(@Total)
END' 
END
GO
