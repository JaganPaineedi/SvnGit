/****** Object:  StoredProcedure [dbo].[csp_PMClaims277Reader]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims277Reader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims277Reader]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims277Reader]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE procedure [dbo].[csp_PMClaims277Reader]
	@File varchar(max),
	@UnPaidOnly bit
AS
BEGIN

create table #277(
	ID int,
	Paid char(1),
	ClaimErrorId int,
	ClaimErrorModifier varchar(25),
	ClaimErrorDescription varchar(500),
	ServiceErrorId int,
	ServiceErrorModifier varchar(25),
	ServiceErrorDescription varchar(500),
	ClientId int,
	ClaimLineItemId int,
	BillingCode varchar(25),
	DateofService date,
	Loop varchar(8000),
	HL varchar(1000),
	NM1 varchar(1000),	
	TRN varchar(1000),
	STC1 varchar(1000),
	REF1 varchar(1000),
	DTP1 varchar(1000),
	SVC varchar(1000),
	STC2 varchar(1000),
	REF2 varchar(1000),
	DTP2 varchar(1000),
	)

DECLARE @i int=1,@s int=1,@e int,@eof int

set nocount on

DELETE FROM #277

SET @e = CHARINDEX(''~HL*4'',@file)+1
SET @eof = CHARINDEX(''~SE*'',@file)+1
SET @i=4

WHILE (@e <> @eof and @i < 10000)
BEGIN

	SET @s = CHARINDEX(''~HL*'',@file,@e)+1
	SET @e = CHARINDEX(''~HL*'',@file,@s+10)+1

	IF @e = 1
		SET @e=@eof

	INSERT INTO #277 (ID,Loop)
	SELECT @i,SUBSTRING(@file,@s,@e-@s)
	
	SET @i=@i+1

END

--Update segments
UPDATE a SET
HL = SUBSTRING(loop,
		CHARINDEX(''HL*'',loop),
		CHARINDEX(''~'',loop,CHARINDEX(''HL*'',loop))-CHARINDEX(''HL*'',loop))
FROM #277 a
WHERE CHARINDEX(''HL*'',loop) <> 0


UPDATE a SET
NM1 = SUBSTRING(loop,
		CHARINDEX(''NM1*'',loop),
		CHARINDEX(''~'',loop,CHARINDEX(''NM1*'',loop))-CHARINDEX(''NM1*'',loop))
FROM #277 a
WHERE CHARINDEX(''NM1*'',loop) <> 0

UPDATE a SET
TRN = SUBSTRING(loop,
		CHARINDEX(''TRN*'',loop),
		CHARINDEX(''~'',loop,CHARINDEX(''TRN*'',loop))-CHARINDEX(''TRN*'',loop))
FROM #277 a
WHERE CHARINDEX(''TRN*'',loop) <> 0

UPDATE a SET
STC1 = SUBSTRING(loop,
		CHARINDEX(''STC*'',loop),
		CHARINDEX(''~'',loop,CHARINDEX(''STC*'',loop))-CHARINDEX(''STC*'',loop))
FROM #277 a
WHERE CHARINDEX(''STC*'',loop) <> 0

UPDATE a SET
REF1 = SUBSTRING(loop,
		CHARINDEX(''REF*'',loop),
		CHARINDEX(''~'',loop,CHARINDEX(''REF*'',loop))-CHARINDEX(''REF*'',loop))
FROM #277 a
WHERE CHARINDEX(''REF*'',loop) <> 0

UPDATE a SET
DTP1 = SUBSTRING(loop,
		CHARINDEX(''DTP*'',loop),
		CHARINDEX(''~'',loop,CHARINDEX(''DTP*'',loop))-CHARINDEX(''DTP*'',loop))
FROM #277 a
WHERE CHARINDEX(''DTP*'',loop) <> 0

UPDATE a SET
SVC = SUBSTRING(loop,
		CHARINDEX(''SVC*'',loop),
		CHARINDEX(''~'',loop,CHARINDEX(''SVC*'',loop))-CHARINDEX(''SVC*'',loop))
FROM #277 a
WHERE CHARINDEX(''SVC*'',loop) <> 0

UPDATE a SET
STC2 = SUBSTRING(loop,
		CHARINDEX(''STC*'',loop,CHARINDEX(''SVC*'',loop)),
		CHARINDEX(''~'',loop,CHARINDEX(''STC*'',loop,CHARINDEX(''SVC*'',loop)))-CHARINDEX(''STC*'',loop,CHARINDEX(''SVC*'',loop)))
FROM #277 a
WHERE CHARINDEX(''STC*'',loop,CHARINDEX(''SVC*'',loop)) <> 0

UPDATE a SET
REF2 = SUBSTRING(loop,
		CHARINDEX(''REF*'',loop,CHARINDEX(''SVC*'',loop)),
		CHARINDEX(''~'',loop,CHARINDEX(''REF*'',loop,CHARINDEX(''SVC*'',loop)))-CHARINDEX(''REF*'',loop,CHARINDEX(''SVC*'',loop)))
FROM #277 a
WHERE CHARINDEX(''REF*'',loop,CHARINDEX(''SVC*'',loop)) <> 0

UPDATE a SET
DTP2 = SUBSTRING(loop,
		CHARINDEX(''DTP*'',loop,CHARINDEX(''SVC*'',loop)),
		CHARINDEX(''~'',loop,CHARINDEX(''DTP*'',loop,CHARINDEX(''SVC*'',loop)))-CHARINDEX(''DTP*'',loop,CHARINDEX(''SVC*'',loop)))
FROM #277 a
WHERE CHARINDEX(''DTP*'',loop,CHARINDEX(''SVC*'',loop)) <> 0


UPDATE a SET
	Paid = CASE WHEN SUBSTRING(STC1,5,2) IN (''A1'',''A2'') THEN ''Y'' ELSE ''N'' END,
	ClaimErrorId = CASE WHEN SUBSTRING(STC1,6,1) = ''2'' THEN '''' ELSE 
		CAST(
			SUBSTRING(STC1,
				8,
				CASE WHEN CHARINDEX('':'',STC1,8) = 0 THEN CHARINDEX(''*'',STC1,8) WHEN CHARINDEX('':'',STC1,8)<CHARINDEX(''*'',STC1,8) THEN CHARINDEX('':'',STC1,8) ELSE CHARINDEX(''*'',STC1,8) END - 8
				) 
			as int) END,
	ClaimErrorModifier = CASE WHEN CHARINDEX('':'',STC1,8) = 0 THEN NULL
		WHEN CHARINDEX('':'',STC1,8) < CHARINDEX(''*'',STC1,8) THEN
			SUBSTRING(STC1,
				CHARINDEX('':'',STC1,8)+1,
				CHARINDEX(''*'',STC1,CHARINDEX('':'',STC1,8))-CHARINDEX('':'',STC1,8)-1
				)
		ELSE NULL END,
	ServiceErrorId = CASE WHEN SUBSTRING(STC2,6,1) = ''2'' THEN '''' ELSE 
		CAST(
			SUBSTRING(STC2,
				8,
				CASE WHEN CHARINDEX('':'',STC2,8) = 0 THEN CHARINDEX(''*'',STC2,8) WHEN CHARINDEX('':'',STC2,8)<CHARINDEX(''*'',STC2,8) THEN CHARINDEX('':'',STC2,8) ELSE CHARINDEX(''*'',STC2,8) END - 8
				) 
			as int) END,
	ServiceErrorModifier = CASE WHEN CHARINDEX('':'',STC2,8) = 0 THEN NULL
		WHEN CHARINDEX('':'',STC2,8) < CHARINDEX(''*'',STC2,8) THEN
			SUBSTRING(STC2,
				CHARINDEX('':'',STC2,8)+1,
				CHARINDEX(''*'',STC2,CHARINDEX('':'',STC2,8))-CHARINDEX('':'',STC2,8)-1
				)
		ELSE NULL END,
	ClientId = SUBSTRING(TRN,7,CHARINDEX(''-'',TRN)-7),
	ClaimLineItemId = SUBSTRING(REF2,8,LEN(REF2)-8),
	BillingCode = SUBSTRING(SVC,8,CHARINDEX(''*'',SVC,8)-8)
FROM #277 a

UPDATE a SET
	ClaimErrorDescription = CASE WHEN ClaimErrorId = 0 THEN NULL ELSE b.ErrorDescription END,
	ServiceErrorDescription = CASE WHEN ServiceErrorId = 0 THEN NULL ELSE c.ErrorDescription END
FROM #277 a
JOIN Custom277Errors b ON b.ErrorId = a.ClaimErrorId
JOIN Custom277Errors c ON c.ErrorId = a.ServiceErrorId
WHERE a.Paid = ''N''

SELECT Paid = a.Paid,
	ClaimErrorId = a.ClaimErrorId,
	ClaimErrorModifier = a.ClaimErrorModifier,
	ClaimErrorDescription = a.ClaimErrorDescription,
	ServiceErrorId = a.ServiceErrorId,
	ServiceErrorModifier = a.ServiceErrorModifier,
	ServiceErrorDescription = a.ServiceErrorDescription,
	ClientId = a.ClientId,
	ClaimLineItemId = a.ClaimLineItemId,
	BillingCode =a.BillingCode,
	DateofService = b.DateofService
FROM #277 a
JOIN ClaimLineItems b ON b.ClaimLineItemId = a.ClaimLineItemId
WHERE @UnPaidOnly = 0 OR a.Paid = ''N''

END
' 
END
GO
