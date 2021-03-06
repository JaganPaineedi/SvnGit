
/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetProcedureListServiceSummary]    Script Date: 06/11/2015 18:31:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetProcedureListServiceSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRCSGetProcedureListServiceSummary]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetProcedureListServiceSummary]    Script Date: 06/11/2015 18:31:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 19, 2014      
-- Description: Retrieves CCR Message      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================   
CREATE PROCEDURE [dbo].[ssp_CCRCSGetProcedureListServiceSummary] @ClientId AS INT
	,@ServiceId AS INT
	,@DocumentVersionId AS INT
AS
BEGIN
	SET NOCOUNT ON;

	IF (@ServiceId IS NOT NULL)
	BEGIN
		SELECT DISTINCT TOP 1 '' AS [Type]
			,ISNULL(PR.BillingCode, '') + ' ' + ISNULL(PR.Modifier1, '') + ' ' + ISNULL(PR.Modifier2, '') + ' ' + ISNULL(PR.Modifier3, '') + ' ' + ISNULL(PR.Modifier4, '') AS Code_Value
			,pc.ProcedureCodeName AS Code_Description
			--,(CONVERT(VARCHAR(10), s.DateofService, 101) + ' ' + SUBSTRING(CONVERT(VARCHAR(20), s.DateofService, 9), 13, 5) + ' ' + SUBSTRING(CONVERT(VARCHAR(30), s.DateofService, 9), 25, 2)) AS DateOfService_ApproximateDateTime
			, replace(replace(replace(convert(varchar(19), s.DateofService, 126),'-',''),'T',''),':','')AS DateOfService_ApproximateDateTime
			,l.LocationName Location_Description
			,gc.CodeName AS [Status]
		FROM dbo.Services AS s
		INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId
		INNER JOIN ProcedureRates PR ON pr.ProcedureCodeId = pc.ProcedureCodeId
		LEFT JOIN locations l ON (s.LocationId = l.LocationId)
		LEFT JOIN globalcodes gc ON (s.STATUS = gc.GlobalCodeId)
		WHERE s.ServiceId = @ServiceId
	END
	ELSE IF((@DocumentVersionId IS NOT NULL) OR (@DocumentVersionId IS NULL AND @ServiceId IS NULL))
	BEGIN
		SELECT '' AS [Type]
		,'' AS Code_Value
	   ,pc.ProcedureCodeName AS Code_Description  
	   --,max(S.DateofService) AS DateOfService_ApproximateDateTime  
	   , replace(replace(replace(convert(varchar(19), max(s.DateofService), 126),'-',''),'T',''),':','')AS DateOfService_ApproximateDateTime
			
	   ,l.LocationName AS Location_Description 
	   ,gc.CodeName AS [Status]
	  FROM dbo.Services AS s  
	  INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId  
	  LEFT JOIN locations l ON (s.LocationId = l.LocationId)
	  LEFT JOIN globalcodes gc ON (s.STATUS = gc.GlobalCodeId)
	  WHERE s.Clientid = @ClientId  
	   AND CAST(S.DateofService AS DATE) <= CAST(Getdate() AS DATE)  
	   AND CAST(S.DateofService AS DATE) >= DATEADD(mm, - 12, CAST(Getdate() AS DATE)) and Isnull(S.RecordDeleted,'N')<>'Y' AND Isnull(pc.RecordDeleted,'N')<>'Y'  
	  GROUP BY S.Procedurecodeid  
	   ,pc.ProcedureCodeName,l.LocationName,gc.CodeName 
	END
END

GO


