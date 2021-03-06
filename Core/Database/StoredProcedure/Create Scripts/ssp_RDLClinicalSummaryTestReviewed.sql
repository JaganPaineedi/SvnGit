/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryTestReviewed]    Script Date: 06/09/2015 04:09:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryTestReviewed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryTestReviewed] @ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
AS 
/******************************************************************************                      
**  File: ssp_RDLClinicalSummaryTestReviewed.sql    
**  Name: ssp_RDLClinicalSummaryTestReviewed    
**  Desc:     
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
**  Date:  Feb 20 2014    
*******************************************************************************                      
**  Change History                      
*******************************************************************************                      
**  Date:        Author:            Description:                      
**  --------     --------           -------------------------------------------     
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18    
**  19/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.          
 03/09/2014  Revathi   what:check RecordDeleted , avoid Ambiguous column  
         why:task#36 MeaningfulUse    
 11/12/2014 NJain    Updated logic to get the Flag field to look at RecordDeleted           
*******************************************************************************/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from    
	-- interfering with SELECT statements.    
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @DOS DATETIME = NULL
		DECLARE @TC VARCHAR(10) = ''PC''
		DECLARE @DocumentCodeId INT

		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
		END
		ELSE IF (
				@ServiceId IS NULL
				AND @DocumentVersionId IS NOT NULL
				)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
				,@DocumentCodeId = DocumentCodeId
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, ''N'') = ''N''
		END

		IF (@DocumentCodeId = 1611)
			OR (
				@ServiceId IS NULL
				AND @DocumentVersionId IS NULL
				AND @ClientId IS NOT NULL
				)
		BEGIN
			SET @TC = ''TC''

			SELECT @DOS = MAX(healthrecorddate)
			FROM ClientHealthDataAttributes
			WHERE ClientId = @ClientId
				AND ISNULL(RecordDeleted, ''N'') = ''N''
		END

		
		SELECT ORD.OrderName
			,CONVERT(VARCHAR(12), D.EffectiveDate, 101) AS OrderDate
			,CONVERT(VARCHAR(12), CO.OrderStartDateTime, 101) AS TestDate
			,--COR.ResultDateTime ,  
			S.LastName + '', '' + S.FirstName AS OrderingPhysician
			,O.LOINCCode AS LOINC
			,O.ObservationName AS Element
			,COO.Value AS Result
			,COO.Flag AS Flag
		FROM ClientOrders AS CO
		INNER JOIN ORDERS AS ORD ON ORD.ORDERID = CO.ORDERID
		INNER JOIN documents d ON CO.DocumentId = d.DocumentId
		INNER JOIN ClientOrderResults AS COR ON COR.CLIENTORDERID = CO.CLIENTORDERID
		INNER JOIN ClientOrderObservations AS COO ON COR.ClientOrderResultId = COO.ClientOrderResultId
		INNER JOIN OBSERVATIONS AS O ON O.ObservationId = COO.ObservationId
		LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician
		WHERE CO.ClientId = @ClientId
			AND ORD.OrderType IN (
				6481
				,6482
				)
			AND D.[Status] = 22
			AND (
				(@TC = ''TC'')
				OR (CAST(CO.ReviewedDateTime AS DATE) >= CAST(@DOS AS DATE))
				)
			AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''
			AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''
			AND ISNULL(O.RecordDeleted, ''N'') <> ''Y''
			AND ISNULL(D.RecordDeleted, ''N'') <> ''Y''
			AND ISNULL(COR.RecordDeleted, ''N'') <> ''Y''
			AND ISNULL(COO.RecordDeleted, ''N'') <> ''Y''
			AND ISNULL(ORD.RecordDeleted, ''N'') <> ''Y''
			AND ISNULL(S.RecordDeleted, ''N'') <> ''Y''
		ORDER BY OrderName
			,OrderDate
			,TestDate
			,OrderingPhysician
			,LOINC
			,Element
			,Result
			,Flag
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_RDLClinicalSummaryTestReviewed'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****
'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                   
				16
				,-- Severity.                                                          
				1 -- State.                                                       
				);
	END CATCH
END
' 
END
GO
