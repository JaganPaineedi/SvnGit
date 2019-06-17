
/****** Object:  StoredProcedure [dbo].[ssp_GetClientContactsTabOrder]    Script Date: 12/01/2018 12:13:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientContactsTabOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientContactsTabOrder]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetClientContactsTabOrder]    Script Date: 12/01/2018 12:13:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   CREATE  PROCEDURE [dbo].[ssp_GetClientContactsTabOrder]             
              
              
              
/*********************************************************************/                            
/* Stored Procedure: dbo.ssp_GetClientContactsTabOrder          */                            
/* Copyright: 2014              */                            
/* Creation Date:  12 Jan 2018                                   */                                
/* Purpose: It will retun tab order of client contact           */                                
/* Output Parameters:                                */                                             
/* Called By:                                                        */                               
/* Calls:                                                            */                               
/* Data Modifications:                                               */                             
/* Updates:                                                          */                            
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */                        
/*********************************************************************/                          
AS     
BEGIN                                                            
	BEGIN TRY 

		SELECT TabOrder FROM dbo.ClientInformationTabConfigurations WHERE TabURL  LIKE '%/Contacts.ascx'   
              
	END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_GetClientContactsTabOrder]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO

