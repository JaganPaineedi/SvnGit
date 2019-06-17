IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateBedSwappingDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_UpdateBedSwappingDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create  Procedure [dbo].[ssp_UpdateBedSwappingDetails] --9,6,'2016-01-21 15:42:00.000' --1 -- 131           
(                    
@OldBedId int 
,@NewBedId int        
,@EndDate DateTime           
)                    
As   
 Begin   
 Begin TRY     
/****************************************************************************************/                            
/* Stored Procedure: dbo.ssp_UpdateBedSwappingDetails                                   */                            
/* Creation Date:  07-June-2012                                                         */                            
/* Creation By:  Veena S Mani                                                           */                            
/* Purpose: To Get Units and UnitAvailabilityHistory per UnitId                         */                         
/* Input Parameters: @UnitId                                                            */                          
/* Output Parameters:                                                                   */                            
/*  Date                  Author                 Purpose                                */    
/*  20/01/2016            Veena                  Philhaven Development #373 Swap beds   */
/*  01/AUG/2016           Akwinass               What : Modified the logic using system configuration key 'BEDASSIGNMENTRETAINPROCEDURECODE'*/
/*												 What : Why : Woods - Support Go Live #43*/
/*  22/AUG/2016           Akwinass               What : Changed system configuration key name from 'BEDASSIGNMENTRETAINPROCEDURECODE' to 'RETAINBEDASSIGNMENTPROCEDURECODE'*/
/*												 What : Why : Woods - Support Go Live #43*/
/****************************************************************************************/                     
DECLARE @BedAssignmentIdOld INT
DECLARE @ClientInpatientVisitId INT

DECLARE @RETAINPROCEDURECODE VARCHAR(10)
SELECT TOP 1 @RETAINPROCEDURECODE = Value
FROM SystemConfigurationKeys
WHERE [Key] = 'RETAINBEDASSIGNMENTPROCEDURECODE'
	AND ISNULL(RecordDeleted, 'N') = 'N'

SELECT TOP 1 @BedAssignmentIdOld = BedAssignmentId
	,@ClientInpatientVisitId = ClientInpatientVisitId
FROM BedAssignments
WHERE BedId = @OldBedId
	AND EndDate IS NULL
ORDER BY BedAssignmentId DESC

-- 01-AUG-2016 Akwinass	
DECLARE @ProcedureCodeId INT
DECLARE @BedLocationId INT = NULL
SELECT TOP 1 @ProcedureCodeId = BAH.ProcedureCodeId
	,@BedLocationId = BAH.LocationId
FROM dbo.BedAvailabilityHistory BAH
JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId)
JOIN dbo.Beds B ON (B.BedId = BAH.BedId)
WHERE BAH.BedId = @NewBedId
	AND (ISNULL(BAH.RecordDeleted, 'N') = 'N')
	AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE())
ORDER BY BAH.BedAvailabilityHistoryId DESC

IF ISNULL(@RETAINPROCEDURECODE, '') = 'Y'
BEGIN
	SELECT TOP 1 @ProcedureCodeId = BedProcedureCodeId
	FROM ClientInpatientVisits
	WHERE ClientInpatientVisitId = @ClientInpatientVisitId
		AND (ISNULL(RecordDeleted, 'N') = 'N')
END


DECLARE @bedassignmentid INT

INSERT INTO BedAssignments (
	ClientInpatientVisitId
	,BedId
	,StartDate
	,EndDate
	,[Status]
	,Type
	,Reason
	,Active
	,ProgramId
	,LocationId
	,ProcedureCodeId
	,BedNotAvailable
	,NotBillable
	,Disposition
	,Overbooked
	,Priority
	,LastServiceCreationDate
	,Comment
	,NextBedAssignmentId
	,ArrivalDate
	,ExpectedDischargeDate
	)
SELECT ClientInpatientVisitId
	,@NewBedId
	,@EndDate
	,NULL
	,[Status]
	,Type
	,Reason
	,Active
	,ProgramId
	-- 01-AUG-2016 Akwinass
	,CASE WHEN @BedLocationId IS NULL THEN LocationId ELSE @BedLocationId END	
	,CASE WHEN @ProcedureCodeId IS NULL THEN ProcedureCodeId ELSE @ProcedureCodeId END
	,BedNotAvailable
	,NotBillable
	,NULL
	,Overbooked
	,Priority
	,LastServiceCreationDate
	,Comment
	,NextBedAssignmentId
	,ArrivalDate
	,ExpectedDischargeDate
