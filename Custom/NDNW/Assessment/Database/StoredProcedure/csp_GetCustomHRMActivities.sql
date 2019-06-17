
/****** Object:  StoredProcedure [dbo].[csp_GetCustomHRMActivities]    Script Date: 01/16/2015 17:26:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomHRMActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomHRMActivities]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetCustomHRMActivities]    Script Date: 01/16/2015 17:26:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
/************************************************************************/                                          
/* Stored Procedure: dbo.csp_GetCustomHRMActivities      */                                 
/* Copyright: 2009 Streamlin Healthcare Solutions      */                                          
/* Creation Date:  20th July 2010          */                                          
/* Purpose: Gets Data from CustomHRMActivities       */                                         
/* Called By:  Method in Documents Class Of DataService      */                                          
/* Calls:                */                                          
/* Data Modifications:             */                                          
/*   Updates:               */                                          
                                
/*       Date              Author                  Purpose                                    */                                          
/* 20 july 2010   Priya              Created      */  
/* 27 Nov 2013	Pradeep				 Renamed from ssp_SCGetCustomHRMActivities to csp_GetCustomHRMActivities  */                                     
                                                   
/************************************************************************/             
            
CREATE PROCEDURE  [dbo].[csp_GetCustomHRMActivities]              
as              
begin            
select HRMActivityId,HRMActivityDescription,SortOrder,Active,              
AssociatedHRMNeedId,Example,CreatedBy,CreatedDate,              
ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy              
from CustomHRMActivities  where ISNULL(RecordDeleted,'N')='N' and Active='Y'            
end   

GO


