/****** Object:  StoredProcedure [dbo].[scsp_InitASAM]    Script Date: 06/14/2016 14:46:27 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitASAM]')
			AND type IN (N'P',N'PC')
		)
BEGIN
	DROP PROCEDURE [dbo].[scsp_InitASAM]
END