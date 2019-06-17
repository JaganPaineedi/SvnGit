 
 
 /****** Object:  StoredProcedure [dbo].[csp_SCGetVitalsHPA]    Script Date: 06/30/2014 18:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomSecondPreviousVitalsPsycNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomSecondPreviousVitalsPsycNote] 
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomSecondPreviousVitalsPsycNote]    Script Date: 06/30/2014 18:06:43 ******/
SET ANSI_NULLS ON
GO	

SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[csp_RDLCustomSecondPreviousVitalsPsycNote]  (@DocumentVersionId INT)   
  AS    
  /*********************************************************************/
/* Stored Procedure: [csp_RDLCustomSecondPreviousVitalsPsycNote] 738144
  */
/*       Date              Author                  Purpose                   */
/*      14-11-2016		   Ravichandra               To Get Vitals Data          */
/*		12-4-2017			Manjunath			Showing Vitals in Color. For Renaissance Dev Ites 890.1*/
/*      06/07/2017          Pabitra             TxAce Customizations #22 */	 
/*********************************************************************/
BEGIN    
 BEGIN TRY  
 
 DECLARE @ClientID int 
 SELECT top 1 @ClientId=D.ClientId 
 FROM  Documents D 
 JOIN Clients C ON C.ClientId=D.ClientId
 JOIN DocumentCodes DC ON DC.DocumentCodeId=D.DocumentCodeId
 WHERE  D.InProgressDocumentVersionId = @DocumentVersionId 
 AND ISNULL(D.RecordDeleted, 'N') = 'N'  
 AND ISNULL(DC.RecordDeleted, 'N') = 'N'  
 
  DECLARE  @AGE INT
  SELECT @AGE = DATEDIFF(day, DOB, GETDATE()) / 30  
  FROM Clients  
  WHERE ClientId = @clientId 
  Declare @ClientAge int
set @ClientAge=(SELECT DATEDIFF(year, DOB, getdate())  from Clients where ClientId=@ClientId)
  DECLARE @IntegerCodeId INT  
  
  SET @IntegerCodeId = (  
    SELECT integercodeid  
    FROM dbo.Ssf_recodevaluescurrent('XPSYCHIATRICNOTEVITAL')  
    )  
    
      DECLARE @CountofPrevious AS INT  
  DECLARE @SecondLatestHealthRecord AS DATETIME  
  DECLARE @PreviousVitalsWithDate VARCHAR(max)  
  
  SET @PreviousVitalsWithDate = ''  
  
  DECLARE @SecondLatestHealthRecordFormated VARCHAR(max)  
  
  SET @SecondLatestHealthRecordFormated = ''  
  
  DECLARE @PreviousVitals VARCHAR(max)  
  
   CREATE TABLE #Results(id int identity(1,1), vitals varchar(max),value varchar(500), Color Varchar(200))

  SET @PreviousVitals = ''  
  SET @CountofPrevious = (  
    SELECT Count(DISTINCT healthrecorddate)  
    FROM clienthealthdataattributes  
    WHERE clientid = @clientId  AND ISNULL(RecordDeleted,'N')='N'
    )  
  
  IF (@CountofPrevious > 2)  
  BEGIN  

   SET @SecondLatestHealthRecord = (  
     SELECT DISTINCT healthrecorddate  
     FROM clienthealthdataattributes  
     WHERE clientid = @clientId  
      AND healthrecorddate = (  
       SELECT Min(healthrecorddate)  
       FROM (  
        SELECT DISTINCT TOP (3) healthrecorddate  
        FROM clienthealthdataattributes  
        WHERE clientid = @clientId  AND ISNULL(RecordDeleted,'N')='N'
        ORDER BY healthrecorddate DESC  
        ) T  
       )  
     )  
   
  
  CREATE TABLE #tempvitals (  
   rowid INT PRIMARY KEY IDENTITY(1, 1)  
   ,healthdatatemplateid INT  
   ,healthdatasubtemplateid INT  
   ,healthdataattributeid INT  
   ,subtemplatename VARCHAR(200)  
   ,attributename VARCHAR(200)  
   ,value VARCHAR(200)  
   ,healthrecorddate DATETIME  
   ,clienthealthdataattributeid INT  
   ,datatype INT  
   )  
  

