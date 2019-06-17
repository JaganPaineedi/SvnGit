
/****** Object:  StoredProcedure [dbo].[ssp_PMProgramAssignmentDetail]    Script Date: 04/27/2011 10:49:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMProgramAssignmentDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMProgramAssignmentDetail]

GO

/****** Object:  StoredProcedure [dbo].[ssp_PMProgramAssignmentDetail]    Script Date: 04/27/2011 10:49:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_PMProgramAssignmentDetail]
	 @ClientProgramId INT
	,@ClientId INT
	,@ProgramId INT
/********************************************************************************                                                  
-- Stored Procedure: [ssp_PMProgramAssignmentDetail]
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return data for the program assignment details page.
--  Malathi Siva
--
-- *****History****
-- 24 Aug 2011 Girish		Removed References to Rowidentifier and/or ExternalReferenceId
-- 27 Aug 2011 Girish		Readded References to Rowidentifier and ExternalReferenceId
-- 10 Sep 2011 MSuma		Included Try Catch Block
-- 11 Oct 2011 Priyanka		commented  two columns RowIdentifier,ExternalReferenceId
-- 5/21/2012   Shruthi.S	To remove binding of dropdown using SP returned dt.
-- 12 Sep 2012 MSuma		Removed Hardcoded GlobalCodes
-- 6/19/2015   Hemant       Added Columns PriorityNumber,Emergent,MustBeEnrolledByDate,Prerequisite,WaitListPriorityComment
                            in ClientPrograms Why:network180 #616
-- 19 Oct 2015   Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.          
--          why:task #609, Network180 Customization 
-- 01/March/2016 Deej	Added top 1 in select query.
--13/October/2017  Prem   Added new Column 'Discharge Reason'   as part of MeaningFull Use Stage 3  #61  
-- 22/MAR/2018   Akwinass	Added non nullable columns for the select query of Services table (Task #200 in Texas Go Live Build Issues)
-- 06/04/2018    Hemant     PascalCase schema issue in select query is fixed. Thresholds Build Cycle Tasks #16
*********************************************************************************/

AS

BEGIN
BEGIN TRY

Declare @ClientProgramPriorityPopulation varchar(max);
set @ClientProgramPriorityPopulation =  (SELECT TOP 1 PriorityPopulation From ClientProgramPriorityPopulations WHERE ClientProgramId=@ClientProgramId)
--ClientProgram
		SELECT 
		 CP.ClientProgramId
		,CP.ClientId
		,CP.ProgramId
		,CP.Status
		/*,CONVERT(VARCHAR,CP.RequestedDate,101) AS RequestedDate
		,CONVERT(VARCHAR,CP.EnrolledDate,101) AS EnrolledDate
		,CONVERT(VARCHAR,CP.DischargedDate,101) AS DischargedDate*/
		,RequestedDate
		,EnrolledDate
		,DischargedDate
		,CP.PrimaryAssignment
		,CP.Comment
		--,CP.RowIdentifier
		--,CP.ExternalReferenceId
		,CP.CreatedBy
		,CP.CreatedDate
		,CP.ModifiedBy
		,CP.ModifiedDate
		,CP.RecordDeleted
		,CP.DeletedDate
		,CP.DeletedBy
		,CP.AssignedStaffId
   --Added by Revathi 19 Oct 2015  
   ,CASE   
    WHEN ISNULL(C.ClientType, 'I') = 'I'  
     THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  
    ELSE ISNULL(C.OrganizationName, '')  
    END AS ClientName   
    --Delete Column while update  
		--,CASE CP.Status
		--WHEN 1 THEN 'Requested'
		--WHEN 3 THEN 'Scheduled'  --Scheduled Status
		--WHEN 4 THEN 'Enrolled'
		--WHEN 5 THEN 'Discharged'
		--ELSE NULL
		--END AS [Current Status] 
		,GC.CodeName
				,CP.PriorityNumber        ,
