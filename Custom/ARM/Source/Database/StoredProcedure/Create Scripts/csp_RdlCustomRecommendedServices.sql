/****** Object:  StoredProcedure [dbo].[csp_RdlCustomRecommendedServices]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomRecommendedServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomRecommendedServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomRecommendedServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomRecommendedServices] 
  
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010   
  
AS   
  
Begin   
  
/*   
  
** Object Name: [csp_RdlCustomRecommendedServices]   
  
**   
  
**   
  
** Notes: Accepts two parameters (DocumentId & Version) and returns a record set   
  
** which matches those parameters.   
  
**   
  
** Programmers Log:   
  
** Date Programmer Description   
  
**------------------------------------------------------------------------------------------   
  
** Get Data From CustomRecommendedServices,GlobalCode   
  
** Oct 16 2007 Ranjeetb   
  
*/   
  
DECLARE @Recommended nvarchar(10)   
  
DECLARE @CustomRecommendedServices CURSOR   
  
DeClare @CodeName nvarchar(4000)  
  
SET @CustomRecommendedServices = CURSOR FAST_FORWARD   
  
FOR   
  
--Select Recommended from CustomRecommendedServices where Documentid=@DocumentId and Version=@Version  
Select Recommended from CustomRecommendedServices where DocumentVersionId= @DocumentVersionId   --Modified by Anuj Dated 03-May-2010  

OPEN @CustomRecommendedServices   
  
FETCH NEXT FROM @CustomRecommendedServices   
  
INTO @Recommended  
  
WHILE @@FETCH_STATUS = 0   
  
BEGIN   
  
Select @CodeName = isnull(@CodeName,'''') + '','' + CodeName from globalcodes where globalcodeid=@Recommended  
  
FETCH NEXT FROM @CustomRecommendedServices   
  
INTO @Recommended  
  
END   
  
CLOSE @CustomRecommendedServices   
  
DEALLOCATE @CustomRecommendedServices   

Select @CodeName  = Substring(@CodeName,2,Len(rtrim(@CodeName)))

Select @CodeName 
  
  
--Checking For Errors   
  
If (@@error!=0)   
  
Begin   
  
RAISERROR 20006 ''csp_RdlCustomRecommendedServices: An Error Occured''   
  
Return   
  
End   
  
  
  
  
End  
  
  
  
--------------------------------------------------------------------------------
' 
END
GO
