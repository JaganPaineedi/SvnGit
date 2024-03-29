/****** Object:  UserDefinedFunction [dbo].[ReturnTotalClientsForGroupService]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnTotalClientsForGroupService]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnTotalClientsForGroupService]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnTotalClientsForGroupService]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'    
      
CREATE FUNCTION [dbo].[ReturnTotalClientsForGroupService]      
  ( @GroupServiceId int )      
  /****************************************************************************/                                                                                                                        
 /* Function:   GroupServiceList                             */                                                                                                               
 /* Copyright:   2006 Streamlin Healthcare Solutions                           */                                                                                                                       
 /* Creation Date:  April 13, 2009                                                          */                                                                                                                        
  /* Purpose:   To return total number of clients for group service id     */                                                                                                                       
  /*     where status is not Cancelled, No Show and Errors      */                                                                                                                       
 /* Input Parameters: @GroupServiceId                                    */                                                                                                                      
 /* Output Parameters:                                 */                                                                                                                        
 /* Return:             TotalClients for @GroupServiceId                                         */                                                                                                         
 /* Call Procedure:  From [GroupServiceList]                                                      */                                                                                                                        
 /*-----------Creation History---------                                  */                                        
 /*----Date---------------Author-----------------Purpose-------------------------------------*/                                        
/*    April 13, 2009      Munish Singla        */     
/*    July 7,2009         Pradeep              Apply Record deleted check */   
 /****************************************************************************/                                                                                                                                     
      
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