FROM BedAssignments
WHERE BedAssignmentId = @BedAssignmentIdOld

SET @bedassignmentid = @@IDENTITY

UPDATE BedAssignments
SET EndDate = @EndDate
	,Disposition = 5202
	,NextBedAssignmentId = @bedassignmentid
WHERE BedAssignmentId = @BedAssignmentIdOld

UPDATE ClientInpatientVisits
SET [Status] = 4982
WHERE ClientInpatientVisitId = @ClientInpatientVisitId

---if the new bedId is occuped need to do the same for bed2 also
DECLARE @BedAssignmentIdNew INT
DECLARE @ClientInpatientVisitIdNew INT

SELECT TOP 1 @BedAssignmentIdNew = BedAssignmentId
	,@ClientInpatientVisitIdNew = ClientInpatientVisitId
FROM BedAssignments
WHERE BedId = @NewBedId
	AND EndDate IS NULL
	AND ClientInpatientVisitId <> @ClientInpatientVisitId
ORDER BY BedAssignmentId DESC

IF @BedAssignmentIdNew IS NOT NULL
BEGIN	
	-- 01-AUG-2016 Akwinass
	SET @ProcedureCodeId = NULL
	SET @BedLocationId = NULL
	SELECT TOP 1 @ProcedureCodeId = BAH.ProcedureCodeId
		,@BedLocationId = BAH.LocationId
	FROM dbo.BedAvailabilityHistory BAH
	JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId)
	JOIN dbo.Beds B ON (B.BedId = BAH.BedId)
	WHERE BAH.BedId = @OldBedId
		AND (ISNULL(BAH.RecordDeleted, 'N') = 'N')
		AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE())
	ORDER BY BAH.BedAvailabilityHistoryId DESC
	
	IF ISNULL(@RETAINPROCEDURECODE, '') = 'Y'
	BEGIN					
		SELECT TOP 1 @ProcedureCodeId = BedProcedureCodeId
		FROM ClientInpatientVisits					
		WHERE ClientInpatientVisitId = @ClientInpatientVisitIdNew
			AND (ISNULL(RecordDeleted, 'N') = 'N')
	END

	INSERT INTO BedAssignments (
		ClientInpatientVisitId
		,BedId
		,StartDate
		,EndDate
		,[Status]
		,Type
		,Reason
		,Active
		,ProgramId
		,LocationId
		,ProcedureCodeId
		,BedNotAvailable
		,NotBillable
		,Disposition
		,Overbooked
		,Priority
		,LastServiceCreationDate
		,Comment
		,NextBedAssignmentId
		,ArrivalDate
		,ExpectedDischargeDate
		)
	SELECT ClientInpatientVisitId
		,@OldBedId
		,@EndDate
		,NULL
		,[Status]
		,Type
		,Reason
		,Active
		,ProgramId
		-- 01-AUG-2016 Akwinass
		,CASE WHEN @BedLocationId IS NULL THEN LocationId ELSE @BedLocationId END		
		,CASE WHEN @ProcedureCodeId IS NULL THEN ProcedureCodeId ELSE @ProcedureCodeId END
		,BedNotAvailable
		,NotBillable
		,NULL
		,Overbooked
		,Priority
		,LastServiceCreationDate
		,Comment
		,NextBedAssignmentId
		,ArrivalDate
		,ExpectedDischargeDate
	FROM BedAssignments
	WHERE BedAssignmentId = @BedAssignmentIdNew

	SET @bedassignmentid = @@IDENTITY

	UPDATE BedAssignments
	SET EndDate = @EndDate
		,Disposition = 5202
		,NextBedAssignmentId = @bedassignmentid
	WHERE BedAssignmentId = @BedAssignmentIdNew

	UPDATE ClientInpatientVisits
	SET [Status] = 4982
	WHERE ClientInpatientVisitId = @ClientInpatientVisitIdNew
	
	
END



END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_UpdateBedSwappingDetails')                                                                                                           
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

