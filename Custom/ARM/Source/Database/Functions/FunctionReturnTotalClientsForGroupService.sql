/****** Object:  UserDefinedFunction [dbo].[FunctionReturnTotalClientsForGroupService]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FunctionReturnTotalClientsForGroupService]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FunctionReturnTotalClientsForGroupService]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FunctionReturnTotalClientsForGroupService]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[FunctionReturnTotalClientsForGroupService]          
  ( @GroupServiceId int )   
        
/******************************************************************************                                    
**File: GroupScheduled List Page                                    
** Name:                   
**Desc:Used to list all groups that are Sheduled                    
**                                    
** Return values:                                    
**                                     
**  Called by:Groups.cs                           
**                                                  
**  Parameters:                                    
**  Input       Output                                    
**  @GroupId INT                     
**                              
**                                
**                              
**  Auth:  Pradeep                            
**  Date:  17 Dec 2009                                   
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:         Author:       Description:             
**  17 Dec 2009       Pradeep          Created                               
**  --------  --------    ----------------------------------------------------                                    
                               
*******************************************************************************/                                                                                                                                       
          
RETURNS int          
AS          
BEGIN   
         
 RETURN (          
 select count(distinct ClientId) from services          
 inner join globalcodes on  services.[Status]=globalcodes.GlobalCodeId          
 where [services].GroupServiceId = @GroupServiceId          
 and (globalcodes.GlobalCodeId<>72 and globalcodes.GlobalCodeId<>73 and globalcodes.GlobalCodeId<>76)      
 and ISNULL(services.RecordDeleted,''N'')=''N''      
 and ISNULL(globalcodes.RecordDeleted,''N'')=''N''      
 and globalcodes.Active=''Y''      
        
           
 )  
          
END
' 
END
GO
