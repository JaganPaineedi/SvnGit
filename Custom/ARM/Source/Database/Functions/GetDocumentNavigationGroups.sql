/****** Object:  UserDefinedFunction [dbo].[GetDocumentNavigationGroups]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentNavigationGroups]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetDocumentNavigationGroups]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentNavigationGroups]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

 create FUNCTION [dbo].[GetDocumentNavigationGroups](@DocumentNavigationId int,    
  @ParentDocumentNavigationIds varchar(500))     
      
RETURNS VARCHAR(500)      
AS        
      
BEGIN       
 If @DocumentNavigationId<>0        
 Begin        
   Select @DocumentNavigationId = ISNULL(ParentDocumentNavigationId,0) From DocumentNavigations         
   Where DocumentNavigationId=@DocumentNavigationId         
   And Isnull(RecordDeleted,''N'') = ''N''        
   And Isnull(Active,''N'') = ''Y''        
   Set @ParentDocumentNavigationIds = ISNULL(@ParentDocumentNavigationIds,'''')+'',''+ Cast(Isnull(@DocumentNavigationId,'''') as VARCHAR)  +         
   Cast(dbo.GetDocumentNavigationGroups(@DocumentNavigationId,@ParentDocumentNavigationIds) as varchar)      
      
  End       
  Set @ParentDocumentNavigationIds = @ParentDocumentNavigationIds+'',''      
   Return @ParentDocumentNavigationIds      
END    
' 
END
GO
