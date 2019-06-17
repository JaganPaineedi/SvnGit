

-- What :  There is an issue with an release process.scsp_ReportPrint1099s stored procedure should be release as part od Aspenpoint not for other customer.
-- Why  : AspenPointe - Support Go Live #849

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ReportPrint1099s]') AND type in (N'P', N'PC'))
BEGIN
	 DROP PROCEDURE [dbo].[scsp_ReportPrint1099s]
END

 