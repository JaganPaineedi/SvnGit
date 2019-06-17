IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLASAM] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLASAM] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_RDLASAM]   */
/*       Date              Author                  Purpose                   */
/*      10-08-2014     Dhanil Manuel               To Retrieve Data  for RDL   */
/*      11-16-2016     Veena                       Added agency selection Core Bugs 2232      */
/*********************************************************************/
BEGIN
	BEGIN TRY
	
	DECLARE @ClientId int      
    --Added by Veena on 11/16/2016 for Core Bugs 2232
	DECLARE @Agency Varchar(500)                                                                                                             SELECT @ClientId = ClientId from Documents where                                                                          		InProgressDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N'  
	Set @Agency= (Select OrganizationName from systemconfigurations) 
	DECLARE @ShowSummary char(1);
	set @ShowSummary = (select top 1 isnull(value,'N') from SystemConfigurationKeys where [KEY] = 'SHOWASAMSUMMARY') 	
	
		
		SELECT DocumentVersionId
		,C.LastName + ', ' + C.FirstName AS ClientName
	    ,D.ClientID
	    ,CASE 
				WHEN C.DOB IS NOT NULL
					THEN CONVERT(VARCHAR(10), C.DOB, 101)
				ELSE ''
				END DOB
	    ,CONVERT(VARCHAR(10), D.EffectiveDate, 101)  as EffectiveDate
		,CD.CreatedBy
		,CD.CreatedDate
		,Dimension1LevelOfCare
		,dbo.csf_GetGlobalCodeNameById(Dimension1Level) as Dimension1Level
		,dbo.csf_GetGlobalCodeNameById(Dimension1DocumentedRisk) as Dimension1DocumentedRisk
		,Dimension1Comments
		,Dimension1Summary 
		,Dimension2LevelOfCare
		,dbo.csf_GetGlobalCodeNameById(Dimension2Level) as Dimension2Level
		,dbo.csf_GetGlobalCodeNameById(Dimension2DocumentedRisk) as Dimension2DocumentedRisk
		,Dimension2Comments
		,Dimension2Summary
		,Dimension3LevelOfCare
		,dbo.csf_GetGlobalCodeNameById(Dimension3Level) as Dimension3Level
		,dbo.csf_GetGlobalCodeNameById(Dimension3DocumentedRisk) as Dimension3DocumentedRisk
		,Dimension3Comments
		,Dimension3Summary
		,Dimension4LevelOfCare
		,dbo.csf_GetGlobalCodeNameById(Dimension4Level) as Dimension4Level
		,dbo.csf_GetGlobalCodeNameById(Dimension4DocumentedRisk) as Dimension4DocumentedRisk
		,Dimension4Comments
		,Dimension4Summary
		,Dimension5LevelOfCare
		,dbo.csf_GetGlobalCodeNameById(Dimension5Level) as Dimension5Level
		,dbo.csf_GetGlobalCodeNameById(Dimension5DocumentedRisk) as Dimension5DocumentedRisk
		,Dimension5Comments
		,Dimension5Summary
		,Dimension6LevelOfCare
		,dbo.csf_GetGlobalCodeNameById(Dimension6Level) as Dimension6Level
		,dbo.csf_GetGlobalCodeNameById(Dimension6DocumentedRisk) as Dimension6DocumentedRisk
		,Dimension6Comments
		,Dimension6Summary
		,dbo.csf_GetGlobalCodeNameById(IndicatedReferredLevel) as IndicatedReferredLevel
		,dbo.csf_GetGlobalCodeNameById(ProvidedLevel) as ProvidedLevel
		,FinalDeterminationComments
		,FinalDeterminationSummary 
		,@ShowSummary as ShowSummary
        --Added by Veena on 11/16/2016 for Core Bugs 2232
		,@Agency as Agency
		FROM DocumentASAMs CD
		JOIN Documents D ON CD.DocumentVersionId = D.CurrentDocumentVersionId
		JOIN Clients C ON D.ClientId = C.ClientId
		WHERE CD.DocumentVersionId = @DocumentVersionId AND ISNULL(CD.RecordDeleted, 'N') = 'N'
			AND ISNull(C.RecordDeleted, 'N') = 'N'
			AND ISNull(D.RecordDeleted, 'N') = 'N'

 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLASAM') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO


