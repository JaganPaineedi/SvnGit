/****** Object:  UserDefinedFunction [dbo].[CustomGetLatestRegistrationInformation]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestRegistrationInformation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CustomGetLatestRegistrationInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestRegistrationInformation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[CustomGetLatestRegistrationInformation]
(@ClientId			int)
Returns
@RegistrationInformation table
	(ClientId		int,
	ClientEpisodeId	int,
	AdmissionDate	datetime)
AS
-- Description: Function to determine and return the details for the most recent client episode.  Currently, the ClientEpisodeId and AdmissionDate are returned from
-- this function.  This can be extended to return additional details for the current registration period.
--
-- Created by: Ryan Noble
-- Created on: Apr 18 2011
Begin
	Insert into @RegistrationInformation
	(ClientId,
	ClientEpisodeId,
	AdmissionDate)
	Select  @ClientId,
			ce.ClientEpisodeId,
			ce.RegistrationDate
		From Clients c
		Join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
			Where c.ClientId = @ClientID
				and ISNULL(c.RecordDeleted, ''N'')= ''N''
				and ISNULL(ce.RecordDeleted, ''N'')= ''N''

Return

End

' 
END
GO
