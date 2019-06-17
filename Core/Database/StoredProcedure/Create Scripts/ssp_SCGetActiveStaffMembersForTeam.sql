/****** Object:  StoredProcedure [dbo].[ssp_SCGetActiveStaffMembersForTeam]    Script Date: 04/09/2012 10:44:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetActiveStaffMembersForTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetActiveStaffMembersForTeam]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetActiveStaffMembersForTeam]    Script Date: 04/09/2012 10:44:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCGetActiveStaffMembersForTeam] 
(	
	@TeamId INT
)
AS
/**************************************************************/                                                                                        
/* Stored Procedure: [ssp_SCGetActiveStaffMembersForTeam]	  */                                                                               
/* Creation Date:  20March2012                                */                                                                                        
/* Purpose: To Get Active Staff for a Team(Program)			  */                                                                                       
/* Input Parameters:   @TeamId								  */                                                                                      
/* Output Parameters:										  */                                                                                        
/* Return:													  */                                                                                        
/* Called By: Core Team Scheduling Detail screen			  */                                                                              
/* Calls:                                                     */                                                                                        
/*                                                            */                                                                                        
/* Data Modifications:                                        */                                                                                        
/* Updates:                                                   */                                                                                        
/* Date			Author   Purpose							  */    
/* 20March2012	Shifali  To get Active staff for a team		  */
/* 12Sept2012	Shifali	 Modified - Added RecordDeleted check for staff*/
/* 13 Dec 2013 Manju P  Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes*/
/*07-07-2015    Dhanil Manuel      select empty row if no data task #1348 */
/*15-10-2015    Anto               Adding  StaffNameWithShortName and ShortStaffName as empty in the else part Why: New Directions - Support Go Live #81*/

/**************************************************************/  
BEGIN
BEGIN TRY
 if exists(SELECT S.StaffId
	FROM StaffPrograms SP
	LEFT JOIN  Staff S ON S.StaffId = SP.StaffId
	WHERE S.Active = 'Y' AND ISNULL(S.RecordDeleted,'N') <> 'Y' AND ISNULL(SP.RecordDeleted,'N') <> 'Y' AND SP.ProgramId = @TeamId)
 begin
 SELECT S.StaffId, S.DisplayAs as StaffName     --S.LastName + ', ' + S.FirstName as StaffName   
	,S.LastName + ', ' + S.FirstName + ' - '+ SUBSTRING(LTRIM(FirstName),1,1)+SUBSTRING(LTRIM(LastName),1,1) +' ('+ CAST(S.StaffId AS VARCHAR) +')' AS StaffNameWithShortName
	,SUBSTRING(LTRIM(FirstName),1,1)+SUBSTRING(LTRIM(LastName),1,1) +' ('+ CAST(S.StaffId AS VARCHAR) +')' AS ShortStaffName
	FROM StaffPrograms SP
	LEFT JOIN  Staff S ON S.StaffId = SP.StaffId
	WHERE S.Active = 'Y' AND ISNULL(S.RecordDeleted,'N') <> 'Y' AND ISNULL(SP.RecordDeleted,'N') <> 'Y' AND SP.ProgramId = @TeamId
	ORDER BY StaffName
 end
 else 
 begin
    select -1 as  StaffId,'' as StaffName,'' as StaffNameWithShortName,'' as ShortStaffName
 end
 
	
END TRY
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetActiveStaffMembersForTeam')                                                                                                       
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


