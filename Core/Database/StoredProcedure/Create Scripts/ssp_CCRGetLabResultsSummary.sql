/****** Object:  StoredProcedure [dbo].[ssp_CCRGetLabResultsSummary]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRGetLabResultsSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_CCRGetLabResultsSummary] ( @ClientId INT )
AS /******************************************************************************                                              
**  File: [ssp_CCRGetLabResultsSummary]                                          
**  Name: [ssp_CCRGetLabResultsSummary]                     
**  Desc:    
**  Return values:                                          
**  Called by:                                               
**  Parameters:                          
**  Auth:  srf
**  Date:  12/13/2011                                         
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:       Description:                            
**  
**  -------------------------------------------------------------------------            
*******************************************************************************/                                            
  
  
    BEGIN                                                            
                  
        BEGIN TRY   
 
 

--select * from healthdatacategories

--
-- Get Health Data Temp tables
--
            DECLARE @HealthDataCategories TABLE
                (
                  HealthDataCategoryId INT ,
                  CategoryName VARCHAR(100) ,
                  ItemNumber INT ,
                  ItemName VARCHAR(100) ,
                  ItemUnit VARCHAR(25) ,
                  ItemCheckBox CHAR(10) ,
                  LOINCCode VARCHAR(15) ,
                  ItemGraphLowRedMinimum DECIMAL(10, 4) ,
                  ItemGraphLowRedMaximum DECIMAL(10, 4) ,
                  ItemGraphLowYellowMinimum DECIMAL(10, 4) ,
                  ItemGraphLowYellowMaximum DECIMAL(10, 4) ,
                  ItemGraphGreenMinimum DECIMAL(10, 4) ,
                  ItemGraphGreenMaximum DECIMAL(10, 4) ,
                  ItemGraphHighYellowMinimum DECIMAL(10, 4) ,
                  ItemGraphHighYellowMaximum DECIMAL(10, 4) ,
                  ItemGraphHighRedMinimum DECIMAL(10, 4) ,
                  ItemGraphHighRedMaximum DECIMAL(10, 4)
                )

            INSERT  INTO @HealthDataCategories
                    ( HealthDataCategoryId ,
                      CategoryName ,
                      ItemNumber ,
                      ItemName ,
                      ItemUnit ,
                      ItemCheckBox ,
                      LOINCCode ,
                      ItemGraphLowRedMinimum ,
                      ItemGraphLowRedMaximum ,
                      ItemGraphLowYellowMinimum ,
                      ItemGraphLowYellowMaximum ,
                      ItemGraphGreenMinimum ,
                      ItemGraphGreenMaximum ,
                      ItemGraphHighYellowMinimum ,
                      ItemGraphHighYellowMaximum ,
                      ItemGraphHighRedMinimum ,
                      ItemGraphHighRedMaximum
                    )
                    SELECT 
--1
                            HealthDataCategoryId ,
                            CategoryName ,
                            1 AS ItemNumber ,
                            ItemName1 ,
                            ItemUnit1 ,
                            Item1CheckBox1 ,
                            LOINCCode1 ,
                            ItemGraphLowRedMinimum1 ,
                            ItemGraphLowRedMaximum1 ,
                            ItemGraphLowYellowMinimum1 ,
                            ItemGraphLowYellowMaximum1 ,
                            ItemGraphGreenMinimum1 ,
                            ItemGraphGreenMaximum1 ,
                            ItemGraphHighYellowMinimum1 ,
                            ItemGraphHighYellowMaximum1 ,
                            ItemGraphHighRedMinimum1 ,
                            ItemGraphHighRedMaximum1
                    FROM    HealthDataCategories 
--2
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            2 ,
                            ItemName2 ,
                            ItemUnit2 ,
                            ItemCheckBox2 ,
                            LOINCCode2 ,
                            ItemGraphLowRedMinimum2 ,
                            ItemGraphLowRedMaximum2 ,
                            ItemGraphLowYellowMinimum2 ,
                            ItemGraphLowYellowMaximum2 ,
                            ItemGraphGreenMinimum2 ,
                            ItemGraphGreenMaximum2 ,
                            ItemGraphHighYellowMinimum2 ,
                            ItemGraphHighYellowMaximum2 ,
                            ItemGraphHighRedMinimum2 ,
                            ItemGraphHighRedMaximum2
                    FROM    HealthDataCategories 