CP.Emergent              ,
CP.MustBeEnrolledByDate ,
CP.Prerequisite       ,                                              
CP.WaitListPriorityComment,
--CP.PriorityPopulation
@ClientProgramPriorityPopulation as PriorityPopulation
     --Added By Prem 13 Oct 2017 
       ,CP.dischargereason 
		FROM
			ClientPrograms CP
		INNER JOIN Clients C ON CP.ClientId=C.ClientId		
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CP.Status AND ISNULL(GC.RecordDeleted,'N')='N'
		WHERE 
			ClientProgramId = @ClientProgramId

		SELECT @ClientId=ClientId From ClientPrograms WHERE ClientProgramId=@ClientProgramId
		SELECT @ProgramId=ProgramID From ClientPrograms WHERE ClientProgramId=@ClientProgramId
			
		--ClientProgramHistory
		SELECT 
			 CPH.ClientProgramHistoryId
			,CPH.ClientProgramId
			,CPH.Status
			,CASE CPH.RequestedDate
				WHEN  NULL  THEN NULL
				ELSE CONVERT(VARCHAR,CPH.RequestedDate,101)
				END AS RequestedDateFormated 
			,CASE CPH.EnrolledDate
			WHEN  NULL  THEN NULL
			ELSE CONVERT(VARCHAR,CPH.EnrolledDate,101)
			END AS EnrolledDateFormated 
			,CASE CPH.DischargedDate
			WHEN  NULL  THEN NULL
			ELSE CONVERT(VARCHAR,CPH.DischargedDate,101)
			END AS DischargedDateFormated 
			/*,CONVERT(VARCHAR,CPH.RequestedDate,101) AS RequestedDate
			,CONVERT(VARCHAR,CPH.EnrolledDate,101) AS EnrolledDate
			,CONVERT(VARCHAR,CPH.DischargedDate,101) AS DischargedDate*/
			,CPH.RequestedDate
			,CPH.EnrolledDate
			,CPH.DischargedDate
			,CPH.PrimaryAssignment
			,CPH.CreatedBy
			,CPH.CreatedDate
			,CPH.ModifiedBy
			,CPH.ModifiedDate
			,CPH.RecordDeleted
			,CPH.DeletedDate
			,CPH.DeletedBy
			,CPH.AssignedStaffId
			,S.LastName+', '+S.FirstName AS StaffName
			,GC.CodeName AS CodeName
			--,CASE CPH.Status
			--	WHEN 1 THEN 'Requested'
			--	WHEN 3 THEN 'Scheduled' --Scheduled Status
			--	WHEN 4 THEN 'Enrolled'
			--	WHEN 5 THEN 'Discharged'
			--	ELSE NULL
			--END AS CodeName 
			,CASE CPH.PrimaryAssignment
			 WHEN 'Y' THEN 'Yes'
			 ELSE 'No' 
			 End  AS [Primary]
			 ,[dbo].ssf_GetGlobalCodeNameById(CPH.Prerequisite) as 'PrerequisiteText'
			 ,CPH.PriorityPopulation
			 ,CPH.PriorityNumber
			 ,CPH.WaitListPriorityComment
			 ,CPH.Prerequisite
			  --Added By Prem 13 Oct 2017 
             ,GC1.CodeName AS DischargeReasonText 		
		FROM 
			ClientProgramHistory CPH
		LEFT JOIN Staff S ON CPH.AssignedStaffId = S.StaffId AND ISNULL(S.RecordDeleted,'N')='N'
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CPH.Status AND ISNULL(GC.RecordDeleted,'N')='N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeID = CPH.DischargeReason AND ISNULL(GC1.RecordDeleted, 'N') = 'N' 
		WHERE 	
			ClientProgramId = @ClientProgramId	
		
		ORDER BY ModifiedDate DESC
		
		select ClientProgramPriorityPopulationId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,RecordDeleted
,ClientProgramId
,PriorityPopulation
from ClientProgramPriorityPopulations where ClientProgramId =@ClientProgramId


		--Programs .. For Programs drop down, filter the list on client side based on Active and RecordDeleted flag
		--SELECT
		--		ProgramId
		--	   ,ProgramCode AS ProgramName
		--	   ,Active
		--	   ,RecordDeleted	
		--FROM 
		--	Programs	   
		--WHERE
		--	(RecordDeleted='N' OR RecordDeleted IS NULL)	
		--ORDER BY ProgramCode	

		--GlobalCodes For ProgramStatus
		--SELECT
		--	 GlobalCodeId
		--	,CodeName
		--	,Active
		--	,RecordDeleted	
		--FROM	
		--	GlobalCodes
		--WHERE	
		--	GlobalCodeId IN (1,4,5) -- (Requested,Enrolled,Discharged)
			


		--NextScheduledService	
		SELECT TOP 1 ServiceId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ClientId
			,ProcedureCodeId
			,DateOfService
			,Unit
			,[Status]
			,ProgramId
			,Billable
		FROM 
			Services			
		WHERE 
			DateOfService >= GETDATE() 
		AND 
			(ClientId = @ClientId AND ProgramId = @ProgramId)
		AND
			Status = 70 -- (Scheduled)
		AND
			(RecordDeleted = 'N' OR RecordDeleted IS NULL)			
		ORDER BY DateOfService
		
		
		


END TRY
              
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMProgramAssignmentDetail')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH 
	RETURN

END

GO


