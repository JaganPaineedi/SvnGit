/****** Object:  StoredProcedure [dbo].[csp_SCGetColorVitals]    Script Date: 06/30/2014 18:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetColorVitals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetColorVitals] 
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetColorVitals]    Script Date: 06/30/2014 18:06:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[csp_SCGetColorVitals]  (@ClientID INT)   
  AS    
  /*********************************************************************/
/* Stored Procedure: [csp_SCGetColorVitals] 4  */
/*       Date              Author                  Purpose                   */
/*      24-3-2015		    vamsi               To Get Vitals Data          */
/*		12-4-2017			Manjunath			Showing Vitals in Color. For Renaissance Dev Ites 890.1*/
/*      06/07/2017          Pabitra             TxAce Customizations #22 */
/*********************************************************************/
BEGIN    
 BEGIN TRY  
  
  DECLARE @IntegerCodeId INT  
  
  SET @IntegerCodeId = (  
    SELECT integercodeid  
    FROM dbo.Ssf_recodevaluescurrent('XPSYCHIATRICNOTEVITAL')  
    )  
  Declare @ClientAge int
set @ClientAge=(SELECT DATEDIFF(year, DOB, getdate())  from Clients where ClientId=@ClientId)
  
  DECLARE  @AGE INT
  SELECT @AGE = DATEDIFF(day, DOB, GETDATE()) / 30  
  FROM Clients  
  WHERE ClientId = @clientId 
  
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
   AND chd.healthrecorddate = (  
    SELECT Max(healthrecorddate)  
    FROM clienthealthdataattributes  
    WHERE clientid = @ClientID  
    )  
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
	WHERE (@AGE BETWEEN HDG.AgeFrom  AND HDG.AgeTo  OR HDG.AllAge = 'Y') 
         --AND (t.value BETWEEN HDGR.MinimumValue  AND HDGR.MaximumValue) AND 
                  AND (CAST(isnull(t.value,0) As Decimal) BETWEEN CAST(HDGR.MinimumValue AS Decimal) AND Cast(HDGR.MaximumValue As decimal))  

        AND  Isnull(HDG.recorddeleted, 'N') <> 'Y'  
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
--AND (isnull(t.value,0) BETWEEN HDG.MinimumValue  AND HDG.MaximumValue)
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
  
  DECLARE @Currentvitals VARCHAR(max)  
  DECLARE @CurrentVitalDate AS DATETIME   
        DECLARE @CurrentLatestHealthRecordFormated VARCHAR(max)  
          
       SET @CurrentVitalDate = (SELECT Max(healthrecorddate)  
    FROM clienthealthdataattributes  
    WHERE clientid = @ClientID)  
  
  SET @Currentvitals = ''  
        SET @CurrentLatestHealthRecordFormated = ''  
  
 
  
 --Height                                    
    SELECT  @Currentvitals = @Currentvitals + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')  + '<br>'       
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
    WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=111        
    ORDER BY attributename 
            
 --Weight                              
    SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')   + '<br>'      
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
    WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=110        
    ORDER BY attributename 
    
 ---BMI     
     SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + 'BMI' + ': ' + 
     ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
     ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'       
     END, '' )    + '<br>'     
     FROM    #tempvitals t 
     LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
     WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=112       
     ORDER BY attributename 
            
    --Systolic

	SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' +  attributename + ': ' + 
	ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)  
	ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'  
	END, '') + '<br>'     
	FROM    #tempvitals t
	LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116        
	ORDER BY attributename 
 --   If(@ClientAge <18)
 --    Begin
		 
 --        SELECT  @Currentvitals = @Currentvitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 89  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 90   and Cast(value AS decimal(18,6))<= 101  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 102 and Cast(value AS decimal(18,6))<= 129 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 130 and Cast(value AS decimal(18,6))<= 140  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 141  and Cast(value AS decimal(18,6))<= 160 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116        
	--ORDER BY attributename 
	--end
 --   else
 --   begin
 --   SELECT  @Currentvitals = @Currentvitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 89  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 90   and Cast(value AS decimal(18,6))<= 101  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 102 and Cast(value AS decimal(18,6))<= 129 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 130 and Cast(value AS decimal(18,6))<= 170  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 171 and Cast(value AS decimal(18,6))<= 200  then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116         
	--ORDER BY attributename
    
 --   end
                    
            
            
            
        --BP Position
       IF  NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=116)
        BEGIN  
        SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value   
																						       
		 																  END, '') + '<br>'      
			FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=130        
			ORDER BY attributename 
        END
        ELSE
        BEGIN
			SELECT  @Currentvitals = @Currentvitals + ''+ attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value        
		 																  END, '')  + '<br>'     
			FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=130        
			ORDER BY attributename 
        END
    
       	--Diastolic	
  SELECT  @Currentvitals = @Currentvitals + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')  + '<br>'       
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
  WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113      
    ORDER BY attributename 
 -- If(@ClientAge <18)
 --    Begin
		 
 --        SELECT  @Currentvitals = @Currentvitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 79 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 80 and Cast(value AS decimal(18,6))<= 90  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 91 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113     
	--ORDER BY attributename 
	--end
 --   else
 --   begin
 --   SELECT  @Currentvitals = @Currentvitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 80 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 81 and Cast(value AS decimal(18,6))<= 100  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 101 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113       
	--ORDER BY attributename
    
 --   end
            
  ---- Pulse
	 SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')   + '<br>'      
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
    WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114         
     ORDER BY attributename        
 -- If(@ClientAge <18)
 --    Begin
		 
 --        SELECT  @Currentvitals = @Currentvitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 79 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 80 and Cast(value AS decimal(18,6))<= 90  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 91 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114        
	--ORDER BY attributename 
	--end
 --   else
 --   begin
 --   SELECT  @Currentvitals = @Currentvitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 80 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 81 and Cast(value AS decimal(18,6))<= 100  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 101 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114        
	--ORDER BY attributename
    
 --   end
            
         --Position 
       IF NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=114)
        BEGIN  
        SELECT  @Currentvitals = @Currentvitals + CHAR(13)+ ' ' + attributename + ': ' + 
        ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
        ELSE value        
        END, '') + '<br>'
        FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=133        
        ORDER BY attributename 
        END  
      ELSE   
       BEGIN
       SELECT  @Currentvitals = @Currentvitals +''+ attributename + ': ' + 
       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
       ELSE value        
       END, '')   + '<br>'      
       FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=133        
       ORDER BY attributename 
       
       END   
          --Respiratory     
       SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + 
       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
       ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
       END, '') + '<br>'
       FROM    #tempvitals t 
       LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
       WHERE  t.healthdatasubtemplateid=114 and t.healthdataattributeid=115        
       ORDER BY attributename 
   
      --Temperature
               
        SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + 
        ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
        ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'  
        END, '')   + '<br>'      
        FROM    #tempvitals t 
        LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  t.healthdatasubtemplateid=112 and t.healthdataattributeid=120        
        ORDER BY attributename 
          --Temperature  
      
  --      SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(
		--CASE WHEN datatype = 8081 THEN  dbo.Getglobalcodename(value)  
		----  ELSE value              
		--ELSE 
		--case when Cast(value AS decimal(18,6))<= 95.4  then '<span style="color:Salmon">'+value+'</span>' 
		--ELSE  
		--case when Cast(value AS decimal(18,6))>= 95.5   and Cast(value AS decimal(18,6))<= 97.3  then '<span style="color:Gold">'+value+'</span>' 
		--ELSE 
		--case when Cast(value AS decimal(18,6))>= 97.4 and Cast(value AS decimal(18,6))<= 99.6  then '<span style="color:Green">'+value+'</span>' 
		--ELSE 
		--case when Cast(value AS decimal(18,6))>= 99.7 and Cast(value AS decimal(18,6))<= 101.4  then '<span style="color:Yellow">'+value+'</span>' 
		--ELSE  
		--case when Cast(value AS decimal(18,6))>= 101.5  then '<span style="color:Red">'+value+'</span>' 
		--ELSE value
		--end		end		end		end		END     		END, '')   + '<br>'        
  --     FROM    #tempvitals t 
  --      LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
  --      WHERE  t.healthdatasubtemplateid=112 and t.healthdataattributeid=120        
  --      ORDER BY attributename       
         
        
      --Temperature Location
      
        SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + 
        ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
        ELSE value        
        END, '') + '<br>'      
        FROM    #tempvitals WHERE  healthdatasubtemplateid=112 and healthdataattributeid=119        
        ORDER BY attributename 
      
   

          
       --Smoking Status     
            SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' +attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')   + '<br>'       
            FROM    #tempvitals WHERE  healthdatasubtemplateid=117 and healthdataattributeid=123        
            ORDER BY attributename  
            --set @Currentvitals=@Currentvitals+ +CHAR(13);
            
            
                     
     --Pain Level
     
        SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')  + '<br>'     
        FROM    #tempvitals WHERE  healthdatasubtemplateid=115 and healthdataattributeid=118        
        ORDER BY attributename 
                
            
      --Pain Location
      
         SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')  + '<br>'       
        FROM    #tempvitals WHERE  healthdatasubtemplateid=115 and healthdataattributeid=124        
        ORDER BY attributename 
      
            
        --Medication list reconciled on this date     
            SELECT  @Currentvitals = @Currentvitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')  + '<br>'        
            FROM    #tempvitals WHERE  healthdatasubtemplateid=118 and healthdataattributeid=125        
            ORDER BY attributename       
    
   SET @CurrentLatestHealthRecordFormated = (  
     SELECT CONVERT(VARCHAR, @CurrentVitalDate, 101)       
     )  
       
   IF NOT (  
    --NULLIF(@CurrentLatestHealthRecordFormated, '') IS NULL  
    --AND   
    NULLIF(@Currentvitals, '') IS NULL  
    )  
  BEGIN  
   SET @Currentvitals = @Currentvitals  
  END  
  ELSE  
  BEGIN  
   SET @Currentvitals = ''  
  END  
  
  --SELECT  LEFT(@Currentvitals,LEN(@Currentvitals)-1) AS Value   
  DECLARE @CountofPrevious AS INT  
  DECLARE @SecondLatestHealthRecord AS DATETIME  
  DECLARE @PreviousVitalsWithDate VARCHAR(max)  
  
  SET @PreviousVitalsWithDate = ''  
  
  DECLARE @SecondLatestHealthRecordFormated VARCHAR(max)  
  
  SET @SecondLatestHealthRecordFormated = ''  
  
  DECLARE @PreviousVitals VARCHAR(max)  
  
  SET @PreviousVitals = ''  
  SET @CountofPrevious = (  
    SELECT Count(DISTINCT healthrecorddate)  
    FROM clienthealthdataattributes  
    WHERE clientid = @ClientID  
    )  
  
  IF (@CountofPrevious > 1)  
  BEGIN  
   SET @SecondLatestHealthRecord = (  
     SELECT DISTINCT healthrecorddate  
     FROM clienthealthdataattributes  
     WHERE clientid = @ClientID  
      AND healthrecorddate = (  
       SELECT Min(healthrecorddate)  
       FROM (  
        SELECT DISTINCT TOP (2) healthrecorddate  
        FROM clienthealthdataattributes  
        WHERE clientid = @ClientID AND ISNULL(RecordDeleted,'N')='N'
        ORDER BY healthrecorddate DESC  
        ) T  
       )  
     )  
  
   DELETE  
   FROM #tempvitals  
  
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
    
    DELETE  
    FROM #tempvitalsWithGraphAttributes  
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
	HA.Name  
	from HealthDataAttributes HA
	LEFT JOIN HealthDataGraphCriteria HDG ON HDG.HealthDataAttributeId= HA.HealthDataAttributeId
	LEFT JOIN HealthDataGraphCriteriaRanges HDGR ON  HDGR.HealthDataGraphCriteriaId = HDG.HealthDataGraphCriteriaId
	LEFT JOIN #tempvitals t ON t.healthdataattributeid=HA.HealthDataAttributeId
	LEFT JOIN GlobalCodes g ON g.GlobalCodeId=HDGR.Level
    WHERE (@AGE BETWEEN HDG.AgeFrom  AND HDG.AgeTo  OR HDG.AllAge = 'Y') 
         AND (t.value BETWEEN HDGR.MinimumValue  AND HDGR.MaximumValue) AND 
         Isnull(HDG.recorddeleted, 'N') <> 'Y'  
         AND Isnull(HDGR.recorddeleted, 'N') <> 'Y'  
         AND Isnull(g.recorddeleted, 'N') <> 'Y'       
		 AND HDGR.MinimumValue >= 0  
		 AND HDGR.MaximumValue > 0 
    DELETE FROM #tempvitalsWithGraphAttributesWithPriority
    DELETE FROM #tempvitalsColors
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
--AND (CAST(t.value AS DEcimal) BETWEEN  CAST(HDG.MinimumValue as Decimal)  AND  CAST(HDG.MaximumValue as decimal))
AND (CAST(isnull(t.value,0) As Decimal) BETWEEN CAST(HDG.MinimumValue AS Decimal) AND Cast(HDG.MaximumValue As decimal))  

    
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
       SELECT  @PreviousVitals = @PreviousVitals + ' ' + attributename + ': ' + 
       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
       ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'     
       END, '')   + '<br>'       
       FROM    #tempvitals t 
       LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
       WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=111        
       ORDER BY attributename 
                    
 --Weight                              
    SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'     
    END, '')  + '<br>'        
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
    WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=110        
    ORDER BY attributename 
 
	 --BMI     
     SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + 'BMI' + ': ' + 
     ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
     ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'           
     END, '' )   + '<br>'      
     FROM    #tempvitals t 
     LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
     WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=112
     ORDER BY attributename 
            
	--Systolic
	SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' +  attributename + ': ' + 
	ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
	ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'          
	END, '')  + '<br>'         
	FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116        
	ORDER BY attributename 
	
	-- If(@ClientAge <18)
 --    Begin
		 
 --        SELECT  @PreviousVitals = @PreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 89  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 90   and Cast(value AS decimal(18,6))<= 101  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 102 and Cast(value AS decimal(18,6))<= 129 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 130 and Cast(value AS decimal(18,6))<= 140  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 141  and Cast(value AS decimal(18,6))<= 160 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116        
	--ORDER BY attributename 
	--end
 --   else
 --   begin
 --   SELECT  @PreviousVitals = @PreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 89  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 90   and Cast(value AS decimal(18,6))<= 101  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 102 and Cast(value AS decimal(18,6))<= 129 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 130 and Cast(value AS decimal(18,6))<= 170  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 171 and Cast(value AS decimal(18,6))<= 200  then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116         
	--ORDER BY attributename
    
 --   end
            
        --BP Position
       IF  NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=116)
        BEGIN  
        SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value        
		 																  END, '')   + '<br>'      
			FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=130        
			ORDER BY attributename 
        END
        ELSE
        BEGIN
			SELECT  @PreviousVitals = @PreviousVitals + ''+ attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value        
		 																  END, '')   + '<br>'      
			FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=130        
			ORDER BY attributename 
        END
    
	       	--Diastolic	
         SELECT  @PreviousVitals = @PreviousVitals + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')  + '<br>'       
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
      WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113      
            ORDER BY attributename 
 -- If(@ClientAge <18)
 --    Begin
		 
 --        SELECT  @PreviousVitals = @PreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 79 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 80 and Cast(value AS decimal(18,6))<= 90  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 91 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113     
	--ORDER BY attributename 
	--end
 --   else
 --   begin
 --   SELECT  @PreviousVitals = @PreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 80 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 81 and Cast(value AS decimal(18,6))<= 100  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 101 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113       
	--ORDER BY attributename
    
 --   end
            
  ---- Pulse
		   SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')   + '<br>'      
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
    WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114         
            ORDER BY attributename     
 -- If(@ClientAge <18)
 --    Begin
		 
 --        SELECT  @PreviousVitals = @PreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 79 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 80 and Cast(value AS decimal(18,6))<= 90  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 91 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114        
	--ORDER BY attributename 
	--end
 --   else
 --   begin
 --   SELECT  @PreviousVitals = @PreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + 
 --       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)
	--		else  
	--	case when Cast(value AS decimal(18,6))<= 59  then  '<span style="color:Salmon">'+t.value+'</span>' 
	--	ELSE  
	--	case when Cast(value AS decimal(18,6))>= 60   and Cast(value AS decimal(18,6))<= 70  then   '<span style="color:Gold">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 71 and Cast(value AS decimal(18,6))<= 80 then   '<span style="color:Green">'+t.value+'</span>' 
	--	ELSE 
	--	case when Cast(value AS decimal(18,6))>= 81 and Cast(value AS decimal(18,6))<= 100  then   '<span style="color:Yellow">'+t.value+'</span>' 
	--	ELSE
	--	case when Cast(value AS decimal(18,6))>= 101 then  '<span style="color:Red">'+t.value+'</span>' 
	--	 		 	end end		end	end	 end end	 
	--	,'<span style="color:Black">'+t.value+'</span>') + '<br>'     
	--FROM    #tempvitals t
	--LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	--WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114        
	--ORDER BY attributename
    
 --   end
            
         --Position 
       IF NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=114)
        BEGIN  
        SELECT  @PreviousVitals = @PreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')   + '<br>'       
            FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=133        
            ORDER BY attributename 
        END  
      ELSE   
       BEGIN
       SELECT  @PreviousVitals = @PreviousVitals +''+ attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')    + '<br>'      
            FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=133        
            ORDER BY attributename 
       
       END   
          --Respiratory     
        		   
       SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
       ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'  
       END, '') + '<br>'         
       FROM  #tempvitals t 
       LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
       WHERE  t.healthdatasubtemplateid=114 and t.healthdataattributeid=115        
       ORDER BY attributename 
   
      --Temperature
        SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
        ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
        ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'  
        END, '')  + '<br>'        
        FROM    #tempvitals t 
        LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  t.healthdatasubtemplateid=112 and t.healthdataattributeid=120        
        ORDER BY attributename 
         --Temperature  
      
  --      SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(
		--CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)  
		----  ELSE value              
		--ELSE 
		--case when Cast(value AS decimal(18,6))<= 95.4  then '<span style="color:Salmon">'+value+'</span>' 
		--ELSE  
		--case when Cast(value AS decimal(18,6))>= 95.5   and Cast(value AS decimal(18,6))<= 97.3  then '<span style="color:Gold">'+value+'</span>' 
		--ELSE 
		--case when Cast(value AS decimal(18,6))>= 97.4 and Cast(value AS decimal(18,6))<= 99.6  then '<span style="color:Green">'+value+'</span>' 
		--ELSE 
		--case when Cast(value AS decimal(18,6))>= 99.7 and Cast(value AS decimal(18,6))<= 101.4  then '<span style="color:Yellow">'+value+'</span>' 
		--ELSE  
		--case when Cast(value AS decimal(18,6))>= 101.5  then '<span style="color:Red">'+value+'</span>' 
		--ELSE value
		--end		end		end		end		END     		END, '')   + '<br>'        
  --      FROM    #tempvitals t 
  --      LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
  --      WHERE  t.healthdatasubtemplateid=112 and t.healthdataattributeid=120        
  --      ORDER BY attributename  
        
      --Temperature Location
      
           SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
           ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')  + '<br>'        
        FROM    #tempvitals WHERE  healthdatasubtemplateid=112 and healthdataattributeid=119        
        ORDER BY attributename 
      
            
     --Pain Level
     
        SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')    + '<br>'      
        FROM    #tempvitals WHERE  healthdatasubtemplateid=115 and healthdataattributeid=118        
        ORDER BY attributename 
                
            
      --Pain Location
      
         SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')   + '<br>'       
        FROM    #tempvitals WHERE  healthdatasubtemplateid=115 and healthdataattributeid=124        
        ORDER BY attributename 
      

          
       --Smoking Status     
            SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' +attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')   + '<br>'        
            FROM    #tempvitals WHERE  healthdatasubtemplateid=117 and healthdataattributeid=123        
            ORDER BY attributename  
            --set @PreviousVitals=@PreviousVitals+ +CHAR(13);
            
        --Medication list reconciled on this date     
            SELECT  @PreviousVitals = @PreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')    + '<br>'       
            FROM    #tempvitals WHERE  healthdatasubtemplateid=118 and healthdataattributeid=125        
            ORDER BY attributename   
  
   SET @SecondLatestHealthRecordFormated = (  
     SELECT CONVERT(VARCHAR, @SecondLatestHealthRecord, 101)  
     )  
  END  
  
 
  IF NOT (  
  
    NULLIF(@PreviousVitals, '') IS NULL  
    )  
  BEGIN  
   SET @PreviousVitalsWithDate = @PreviousVitals  
  END  
  ELSE  
  BEGIN  
   SET @PreviousVitalsWithDate = ''  
  END  
  
  
  -------------------------------------
  ----2 nd Previous Viatls
  ---------------------------------------
  DECLARE @ThirdLatestHealthRecord AS DATETIME  
  DECLARE @ThirdPreviousVitalsWithDate VARCHAR(max)  
  
 --DECLARE @ClientID INT=4
 
  SET @ThirdPreviousVitalsWithDate = ''  
  
  DECLARE @ThirdLatestHealthRecordFormated VARCHAR(max)  
  
  SET @ThirdLatestHealthRecordFormated = ''  
  
  DECLARE @ThirdPreviousVitals VARCHAR(max)  
  
  SET @ThirdPreviousVitals = ''  

  
  IF (@CountofPrevious > 2)  
  BEGIN  
   SET @ThirdLatestHealthRecord = (  
     SELECT DISTINCT healthrecorddate  
     FROM clienthealthdataattributes  
     WHERE clientid = @ClientID  
      AND healthrecorddate = (  
       SELECT Min(healthrecorddate)  
       FROM (  
        SELECT DISTINCT TOP (3) healthrecorddate  
        FROM clienthealthdataattributes  
        WHERE clientid = @ClientID AND ISNULL(RecordDeleted,'N')='N'
        ORDER BY healthrecorddate DESC  
        ) T  
       )  
     )  
  
   DELETE  
   FROM #tempvitals  
  
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
    AND chd.healthrecorddate = @ThirdLatestHealthRecord  
    AND Isnull(st.recorddeleted, 'N') <> 'Y'  
    AND Isnull(s.recorddeleted, 'N') <> 'Y'  
    AND Isnull(a.recorddeleted, 'N') <> 'Y'  
    AND Isnull(chd.recorddeleted, 'N') <> 'Y'  
    
    DELETE  
    FROM #tempvitalsWithGraphAttributes  
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
	HA.Name  
	from HealthDataAttributes HA
	LEFT JOIN HealthDataGraphCriteria HDG ON HDG.HealthDataAttributeId= HA.HealthDataAttributeId
	LEFT JOIN HealthDataGraphCriteriaRanges HDGR ON  HDGR.HealthDataGraphCriteriaId = HDG.HealthDataGraphCriteriaId
	LEFT JOIN #tempvitals t ON t.healthdataattributeid=HA.HealthDataAttributeId
	LEFT JOIN GlobalCodes g ON g.GlobalCodeId=HDGR.Level
    WHERE (@AGE BETWEEN HDG.AgeFrom  AND HDG.AgeTo  OR HDG.AllAge = 'Y') 
         AND (t.value BETWEEN HDGR.MinimumValue  AND HDGR.MaximumValue) AND 
         Isnull(HDG.recorddeleted, 'N') <> 'Y'  
         AND Isnull(HDGR.recorddeleted, 'N') <> 'Y'  
         AND Isnull(g.recorddeleted, 'N') <> 'Y'       
		 AND HDGR.MinimumValue >= 0  
		 AND HDGR.MaximumValue > 0 
    DELETE FROM #tempvitalsWithGraphAttributesWithPriority
    DELETE FROM #tempvitalsColors
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
--AND (CAST(t.value AS DEcimal) BETWEEN  CAST(HDG.MinimumValue as Decimal)  AND  CAST(HDG.MaximumValue as decimal))
AND (CAST(isnull(t.value,0) As Decimal) BETWEEN CAST(HDG.MinimumValue AS Decimal) AND Cast(HDG.MaximumValue As decimal))  

    
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
       SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals + ' ' + attributename + ': ' + 
       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
       ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'     
       END, '')   + '<br>'       
       FROM    #tempvitals t 
       LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
       WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=111        
       ORDER BY attributename 
                    
 --Weight                              
    SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'     
    END, '')  + '<br>'        
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
    WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=110        
    ORDER BY attributename 
 
	 --BMI     
     SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + 'BMI' + ': ' + 
     ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
     ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'           
     END, '' )   + '<br>'      
     FROM    #tempvitals t 
     LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
     WHERE  t.healthdatasubtemplateid=111 and t.healthdataattributeid=112
     ORDER BY attributename 
 
		--Systolic
	SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' +  attributename + ': ' + 
	ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
	ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'          
	END, '')  + '<br>'         
	FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
	WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=116        
	ORDER BY attributename 

            
        --BP Position
       IF  NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=116)
        BEGIN  
        SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value        
		 																  END, '')   + '<br>'      
			FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=130        
			ORDER BY attributename 
        END
        ELSE
        BEGIN
			SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals + ''+ attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
																						   ELSE value        
		 																  END, '')   + '<br>'      
			FROM    #tempvitals WHERE  healthdatasubtemplateid=110 and healthdataattributeid=130        
			ORDER BY attributename 
        END
    
	       	--Diastolic	
         SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')  + '<br>'       
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
      WHERE  t.healthdatasubtemplateid=110 and t.healthdataattributeid=113      
            ORDER BY attributename 

            
  ---- Pulse
		   SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
    ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
    ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>' 
    END, '')   + '<br>'      
    FROM    #tempvitals t 
    LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
    WHERE  t.healthdatasubtemplateid=113 and t.healthdataattributeid=114         
            ORDER BY attributename     

            
         --Position 
       IF NOT EXISTS( SELECT 1 FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=114)
        BEGIN  
        SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals + CHAR(13)+ ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')   + '<br>'       
            FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=133        
            ORDER BY attributename 
        END  
      ELSE   
       BEGIN
       SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +''+ attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')    + '<br>'      
            FROM    #tempvitals WHERE  healthdatasubtemplateid=113 and healthdataattributeid=133        
            ORDER BY attributename 
       
       END   
          --Respiratory     
        		   
       SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
       ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
       ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'  
       END, '') + '<br>'         
       FROM  #tempvitals t 
       LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
       WHERE  t.healthdatasubtemplateid=114 and t.healthdataattributeid=115        
       ORDER BY attributename 
   
      --Temperature
        SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
        ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
        ELSE '<span style="color:'+IsNull(ta.Color,'Black')+'">'+t.value+'</span>'  
        END, '')  + '<br>'        
        FROM    #tempvitals t 
        LEFT JOIN #tempvitalsColors ta On t.healthdataattributeid=ta.healthdataattributeid
        WHERE  t.healthdatasubtemplateid=112 and t.healthdataattributeid=120        
        ORDER BY attributename 

      

      --Temperature Location
      
           SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + 
           ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')  + '<br>'        
        FROM    #tempvitals WHERE  healthdatasubtemplateid=112 and healthdataattributeid=119        
        ORDER BY attributename 
      
            
     --Pain Level
     
        SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')    + '<br>'      
        FROM    #tempvitals WHERE  healthdatasubtemplateid=115 and healthdataattributeid=118        
        ORDER BY attributename 
                
            
      --Pain Location
      
         SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')   + '<br>'       
        FROM    #tempvitals WHERE  healthdatasubtemplateid=115 and healthdataattributeid=124        
        ORDER BY attributename 
      

          
       --Smoking Status     
            SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' +attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')   + '<br>'        
            FROM    #tempvitals WHERE  healthdatasubtemplateid=117 and healthdataattributeid=123        
            ORDER BY attributename  
            --set @PreviousVitals=@PreviousVitals+ +CHAR(13);
            
        --Medication list reconciled on this date     
            SELECT  @ThirdPreviousVitals = @ThirdPreviousVitals +CHAR(13) + ' ' + attributename + ': ' + ISNULL(CASE WHEN datatype = 8081 THEN dbo.Getglobalcodename(value)        
                                                                                               ELSE value        
                                                                                          END, '')    + '<br>'       
            FROM    #tempvitals WHERE  healthdatasubtemplateid=118 and healthdataattributeid=125        
            ORDER BY attributename   
  
   SET @ThirdLatestHealthRecordFormated = (  
     SELECT CONVERT(VARCHAR, @ThirdLatestHealthRecord, 101)  
     )  
  END  
  
 
  IF NOT (  
  
    NULLIF(@ThirdPreviousVitals, '') IS NULL  
    )  
  BEGIN  
   SET @ThirdPreviousVitalsWithDate = @ThirdPreviousVitals  
  END  
  ELSE  
  BEGIN  
   SET @ThirdPreviousVitalsWithDate = ''  
  END  
  ----------------
  ---------------
  
  DROP TABLE #tempvitals
  SELECT 'CustomDocumentPsychiatricNoteExams' AS TableName	
            ,@Currentvitals AS VitalsCurrent	
			,@PreviousVitalsWithDate AS VitalsPrevious    
			,@ThirdPreviousVitalsWithDate AS ThirdPreviousVitals	 			
			,@CurrentLatestHealthRecordFormated AS CurreentVitalDate
			,@SecondLatestHealthRecordFormated AS PreviousVitalDate
			,@ThirdLatestHealthRecordFormated AS ThirdPreviousVitalDate
			 
			
		FROM systemconfigurations s
  END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetColorVitals') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                            
    16    
    ,-- Severity.                                                                                                            
    1 -- State.                                                                                                            
    );    
 END CATCH    
END 