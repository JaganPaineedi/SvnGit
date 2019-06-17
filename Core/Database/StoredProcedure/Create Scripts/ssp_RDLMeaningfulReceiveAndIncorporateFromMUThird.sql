 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulReceiveAndIncorporateFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulReceiveAndIncorporateFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
         
CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulReceiveAndIncorporateFromMUThird]             
 @StaffId INT            
 ,@StartDate DATETIME            
 ,@EndDate DATETIME            
 ,@MeasureType INT            
 ,@MeasureSubType INT            
 ,@ProblemList VARCHAR(50)            
 ,@Option CHAR(1)            
 ,@Stage  VARCHAR(10)=NULL            
 ,@InPatient INT=0          
   ,@Tin VARCHAR(150)             
 /********************************************************************************                
-- Stored Procedure: dbo.ssp_RDLMeaningfulReceiveAndIncorporateFromMUThird                  
--               
-- Copyright: Streamline Healthcate Solutions             
--                 
-- Updates:                                                                         
-- Date   Author  Purpose                  
-- 15-Oct-2017  Gautam  What:ssp  for Patient Generated Helath Data Report.                        
--       Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports            
*********************************************************************************/            
AS            
BEGIN            
 BEGIN TRY            
 IF @MeasureType <> 9479 OR @InPatient <> 0            
    BEGIN            
     RETURN            
    END          
              
  CREATE TABLE #RESULT (            
   ClientId INT            
   ,ClientName VARCHAR(250)            
   ,ProviderName VARCHAR(250)             
   ,DateOfService DATETIME            
   ,ProcedureCodeName VARCHAR(250)           
   ,TransitionDate  DATETIME          
   )            
            
  IF @MeasureType = 9479           
  BEGIN            
   DECLARE @MeaningfulUseStageLevel VARCHAR(10)            
   DECLARE @RecordCounter INT            
   DECLARE @TotalRecords INT            
            
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
            
            
   DECLARE @ProviderName VARCHAR(40)            
            
   SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))            
   FROM staff            
   WHERE staffId = @StaffId            
            
   SET @RecordCounter = 1            
            
      
             
   IF @MeaningfulUseStageLevel in ( 8768,9476 ,9477,9480,9481) --            
   BEGIN              
    
    IF @Option = 'D'              
    BEGIN              
     INSERT INTO #RESULT (              
      ClientId              
      ,ClientName              
      ,ProviderName              
      ,DateOfService              
      ,ProcedureCodeName          
      ,TransitionDate             
      )              
    SELECT S.ClientId,S.ClientName ,@ProviderName, S.TransferDate,g.CodeName  ,S.TransferDate                              
        FROM dbo.ViewMUClientCCDs S     
     join GlobalCodes g on S.CCDType  =g.GlobalCodeId       
      Left JOIN Locations L On S.LocationId=L.LocationId                                 
    WHERE     
     S.TransferDate >= CAST(@StartDate AS DATE)                                
     AND S.TransferDate <= CAST(@EndDate AS DATE)   
     AND   
    (g.GlobalCodeId in (SELECT GlobalCodeId FROM GlobalCodes WHERE Category='XCCDType' and CodeName in ('Transitioned','Referred','New')))     
    AND (S.LocationId is not null AND ( S.LocationId = -1 or  L.TaxIdentificationNumber=@Tin)  )             
     AND S.RecipientPhysicianId = @StaffId                  
                    
    END              
              
   IF  (@Option = 'N' OR @Option = 'A')           
   BEGIN          
   INSERT INTO #RESULT (              
      ClientId              
      ,ClientName              
      ,ProviderName              
      ,DateOfService              
      ,ProcedureCodeName          
      ,TransitionDate             
      )              
    SELECT S.ClientId,S.ClientName ,@ProviderName, S.TransferDate,g.CodeName  ,S.TransferDate                              
        FROM dbo.ViewMUClientCCDs S     
     join GlobalCodes g on S.CCDType  =g.GlobalCodeId       
      Left JOIN Locations L On S.LocationId=L.LocationId                          
    WHERE     
      S.TransferDate >= CAST(@StartDate AS DATE)                                
     AND S.TransferDate <= CAST(@EndDate AS DATE)   
     AND   
    (g.GlobalCodeId in (SELECT GlobalCodeId FROM GlobalCodes WHERE Category='XCCDType' and CodeName in ('Transitioned','Referred','New')))     
    AND (S.LocationId is not null AND ( S.LocationId = -1 or  L.TaxIdentificationNumber=@Tin)  )             
     AND S.RecipientPhysicianId = @StaffId          
     AND ISNULL(S.Incorporated,'N')='Y'                       
          
           
  END      
  end          
            
  SELECT  R.ClientId            
   ,R.ClientName            
   ,R.ProviderName            
   ,null AS DateOfService            
   ,R.ProcedureCodeName           
   ,@Tin as 'Tin'          
   ,convert(VARCHAR, R.TransitionDate, 101) AS   'Transfer Date'        
  FROM #RESULT R            
  ORDER BY R.ClientId ASC            
   ,R.DateOfService DESC            
   ,R.TransitionDate DESC        
   end          
 END TRY            
            
   BEGIN CATCH            
    DECLARE @error varchar(8000)            
            
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'            
    + CONVERT(varchar(4000), ERROR_MESSAGE())            
    + '*****'            
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),            
    'ssp_RDLMeaningfulReceiveAndIncorporateFromMUThird')            
    + '*****' + CONVERT(varchar, ERROR_LINE())            
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())            
    + '*****' + CONVERT(varchar, ERROR_STATE())            
            
    RAISERROR (@error,-- Message text.            
    16,-- Severity.            
    1 -- State.            
    );            
  END CATCH            
END 