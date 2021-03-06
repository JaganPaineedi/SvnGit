/****** Object:  UserDefinedFunction [dbo].[GetClientServiceErrors]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetClientServiceErrors]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetClientServiceErrors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetClientServiceErrors]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'   
    
CREATE FUNCTION [dbo].[GetClientServiceErrors]         
(          
  @ClientId int,    
  @GroupServiceId int          
)          
RETURNS VARCHAR(1)                
BEGIN          
    
    DECLARE  @ServiceErrorId int    
    DECLARE @IsErrors VARCHAR(1)           
         
     SET @ServiceErrorId = 0                 
     SELECT  @ServiceErrorId = count(SE.ServiceId) from Services  S Left outer join ServiceErrors SE ON S.ServiceId =SE.ServiceId     
     WHERE S.GroupServiceId = @GroupServiceId AND S.ClientId = @ClientId    
     AND ISNULL(S.RecordDeleted,''N'')=''N''              
     AND ISNULL(SE.RecordDeleted,''N'')=''N''       
         
     IF(@ServiceErrorId = 0)    
  SET @IsErrors =  ''N''    
  ELSE     
  SET @IsErrors =  ''Y''       
      
 RETURN @IsErrors    
End' 
END
GO
