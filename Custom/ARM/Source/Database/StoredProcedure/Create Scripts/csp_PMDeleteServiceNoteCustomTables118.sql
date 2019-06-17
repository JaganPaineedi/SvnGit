/****** Object:  StoredProcedure [dbo].[csp_PMDeleteServiceNoteCustomTables118]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMDeleteServiceNoteCustomTables118]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMDeleteServiceNoteCustomTables118]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMDeleteServiceNoteCustomTables118]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_PMDeleteServiceNoteCustomTables118]               
(                  
   @DocumentVersionId int,                                                
   @AuthorName varchar(50)       
)                  
As        
/******************************************************************************          
**  File:           
**  Name: csp_SCGetServiceNoteCustomTables118         
**  Desc: This will delete data from Service Note Custom Tables         
**  Copyright: 2006 Streamline SmartCare                                    
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Called by:   [ssp_PMServiceDeleteNote]      
**                        
**  Parameters:          
**  Input       Output          
**     ----------      -----------          
**  Delete records from Service Note Custom Tables        
**          
**  Auth: Rohit Verma      
**  Date: 26-May-09          
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:    Author:    Description:          
**  --------   --------   -------------------------------------------          
        
*******************************************************************************/          
BEGIN TRY          
                                  
                           
update CustomMedicationAdministrations  set RecordDeleted=''Y'',DeletedBy= @AuthorName, DeletedDate=getDate()  where DocumentVersionId = @DocumentVersionId                                                          
                                              
                                                   
                                                          
update MentalStatus set RecordDeleted=''Y'',DeletedBy= @AuthorName, DeletedDate=getDate()  where DocumentVersionId = @DocumentVersionId                                                          
                                
        
END TRY          
        
BEGIN CATCH          
 declare @Error varchar(8000)          
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_PMDeleteServiceNoteCustomTables118'')           
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())            
    + ''*****'' + Convert(varchar,ERROR_STATE())          
            
 RAISERROR           
 (          
  @Error, -- Message text.          
  16,  -- Severity.          
  1  -- State.          
 );          
          
END CATCH
' 
END
GO