--3
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            3 ,
                            ItemName3 ,
                            ItemUnit3 ,
                            ItemCheckBox3 ,
                            LOINCCode3 ,
                            ItemGraphLowRedMinimum3 ,
                            ItemGraphLowRedMaximum3 ,
                            ItemGraphLowYellowMinimum3 ,
                            ItemGraphLowYellowMaximum3 ,
                            ItemGraphGreenMinimum3 ,
                            ItemGraphGreenMaximum3 ,
                            ItemGraphHighYellowMinimum3 ,
                            ItemGraphHighYellowMaximum3 ,
                            ItemGraphHighRedMinimum3 ,
                            ItemGraphHighRedMaximum3
                    FROM    HealthDataCategories 
--4
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            4 ,
                            ItemName4 ,
                            ItemUnit4 ,
                            ItemCheckBox4 ,
                            LOINCCode4 ,
                            ItemGraphLowRedMinimum4 ,
                            ItemGraphLowRedMaximum4 ,
                            ItemGraphLowYellowMinimum4 ,
                            ItemGraphLowYellowMaximum4 ,
                            ItemGraphGreenMinimum4 ,
                            ItemGraphGreenMaximum4 ,
                            ItemGraphHighYellowMinimum4 ,
                            ItemGraphHighYellowMaximum4 ,
                            ItemGraphHighRedMinimum4 ,
                            ItemGraphHighRedMaximum4
                    FROM    HealthDataCategories 
--5
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            5 ,
                            ItemName5 ,
                            ItemUnit5 ,
                            ItemCheckBox5 ,
                            LOINCCode5 ,
                            ItemGraphLowRedMinimum5 ,
                            ItemGraphLowRedMaximum5 ,
                            ItemGraphLowYellowMinimum5 ,
                            ItemGraphLowYellowMaximum5 ,
                            ItemGraphGreenMinimum5 ,
                            ItemGraphGreenMaximum5 ,
                            ItemGraphHighYellowMinimum5 ,
                            ItemGraphHighYellowMaximum5 ,
                            ItemGraphHighRedMinimum5 ,
                            ItemGraphHighRedMaximum5
                    FROM    HealthDataCategories 
--6
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            6 ,
                            ItemName6 ,
                            ItemUnit6 ,
                            ItemCheckBox6 ,
                            LOINCCode6 ,
                            ItemGraphLowRedMinimum6 ,
                            ItemGraphLowRedMaximum6 ,
                            ItemGraphLowYellowMinimum6 ,
                            ItemGraphLowYellowMaximum6 ,
                            ItemGraphGreenMinimum6 ,
                            ItemGraphGreenMaximum6 ,
                            ItemGraphHighYellowMinimum6 ,
                            ItemGraphHighYellowMaximum6 ,
                            ItemGraphHighRedMinimum6 ,
                            ItemGraphHighRedMaximum6
                    FROM    HealthDataCategories 
--7
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            7 ,
                            ItemName7 ,
                            ItemUnit7 ,
                            Item1CheckBox7 ,
                            LOINCCode7 ,
                            ItemGraphLowRedMinimum7 ,
                            ItemGraphLowRedMaximum7 ,
                            ItemGraphLowYellowMinimum7 ,
                            ItemGraphLowYellowMaximum7 ,
                            ItemGraphGreenMinimum7 ,
                            ItemGraphGreenMaximum7 ,
                            ItemGraphHighYellowMinimum7 ,
                            ItemGraphHighYellowMaximum7 ,
                            ItemGraphHighRedMinimum7 ,
                            ItemGraphHighRedMaximum7
                    FROM    HealthDataCategories 
--8
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            8 ,
                            ItemName8 ,
                            ItemUnit8 ,
                            ItemCheckBox8 ,
                            LOINCCode8 ,
                            ItemGraphLowRedMinimum8 ,
                            ItemGraphLowRedMaximum8 ,
                            ItemGraphLowYellowMinimum8 ,
                            ItemGraphLowYellowMaximum8 ,
                            ItemGraphGreenMinimum8 ,
                            ItemGraphGreenMaximum8 ,
                            ItemGraphHighYellowMinimum8 ,
                            ItemGraphHighYellowMaximum8 ,
                            ItemGraphHighRedMinimum8 ,
                            ItemGraphHighRedMaximum8
                    FROM    HealthDataCategories 
