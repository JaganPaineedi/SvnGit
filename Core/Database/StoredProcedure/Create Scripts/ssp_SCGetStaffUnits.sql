/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffUnits]    Script Date: 07/9/2018 15:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetStaffUnits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].ssp_SCGetStaffUnits
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffUnits]    Script Date: 07/9/2018 15:15:07  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************/       
CREATE PROCEDURE [dbo].ssp_SCGetStaffUnits    
AS  
/*****************************************************************************************************
 Data Modifications:               
                                                                                    
	Updates:                                                                              
 Date			Author               Purpose                                                        
 09.July.2018	swatika				 Getting All units name.Bradford - Enhancements: Task# 400.2
 *************************************************************************************************/   
begin  
 BEGIN TRY  
SELECT   UnitId
        ,CreatedBy
        ,CreatedDate
	    ,ModifiedBy
	    ,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,UnitName
		,DisplayAs
		,Active
		,Comment
		,InactiveReason
		,ShowOnBedBoard
		,ShowOnBedCensus
		,ShowOnWhiteBoard
FROM    dbo.Units 
WHERE     (ISNULL(RecordDeleted, 'N') = 'N')     
          AND (Active = 'Y')    
END TRY
BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'ssp_SCGetStaffUnits')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH 
End
GO


