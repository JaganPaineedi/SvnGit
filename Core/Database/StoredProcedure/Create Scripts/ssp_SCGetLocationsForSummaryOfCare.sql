/****** Object:  StoredProcedure [dbo].[ssp_SCGetLocationsForSummaryOfCare]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = '[ssp_SCGetLocationsForSummaryOfCare'
		)
	DROP PROCEDURE [dbo].[ssp_SCGetLocationsForSummaryOfCare]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLocationsForSummaryOfCare]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetLocationsForSummaryOfCare]  
AS    
/******************************************************************************  
**  File: ssp_SCGetLocationsForSummaryOfCare.sql  
**  Name: ssp_SCGetLocationsForSummaryOfCare  
**  Desc: Provides Clinicians list who is having permission.  
**  
**  Return values: <Return Values>  
**  
**  Called by: <Code file that calls>  
**  
**  Parameters:  
**  Input   Output  
**  ServiceId      -----------  
**  
**  Created By: Veena S Mani  
**  Date:  June 13 2014  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:  Author:    Description:  
**  --------  --------    -------------------------------------------  
--  23/06/14   Veena   Removed conditions to exclude staffs.  
*******************************************************************************/  
  
BEGIN  
 BEGIN TRY  
  BEGIN  
   DECLARE @Locations TABLE (  
    LocationId INT  
    ,LocationName VARCHAR(100)  
    )  
  
   INSERT INTO @Locations (  
    LocationId  
    ,LocationName  
    )  
   VALUES (  
    - 1  
    ,'All Locations'  
    )  
  
   INSERT INTO @Locations  
   SELECT LocationId  
    ,LocationName  
   FROM Locations  
   WHERE LocationId > 0  
    AND Isnull(RecordDeleted, 'N') = 'N'  
   ORDER BY LocationName  
  
   SELECT *  
   FROM @Locations  
  END  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetLocationsForSummaryOfCare') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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