/****** Object:  UserDefinedFunction [dbo].[csfGetHoursCalculation]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csfGetHoursCalculation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csfGetHoursCalculation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csfGetHoursCalculation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create FUNCTION [dbo].[csfGetHoursCalculation] (@StartDate DATETIME,
@EndDate DATETIME,
@ProductivityTarget INT,
@OffsetId1 INT,
@OffsetId2 INT,
@OffsetId3 INT,
@AdditionalOffset DECIMAL(10,2),
@MultiplierOffsetId INT,
@PercentageWorked INT,
@ProductivityTargetFrection DECIMAL(10,2),
@Offset1 DECIMAL(10,2),
@Offset2 DECIMAL(10,2),
@Offset3 DECIMAL(10,2),
@FlagType Char(1))  

RETURNS VARCHAR(1000)

/*********************************************************************************/          
/* FUNCTION: csfGetHoursCalculation					 */ 
/* Copyright: Streamline Healthcare Solutions									 */          
/* Creation Date:  13-Feb-2012													 */          
/* Purpose: Used by ProductivityTargetDates Table Get HourOrFraction			 */         
/* Input Parameters:															 */        
/* Output Parameters:@StartDate,@EndDate,@TargetOffset							 */
/* Return:																	     */          
/* Called By: 																	 */          
/* Calls:																		 */          
/* Data Modifications:															 */          
/* Updates:																		 */          
/* Date					 Author                  Purpose						 */          
/* 15-March-2012         Vikas Kashyap			 Created						 */          
/* 28-March-2012         Jagdeep Hundal 		 Modify to maanage date range    */     
-- 17- May -2012         Jagdeep Hundal          set default value of @MultiplierOffsetIdValue        
/*********************************************************************************/  

AS  
BEGIN
DECLARE @ProductivityTargetValue DECIMAL(10, 2)=0.0;
DECLARE @OffsetId1Value DECIMAL(10,2)=0.0;
DECLARE @OffsetId2Value DECIMAL(10,2)=0.0;
DECLARE @OffsetId3Value DECIMAL(10,2)=0.0;
DECLARE @MultiplierOffsetIdValue DECIMAL(10,2)=0.0;
--DECLARE @HourCalculate DECIMAL(10,1)=0.0;
DECLARE @HourCalculate Varchar(max)=''0.0'';
DECLARE @ResultSet varchar(1000);
IF @EndDate IS NULL
BEGIN
SET @EndDate=GETDATE();
END
   
DECLARE @ProductivityTargetName varchar(100);
DECLARE @Offset1Name varchar(100);
DECLARE @Offset2Name varchar(100);
DECLARE @Offset3Name varchar(100);
DECLARE @Offset4Name varchar(100);

Declare @currentDate date=getdate();
Declare @effDate DATETIME;
declare @indexOfDot int
IF @EndDate<=@currentDate
BEGIN
SET @effDate=@EndDate;
END
ELSE IF @EndDate>=@currentDate
BEGIN
SET @effDate=@currentDate;
END

