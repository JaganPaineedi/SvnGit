/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupServiceStaff]    Script Date: 12/26/2013 14:01:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGroupServiceStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetGroupServiceStaff]
GO  
    
/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupServiceStaff]    Script Date: 12/26/2013 14:01:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO      
      
CREATE PROCEDURE [dbo].[ssp_SCGetGroupServiceStaff]       
(       
 @GroupServiceId INT      
)      
AS      
/*************************************************************/                                                                                              
/* Stored Procedure: [ssp_SCGetGroupServiceStaff]            */                                                                                     
/* Creation Date:  11Sept2012                                */                                                                                              
/* Purpose: To Get Group Service Staff          */                                                                                             
/* Input Parameters:   @GroupServiceId                       */                                                                                            
/* Output Parameters:            */                                                                                              
/* Return:               */                                                                                              
/* Called By: Core Service Detail screen       */                                                                                    
/* Calls:                                                     */                                                                                              
/*                                                            */                                                                                              
/* Data Modifications:                                        */                                                                                              
/* Updates:                                                   */                                                                                              
/* Date   Author   Purpose         */          
/* 11Oct2012 Shifali  Created - To Bind Clinician Dropdown with group service staff when service opened in service detail is part of group       */      
/* 13 Dec 2013        Manju P   Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes*/  
/* 11 JULY 2016       Akwinass  Moved from 3.5x and Modified to display based on Service Clinician (Task #742 in Valley - Support Go Live)*/ 
/**************************************************************/        
BEGIN      
BEGIN TRY      
 ;WITH GroupStaff (ClinicianId,ClinicianName)
	AS (
		SELECT DISTINCT S.StaffId AS ClinicianId
			,S.DisplayAs AS ClinicianName
		FROM GroupServiceStaff GS
		LEFT JOIN Staff S ON S.StaffId = GS.StaffId
		WHERE ISNULL(GS.RecordDeleted, 'N') <> 'Y'
			AND GS.GroupServiceId = @GroupServiceId

		UNION

		SELECT DISTINCT ST.StaffId AS ClinicianId
			,ST.DisplayAs AS ClinicianName
		FROM Services S
		JOIN Staff ST ON S.ClinicianId = ST.StaffId
		WHERE ISNULL(S.RecordDeleted, 'N') <> 'Y'
			AND S.GroupServiceId = @GroupServiceId
			AND ISNULL(ST.RecordDeleted, 'N') <> 'Y'
			AND NOT EXISTS (
				SELECT 1
				FROM GroupServiceStaff GSS
				LEFT JOIN Staff STT ON STT.StaffId = GSS.StaffId
				WHERE ISNULL(GSS.RecordDeleted, 'N') <> 'Y'
					AND GSS.GroupServiceId = @GroupServiceId
					AND STT.StaffId = S.ClinicianId
				)
		)
	SELECT DISTINCT ClinicianId
		,ClinicianName
	FROM GroupStaff   
	ORDER BY ClinicianName ASC       
END TRY      
BEGIN CATCH                                  
DECLARE @Error varchar(8000)                                                                            
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetGroupServiceStaff')                                                                                                             
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
  
GO 