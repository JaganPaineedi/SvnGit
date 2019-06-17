/****** Object:  StoredProcedure [dbo].[ssp_SCGetContactFlagsRWQMWidgetData]    Script Date: 10/13/2015 20:16:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetContactFlagsRWQMWidgetData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetContactFlagsRWQMWidgetData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetContactFlagsRWQMWidgetData]    Script Date: 10/13/2015 20:16:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetContactFlagsRWQMWidgetData] (
	@AssignedTo INT
	
	)
AS
/******************************************************************************          
**  File: dbo.ssp_SCGetContactFlagsRWQMWidgetData.prc          
**  Name: dbo.ssp_SCGetContactFlagsRWQMWidgetData          
**  Desc: This SP returns the data required by dashboard          
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Called by:             
**                        
**  Parameters:          
**  Input       Output          
**     ----------       -----------          
**          
**  Auth: Ponnin           
**  Date:           
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:  Author:   Description:          
**  -------- --------  -------------------------------------------          
**  28/May/2018  Ponnin   Took the copy of Contacts/Flags Widget stored procedure(ssp_SCGetContactFlagsWidgetData) and added RWQM work Queue count.  AHN - Cutomizations: Task# 44.2
**  21/Aug/2018  Ponnin   The dashboard widget and list page should only show items that do not have an action, so show only "To do" records count for the RWQM. Why: Core Bugs #2361
**  07/Jan/2019  Vijay   The count in "Contacts/Flags" and "Contacts/Flags/RWQM" widgets are not matching the flags list page. Why: Core Bugs #2700
*******************************************************************************/
BEGIN
	BEGIN TRY
	DECLARE @ContactNoteCount INT
	DECLARE @ClientFlagCount INT
	DECLARE @RWQMWorkDueCount INT
					
		 SELECT @ContactNoteCount = COUNT(*)            
  FROM ClientContactNotes CCN                          
      INNER JOIN Clients C ON C.ClientId = CCN.ClientId AND ISNULL(C.RecordDeleted,'N') <> 'Y'    
      LEFT OUTER JOIN Staff S ON CCN.AssignedTo = S.StaffId AND ISNULL(s.RecordDeleted,'N') <> 'Y'    
  WHERE CCN.ContactStatus=370  AND ISNULL(CCN.RecordDeleted, 'N') = 'N'         
        --Pavani 02/06/2016        
        and CAST(CCN.ContactDateTime AS DATE) <= CAST(GETDATE()AS DATE)  
        and (CCN.AssignedTo= isnull(@AssignedTo,0) or @AssignedTo=-1)          
        --End            
                
  SELECT @ClientFlagCount=COUNT(*)            
     FROM ClientNotes CN            
     inner JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType    
              INNER JOIN Clients C ON C.ClientId = CN.ClientId AND ISNULL(C.RecordDeleted,'N') <> 'Y'    
      LEFT OUTER JOIN Staff S ON CN.AssignedTo = S.StaffId AND ISNULL(s.RecordDeleted,'N') <> 'Y'    
     WHERE ISNULL(CN.RecordDeleted, 'N') = 'N'          
                 
     --AND CN.Active='Y'  AND ISNULL(FT.Active,'Y') = 'Y'  
      --Pavani 02/06/2016 
            
     and (cast(CN.StartDate as date) <= cast(GETDATE() as date) or CN.StartDate is null) AND 
     (cast(CN.EndDate as date)>=cast(GETDATE()as date) OR        
            CN.EndDate is null )  --AND (CN.AssignedTo= isnull(@AssignedTo,0) or @AssignedTo=-1)
     AND (  
		 @AssignedTo = - 1  
		 OR EXISTS(SELECT 1 FROM ClientNoteAssignedUsers CNAU WHERE CNAU.ClientNoteId = CN.ClientNoteId AND ISNULL(CNAU.RecordDeleted, 'N') = 'N' AND @AssignedTo = CNAU.StaffId)
       )            
      --End       

Select @RWQMWorkDueCount=COUNT(*)      
FROM   RWQMWorkQueue RWQM 
     --  INNER JOIN Charges CH 
     --          ON RWQM.ChargeId = CH.ChargeId 
     --  INNER JOIN ClientContactNotes CCN 
     --         ON RWQM.ClientContactNoteId = CCN.ClientContactNoteId
     --  INNER JOIN RWQMClientContactNotes RWQMCCN 
			  --ON RWQMCCN.ClientContactNoteId = CCN.ClientContactNoteId AND RWQMCCN.RWQMWorkQueueId = RWQM.RWQMWorkQueueId 
WHERE  ISNULL(RWQM.RecordDeleted, 'N') = 'N'
      --AND ISNULL(CCN.RecordDeleted, 'N') = 'N'
      -- AND ISNULL(CH.RecordDeleted, 'N') = 'N'
       AND RWQM.RWQMAssignedId = @AssignedTo  AND RWQM.RWQMActionId IS NULL
      -- AND ISNULL(CCN.ReferenceType,0)= 9466  
       

	SELECT @ContactNoteCount AS ContactNoteCount,@ClientFlagCount AS ClientFlagCount, @RWQMWorkDueCount as RWQMWorkDueCount
		
	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetContactFlagsRWQMWidgetData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH

	RETURN
END

GO


