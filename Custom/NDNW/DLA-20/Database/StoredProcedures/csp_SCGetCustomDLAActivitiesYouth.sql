
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDLAActivitiesYouth]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDLAActivitiesYouth]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************************************************************************/                                          
/* Stored Procedure: dbo.csp_SCGetCustomDLAActivitiesYouth      */                                 
/* Copyright: 2009 Streamlin Healthcare Solutions      */                                          
/* Creation Date:  20-Jan-2017         */                                          
/* Purpose: Gets Data from DLA tab       */                                         
/* What:Moved from F&CS to NDNW; Why:New Directions - Support Go Live ,Task#286*/
/************************************************************************/             
            
CREATE PROCEDURE  [dbo].[csp_SCGetCustomDLAActivitiesYouth]              
as              
begin            
select DailyLivingActivityId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,HRMActivityDescription
		,SortOrder
		,Active
		,AssociatedHRMNeedId
		,Example            
from CustomDailyLivingActivities  where ISNULL(RecordDeleted,'N')='N' and Active='Y'            
end

GO