INSERT INTO #tempvitals  
   SELECT ta.healthdatatemplateid  
    ,ta.healthdatasubtemplateid  
    ,st.healthdataattributeid  
    ,s.NAME  
    ,a.NAME  
    ,chd.value  
    ,chd.healthrecorddate  
    ,chd.clienthealthdataattributeid  
    ,a.datatype  
   FROM healthdatatemplateattributes ta  
   INNER JOIN healthdatasubtemplateattributes st ON ta.healthdatasubtemplateid = st.healthdatasubtemplateid  
   INNER JOIN healthdatasubtemplates s ON ta.healthdatasubtemplateid = s.healthdatasubtemplateid  
   INNER JOIN healthdataattributes a ON a.healthdataattributeid = st.healthdataattributeid  
   INNER JOIN clienthealthdataattributes chd ON chd.healthdataattributeid = st.healthdataattributeid  
   WHERE ta.healthdatatemplateid = @IntegerCodeId  
    AND Isnull(ta.recorddeleted, 'N') <> 'Y'  
    AND chd.clientid = @ClientID  
    AND chd.healthrecorddate = @SecondLatestHealthRecord  
    AND Isnull(st.recorddeleted, 'N') <> 'Y'  
    AND Isnull(s.recorddeleted, 'N') <> 'Y'  
    AND Isnull(a.recorddeleted, 'N') <> 'Y'  
    AND Isnull(chd.recorddeleted, 'N') <> 'Y'  
 
 
  CREATE TABLE #tempvitalsWithGraphAttributes (  
   rowid INT PRIMARY KEY IDENTITY(1, 1),  
	HealthDataGraphCriteriaRangeId INT,
	HealthDataAttributeId INT, 
	HealthDataGraphCriteriaId INT,
	AgeFrom INT, 
	AgeTo INT,
	AllAge CHAR(1), 
	MinimumValue Varchar(20), 
	MaximumValue Varchar(20), 
	Color varchar(10),
	NAME varchar(200)
   )  
  
  INSERT INTO #tempvitalsWithGraphAttributes
  SELECT 
	HDGR.HealthDataGraphCriteriaRangeId,
	HA.HealthDataAttributeId, 
	HDG.HealthDataGraphCriteriaId,
	HDG.AgeFrom, 
	HDG.AgeTo,
	HDG.AllAge, 
	HDGR.MinimumValue, 
	HDGR.MaximumValue,
	g.Color,
	HA.NAME  
	from HealthDataAttributes HA
	LEFT JOIN HealthDataGraphCriteria HDG ON HDG.HealthDataAttributeId= HA.HealthDataAttributeId
	LEFT JOIN HealthDataGraphCriteriaRanges HDGR ON  HDGR.HealthDataGraphCriteriaId = HDG.HealthDataGraphCriteriaId
	LEFT JOIN #tempvitals t ON t.healthdataattributeid=HA.HealthDataAttributeId
	LEFT JOIN GlobalCodes g ON g.GlobalCodeId=HDGR.Level
	WHERE 
		(@AGE BETWEEN HDG.AgeFrom  AND HDG.AgeTo  OR HDG.AllAge = 'Y') 
         --AND (t.value BETWEEN HDGR.MinimumValue  AND HDGR.MaximumValue) AND
           AND (CAST(isnull(t.value,0) As Decimal) BETWEEN CAST(HDGR.MinimumValue AS Decimal) AND Cast(HDGR.MaximumValue As decimal))   
         AND Isnull(HDG.recorddeleted, 'N') <> 'Y'  
         AND Isnull(HDGR.recorddeleted, 'N') <> 'Y'  
         AND Isnull(g.recorddeleted, 'N') <> 'Y'    
		 AND HDGR.MinimumValue >= 0  
		 AND HDGR.MaximumValue > 0 

 CREATE TABLE #tempvitalsWithGraphAttributesWithPriority (  
   rowid INT PRIMARY KEY IDENTITY(1, 1),  
	HealthDataGraphCriteriaRangeId INT,
	HealthDataAttributeId INT, 
	HealthDataGraphCriteriaId INT,
	AgeFrom INT, 
	AgeTo INT,
	AllAge CHAR(1), 
	MinimumValue Varchar(20), 
	MaximumValue Varchar(20),
	Color varchar(10),
	NAME varchar(200)
   )  
