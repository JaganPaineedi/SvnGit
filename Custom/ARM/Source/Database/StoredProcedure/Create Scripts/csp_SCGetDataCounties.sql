/****** Object:  StoredProcedure [dbo].[csp_SCGetDataCounties]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDataCounties]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDataCounties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDataCounties]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE  [dbo].[csp_SCGetDataCounties]                                   
                                 
As                                          
 /****************************************************************************/                                                    
 /* Stored Procedure:csp_SCGetDataCounties                                  */                                           
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */                                                   
 /* Creation Date:  Jan 27,2009                                              */                                                    
 /* Purpose: Gets Data From Counties table to bind drop down                 */                                                   
 /* Input Parameters:                                                        */                                                  
 /* Output Parameters:None                                                   */                                                    
 /* Return:                                                                  */                                                    
 /* Calls:PrescreeningGeneral                                           */                                                    
 /* Data Modifications:                                                      */                                                    
 /*                                                                          */                                                    
 /*   Updates:                                                               */                                                    
 /*   Date              Author   Purpose                                     */                                     
 /*   April 29,2009     Pradeep  Corrected header comment                    */    
 /*   May 19,2009       Pradeep  Made changes as per task#95(St.Joe NonBillable)*/                                                                    
 /*********************************************************************/                                                     
 BEGIN        
    BEGIN TRY        
       SELECT CountyFIPS,CountyName FROM Counties where StateFIPS = 26    
       order by CountyName         
    END TRY        
    BEGIN CATCH        
      DECLARE @Error varchar(8000)                                                           
      set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                          
      + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetDataCounties]'')                                                           
      + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                          
      + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                          
      RAISERROR                                                           
      (                                                           
        @Error, -- Message text.                                                           
        16, -- Severity.                                                           
        1-- State.                                                           
      )        
    END CATCH         
 END
' 
END
GO
