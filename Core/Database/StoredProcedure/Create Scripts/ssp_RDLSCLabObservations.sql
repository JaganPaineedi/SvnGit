IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCLabObservations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCLabObservations]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_RDLSCLabObservations] 
	@ObservationName VARCHAR(MAX)
	,@LOINC VARCHAR(MAX)	
	/********************************************************************************    
-- Stored Procedure: dbo.ssp_RDLSCLabObservations      
--   
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 14-Nov-2014	 Revathi		What:Lab Observations 
--								
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		
		SELECT  ObservationName as ObservationName,
		LOINCCode as LOINCCode,
		[Range] as Ranges,
		Unit as unit,
		UnitText as UnitText,
		ObservationMethodText as TestMethod 
		FROM Observations WHERE 
		(@ObservationName IS NULL OR ObservationName like '%'+@ObservationName+'%' )  
		AND (@LOINC IS NULL OR LOINCCode like '%'+@LOINC+'%' )
		AND ISNULL(RecordDeleted,'N')='N'
		
	END TRY

	 BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'ssp_RDLSCLabObservations')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@error,-- Message text.
    16,-- Severity.
    1 -- State.
    );
  END CATCH
END

GO


