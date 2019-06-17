 /****** Object:  UserDefinedFunction [dbo].[ssf_MUPOSAdmitTypeValues]    Script Date: 06/15/2015 15:16:34 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_MUPOSAdmitTypeValues]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_MUPOSAdmitTypeValues]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_MUPOSAdmitTypeValues]    Script Date: 06/15/2015 15:16:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_MUPOSAdmitTypeValues] ()
RETURNS @f TABLE (
	GlobalCodeId INT
	,CodeName VARCHAR(250)
	)
	/********************************************************************************                                          
-- Function: ssf_MUPOSAdmitTypeValues                                            
--                                          
-- Copyright: Streamline Healthcare Solutions                                          
--                                          
-- Purpose: get Admit type values    
--                                          
-- Updates:                                                                                                 
-- Date        Author      Purpose                                          
-- 03.25.2015  Shankha     Created.  Certification 2014                                            
*********************************************************************************/
AS
BEGIN
	INSERT INTO @f (
		GlobalCodeId
		,CodeName
		)
	SELECT GlobalCodeId
		,CodeName
	FROM GlobalCodes
	WHERE Category = 'INPATIENTADMITTYPE'
		AND ExternalCode1 IN (
			'21'
			,'22'
			)
		AND ISNULL(RecordDeleted, 'N') = 'N'

	IF EXISTS (
			SELECT *
			FROM SystemConfigurationKeys
			WHERE [KEY] = 'MUEHCAHReportingPOSMode'
				AND [Value] = 'All ED Visits' --Observation Services  
				AND ISNULL(RecordDeleted, 'N') = 'N'
			)
	BEGIN
		INSERT INTO @f (
			GlobalCodeId
			,CodeName
			)
		SELECT GlobalCodeId
			,CodeName
		FROM GlobalCodes
		WHERE Category = 'INPATIENTADMITTYPE'
			AND ExternalCode1 = '23'
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END
	IF not exists(Select 1 from @f)
	BEGIN
		INSERT INTO @f (
			GlobalCodeId
			,CodeName
			)
		SELECT GlobalCodeId
			,CodeName
		FROM GlobalCodes
		WHERE Category = 'INPATIENTADMITTYPE'
		AND ISNULL(RecordDeleted, 'N') = 'N'
	END

	RETURN
END

