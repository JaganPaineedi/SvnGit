/****** Object:  UserDefinedFunction [dbo].[csf_GetRxPhraseText]    Script Date: 11/17/2017 14:18:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetRxPhraseText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_GetRxPhraseText]
GO

/****** Object:  UserDefinedFunction [dbo].[csf_GetRxPhraseText]    Script Date: 11/17/2017 14:18:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE FUNCTION [dbo].[csf_GetRxPhraseText]  
(  
  @KeyPhraseText Varchar(max)  
 ,@KeyPhraseCategory int  
 ,@ClientId int  
)  
RETURNS varchar(Max)  
  
AS  
 BEGIN                 
  -- Declare the return variable here  
   Declare @KeyPhraseTextTags as Varchar(max)  
   DECLARE @MemberName varchar(200)  
   DECLARE @MemberAddress varchar(500)  
   DECLARE @HeShe varchar(3)  
     
  -- SET @MemberName = ( SELECT FirstName + ' ' + LastName FROM Clients WHERE ClientId = @ClientId )  
   SET @MemberAddress = ( SELECT Display FROM ClientAddresses WHERE ClientId = @ClientId AND AddressType = 90 AND ISNULL(RecordDeleted,'N') = 'N' )  
   --SET @HeShe = ( SELECT CASE WHEN Sex = 'M' THEN 'He' ELSE 'She' END FROM Clients WHERE ClientId = @ClientId )  
   
     
  -- Set @KeyPhraseTextTags=Replace(@KeyPhraseText,'&lt;memberName&gt;',ISNULL(@MemberName,''))  
   SET @KeyPhraseTextTags=REPLACE(@KeyPhraseText,'&lt;MemberAddress&gt;',ISNULL(@MemberAddress,''))  
   --SET @KeyPhraseTextTags=REPLACE(@KeyPhraseTextTags,'&lt;he/she&gt;',ISNULL(@HeShe,''))  
  RETURN @KeyPhraseTextTags
  
END  

GO


