/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolDetails]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTrackingProtocolDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTrackingProtocolDetails]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolDetails]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetTrackingProtocolDetails] 
(@TrackingProtocolId int)            
As    
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetTrackingProtocolDetails]  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  01-02-2018    Vijay		What:This ssp is for retriving Protocol Details
							Why:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/         
 Begin   
 Begin TRY
 
   SELECT 
	P.TrackingProtocolId
	,P.CreatedBy
	,P.CreatedDate
	,P.ModifiedBy
	,P.ModifiedDate
	,P.RecordDeleted
	,P.DeletedBy
	,P.DeletedDate
	,P.ProtocolName
	,P.ProtocolDescription
	,P.StartDate
	,P.EndDate
	,P.Active
	,P.CreateProtocol
FROM TrackingProtocols P 
	WHERE ISNULL(P.RecordDeleted, 'N') = 'N' 
	AND P.TrackingProtocolId = @TrackingProtocolId
	
	
	SELECT PTF.TrackingProtocolFlagId,
	PTF.CreatedBy,
	PTF.CreatedDate,
	PTF.ModifiedBy,
	PTF.ModifiedDate,
	PTF.RecordDeleted,
	PTF.DeletedBy,
	PTF.DeletedDate,
	PTF.TrackingProtocolId,
	PTF.Recurring,
	PTF.DueDateType,
	PTF.DueDateUnits,
	PTF.DueDateUnitType,
	PTF.FirstDueDate,
	PTF.FirstDueDateDays,
	PTF.DueDateStartDate,
	PTF.DueDateStartDays,
	PTF.DueDateBasedOn,
	PTF.CanBeCompletedNoSoonerThan,
	PTF.FlagAssignment,
	FT.DocumentCodeId,
	DC.DocumentName,
	SA.[Action] as ActionName,
	FT.FlagTypeId,
	FT.FlagLinkTo,
	FT.FlagType,
	PTF.Active,
	FT.FlagType AS GridFlagType,
	CONVERT(varchar(10),PTF.DueDateUnits)+' '+ g.CodeName as GridDueDate,
	(SELECT ISNULL(STUFF((SELECT ', ' + ISNULL(GC.CodeName, '')
	  FROM 
	  TrackingProtocolFlagRoles PTFR 
	  JOIN GlobalCodes GC ON GC.GlobalCodeId =PTFR.RoleId
	  WHERE PTFR.TrackingProtocolFlagId=PTF.TrackingProtocolFlagId 
	  AND ISNULL(PTFR.RecordDeleted, 'N') = 'N'   
	  AND ISNULL(GC.RecordDeleted,'N')='N'
	  FOR XML PATH('')
	  ,type ).value('.', 'nvarchar(max)'), 1, 1, ' '), '')) AS GridAssignTo,
	CASE     
		WHEN PTF.Recurring = 'R'
		 THEN 'Yes'
		WHEN PTF.Recurring = 'N'
		 THEN 'No'
		END AS GridRecurs,
	CASE     
		WHEN DC.DocumentName IS NOT NULL THEN DC.DocumentName
		WHEN SA.[Action] IS NOT NULL THEN SA.[Action]
		ELSE ''
		END AS GridLinkTo,
	 CASE
		WHEN PTF.Active= 'Y'
		 THEN 'Yes'
		WHEN PTF.Active = 'N'
		 THEN 'No'
		END AS GridActive,
	  --FT.BitmapImage AS GridBitmapImage,
	  CONVERT(VARCHAR, PTF.CreatedDate, 101) AS GridCreatedDate,
	  PTF.CreatedBy AS GridCreatedBy,
	  CONVERT(VARCHAR, PTF.DeletedDate, 101) AS GridDeletedDate,
	  PTF.DeletedBy AS GridDeletedBy
	FROM TrackingProtocolFlags PTF
	LEFT JOIN FlagTypes FT ON FT.FlagTypeId = PTF.FlagTypeId --AND ISNULL(FT.RecordDeleted,'N')='N' 
	LEFT JOIN DocumentCodes DC ON DC.DocumentCodeId = FT.DocumentCodeId --AND ISNULL(DC.RecordDeleted,'N')='N'
	LEFT JOIN SystemActions SA ON SA.ActionId = FT.ActionId --AND ISNULL(SA.RecordDeleted,'N')='N'  
	LEFT JOIN GlobalCodes g  ON PTF.DueDateUnitType=g.GlobalCodeId         
	WHERE --ISNULL(PTF.RecordDeleted,'N')='N'  
		PTF.TrackingProtocolId = @TrackingProtocolId
		Order by FT.FlagType ASC
	
	
	SELECT
	PTP.TrackingProtocolProgramId,
	PTP.CreatedBy,
	PTP.CreatedDate,
	PTP.ModifiedBy,
	PTP.ModifiedDate,
	PTP.RecordDeleted,
	PTP.DeletedBy,
	PTP.DeletedDate,
	PTP.TrackingProtocolId,
	PTP.ProgramId,
	P.ProgramName
	FROM TrackingProtocolPrograms PTP
	LEFT JOIN Programs P ON P.ProgramId = PTP.ProgramId AND ISNULL(P.RecordDeleted,'N')='N' 
	WHERE ISNULL(PTP.RecordDeleted,'N')='N' 
	AND PTP.TrackingProtocolId = @TrackingProtocolId
	
	SELECT 
	PTFR.TrackingProtocolFlagRoleId,
	PTFR.CreatedBy,
	PTFR.CreatedDate,
	PTFR.ModifiedBy,
	PTFR.ModifiedDate,
	PTFR.RecordDeleted,
	PTFR.DeletedBy,
	PTFR.DeletedDate,
	PTFR.TrackingProtocolFlagId,
	PTFR.RoleId,
	GC.CodeName as RoleName
	FROM
	TrackingProtocolFlagRoles PTFR
	LEFT JOIN TrackingProtocolFlags PTF  ON PTFR.TrackingProtocolFlagId = PTF.TrackingProtocolFlagId AND ISNULL(PTF.RecordDeleted,'N')='N' 
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = PTFR.RoleId
	WHERE ISNULL(PTFR.RecordDeleted,'N')='N' 
	AND PTF.TrackingProtocolId = @TrackingProtocolId
	
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetTrackingProtocolDetails')                                                                                                           
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


