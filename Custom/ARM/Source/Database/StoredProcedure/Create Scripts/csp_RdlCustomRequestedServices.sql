/****** Object:  StoredProcedure [dbo].[csp_RdlCustomRequestedServices]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomRequestedServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomRequestedServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomRequestedServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomRequestedServices]   
  
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010  
AS   
  
Begin   
  
/*   
  
** Object Name: [csp_RdlCustomRequestedServices]   
  
**   
  
**   
  
** Notes: Accepts two parameters (DocumentId & Version) and returns a record set   
  
** which matches those parameters.   
  
**   
  
** Programmers Log:   
  
** Date Programmer Description   
  
**------------------------------------------------------------------------------------------   
  
** Get Data Fromc CustomRequestedServices,GlobalCode   
  
** Oct 16 2007 Ranjeetb   
  
*/   
  
DECLARE @Requested nvarchar(10)   
  
DECLARE @CustomRequestedServices CURSOR   
  
DeClare @CodeName nvarchar(4000)  
  
SET @CustomRequestedServices  = CURSOR FAST_FORWARD   
  
FOR   
  
--Select Requested from CustomRequestedServices  where Documentid=@DocumentId and Version=@Version  
Select Requested from CustomRequestedServices  where DocumentVersionId= @DocumentVersionId   --Modified by Anuj Dated 03-May-2010

OPEN @CustomRequestedServices   
  
FETCH NEXT FROM @CustomRequestedServices   
  
INTO @Requested  
  
WHILE @@FETCH_STATUS = 0   
  
BEGIN   
  
Select @CodeName = isnull(@CodeName,'''') + '','' + CodeName from globalcodes where globalcodeid=@Requested  
  
FETCH NEXT FROM @CustomRequestedServices   
  
INTO @Requested  
  
END   
  
CLOSE @CustomRequestedServices   
  
DEALLOCATE @CustomRequestedServices   
  
Select @CodeName = Substring(@CodeName,2,Len(rtrim(@CodeName)))

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
