/****** Object:  StoredProcedure [dbo].[ssp_SCGetGlobalCodeDropDownData]    Script Date: 11/18/2011 16:25:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGlobalCodeDropDownData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetGlobalCodeDropDownData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGlobalCodeDropDownData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
        
CREATE PROCEDURE [dbo].[ssp_SCGetGlobalCodeDropDownData]        
@Category varchar(20)        
As                
/*********************************************************************/                  
/* Stored Procedure: ssp_SCGetGlobalCodeDropDownData             */                  
/* Copyright: 2003-2010 Streamline Healthcare Solutions,  LLC             */                  
/* Creation Date:    21th-May-2010                                         */                  
/*                                                                   */                  
/* Purpose:It Will give return data for the GlobalCodeDropDown    */                 
/*                                                                   */                
/* Input Parameters:@Category            */                
/*                                                                   */                  
/* Output Parameters:   None                               */                  
/*                                                                   */                  
/* Return:  0=success, otherwise an error number                     */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*  Date               Author       Purpose                                    */                  
/* 21th-May-2010     Vikas Vyas    Created                                    */   
/* 25th-May-2015     Vithobha		Appended CodeName for sorting, Philhaven - Customization Issues Tracking #1269                  */                   
/*********************************************************************/                   
 BEGIN              
 BEGIN TRY                   
  select GlobalCodeId,CodeName   from GlobalCodes where Category=@Category and ISNULL(RecordDeleted,''N'')<>''Y'' and Active=''Y'' order by SortOrder , CodeName     
       
                 
 END TRY                                  
  BEGIN CATCH                                  
   DECLARE @Error varchar(8000)                                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                             
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCGetGlobalCodeDropDownData'')                                                             
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                              
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                            
        RAISERROR                                                             
   (                                                            
     @Error, -- Message text.                                                            
     16, -- Severity.                                                            
     1 -- State.                                                            
    );                                                            
  END CATCH                         
 END ' 
END
GO
