 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_GetBedCensusUnitDetails')
	BEGIN
		DROP  Procedure  ssp_GetBedCensusUnitDetails
	END

GO

CREATE  Procedure [dbo].[ssp_GetBedCensusUnitDetails]          
(                  
@UnitId int                  
)                  
As 
 Begin 
 Begin TRY   
/****************************************************************************************/                          
/* Stored Procedure: dbo.ssp_GetBedCensusUnitDetails                                    */                          
/* Creation Date:  07-June-2012                                                         */                          
/* Creation By:  Jagdeep Hundal                                                         */                          
/* Purpose: To Get Units and UnitAvailabilityHistory per UnitId                         */                       
/* Input Parameters: @UnitId                                                            */                        
/* Output Parameters:                                                                   */                          
/*  Date                Author              Purpose                                */       
/*	19June2012			Shifali				Modified - Removed ActiveString Column Ref Task# 72 (Bed Census)*/                   
/*	22June2012			Vikas Kashyap		Modified - Removed UAH.[InactiveReason] & [Active] Add In U.[InactiveReason]*/                   
/*	10-July-2014		Akwinass			Removed the RowIdentifier Column Ref Task#1546 in Core Bugs (Bed Board)*/ 
/*26 May 2015    Veena         Added ShowOnBedBoard,ShowOnBedCensus,ShowOnWhiteBoard columns Philhaven Development #248**/

/****************************************************************************************/                   
SELECT U.[UnitId]
      ,U.[UnitName]
      ,U.[DisplayAs]
      ,U.[Active]
      ,U.[Comment]      
      ,U.[CreatedBy]
      ,U.[CreatedDate]
      ,U.[ModifiedBy]
      ,U.[ModifiedDate]
      ,U.[RecordDeleted]
      ,U.[DeletedDate]
      ,U.[DeletedBy]
      ,U.[InactiveReason]
       --Added by Veena for  ShowOnBedBoard,ShowOnBedCensus,ShowOnWhiteBoard columns for filtering the units in the list page Philhaven Development #248
	,ShowOnBedBoard
	,ShowOnBedCensus
	,ShowOnWhiteBoard
FROM  Units U   
WHERE U.UnitId=@UnitId        
AND   ISNULL(U.RecordDeleted, 'N') = 'N'      
  
SELECT UAH.[UnitAvailabilityHistoryId]
      ,UAH.[UnitId]
      ,UAH.[StartDate]
      ,UAH.[EndDate]
      --,UAH.[Active]
      --,UAH.[InactiveReason]      
      ,UAH.[CreatedBy]
      ,UAH.[CreatedDate]
      ,UAH.[ModifiedBy]
      ,UAH.[ModifiedDate]
      ,UAH.[RecordDeleted]
      ,UAH.[DeletedDate]
      ,UAH.[DeletedBy]
      /*,case UAH.Active when 'Y' then 'Yes' else 'No 'end as ActiveString*/
FROM [UnitAvailabilityHistory] UAH  
INNER JOIN Units U ON U.UnitId=UAH.UnitId  
--LEFT JOIN GLOBALCODES GC ON GC.GlobalCodeId=UAH.InactiveReason  
WHERE UAH.UnitId=@UnitId     
AND ISNULL(UAH.RecordDeleted, 'N') = 'N'         
AND ISNULL(U.RecordDeleted, 'N') = 'N'  
order by StartDate  
      
         
--Checking For Errors          
END TRY                                                                          
BEGIN CATCH                              
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetBedCensusUnitDetails')                                                                                                         
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
                