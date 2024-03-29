/****** Object:  StoredProcedure [dbo].[ssp_SCWebCheckRoleHasAssociatedStaff]    Script Date: 11/18/2011 16:26:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebCheckRoleHasAssociatedStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebCheckRoleHasAssociatedStaff]
GO
CREATE procedure [dbo].[ssp_SCWebCheckRoleHasAssociatedStaff]    
@GlobalCodeId int    
AS      
      
/*********************************************************************/        
/* Stored Procedure: ssp_SCWebCheckRoleHasAssociatedStaff                */        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */        
/* Creation Date:   07/01/2010                                     */        
/*                                                                   */        
/* Purpose:   it will be used to check whether globalCode with codeName already exists for specified category      */       
/*                                                                   */      
/* Input Parameters: @GlobalCodeId,                 */      
/*                                                                   */        
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
/*  Date     Author       Purpose                                    */        
/* 07/01/2010  Shifali     Created                                    */  
/* 00-July-2015 KKumar    added   and isNull(RecordDeleted,'N')='N' */
/*********************************************************************/         
BEGIN      
     
 Declare @varOutput int    
 IF Exists(Select * from StaffRoles where RoleId=@GlobalCodeId and isNull(RecordDeleted,'N')='N')    
 BEGIN    
  set @varOutput = 1    
 END    
 ELSE    
 BEGIN    
  set @varOutput = 0    
 END    
 Select @varOutput    
    IF (@@error!=0)      
    BEGIN      
        RAISERROR  20002 'ssp_SCWebCheckRoleHasAssociatedStaff: An Error Occured'      
        RETURN(1)      
    END      
    RETURN(0)      
    
END  
