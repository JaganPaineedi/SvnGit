/****** Object:  UserDefinedFunction [dbo].[GetAuthorizationHistoryString]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAuthorizationHistoryString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetAuthorizationHistoryString]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAuthorizationHistoryString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================    
-- Author:  Maninder    
-- Create date: 12/1/2011    
-- Description: Restuns Reasons separated by comma    
-- =============================================    
CREATE FUNCTION [dbo].[GetAuthorizationHistoryString]    
(    
 -- Add the parameters for the function here    
 @AuthorizationHistoryId INT    
)    
RETURNS NVARCHAR(MAX)    
AS    
BEGIN    
     
   DECLARE @HideCustomAuthorizationControls Char(1)    
  -- Added for task#68 in Harbor    
  SELECT @HideCustomAuthorizationControls=isnull(HideCustomAuthorizationControls,''N'') FROM SystemConfigurations     
  -- ends    
 -- Declare the return variable here    
 Declare @StrReason as NVARCHAR(MAX)    
 Declare @lenStrReason as int    
      
 set @StrReason='''';    
 if(@HideCustomAuthorizationControls=''N'')  
 begin  
 SET @lenStrReason=LEN(@StrReason);    
     
 SELECT @StrReason=@StrReason+GlobalCodes_1.CodeName+'',<BR>''    
 FROM  dbo.AuthorizationHistory AS AuthHist INNER JOIN    
                      dbo.AuthorizationHistoryReasons ON AuthHist.AuthorizationHistoryId = dbo.AuthorizationHistoryReasons.AuthorizationHistoryId INNER JOIN    
                      dbo.GlobalCodes AS GlobalCodes_1 ON dbo.AuthorizationHistoryReasons.Reason = GlobalCodes_1.GlobalCodeId    
    WHERE       AuthHist.AuthorizationHistoryId= @AuthorizationHistoryId    
     
     
 -- Return the result of the function    
 if(LEN(@StrReason)>0)    
  SET @lenStrReason=LEN(@StrReason)-5;    
   
 select @StrReason=  SUBSTRING(@StrReason,0,@lenStrReason)    
   
 end  
 else  
 begin  
 SELECT @StrReason=Rationale   
 FROM  dbo.AuthorizationHistory AS AuthHist  
 WHERE       AuthHist.AuthorizationHistoryId= @AuthorizationHistoryId    
  
 end  
   
 RETURN @StrReason  
    
END ' 
END
GO
