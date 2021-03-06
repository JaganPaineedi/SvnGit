
/****** Object:  StoredProcedure [dbo].[ssp_SCGetEventTypes]    Script Date: 01/11/2018 12:35:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetEventTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetEventTypes]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetEventTypes]    Script Date: 01/11/2018 12:35:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[ssp_SCGetEventTypes]        
@EventTypeId int        
AS 

/*************************************************************/     
/* Stored Procedure: dbo.[ssp_GetDropDownAssociateDocument ]   */     
/* Creation Date:   3/12/2017                               */     
/* Purpose:  For getting data into the data set    */     
/*  Date                  Author                 Purpose     */     
/*  3/12/2017          Rajeshwari           Created     */  
/* Task: Engineering Improvement Initiatives- NBL(I) #606 */    
   
/*************************************************************/ 
         
begin        
select   
EventTypeId,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedBy,
DeletedDate,
AssociatedDocumentCodeId,
EventName,
EventType,
DisplayNextEventGroup,
SummaryReportRDL,
SummaryStoredProcedure,
RequireProvider,
RowIdentifier from EventTypes WHERE EventTypeId = @EventTypeId AND (RecordDeleted IS NULL OR                                                    
                      RecordDeleted = 'N')             
end 
GO


