IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetBedCensusRoomDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetBedCensusRoomDetails]
GO

CREATE  Procedure [dbo].[ssp_GetBedCensusRoomDetails]            
(                    
@RoomId int                    
)                    
As   
 Begin   
 Begin TRY     
/*********************************************************************************/          
/* Stored Procedure: ssp_GetBedCensusRoomDetails								 */ 
/* Copyright: Streamline Healthcare Solutions									 */          
/* Creation Date:  08-June-2012													 */          
/* Purpose: used by Rooms Detail Page Get Logic									 */         
/* Input Parameters:@RoomId														 */        
/* Output																		 */        
/* Return:																	     */          
/* Called By: RoomDetails.ascx.cs , GetStoreProcedureName Function				 */          
/* Calls:																		 */          
/* Data Modifications:															 */          
/* Updates:																		 */          
/* Date               Author                  Purpose							 */          
/* 08-June-2012       Vikas Kashyap			  Created							 */          
/*	19June2012				Shifali			  Modified - Removed ActiveString Column Ref Task# 72 (Bed Census)*/                   
/*	10-July-2014		  Akwinass				  Removed the RowIdentifier Column Ref Task#1546 in Core Bugs (Bed Board)*/ 
/*  19-Apr-2018      Pradeep Y                 Added two column Classroom,ProgramId For Task #10005 PEP-Customization  */
/*********************************************************************************/                     
SELECT   R.RoomId
		,R.UnitId
		,R.RoomName
		,R.DisplayAs
		,R.Active
		,R.Comment		
		,R.CreatedBy
		,R.CreatedDate
		,R.ModifiedBy
		,R.ModifiedDate
		,R.RecordDeleted
		,R.DeletedDate
		,R.DeletedBy
		,R.InactiveReason
		,R.Classroom
		,R.ProgramId
FROM  Rooms AS R     
WHERE R.RoomId=@RoomId          
AND   ISNULL(R.RecordDeleted, 'N') = 'N'        
    
SELECT   RAH.RoomAvailabilityHistoryId
		,RAH.RoomId
		,RAH.StartDate
		,RAH.EndDate
		--,RAH.Active
		--,RAH.InactiveReason		
		,RAH.CreatedBy
		,RAH.CreatedDate
		,RAH.ModifiedBy
		,RAH.ModifiedDate
		,RAH.RecordDeleted
		,RAH.DeletedDate
		,RAH.DeletedBy
		/*,CASE RAH.Active WHEN 'Y' THEN 'Yes'  
       WHEN 'N' THEN 'No' END ActiveText  */
FROM RoomAvailabilityHistory AS RAH      
WHERE RAH.RoomId=@RoomId       
AND ISNULL(RAH.RecordDeleted, 'N') = 'N'             
order by StartDate    
        
           
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetBedCensusRoomDetails')                                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                        
 RAISERROR                                                                                                           
 (                                                                             
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
 );                                                                                                        
END CATCH                                                       
END   