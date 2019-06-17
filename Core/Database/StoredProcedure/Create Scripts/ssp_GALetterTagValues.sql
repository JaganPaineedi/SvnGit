/****** Object:  StoredProcedure [dbo].[ssp_GALetterTagValues]    Script Date: 11/10/2014 11:00:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GALetterTagValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GALetterTagValues]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GALetterTagValues]    Script Date: 11/10/2014 11:00:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[ssp_GALetterTagValues]         
( 
 @KeyValue int,
 @TaggedFields varchar(max) ,
 @LetterTemplateId Int=0                                                                                                                          
)            
As  
/******************************************************************************    
**  File: MSDE.cs    
**  Name: ssp_GALetterTagValues    
**  Desc: This fetches data for TaggedFields  
**    
**  This template can be customized:    
**                  
**  Return values:    
**     
**  Called by:      
**                  
**  Parameters:    
**  Input       Output    
**     ----------      -----------    
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables  
**    
**  Auth: Vikas Vyas  
**  Date: 05-May-10    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:    Author:    Description:    
**  --------   --------   -------------------------------------------    
   04 Sep 2014   Gautam      Added new parameter @LetterTemplateId Why : Require in application, core bugs#350
   13 Nov 2017	 Msood		 Added a call to SCSP to use custom logic CEI - Support Go Live Task #778 
*******************************************************************************/    
BEGIN TRY   

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GALetterTagValues]') AND type in (N'P', N'PC'))
Begin
Exec scsp_GALetterTagValues @KeyValue,@TaggedFields,@LetterTemplateId

Return

End


 DECLARE @sItem VARCHAR(100)
 Declare @item Varchar(100)
  
IF (SELECT CURSOR_STATUS('global','TagField')) >=0 
BEGIN
DEALLOCATE TagField
END
                                                
  DECLARE TagField CURSOR FOR
  SELECT item
 FROM [dbo].[fnSplit] (@TaggedFields, ',')  




OPEN TagField
--select * from Grievances
--select * from SystemConfigurations
--select * from Clients

FETCH TagField INTO @item 

CREATE TABLE #TEMP
(
 TagValue Varchar(100)
)

-- start the main processing loop.
WHILE @@Fetch_Status = 0
   BEGIN

   -- This is where you perform your detailed row-by-row
   -- processing.
   
    INSERT INTO #TEMP 
    Select CASE @item
         WHEN '[Organization]' THEN (Select OrganizationName from SystemConfigurations)
         WHEN '[ClientID]' THEN (Select Convert(varchar(100),ClientId) from Grievances where GrievanceId = @KeyValue) 
         WHEN '[ClientName]' THEN (Select LastName +', '+ FirstName from Clients where ClientId = (Select ClientId from Grievances where GrievanceId = @KeyValue)) 
         WHEN '[DateReceived]' THEN (Select Convert(nvarchar(100),IsNull(DateReceived,'')) from Grievances where GrievanceId = @KeyValue) 
         ELSE ''
      END

   
   -- Get the next row. 
   FETCH TagField INTO @item             

 
   END

CLOSE TagField

DEALLOCATE TagField

select * from #TEMP
drop table #TEMP

RETURN

  
END TRY    
  
BEGIN CATCH    
 declare @Error varchar(8000)    
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GALetterTagValues')     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())      
    + '*****' + Convert(varchar,ERROR_STATE())    
      
 RAISERROR     
 (    
  @Error, -- Message text.    
  16,  -- Severity.    
  1  -- State.    
 );    
    
END CATCH  

GO