--9
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            9 ,
                            ItemName9 ,
                            ItemUnit9 ,
                            ItemCheckBox9 ,
                            LOINCCode9 ,
                            ItemGraphLowRedMinimum9 ,
                            ItemGraphLowRedMaximum9 ,
                            ItemGraphLowYellowMinimum9 ,
                            ItemGraphLowYellowMaximum9 ,
                            ItemGraphGreenMinimum9 ,
                            ItemGraphGreenMaximum9 ,
                            ItemGraphHighYellowMinimum9 ,
                            ItemGraphHighYellowMaximum9 ,
                            ItemGraphHighRedMinimum9 ,
                            ItemGraphHighRedMaximum9
                    FROM    HealthDataCategories 
--10
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            10 ,
                            ItemName10 ,
                            ItemUnit10 ,
                            ItemCheckBox10 ,
                            LOINCCode10 ,
                            ItemGraphLowRedMinimum10 ,
                            ItemGraphLowRedMaximum10 ,
                            ItemGraphLowYellowMinimum10 ,
                            ItemGraphLowYellowMaximum10 ,
                            ItemGraphGreenMinimum10 ,
                            ItemGraphGreenMaximum10 ,
                            ItemGraphHighYellowMinimum10 ,
                            ItemGraphHighYellowMaximum10 ,
                            ItemGraphHighRedMinimum10 ,
                            ItemGraphHighRedMaximum10
                    FROM    HealthDataCategories 
--11
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            11 ,
                            ItemName11 ,
                            ItemUnit11 ,
                            ItemCheckBox11 ,
                            LOINCCode11 ,
                            ItemGraphLowRedMinimum11 ,
                            ItemGraphLowRedMaximum11 ,
                            ItemGraphLowYellowMinimum11 ,
                            ItemGraphLowYellowMaximum11 ,
                            ItemGraphGreenMinimum11 ,
                            ItemGraphGreenMaximum11 ,
                            ItemGraphHighYellowMinimum11 ,
                            ItemGraphHighYellowMaximum11 ,
                            ItemGraphHighRedMinimum11 ,
                            ItemGraphHighRedMaximum11
                    FROM    HealthDataCategories
--12 
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            12 ,
                            ItemName12 ,
                            ItemUnit12 ,
                            ItemCheckBox12 ,
                            LOINCCode12 ,
                            ItemGraphLowRedMinimum12 ,
                            ItemGraphLowRedMaximum12 ,
                            ItemGraphLowYellowMinimum12 ,
                            ItemGraphLowYellowMaximum12 ,
                            ItemGraphGreenMinimum12 ,
                            ItemGraphGreenMaximum12 ,
                            ItemGraphHighYellowMinimum12 ,
                            ItemGraphHighYellowMaximum12 ,
                            ItemGraphHighRedMinimum12 ,
                            ItemGraphHighRedMaximum12
                    FROM    HealthDataCategories 
--13
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            13 ,
                            ItemName13 ,
                            ItemUnit13 ,
                            ItemCheckBox13 ,
                            LOINCCode13 ,
                            ItemGraphLowRedMinimum14 ,
                            ItemGraphLowRedMaximum14 ,
                            ItemGraphLowYellowMinimum14 ,
                            ItemGraphLowYellowMaximum14 ,
                            ItemGraphGreenMinimum14 ,
                            ItemGraphGreenMaximum14 ,
                            ItemGraphHighYellowMinimum14 ,
                            ItemGraphHighYellowMaximum14 ,
                            ItemGraphHighRedMinimum14 ,
                            ItemGraphHighRedMaximum14
                    FROM    HealthDataCategories 
--14
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            14 ,
                            ItemName14 ,
                            ItemUnit14 ,
                            ItemCheckBox14 ,
                            LOINCCode14 ,
                            ItemGraphLowRedMinimum14 ,
                            ItemGraphLowRedMaximum14 ,
                            ItemGraphLowYellowMinimum14 ,
                            ItemGraphLowYellowMaximum14 ,
                            ItemGraphGreenMinimum14 ,
                            ItemGraphGreenMaximum14 ,
                            ItemGraphHighYellowMinimum14 ,
                            ItemGraphHighYellowMaximum14 ,
                            ItemGraphHighRedMinimum14 ,
                            ItemGraphHighRedMaximum1
                    FROM    HealthDataCategories 
--15
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            15 ,
                            ItemName15 ,
                            ItemUnit15 ,
                            ItemCheckBox15 ,
                            LOINCCode15 ,
                            ItemGraphLowRedMinimum15 ,
                            ItemGraphLowRedMaximum15 ,
                            ItemGraphLowYellowMinimum15 ,
                            ItemGraphLowYellowMaximum15 ,
                            ItemGraphGreenMinimum15 ,
                            ItemGraphGreenMaximum15 ,
                            ItemGraphHighYellowMinimum15 ,
                            ItemGraphHighYellowMaximum15 ,
                            ItemGraphHighRedMinimum15 ,
                            ItemGraphHighRedMaximum15
                    FROM    HealthDataCategories 
