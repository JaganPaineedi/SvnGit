
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMCheckCoveragePlanPriority]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_PMCheckCoveragePlanPriority]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************   
**  File: dbo.ssp_PMCheckCoveragePlanPriority.sql    
**  Name: Add COB   
**  Desc:    
**   
**  This template can be customized:   
**                 
**  Return values:   
**    
**  Called by:      
**                 
**  Parameters:   
**  Input       Output   
**       --------      -----------   
**   
**  Auth:    
**  Date:    
******************************************************************************************************      
**  Change History   
******************************************************************************************************      
**  Date:     Author:      Description:   
**  --------  --------    -------------------------------------------------------------      

  04/06/2015  Shruthi.S   Added to check COBPriority is null or not.Ref #2 - CEI - Customizations.
*******************************************************************************/ 
 CREATE PROCEDURE [dbo].[ssp_PMCheckCoveragePlanPriority] 
 @ClientID  INT
 AS 

Declare @COBPriorityCount int

 --select isnull(COBPriority,0) as COBPriority   from Coverageplans where CoveragePlanId = @CoveragePlanId and ISNULL(RecordDeleted,'N') <> 'Y'
 
 select @COBPriorityCount = count(*) from ClientCoveragePlans CP join CoveragePlans C on CP.CoveragePlanId=C.CoveragePlanId 
 Where CP.ClientId = @ClientID and ISNULL(CP.RecordDeleted,'N') <> 'Y' and ISNULL(C.RecordDeleted,'N') <> 'Y' and ISNULL(C.COBPriority,'')=''
 

 
 if(@COBPriorityCount > 0)
 set @COBPriorityCount = 0
 else if(@COBPriorityCount = 0)
 set @COBPriorityCount = 1
 
 select @COBPriorityCount as COBPriority

 IF ( @@error != 0 )   
 BEGIN  
     RAISERROR  20006  'ssp_PMCheckCoveragePlanPriority: An Error Occured'  
     RETURN  
 END      