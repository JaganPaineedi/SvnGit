/****** Object:  UserDefinedFunction [dbo].[DownloadEDIBatchEligibilityResponse]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DownloadEDIBatchEligibilityResponse]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[DownloadEDIBatchEligibilityResponse]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DownloadEDIBatchEligibilityResponse]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[DownloadEDIBatchEligibilityResponse](@SCDataServicesURL [nvarchar](max), @SCDataServiceTimeout [int], @SCDataServicesKey [nvarchar](max), @SCDataServiceSecret [nvarchar](max), @DestinationGateway [nvarchar](max))
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [EligibilityBatchClient].[EligibilityBatchClient.EligibilityProcess].[DownloadEDIResponses]' 
END
GO
