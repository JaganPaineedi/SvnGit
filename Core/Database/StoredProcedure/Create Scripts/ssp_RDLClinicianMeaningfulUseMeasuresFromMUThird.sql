 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicianMeaningfulUseMeasuresFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicianMeaningfulUseMeasuresFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
        
        
CREATE PROCEDURE [dbo].[ssp_RDLClinicianMeaningfulUseMeasuresFromMUThird]        
(                                                
 @StartDate  DateTime,                                                            
 @EndDate  DateTime,        
 @MeasureType varchar(max),        
 @MeasureSubType varchar(max),        
 @Option char(1)        
 ,@Stage VARCHAR(10)=NULL        
 )        
  /********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLClinicianMeaningfulUseMeasuresFromMUThird              
--            
-- Copyright: Streamline Healthcate Solutions         
--                                                                           
-- Updates:                                                                   
-- Date   Author  Purpose            
-- 15-Oct-2017  Gautam  What:ssp to get MeaningfulUse Measures for Report.                  
--       Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports       
*********************************************************************************/           
AS        
BEGIN        
 BEGIN TRY        
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)          
  DECLARE @ReportPeriod VARCHAR(100)        
        
      
          
  IF @Stage is null        
     BEGIN        
   SELECT TOP 1 @MeaningfulUseStageLevel = Value        
   FROM SystemConfigurationKeys        
   WHERE [key] = 'MeaningfulUseStageLevel'        
    AND ISNULL(RecordDeleted, 'N') = 'N'        
     END        
    ELSE        
     BEGIN        
   SET @MeaningfulUseStageLevel=@Stage        
     END        
        
          
        
  SET @ReportPeriod = convert(VARCHAR, @StartDate, 101) + ' - ' + convert(VARCHAR, @EndDate, 101)        
        
  CREATE TABLE #ResultSet (        
   Stage VARCHAR(200)        
   ,MeasureType VARCHAR(250)        
   ,MeasureTypeId VARCHAR(15)        
   ,DetailsType VARCHAR(250)        
   ,[Target] VARCHAR(20)        
   ,ReportPeriod VARCHAR(100)        
   ,SortOrder INT        
   )        
        
  INSERT INTO #ResultSet (        
   Stage        
   ,MeasureType        
   ,MeasureTypeId        
   ,DetailsType        
   ,[Target]        
   ,ReportPeriod        
   ,SortOrder        
   )        
  SELECT DISTINCT GC1.CodeName          
  ,MU.DisplayWidgetNameAs        
  ,MU.MeasureType        
  , substring(isnull(GS.SubCodeName,MU.DisplayWidgetNameAs),1,          
  case when CHARINDEX('(',isnull(GS.SubCodeName,MU.DisplayWidgetNameAs))=0 then LEN(isnull(GS.SubCodeName,MU.DisplayWidgetNameAs))          
  else CHARINDEX('(',isnull(GS.SubCodeName,MU.DisplayWidgetNameAs))-2 end)        
  ,cast(isnull(mu.Target,0) as int)         
  ,@ReportPeriod        
  ,GC.SortOrder        
  from MeaningfulUseMeasureTargets MU Join GlobalCodes GC On MU.MeasureType= GC.GlobalCodeId        
  and ISNULL(MU.RecordDeleted,'N')='N' and ISNULL(GC.RecordDeleted,'N')='N'        
  Left Join GlobalSubCodes GS On MU.MeasureSubType=GS.GlobalSubCodeId         
  Left Join  GlobalCodes GC1 ON  GC1.GlobalCodeId= MU.Stage             
  and ISNULL(GS.RecordDeleted,'N')='N'                
   cross apply dbo.fnSplit(@MeasureType,',')  as temp        
  WHERE MU.Stage=@MeaningfulUseStageLevel and isnull(mu.Target,0)>0        
  AND GC.GlobalCodeId = temp.item         
  Order by GC.SortOrder asc            
          
        
  SELECT Stage        
   ,MeasureType        
   ,MeasureTypeId        
   ,DetailsType        
   ,[Target]        
   ,ReportPeriod        
  FROM #ResultSet        
          
               
END TRY        
  BEGIN CATCH        
    DECLARE @error varchar(8000)        
        
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'        
    + CONVERT(varchar(4000), ERROR_MESSAGE())        
    + '*****'        
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),        
    'ssp_RDLClinicianMeaningfulUseMeasuresFromMUThird')        
    + '*****' + CONVERT(varchar, ERROR_LINE())        
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())        
    + '*****' + CONVERT(varchar, ERROR_STATE())        
        
    RAISERROR (@error,-- Message text.        
    16,-- Severity.        
    1 -- State.        
    );        
  END CATCH        
END 