--16
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            16 ,
                            ItemName16 ,
                            ItemUnit16 ,
                            ItemCheckBox16 ,
                            LOINCCode16 ,
                            ItemGraphLowRedMinimum16 ,
                            ItemGraphLowRedMaximum16 ,
                            ItemGraphLowYellowMinimum16 ,
                            ItemGraphLowYellowMaximum16 ,
                            ItemGraphGreenMinimum16 ,
                            ItemGraphGreenMaximum16 ,
                            ItemGraphHighYellowMinimum16 ,
                            ItemGraphHighYellowMaximum16 ,
                            ItemGraphHighRedMinimum16 ,
                            ItemGraphHighRedMaximum16
                    FROM    HealthDataCategories 
--17
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            17 ,
                            ItemName17 ,
                            ItemUnit17 ,
                            ItemCheckBox17 ,
                            LOINCCode17 ,
                            ItemGraphLowRedMinimum17 ,
                            ItemGraphLowRedMaximum17 ,
                            ItemGraphLowYellowMinimum17 ,
                            ItemGraphLowYellowMaximum17 ,
                            ItemGraphGreenMinimum17 ,
                            ItemGraphGreenMaximum17 ,
                            ItemGraphHighYellowMinimum17 ,
                            ItemGraphHighYellowMaximum17 ,
                            ItemGraphHighRedMinimum17 ,
                            ItemGraphHighRedMaximum17
                    FROM    HealthDataCategories 
--18
                    UNION
                    SELECT  HealthDataCategoryId ,
                            CategoryName ,
                            18 ,
                            ItemName18 ,
                            ItemUnit18 ,
                            ItemCheckBox18 ,
                            LOINCCode18 ,
                            ItemGraphLowRedMinimum18 ,
                            ItemGraphLowRedMaximum18 ,
                            ItemGraphLowYellowMinimum18 ,
                            ItemGraphLowYellowMaximum18 ,
                            ItemGraphGreenMinimum18 ,
                            ItemGraphGreenMaximum18 ,
                            ItemGraphHighYellowMinimum18 ,
                            ItemGraphHighYellowMaximum18 ,
                            ItemGraphHighRedMinimum18 ,
                            ItemGraphHighRedMaximum18
                    FROM    HealthDataCategories
                    ORDER BY 1 ,
                            3


            DECLARE @HealthData TABLE
                (
                  HealthDataId INT ,
                  ClientId INT ,
                  HealthDataCategoryId INT ,
                  ItemNumber INT ,
                  DateRecorded DATETIME ,
                  ItemValue DECIMAL(10, 4) ,
                  ItemChecked CHAR(1)
                )

            INSERT  INTO @HealthData
                    ( HealthDataId ,
                      ClientId ,
                      HealthDataCategoryId ,
                      ItemNumber ,
                      DateRecorded ,
                      ItemValue ,
                      ItemChecked 
                    )
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            1 ,
                            DateRecorded ,
                            ItemValue1 ,
                            ItemChecked1
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )
--2
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            2 ,
                            DateRecorded ,
                            ItemValue2 ,
                            ItemChecked2
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )
				
--3
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            3 ,
                            DateRecorded ,
                            ItemValue3 ,
                            ItemChecked3
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )
--4
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            4 ,
                            DateRecorded ,
                            ItemValue4 ,
                            ItemChecked4
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )
--5
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            5 ,
                            DateRecorded ,
                            ItemValue5 ,
                            ItemChecked5
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )	
--6
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            6 ,
                            DateRecorded ,
                            ItemValue6 ,
                            ItemChecked6
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )	
				
--7
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            7 ,
                            DateRecorded ,
                            ItemValue7 ,
                            ItemChecked7
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )	
				
--8
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            8 ,
                            DateRecorded ,
                            ItemValue8 ,
                            ItemChecked8
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )		
				
