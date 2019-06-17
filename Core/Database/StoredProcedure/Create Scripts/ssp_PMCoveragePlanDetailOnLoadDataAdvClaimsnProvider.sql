
/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider]    
Script Date: 01/27/2012 12:21:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider]    Script Date: 01/31/2012 16:12:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider]
GO

CREATE PROCEDURE [dbo].[ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider]
@CoveragePlanId INT
AS

		/****************************************************************************** 
		** File: ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider.sql
		** Name: ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider
		** Desc:  
		** 
		** 
		** This template can be customized: 
		** 
		** Return values: Drop down values for Plan Details General Tab - Advanced Claims
		** 
		** Called by: 
		** 
		** Parameters: 
		** Input			Output 
		** ----------		----------- 
		** CoveragePlanId	Dropdown values for General Tab
		** Auth: Malathi Shiva
		** Date: 27/01/2012
		/* Updates:                                                          */
/*   Date        Author          Purpose                                    */
/*  07/17/2014  Hussain Khusro	Added new column "LocationId" in "CoveragePlanProviderIds" table and commented column "RowIdentifier" as it is removed from table
								for task #202 Philhaven Development	 */
/*  05/30/2016  Anto	Added new column "ProcedureCodeId" in "CoveragePlanClaimFormats" table for adding a Type able dropdown in the Popup
								for task #185 Bradford - Customizations	 */								
		*******************************************************************************/

BEGIN
BEGIN TRY   
	
       	
       	 
	   --Table 1 Advanced Claim Format for Plans
	   
 SELECT   
                  CP.CoveragePlanClaimFormatId,
                  CP.CoveragePlanId ,  
                  CP.ProgramId, CP.Degree,CP.ElectronicClaimFormatId,CP.PaperClaimFormatId,
                  CP.StaffId,
                  CP.Active,
                  CASE  WHEN CP.PaperClaimFormatId IS NULL 
                   THEN 'Electronic'  ELSE  'Paper' End as FormatType,  
                  CASE  WHEN CP.PaperClaimFormatId IS NULL 
                     THEN CM1.FormatName   ELSE CM.FormatName End AS Format, 
                  P.ProgramName as ProgramIdText,CP.RecordDeleted as RecordDeleted,
                  GC1.CodeName as DegreeText, 
                  CASE  WHEN S.DEGREE IS NULL THEN S.LastName + ', ' + S.FirstName ELSE S.LastName + ', ' + S.FirstName + ' ' + GC.CodeName END AS StaffIdText,
                  CP.RowIdentifier,
                  CP.CreatedBy,CP.CreatedDate,CP.ModifiedBy,CP.ModifiedDate,CP.DeletedDate,CP.DeletedBy
                  ,CP.ProcedureCodeId as ProcedureCodeId
                  ,PR.ProcedureCodeName as ProcedureCodeIdText
                  FROM  
                     CoveragePlanClaimFormats CP   
                  LEFT JOIN GlobalCodes GC1 on GC1.GlobalCodeId = CP.Degree  
                  LEFT JOIN Staff S on S.StaffId = CP.StaffId   
                  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=S.Degree   
                  LEFT JOIN ClaimFormats CM ON CP.PaperClaimFormatId = CM.ClaimFormatID   
                  LEFT JOIN ClaimFormats CM1 ON CP.ElectronicClaimFormatId = CM1.ClaimFormatID   
                  LEFT JOIN  Programs P ON P.ProgramId = CP.ProgramId  
                  LEFT JOIN  ProcedureCodes PR ON PR.ProcedureCodeId = CP.ProcedureCodeId
                  Where CP.CoveragePlanId =@CoveragePlanId
                  AND isnull(CP.RecordDeleted,'N') <>'Y'   
    ORDER BY CP.ModifiedDate

				
	                 

-- Table 2 Advanced Provider Type

	SELECT  
			CP.CoveragePlanProviderId,
		  ProviderId AS ProviderId, 
		  GC.CodeName AS ProviderIdTypeText ,
		  P.ProgramName AS ProgramIdText,
		  S.LastName + ', '+S.FirstName as StaffIdText,
		  CP.BillingProvider,
		  CP.RecordDeleted as RecordDeleted,
		  CoveragePlanId,
		  --CP.RowIdentifier, -- Changed by Hussain Khusro on 07/17/2014
			CP.CreatedBy,
			CP.CreatedDate,
			CP.ModifiedBy,
			CP.ModifiedDate,
			CP.Active,
			CP.ProgramId,
			CP.StaffId,
			CP.ProviderIdType,
			CP.LocationId, -- Added by Hussain Khusro on 07/17/2014
			L.LocationName as LocationIdText -----End
		  
		 FROM 
		  CoveragePlanProviderIds CP 
		 LEFT JOIN GlobalCodes GC ON  CP.ProviderIdType = GC.GlobalCodeId
		 LEFT JOIN Programs P ON P.ProgramId = CP.ProgramId
		 LEFT JOIN Staff S ON S.StaffId = CP.StaffId
		 LEFT JOIN Locations L ON L.LocationId = CP.LocationId -- Added by Hussain Khusro on 07/17/2014
		 WHERE 
			CP.CoveragePlanId = @CoveragePlanId
			AND isnull(CP.RecordDeleted,'N') <>'Y'
		 ORDER BY    
			ProviderIdTypeText
	   

END TRY

	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMCoveragePlanDetailOnLoadDataAdvClaimsnProvider')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END

