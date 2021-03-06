/****** Object:  StoredProcedure [dbo].[CSP_UpdateAsseeementType]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_UpdateAsseeementType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CSP_UpdateAsseeementType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_UpdateAsseeementType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CSP_UpdateAsseeementType] 
(
@ClientId int
)

As
/*********************************************************************/                                                                                                                                                      
/* Stored Procedure: dbo.CSP_UpdateAsseeementType                */                                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                      
/* Creation Date:  06 August,2010                                       */                                                                                                                                                      
/*                                                                   */                                                                                                                                                      
/* Purpose:  Get Data for Update Assessment Type Pages */                                                                                                                                                    
/*                                                                   */                                                                                                                                                    
/* Input Parameters:  @@ClientId             */                                                                                                                                                    
/*                                                                   */                                                                                                                                                      
/* Output Parameters:   None                   */                                                                                                                                                      
/*                                                                   */                                                                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                      
/*                                                                   */                             
/* Called By:        */     
/* */                     
/* Calls:         */                                       
/*                         */                                         
/* Data Modifications:                   */                                                                      
/*      */                                                                                                     
/* Updates:               */                                                                                              
/*   Date     Author            Purpose                             */                                                                         
/*     */                                                                                 
/*                                                                                                      
*/                                                                                                                           
/*********************************************************************/                                                                                                                                                 
                                                                           

BEGIN
	BEGIN TRY
		BEGIN

	Declare @UpdateAsseeementType varchar(500)
		set @UpdateAsseeementType= ''You have selected ''''Update''''; An ''''Annual'''' is due ___ and will still be required even if you complete an ''''Update'''' 
									Assessment at this time.  Click ''''OK'''' to continue with an ''''Update'''' Assessment or ''''Cancel'''' to change to an ''''Annual'''' Assessment''  

Select  ''UpdateAsseeementType'' AS TableName,@UpdateAsseeementType as ''UpdateAsseeementTypeText''  
END
	END TRY
	
	BEGIN CATCH
	DECLARE @Error varchar(8000)                                                                                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                        
                
 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''CSP_UpdateAsseeementType'')                                                                                                               
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                 
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                                               
 RAISERROR                                                                                                                                   
 (                                                                      
  @Error, -- Message text.                                                                                                                              
  16, -- Severity.                                                                                                                                                                                                                   
  1 -- State.                                  
 );        
	END CATCH
END
' 
END
GO
