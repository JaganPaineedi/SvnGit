/****** Object:  StoredProcedure [dbo].[ssp_SCGetContactFlagsWidgetData]    Script Date: 10/13/2015 20:16:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetContactFlagsWidgetData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetContactFlagsWidgetData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetContactFlagsWidgetData]    Script Date: 10/13/2015 20:16:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetContactFlagsWidgetData] (
	@AssignedTo INT
	
	)
AS
/******************************************************************************          
**  File: dbo.ssp_SCGetContactFlagsWidgetData.prc          
**  Name: dbo.ssp_SCGetContactFlagsWidgetData          
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
**  Auth: Venkatesh           
**  Date:           
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:  Author:   Description:          
**  -------- --------  -------------------------------------------          
**  30/03/2016  Venkatesh   Created.    - As per task Renaissance - Dev Items - #780
**  02/06/2016  Pavani      Added GETDATE,AssignedTo logic as per the Task #69 Bradford EIT 
**  17/Jul/2017  Malathi Shiva	Displaying RWQM work Queue items count which are due for the logged in staff : AHN - Cutomizations: Task# 44
** 28/May/2018	Ponnin		Reverted the changes by removing the RWQM work Queue items count  made for AHN - Cutomizations: Task# 44. Why: For task   AHN - Cutomizations: Task# 44.2
*******************************************************************************/
BEGIN
	BEGIN TRY
	DECLARE @ContactNoteCount INT
	DECLARE @ClientFlagCount INT
					
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
                 
     AND CN.Active='Y'  AND ISNULL(FT.Active,'Y') = 'Y'  
      --Pavani 02/06/2016 
            
     and (cast(CN.StartDate as date) <= cast(GETDATE() as date) or CN.StartDate is null) AND 
     (cast(CN.EndDate as date)>=cast(GETDATE()as date) OR        
            CN.EndDate is null )  AND (CN.AssignedTo= isnull(@AssignedTo,0) or @AssignedTo=-1)            
      --End       

	SELECT @ContactNoteCount AS ContactNoteCount,@ClientFlagCount AS ClientFlagCount
		
	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetContactFlagsWidgetData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