insert into #tempvitalsWithGraphAttributesWithPriority		 
select 
HDG.HealthDataGraphCriteriaRangeId ,
	HDG.HealthDataAttributeId , 
	HDG.HealthDataGraphCriteriaId ,
	HDG.AgeFrom , 
	HDG.AgeTo ,
	HDG.AllAge , 
	HDG.MinimumValue , 
	HDG.MaximumValue ,
	HDG.Color ,
	HDG.NAME 
  from #tempvitalsWithGraphAttributes HDG
LEFT JOIN #tempvitals t ON t.healthdataattributeid=HDG.HealthDataAttributeId
WHERE  (((@AGE BETWEEN HDG.AgeFrom  AND HDG.AgeTo AND HDG.AllAge <> 'Y'
AND Not Exists ( select *  from  #tempvitalsWithGraphAttributes t where t.HealthDataAttributeId=HDG.HealthDataAttributeId AND t.AllAge='Y'))) 
OR HDG.AllAge = 'Y')     
--AND (t.value BETWEEN HDG.MinimumValue  AND HDG.MaximumValue)
AND (CAST(isnull(t.value,0) As Decimal) BETWEEN CAST(HDG.MinimumValue AS Decimal) AND Cast(HDG.MaximumValue As decimal))  
  
  
  
  
  
   CREATE TABLE #tempvitalsColors (  
  	HealthDataGraphCriteriaRangeId INT,
	HealthDataAttributeId INT, 
	HealthDataGraphCriteriaId INT,
	AgeFrom INT, 
	AgeTo INT,
	AllAge CHAR(1), 
	MinimumValue Varchar(20), 
	MaximumValue Varchar(20),
	Color varchar(10),
	NAME varchar(200)
   ) 
  
  ;with distincttemp(HealthDataGraphCriteriaRangeId 
	,HealthDataAttributeId  
	,HealthDataGraphCriteriaId 
	,AgeFrom 
	,AgeTo 
	,AllAge  
	,MinimumValue 
	,MaximumValue 
	,Color 
,	NAME 
,row)
  As
  (select HealthDataGraphCriteriaRangeId 
	,HealthDataAttributeId  
	,HealthDataGraphCriteriaId 
	,AgeFrom 
	,AgeTo 
	,AllAge  
	,MinimumValue 
	,MaximumValue 
	,Color 
,	NAME 
,ROW_NUMBER() over(partition by HealthDataAttributeId,HealthDataGraphCriteriaId order by HealthDataGraphCriteriaRangeId) as row
  from #tempvitalsWithGraphAttributesWithPriority
  )
   insert into #tempvitalsColors(HealthDataGraphCriteriaRangeId 
	,HealthDataAttributeId  
	,HealthDataGraphCriteriaId 
	,AgeFrom 
	,AgeTo 
	,AllAge  
	,MinimumValue 
	,MaximumValue 
	,Color 
,	NAME )	
  select HealthDataGraphCriteriaRangeId 
	,HealthDataAttributeId  
	,HealthDataGraphCriteriaId 
	,AgeFrom 
	,AgeTo 
	,AllAge  
	,MinimumValue 
	,MaximumValue 
	,Color 
,	NAME  from distincttemp where row=1
    
 --Height    
 INSERT INTO #Results(vitals,value,Color)                                
       SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, ''),
                                                                                          IsNull(ta.Color,'Black')         
            FROM    #tempvitals t
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=111        
            ORDER BY attributename 
            
 --Weight 
  INSERT INTO #Results(vitals,value,Color)                                 
                             
    SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')
			,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t 
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  healthdatasubtemplateid=111 and t.healthdataattributeid=110        
            ORDER BY attributename 
 ---BMI  
  INSERT INTO #Results(vitals,value,Color)                                
   
     SELECT   'BMI' , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '' )     
            ,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t 
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  healthdatasubtemplateid=111 and t.healthdataattributeid=112        
            ORDER BY attributename 
            
        --Systolic
        INSERT INTO #Results(vitals,value,Color)    
         SELECT    attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                            
                                                                                               ELSE value          
                                                                                          END, '')         
            ,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t 
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116        
            ORDER BY attributename 
            
        --BP Position
       IF  NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=116)
        BEGIN  
       INSERT INTO #Results(vitals,value,Color)                             

        SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value        
		 																  END, '')        
			,IsNull(ta.Color,'Black')      
			FROM    #tempvitals t 
			LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
			WHERE  healthdatasubtemplateid=110 and t.healthdataattributeid=130        
			ORDER BY attributename 
        END
        ELSE
        BEGIN
        INSERT INTO #Results(vitals,value,Color)                                  

			SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value        
		 																  END, '')        
			,IsNull(ta.Color,'Black')      
			FROM    #tempvitals t
			LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
			WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=130        
			ORDER BY attributename 
        END
    
       	--Diastolic	
          	INSERT INTO #Results(vitals,value,Color)  
			SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                         
                                                                                               ELSE value 
                                                                                             
                                                                                          END, '')
		,IsNull(ta.Color,'Black')    
        FROM    #tempvitals t
        LEFT JOIN #tempvitalsWithGraphAttributes ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113        
        ORDER BY attributename   
  
  ---- Pulse
    INSERT INTO #Results(vitals,value,Color)                           
		 SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, ''),
			IsNull(ta.Color,'Black')                                                                                        
            FROM    #tempvitals t 
            LEFT JOIN #tempvitalsWithGraphAttributes ta On t.healthdataattributeid=ta.healthdataattributeid
           WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114         
            ORDER BY attributename
            
         --Position 
         
       IF NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=114)
        BEGIN  
        INSERT INTO #Results(vitals,value,Color)                            

        SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')         
            ,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=133        
            ORDER BY attributename 
        END  
      ELSE   
       BEGIN
        INSERT INTO #Results(vitals,value,Color)                                

       SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')         
            ,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=133        
            ORDER BY attributename 
       
       END   
          --Respiratory  
           INSERT INTO #Results(vitals,value,Color)                                   
          
       SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                          
                                                                                               ELSE value 
                                                                                     
                                                                                          END, '')          
        ,IsNull(ta.Color,'Black')      
        FROM    #tempvitals t
        LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  t.healthdatasubtemplateid=114 and t.healthdataattributeid=115        
        ORDER BY attributename 
   
      --Temperature
       INSERT INTO #Results(vitals,value,Color)  
         SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)  
                                                                                              
                                                                                               ELSE value 
                                                                                             
                                                                                          END, '') 
			,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t
            LEFT JOIN #tempvitalsWithGraphAttributes ta On t.healthdataattributeid=ta.healthdataattributeid
           WHERE  t.healthdatasubtemplateid=112 and t.healthdataattributeid=120        
        ORDER BY attributename

        
      --Temperature Location
       INSERT INTO #Results(vitals,value,Color)                                

           SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')       
        ,IsNull(ta.Color,'Black')      
        FROM    #tempvitals t
        LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  healthdatasubtemplateid=112 and t.healthdataattributeid=119        
        ORDER BY attributename 
          
       --Smoking Status  
       INSERT INTO #Results(vitals,value,Color)                              
   
            SELECT  attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')        
            ,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  healthdatasubtemplateid=117 and t.healthdataattributeid=123        
            ORDER BY attributename  

            
     --Pain Level
     INSERT INTO #Results(vitals,value,Color)                               

        SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')      
        ,IsNull(ta.Color,'Black')      
        FROM    #tempvitals t
        LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  healthdatasubtemplateid=115 and t.healthdataattributeid=118        
        ORDER BY attributename 
                
            
      --Pain Location
       INSERT INTO #Results(vitals,value,Color)                            

         SELECT   attributename , ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')          
        ,IsNull(ta.Color,'Black')      
        FROM    #tempvitals t
        LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  healthdatasubtemplateid=115 and t.healthdataattributeid=124        
        ORDER BY attributename 
      

      
            
        --Medication list reconciled on this date   
        INSERT INTO #Results(vitals,value,Color)                                
  
            SELECT   attributename , case when ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')='Y' THEN 'Yes' END  AS value    
            ,IsNull(ta.Color,'Black')      
            FROM    #tempvitals t
            LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
            WHERE  t.healthdatasubtemplateid=118 and t.healthdataattributeid=125        
            ORDER BY attributename  
 END     
       
            SELECT  vitals AS PreviousVitals ,value, Color FROM #Results
            
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomSecondPreviousVitalsPsycNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                            
    16    
    ,-- Severity.                                                                                                            
    1 -- State.                                                                                                            
    );    
 END CATCH    
END 