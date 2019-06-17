IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInsertSpellCheckWord]') 
AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInsertSpellCheckWord]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCInsertSpellCheckWord]    Script Date: 1/17/2011 14:36:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCInsertSpellCheckWord] 
(          
@Word varchar(500) ,  
@StaffId int   
)          
AS          
/*********************************************************************/            
/* Stored Procedure: dbo.ssp_SCInsertSpellCheckWord                */            
/* Creation Date:    1/17/2011                                         */            
/* Creation By : Damanpreet Kaur                                                                  */            
/* Purpose: It is used to inter the entry in the SpellCheckUserDictionary table              */           
/*                                                                   */          
/* Input Parameters: @word          */          
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
/*  Date			Author			Purpose                                    */ 
/*  15/11/2017      Suneel N		Changed tablename 'SpellCheckUserDictionary' to 'SpellCheckStaffDictionary' */
/*									Ref : #155 MHP Support Go Live */
/*********************************************************************/             
        
begin          
Insert into SpellCheckStaffDictionary(StaffId,SpellCheckWord)          
values(@StaffId,@word)        
          
 IF (@@error!=0)          
    BEGIN          
        RAISERROR  ('ssp_SCInsertSpellCheckWord: An Error Occured',16,1)          
       RETURN(1)          
    END          
End

GO


