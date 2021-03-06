/****** Object:  UserDefinedFunction [dbo].[ProcessEDIBatchEligibilityResponseCheck]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcessEDIBatchEligibilityResponseCheck]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ProcessEDIBatchEligibilityResponseCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcessEDIBatchEligibilityResponseCheck]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[ProcessEDIBatchEligibilityResponseCheck](@SCDataServicesURL [nvarchar](max), @SCDataServiceTimeout [int], @SCDataServicesKey [nvarchar](max), @SCDataServiceSecret [nvarchar](max), @DestinationGateway [nvarchar](max), @MessageId [int], @BatchSubmissionId [int], @PayerId [nvarchar](max))
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [EligibilityBatchClient].[EligibilityBatchClient.EligibilityProcess].[UpdateEDIResponses]' 
END
GO
