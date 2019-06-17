IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageOrderTemplateFrequencies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageOrderTemplateFrequencies]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
**		File: ssp_SCListPageOrderTemplateFrequencies.sql
**		Name: ssp_SCListPageOrderTemplateFrequencies
**		Desc: ListPageOrderTemplateFrequencies
**              
**		Return values: TablePagingInformation and ListPageOrderTemplateFrequencies
** 
**		Called by: SHS.SmartCareWeb\ActivityPages\Admin\ListPages\OrderTemplateFrequencies.ascx.cs
**              
**		Parameters:
**		Input							Output
**		@SessionId VARCHAR(30)			None
**		@InstanceId INT
**		@PageNumber INT
**		@PageSize INT
**		@SortExpression VARCHAR(100)
**		@OtherFilter INT 
**		@RxFrequencyType INT
**
**		Auth: Jason Steczynski 
**		Date: 3/27/2015
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		4/29/2015	Jason Steczynski	Output time in standard format
**										Change Category from MEDICATIONSCHEDULE to XFREQTIMEDAY
**										Add not RecordDeleted condition check
**		30/7/2015	Chethan N			What: Added SelectDays to Select statement
										Why: Philhaven Development task# 318
**    
*******************************************************************************/

CREATE PROCEDURE  [dbo].[ssp_SCListPageOrderTemplateFrequencies]
	@SessionId VARCHAR(30),
	@InstanceId INT,
	@PageNumber INT,
	@PageSize INT,
	@SortExpression VARCHAR(100),
	@OtherFilter INT, 
	@TimesPerDayId INT
AS
BEGIN

	SET NOCOUNT ON;

	IF @TimesPerDayId = 0
		SET @TimesPerDayId = NULL     
   	            
	--CTE----------------------------------------------------------------------------------------------------------------        
	;WITH TotalOrderTemplates  AS   
	(     
		SELECT otf.OrderTemplateFrequencyId, otf.DisplayName AS TemplateName, 
			   otf.DispenseTime1, otf.DispenseTime2, otf.DispenseTime3, otf.DispenseTime4, 
			   otf.DispenseTime5, otf.DispenseTime6, otf.DispenseTime7, otf.DispenseTime8
		FROM dbo.OrderTemplateFrequencies otf 
		--INNER JOIN dbo.GlobalCodes gc ON otf.TimesPerDay = gc.GlobalCodeId
		WHERE ((@TimesPerDayId IS NULL) OR (otf.TimesPerDay = @TimesPerDayId))
		--AND gc.Category = 'XFREQTIMEDAY' 
		AND ISNULL(otf.RecordDeleted,'N')<>'Y'
	),  
	counts AS ( 
		SELECT COUNT(*) AS totalrows FROM TotalOrderTemplates
	),              
	ListOrderTemplateFrequencies AS   
	(   
		SELECT OrderTemplateFrequencyId, TemplateName, 
			   DispenseTime1, DispenseTime2, DispenseTime3,DispenseTime4, 
			   DispenseTime5, DispenseTime6, DispenseTime7, DispenseTime8,
		COUNT(*) OVER ( ) AS TotalCount,  
		ROW_NUMBER() OVER(ORDER BY    
			CASE WHEN @SortExpression= 'TemplateName' THEN TemplateName END ,                                 
			CASE WHEN @SortExpression= 'TemplateName DESC' THEN TemplateName END DESC, 
		OrderTemplateFrequencyId) AS RowNumber  
		FROM TotalOrderTemplates   
	)  
	---------------------------------------------------------------------------------------------------------------------- 

	SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) FROM counts) ELSE (@PageSize) END)  
	OrderTemplateFrequencyId, TemplateName, DispenseTime1, DispenseTime2, DispenseTime3, DispenseTime4, DispenseTime5, DispenseTime6, DispenseTime7, DispenseTime8, TotalCount, RowNumber  
	INTO #FinalResultSet  
	FROM ListOrderTemplateFrequencies 
	WHERE RowNumber > ( ( @PageNumber - 1 ) * @PageSize )    

	IF (SELECT ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1  
		BEGIN  
			SELECT 0 AS PageNumber ,  
			0 AS NumberOfPages ,  
			0 NumberOfRows  
		END  
	ELSE  
		BEGIN  
			SELECT TOP 1 @PageNumber AS PageNumber,  
			CASE (TotalCount % @PageSize) 
			WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)  
			ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,  
			ISNULL(TotalCount, 0) AS NumberOfRows  
			FROM #FinalResultSet       
		END   

	SELECT OrderTemplateFrequencyId, TemplateName, 
	LEFT(CONVERT(VARCHAR, DispenseTime1, 100), LEN(CONVERT(VARCHAR, DispenseTime1, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime1, 100), 2) AS DispenseTime1,
	LEFT(CONVERT(VARCHAR, DispenseTime2, 100), LEN(CONVERT(VARCHAR, DispenseTime2, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime2, 100), 2) AS DispenseTime2,
	LEFT(CONVERT(VARCHAR, DispenseTime3, 100), LEN(CONVERT(VARCHAR, DispenseTime3, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime3, 100), 2) AS DispenseTime3,
	LEFT(CONVERT(VARCHAR, DispenseTime4, 100), LEN(CONVERT(VARCHAR, DispenseTime4, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime4, 100), 2) AS DispenseTime4,
	LEFT(CONVERT(VARCHAR, DispenseTime5, 100), LEN(CONVERT(VARCHAR, DispenseTime5, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime5, 100), 2) AS DispenseTime5,
	LEFT(CONVERT(VARCHAR, DispenseTime6, 100), LEN(CONVERT(VARCHAR, DispenseTime6, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime6, 100), 2) AS DispenseTime6,
	LEFT(CONVERT(VARCHAR, DispenseTime7, 100), LEN(CONVERT(VARCHAR, DispenseTime7, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime7, 100), 2) AS DispenseTime7,
	LEFT(CONVERT(VARCHAR, DispenseTime8, 100), LEN(CONVERT(VARCHAR, DispenseTime8, 100)) -2 ) + ' ' + RIGHT(CONVERT(VARCHAR, DispenseTime8, 100), 2) AS DispenseTime8
	FROM #FinalResultSet                                    
	ORDER BY RowNumber    

	DROP TABLE #FinalResultSet  

END

GO



