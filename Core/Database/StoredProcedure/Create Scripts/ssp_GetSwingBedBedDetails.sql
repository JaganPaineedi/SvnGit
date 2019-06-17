IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSwingBedBedDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSwingBedBedDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create Procedure [dbo].[ssp_GetSwingBedBedDetails] --409 --1 -- 131           
(                    
@BedId int                    
)                    
As   
 Begin   
 Begin TRY     
/****************************************************************************************/                            
/* Stored Procedure: dbo.ssp_GetSwingBedBedDetails                                    */                            
/* Creation Date:  07-June-2012                                                         */                            
/* Creation By:  Veena S Mani                                                        */                            
/* Purpose: To Get Bed Details                         */                                                
/* Purpose: To Get Units and UnitAvailabilityHistory per UnitId                         */                         
/* Input Parameters: @BedId                                                           */                          
/* Output Parameters:                                                                   */                            
/*  Date                  Author                 Purpose                                */   
/*  20/01/2016            Veena                  Philhaven Development #372 Swing beds          */
                         
/****************************************************************************************/                     
SELECT B.[BedId]  
      ,B.[BedName]  
      ,B.[DisplayAs]  
      ,B.[Active]  
      ,B.[RoomId]  
      ,B.[Type1]  
      ,B.[Type2]  
      ,B.[Type3]  
      ,B.[Type4]  
      ,B.[Comment]        
      ,B.[CreatedBy]  
      ,B.[CreatedDate]  
      ,B.[ModifiedBy]  
      ,B.[ModifiedDate]  
      ,B.[RecordDeleted]  
      ,B.[DeletedDate]  
      ,B.[DeletedBy]  
      ,R.UnitId  
      ,B.InactiveReason  
      ,U.DisplayAs as UnitName
      ,R.DisplayAs as RoomName
      ,B.[DisplayAs] as BedName1
     -- ,NULL as [StartDate]  
      --,NULL as [EndDate]  
      ,BAH.[ProgramId]  
      ,BAH.[ProcedureCodeId]  
      ,BAH.[LocationId]  
      ,BAH.[LeaveProcedureCodeId]    
      ,P.ProgramCode as 'Program'  
      ,PC.DisplayAs as 'Procedure'  
      ,L.LocationCode as 'Location'  
      ,PC1.DisplayAs as 'LeaveProcedure'
FROM  Beds B   
INNER JOIN Rooms R ON B.RoomId=R.RoomId 
INNER JOIN Units U ON R.UnitId=U.UnitId
LEFT JOIN  BedAvailabilityHistory BAH ON B.BedId=BAH.BedId 
LEFT JOIN Locations L ON BAH.LocationId=L.LocationId    
LEFT JOIN Programs P ON BAH.ProgramId=P.ProgramId    
LEFT JOIN ProcedureCodes PC ON BAH.ProcedureCodeId=PC.procedurecodeid    
LEFT JOIN  ProcedureCodes PC1 ON BAH.LeaveProcedureCodeId = PC1.procedurecodeid AND ISNULL(PC1.RecordDeleted, 'N') = 'N'
WHERE B.BedId=@BedId          
AND   ISNULL(B.RecordDeleted, 'N') = 'N'  
AND   ISNULL(R.RecordDeleted, 'N') = 'N'         
AND   ISNULL(BAH.RecordDeleted, 'N') = 'N' and BAH.BedAvailabilityHistoryId=(Select  top 1 BedAvailabilityHistoryId from BedAvailabilityHistory where BedId=@BedId and ISNULL(recorddeleted,'N')<>'Y' AND EndDate IS NULL  order by modifieddate desc)

SELECT BAM.[BedAvailabilityHistoryId]  
      ,BAM.[BedId]  
      ,BAM.[StartDate]  
      ,BAM.[EndDate]  
      --,BAM.[Active]  BedAvailabilityHistory
      --,BAM.[InactiveReason]  
      ,BAM.[ProgramId]  
      ,BAM.[ProcedureCodeId]  
      ,BAM.[LocationId]  
      --10-July-2014:Akwinass  
      ,BAM.[LeaveProcedureCodeId]    
      ,BAM.[CreatedBy]  
      ,BAM.[CreatedDate]  
      ,BAM.[ModifiedBy]  
      ,BAM.[ModifiedDate]  
      ,BAM.[RecordDeleted]  
      ,BAM.[DeletedDate]  
      ,BAM.[DeletedBy]  
      ,P.ProgramCode as 'Program'  
      ,PC.DisplayAs as 'Procedure'  
      ,L.LocationCode as 'Location'  
      --11-Sep-2014:Akwinass  
      ,PC1.DisplayAs as 'LeaveProcedure'  
      /*,case BAM.Active when 'Y' then 'Yes' else 'No 'end as ActiveString*/  
      --,GC.CodeName as InactiveReasonString  
   
    
  
            
FROM [BedAvailabilityHistory] BAM    
INNER JOIN Beds B ON B.BedId=BAM.BedId    
LEFT JOIN Locations L ON BAM.LocationId=L.LocationId    
LEFT JOIN Programs P ON BAM.ProgramId=P.ProgramId    
LEFT JOIN ProcedureCodes PC ON BAM.ProcedureCodeId=PC.procedurecodeid    
--11-Sep-2014:Akwinass  
LEFT JOIN  ProcedureCodes PC1 ON BAM.LeaveProcedureCodeId = PC1.procedurecodeid AND ISNULL(PC1.RecordDeleted, 'N') = 'N'  
--LEFT JOIN GLOBALCODES GC ON GC.GlobalCodeId=BAM.InactiveReason    
WHERE BAM.BedId=@BedId 
AND ISNULL(BAM.RecordDeleted, 'N') = 'N'           
AND ISNULL(B.RecordDeleted, 'N') = 'N'    
AND ISNULL(P.RecordDeleted, 'N') = 'N'   
AND ISNULL(L.RecordDeleted, 'N') = 'N'   
AND ISNULL(PC.RecordDeleted, 'N') = 'N' 
--and (BAM.EndDate is null or BAM.EndDate>= GETDATE())  
and  BAM.BedAvailabilityHistoryId=(Select  top 1 BedAvailabilityHistoryId from BedAvailabilityHistory where BedId=@BedId and ISNULL(recorddeleted,'N')<>'Y' AND EndDate IS NULL order by modifieddate desc)
order by StartDate  
--Checking For Errors    

     
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetSwingBedBedDetails')                                                                                                           
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

