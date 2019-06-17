
/****** Object:  StoredProcedure [dbo].[csp_GetActiveStaff]    Script Date: 10/18/2014 12:13:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetActiveStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetActiveStaff]
GO



/****** Object:  StoredProcedure [dbo].[csp_GetActiveStaff]    Script Date: 10/18/2014 12:13:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   CREATE  PROCEDURE [dbo].[csp_GetActiveStaff]             
              
              
              
/*********************************************************************/                            
/* Stored Procedure: dbo.csp_GetActiveStaff          */                            
/* Copyright: 2014  valley            */                            
/* Creation Date:  18 oct 2014                                   */                            
/*                                                                   */                            
/* Purpose: it will get all active  Staff            */                           
/*                                                                   */                          
/* Output Parameters:                                */                            
/*                                                                   */                            
/* Called By:                                                        */                            
/*                                                                   */                            
/* Calls:                                                            */                            
/*                                                                   */                            
/* Data Modifications:                                               */                            
/*                                                                   */                            
/* Updates:                                                          */                            
/*  Date          Author      Purpose                                    */                            
/*  18 oct 2014    Aravind  Created                        */                            
/*********************************************************************/                          
AS     

Select Distinct s.StaffId, s.lastname +', '+ s.firstname as StaffName
From Staff s 
Where isnull(s.RecordDeleted, 'N') ='N' and active = 'Y'    
              
 IF (@@error!=0)                          
  BEGIN                          
         RAISERROR  20002  'ssp_GetActiveStaff: An Error Occured'                          
         RETURN                     
  END              
GO