--9
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            9 ,
                            DateRecorded ,
                            ItemValue9 ,
                            ItemChecked9
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )
--10
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            10 ,
                            DateRecorded ,
                            ItemValue10 ,
                            ItemChecked10
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )	
--11
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            11 ,
                            DateRecorded ,
                            ItemValue11 ,
                            ItemChecked11
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )
--12
                    UNION
                    SELECT  HealthDataId ,
                            ClientId ,
                            HealthDataCategoryId ,
                            12 ,
                            DateRecorded ,
                            ItemValue12 ,
                            ItemChecked12
                    FROM    HealthData hd
                    WHERE   ClientId = @ClientId
                            AND ISNULL(hd.RecordDeleted, ''N'') = ''N''
                            AND NOT EXISTS ( SELECT *
                                             FROM   HealthData hd2
                                             WHERE  hd2.ClientId = hd.ClientId
                                                    AND hd2.HealthDataCategoryId = hd.HealthDataCategoryId
                                                    AND hd2.DateRecorded > hd.DateRecorded
                                                    AND ISNULL(hd2.RecordDeleted,
                                                              ''N'') = ''N'' )			
											


            SELECT  ''RS.'' + CAST(hd1.HealthDataCategoryId AS VARCHAR(100))
                    + ''.'' + CAST(hd1.ItemNumber AS VARCHAR(10)) AS CCRDataObjectID ,
                    ''RS.'' + CAST(hd1.HealthDataId AS VARCHAR(100)) + ''.''
                    + CAST(hd1.ItemNumber AS VARCHAR(10)) AS Result_Test_CCRDataObjectID ,
                    CONVERT(VARCHAR(10), hd1.DateRecorded, 21) AS ApproximateDateTime ,
                    CASE WHEN dc1.LOINCCode IS NOT NULL THEN ''Result''
                         ELSE ''VitalSigns''
                    END AS RowType ,
                    -- Result -> Type ## Need to define O_0
                    ''Chemistry'' AS TYPE ,
                    CASE WHEN dc1.LOINCCode IS NOT NULL THEN LOINCCode
                         ELSE ''Observation''
                    END AS Result_Test_Code_Value ,
                    --''Description Needed'' AS Result_Test_TestResult_Description,
                    CASE WHEN dc1.LOINCCode IS NOT NULL THEN ''LOINC''
                         ELSE ''''
                    END AS Result_Test_Code_CodingSystem ,
                    dc1.CategoryName AS Result_Description , --Result
                    dc1.ItemName AS Result_Test_Description , --Test
                    hd1.ItemValue AS Result_Test_TestResult_Value ,
                    dc1.ItemUnit AS Result_Test_TestResult_Unit ,
                    CAST(CAST(ISNULL(dc1.ItemGraphGreenMinimum, 0) AS DECIMAL(8,
                                                              2)) AS VARCHAR(100))
                    + '' - ''
                    + CAST(CAST(ISNULL(dc1.ItemGraphGreenMaximum, 0) AS DECIMAL(8,
                                                              2)) AS VARCHAR(100)) AS Result_Test_NormalResult_Value ,
                    dc1.ItemUnit AS Result_Test_NormalResult_Unit ,
                    CASE WHEN dc1.LOINCCode IS NOT NULL THEN ''Result''
                         ELSE ''Observation''
                    END AS Result_Test_Type ,
                    ''SmartcareWeb'' AS SLRCGroup_Source_ActorID ,
                    ''SmartcareWeb'' AS Result_Test_SLRCGroup_Source_ActorID ,
                    ''SmartcareWeb'' AS Result_Test_NormalResult_Source_ActorID,
                    ''Result Test ID'' AS ID1_IDType ,
                    CAST(hd1.HealthDataId AS VARCHAR(100)) + ''.''
                    + CAST(hd1.ItemNumber AS VARCHAR(10)) AS Result_Test_ID1_ActorID ,
                    ''Result'' AS Result_Test_ID1_IDType ,
                    ''SmartcareWeb'' AS ID1_SLRCGroup_Source_ActorID ,
                    ''SmartcareWeb'' AS Result_Test_ID1_Source_ActorID
            FROM    @HealthDataCategories dc1
                    JOIN @HealthData hd1 ON hd1.HealthDataCategoryId = dc1.HealthDataCategoryId
                                            AND hd1.ItemNumber = dc1.ItemNumber
            WHERE   dc1.ItemCheckbox = ''N''


              
        END TRY                                                            
                                                                                            
        BEGIN CATCH                
              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****''
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         ''[ssp_CCRGetLabResultsSummary]'') + ''*****''
                + CONVERT(VARCHAR, ERROR_LINE()) + ''*****''
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****''
                + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 ) ;                                                                                       
        END CATCH                                      
    END
' 
END
GO
