/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomHRMActivities]    Script Date: 08/09/2014 16:41:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomHRMActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomHRMActivities]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomHRMActivities]    Script Date: 08/09/2014 16:41:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************************************************************************/                                          
/* Stored Procedure: dbo.csp_SCGetCustomHRMActivities      */                                 
/* Copyright: 2009 Streamlin Healthcare Solutions      */                                          
/* Creation Date:  20th Jan 2017          */                                          
/* Purpose: Gets Data from CustomHRMActivities       */                                         
/* Called By:  Method in Documents Class Of DataService      */                                          
/* Calls:                */                                          
/* Data Modifications:             */                                          
/*   Updates:               */                                          
 /* What:Moved from F&CS to NDNW; Why:New Directions - Support Go Live ,Task#286*/                               
/*       Date              Author                  Purpose                                    */                                                                               
                                                   
/************************************************************************/             
            
CREATE PROCEDURE  [dbo].[csp_SCGetCustomHRMActivities]              
as              
begin            
select HRMActivityId,HRMActivityDescription,SortOrder,Active,              
AssociatedHRMNeedId,Example,CreatedBy,CreatedDate,              
ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy              
from CustomHRMActivities  where ISNULL(RecordDeleted,'N')='N' and Active='Y'            
end

GO