Select @ProductivityTargetValue=PTD.HourOrFraction,@ProductivityTargetName=PT.TargetName  FROM 
ProductivityTargetDates AS PTD
inner JOIN ProductivityTargets PT ON PT.ProductivityTargetId=PTD.ProductivityTargetId AND ISNULL(PTD.RecordDeleted, ''N'') = ''N''
WHERE ISNULL(PT.RecordDeleted, ''N'') = ''N'' 
AND (@StartDate>=PTD.StartDate or isnull(@StartDate,'''') = '''')
AND (@StartDate<=isnull(PTD.EndDate,getdate()) or isnull(@StartDate,'''') = '''')
AND (@effDate>=PTD.StartDate or isnull(@effDate,'''') = '''')
AND (@effDate<=isnull(PTD.EndDate,getdate()) or isnull(@effDate,'''') = '''')
AND PT.ProductivityTargetId=@ProductivityTarget

Select @OffsetId1Value=PTD.HourOrFraction,@Offset1Name=PT.TargetName  FROM 
ProductivityTargetDates AS PTD
inner JOIN ProductivityTargets PT ON PT.ProductivityTargetId=PTD.ProductivityTargetId AND ISNULL(PTD.RecordDeleted, ''N'') = ''N''
WHERE ISNULL(PT.RecordDeleted, ''N'') = ''N''
AND (@StartDate>=PTD.StartDate or isnull(@StartDate,'''') = '''')
AND (@StartDate<=isnull(PTD.EndDate,getdate()) or isnull(@StartDate,'''') = '''') 
AND (@effDate>=PTD.StartDate or isnull(@effDate,'''') = '''')
AND (@effDate<=isnull(PTD.EndDate,getdate())  or isnull(@effDate,'''') = '''')
AND PT.ProductivityTargetId=@OffsetId1
--
Select @OffsetId2Value=PTD.HourOrFraction,@Offset2Name=PT.TargetName  FROM 
ProductivityTargetDates AS PTD
inner JOIN ProductivityTargets PT ON PT.ProductivityTargetId=PTD.ProductivityTargetId AND ISNULL(PTD.RecordDeleted, ''N'') = ''N''
WHERE ISNULL(PT.RecordDeleted, ''N'') = ''N'' 
AND (@StartDate>=PTD.StartDate or isnull(@StartDate,'''') = '''')
AND (@StartDate<=isnull(PTD.EndDate,getdate()) or isnull(@StartDate,'''') = '''')
AND (@effDate>=PTD.StartDate or isnull(@effDate,'''') = '''')
AND (@effDate<=isnull(PTD.EndDate,getdate())  or isnull(@effDate,'''') = '''')
AND PT.ProductivityTargetId=@OffsetId2

Select @OffsetId3Value=PTD.HourOrFraction,@Offset3Name=PT.TargetName  FROM 
ProductivityTargetDates AS PTD
inner JOIN ProductivityTargets PT ON PT.ProductivityTargetId=PTD.ProductivityTargetId AND ISNULL(PTD.RecordDeleted, ''N'') = ''N''
WHERE ISNULL(PT.RecordDeleted, ''N'') = ''N'' 
AND (@StartDate>=PTD.StartDate or isnull(@StartDate,'''') = '''')
AND (@StartDate<=isnull(PTD.EndDate,getdate()) or isnull(@StartDate,'''') = '''')
AND (@effDate>=PTD.StartDate or isnull(@effDate,'''') = '''')
AND (@effDate<=isnull(PTD.EndDate,getdate())  or isnull(@effDate,'''') = '''')
AND PT.ProductivityTargetId=@OffsetId3

Select @MultiplierOffsetIdValue=PTD.HourOrFraction,@Offset4Name=PT.TargetName  FROM 
ProductivityTargetDates AS PTD
inner JOIN ProductivityTargets PT ON PT.ProductivityTargetId=PTD.ProductivityTargetId AND ISNULL(PTD.RecordDeleted, ''N'') = ''N''
WHERE ISNULL(PT.RecordDeleted, ''N'') = ''N'' 
AND (@StartDate>=PTD.StartDate or isnull(@StartDate,'''') = '''')
AND (@StartDate<=isnull(PTD.EndDate,getdate()) or isnull(@StartDate,'''') = '''')
AND (@effDate>=PTD.StartDate or isnull(@effDate,'''') = '''')
AND (@effDate<=isnull(PTD.EndDate,getdate())  or isnull(@effDate,'''') = '''')
AND PT.ProductivityTargetId=@MultiplierOffsetId
 
 if(@MultiplierOffsetId<=0)
  begin
  set  @MultiplierOffsetIdValue=1
  set  @Offset4Name='' ''
  end
  
  /*    
    SET @HourCalculate=((@ProductivityTargetValue*@ProductivityTargetFrection)+
						 (@OffsetId1Value*@Offset1)+
						 (@OffsetId2Value*@Offset2)+
						 (@OffsetId3Value*@Offset3)+
						 (@AdditionalOffset))*@MultiplierOffsetIdValue*(CONVERT(DECIMAL(18,2),@PercentageWorked)/100) 

*/

SET @HourCalculate=((convert(decimal(10,2),@ProductivityTargetValue)*convert(decimal(10,2),@ProductivityTargetFrection))+
							 (convert(decimal(10,2),@OffsetId1Value)*convert(decimal(10,2),@Offset1))+
							 (convert(decimal(10,2),@OffsetId2Value)*convert(decimal(10,2),@Offset2))+
							 (convert(decimal(10,2),@OffsetId3Value)*convert(decimal(10,2),@Offset3))+
							 (convert(decimal(10,2),@AdditionalOffset)))*convert(decimal(10,2),@MultiplierOffsetIdValue)*(convert(decimal(10,2),@PercentageWorked)/100) 
							 
select  @indexOfDot=charindex(''.'',@HourCalculate)
						 
	SET @ResultSet=COALESCE(CONVERT(VARCHAR(50),SUBSTRING(@HourCalculate,0,@indexOfDot+2)),'''') +''=''+  Convert(varchar(1000),''(''+COALESCE(CONVERT(VARCHAR(100),@ProductivityTargetName +''(''+CONVERT(VARCHAR(100),@ProductivityTargetValue)+'') x ''+CONVERT(VARCHAR(100),@ProductivityTargetFrection)),''Invalid'')+'' + ''
					   +COALESCE(CONVERT(VARCHAR(100),@Offset1Name +''(''+CONVERT(VARCHAR(100),@OffsetId1Value)+'') x ''+CONVERT(VARCHAR(100),@Offset1)),''Invalid'')+'' + ''
					   +COALESCE(CONVERT(VARCHAR(100),@Offset2Name+''(''+CONVERT(VARCHAR(100),@OffsetId2Value)+'') x ''	+CONVERT(VARCHAR(100),@Offset2)),''Invalid'')+'' + ''
					   +COALESCE(CONVERT(VARCHAR(100),@Offset3Name+''(''+CONVERT(VARCHAR(100),@OffsetId3Value)+'') x '' +CONVERT(VARCHAR(100),@Offset3)),''Invalid'')+'' + ''
					   +COALESCE(CONVERT(VARCHAR(100),@AdditionalOffset),'''')+'') x ''
					   +COALESCE(CONVERT(VARCHAR(100),@Offset4Name+''(''+CONVERT(VARCHAR,@MultiplierOffsetIdValue)),''Invalid'')+'') x ''
					   +COALESCE(CONVERT(VARCHAR(5),@PercentageWorked),'''')+''%)'')
					   --+COALESCE(CONVERT(VARCHAR(5),@PercentageWorked),'''')+''=''+COALESCE(CONVERT(VARCHAR(50),@HourCalculate),''''));
					   
	return @ResultSet;
END
' 
END
GO
