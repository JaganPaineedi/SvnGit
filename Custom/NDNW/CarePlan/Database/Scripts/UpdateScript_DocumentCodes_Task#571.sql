-- MSOOD 2/1/2017 NEW DIRECTIONS - SUPPORT GO LIVE  TASK # 571
IF EXISTS (SELECT 1
	FROM DOCUMENTCODES
	WHERE DOCUMENTCODEID = 1620)
BEGIN
	UPDATE DOCUMENTCODES
	SET DOCUMENTNAME        = 'SERVICE PLAN'
	,   DOCUMENTDESCRIPTION = 'CARE PLAN'
	WHERE DOCUMENTCODEID = 1620
END
GO

IF EXISTS (SELECT 1
	FROM DOCUMENTCODES
	WHERE DOCUMENTCODEID = 1632)
BEGIN
	UPDATE DOCUMENTCODES
	SET DOCUMENTNAME        = 'SERVICE PLAN REVIEW'
	,   DOCUMENTDESCRIPTION = 'CARE PLAN REVIEW'
	WHERE DOCUMENTCODEID = 1632
END