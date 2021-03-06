/****** Object:  StoredProcedure [dbo].[csp_GetClientPrompts]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetClientPrompts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetClientPrompts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetClientPrompts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_GetClientPrompts]      
@StaffId int    
as      
/******************************************************************************  
**  File: dbo.csp_GetClientPrompts.prc   
**  Name: dbo.csp_GetClientPrompts  
**  Desc: This will be used to get client information.   
**  
**  This template can be customized:  
**                
**  Return values:  
**   
**  Called by:     
**                
**  Parameters:  
**  Input       Output  
**  ----------      -----------  
**  @StaffId  
**  
**  Auth: Nisha Mittal  
**  Date:   
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:   Author:   Description:  
**  -----------  ------------ ---------------------------------------  
**  07-Aug-2010  Nisha Mittal Added new Parameter StaffId  
*******************************************************************************/  
--begin      

--end
' 
END
GO
