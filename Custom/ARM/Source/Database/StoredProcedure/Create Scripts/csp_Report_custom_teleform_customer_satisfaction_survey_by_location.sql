/****** Object:  StoredProcedure [dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_by_location]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_by_location]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_by_location]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_by_location]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_by_location]
	-- Add the parameters for the stored procedure here
			@location	varchar(16),
			@beg_date	DATETIME,
			@end_date	DATETIME	
AS
--*/
-- =============================================
-- Author:		<Michael Rowley>
-- Copyright:	Harbor Behavioral Healthcare
-- Description:	SP to generate Customer Satisfaction Survey by Location Report.
-- Updates:
--   Date			Author      Purpose
--   12/19/2012		MSR         Created
-- =============================================
/*
DECLARE
			@location	varchar(16),
			@beg_date	DATETIME,
			@end_date	DATETIME							
								
SELECT
			@location = ''ALL'',
			@beg_date = ''2012-11-01'',
			@end_date = ''2012-12-21''
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @Row_Question TABLE
(
	RowNo		Int,
	Row			Varchar(50),
	Question	Varchar(200)
)	

DECLARE @TempLocation TABLE
(
	Location	Varchar(15)
)		

IF @location = ''ALL'' BEGIN
INSERT INTO @TempLocation
VALUES (''Secor''), (''Twenty_Second''), (''Monroe''), (''Defiance''), (''Central''), (''School_Based''), (''Quest''), (''CSH'')
END
IF @location <> ''ALL'' BEGIN
INSERT INTO @TempLocation
VALUES (@location)
END			

IF OBJECT_ID(''tempdb..#temp'') IS NOT NULL BEGIN DROP TABLE #temp END;
IF OBJECT_ID(''tempdb..#temp_l'') IS NOT NULL BEGIN DROP TABLE #temp_l END;
IF OBJECT_ID(''tempdb..#temp2'') IS NOT NULL BEGIN DROP TABLE #temp2 END;
IF OBJECT_ID(''tempdb..#temp2_l'') IS NOT NULL BEGIN DROP TABLE #temp2_l END;
IF OBJECT_ID(''tempdb..#temp3'') IS NOT NULL BEGIN DROP TABLE #temp3 END;
IF OBJECT_ID(''tempdb..#jcaho'') IS NOT NULL BEGIN DROP TABLE #jcaho END;

create table #temp(location Varchar(15),
			total2 int,
			total int,
			ans       varchar(300),
			ans_order int,
			a  	int,
			b	int,
			c	int,
			d	int,
			e	int);
			
create table #temp_l (	location varchar(20),
			total2 int,
			total int,
			ans       varchar(300),			
			ans_order int,
			a 	int,
			b	int,
			c  	int,
			d	int,
			e	int,
			f	int,
			g	int);	

create table #temp2 (		a float,
				b float,
				c float,
				d float,
				e float,
				ans	varchar(300),				
				ans_order int,
				total2 int,
				total int,
				location varchar(20),
				average float);	
				
create table #temp2_l (a float,
				b float,
				c float,
				d float,
				e float,
				f float,
				g float,	
				ans	varchar(300),
				ans_order int,				
				total2 int,
				total int,
				location varchar(20))				
				
create table #temp3 (		a float,
				b float,
				c float,
				d float,
				e float,
				ans	varchar(300),				
				ans_order int,
				total2 int,
				total int,
				location varchar(20),
				average float,
				jcaho float);								

with dnorm as (
    select BatchNo, Services_helped, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)

INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Services_helped is not null then 1 else 0 end) as total2,
       ''The Service I have had so far have helped my problem or situation'',
        1,
       sum(case when dnorm.Services_helped = ''SA'' then 1 else 0 end),
       sum(case when dnorm.Services_helped = ''A'' then 1 else 0 end),
       sum(case when dnorm.Services_helped = ''N'' then 1 else 0 end),
       sum(case when dnorm.Services_helped = ''D'' then 1 else 0 end),
       sum(case when dnorm.Services_helped = ''SD'' then 1 else 0 end)
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Given_chances, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Given_chances is not null then 1 else 0 end) as total2,
       ''I am given chances to make decisions about my services'', 
       2,
       sum(case when dnorm.Given_chances = ''SA'' then 1 else 0 end),
       sum(case when dnorm.Given_chances = ''A'' then 1 else 0 end),
       sum(case when dnorm.Given_chances = ''N'' then 1 else 0 end),
       sum(case when dnorm.Given_chances = ''D'' then 1 else 0 end),
       sum(case when dnorm.Given_chances = ''SD'' then 1 else 0 end)
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location; 

with dnorm as (
    select BatchNo, Needs_addressed, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)

INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Needs_addressed is not null then 1 else 0 end) as total2,
       ''My needs have been or are being addressed'',
        3,
       sum(case when dnorm.Needs_addressed = ''SA'' then 1 else 0 end),
       sum(case when dnorm.Needs_addressed = ''A'' then 1 else 0 end),
       sum(case when dnorm.Needs_addressed = ''N'' then 1 else 0 end),
       sum(case when dnorm.Needs_addressed = ''D'' then 1 else 0 end),
       sum(case when dnorm.Needs_addressed = ''SD'' then 1 else 0 end)
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Protect_privacy, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp
select dnorm.location, count(*) as total,
       sum(case when dnorm.Protect_privacy is not null then 1 else 0 end) as total2,
	''Harbor treats me fairly, with respect and courtesy'',
	4,
       sum(case when dnorm.Protect_privacy = ''SA'' then 1 else 0 end),
       sum(case when dnorm.Protect_privacy = ''A'' then 1 else 0 end),
       sum(case when dnorm.Protect_privacy = ''N'' then 1 else 0 end),
       sum(case when dnorm.Protect_privacy = ''D'' then 1 else 0 end),
       sum(case when dnorm.Protect_privacy = ''SD'' then 1 else 0 end) 
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location ; 

with dnorm as (
    select BatchNo, Overall_satis, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)

INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Overall_satis is not null then 1 else 0 end) as total2,
       ''Overall, I am satisfied with Harbor'',
        5,
       sum(case when dnorm.Overall_satis = ''SA'' then 1 else 0 end) as SA,
       sum(case when dnorm.Overall_satis = ''A'' then 1 else 0 end) as SA,
       sum(case when dnorm.Overall_satis = ''N'' then 1 else 0 end) as SA,
       sum(case when dnorm.Overall_satis = ''D'' then 1 else 0 end) as SA,
       sum(case when dnorm.Overall_satis = ''SD'' then 1 else 0 end) as SA
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Choose_harbor, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Choose_harbor is not null then 1 else 0 end) as total2,
       ''I am likely to continue to choose Harbor'', 
       6,
       sum(case when dnorm.Choose_harbor = ''SA'' then 1 else 0 end) as SA,
       sum(case when dnorm.Choose_harbor = ''A'' then 1 else 0 end) as SA,
       sum(case when dnorm.Choose_harbor = ''N'' then 1 else 0 end) as SA,
       sum(case when dnorm.Choose_harbor = ''D'' then 1 else 0 end) as SA,
       sum(case when dnorm.Choose_harbor = ''SD'' then 1 else 0 end) as SA
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location; 

with dnorm as (
    select BatchNo, Recommend_harbor, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)

INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Recommend_harbor is not null then 1 else 0 end) as total2,
       ''I would recommend Harbor to a friend or family member'',
        7,
       sum(case when dnorm.Recommend_harbor = ''SA'' then 1 else 0 end) as SA,
       sum(case when dnorm.Recommend_harbor = ''A'' then 1 else 0 end) as SA,
       sum(case when dnorm.Recommend_harbor = ''N'' then 1 else 0 end) as SA,
       sum(case when dnorm.Recommend_harbor = ''D'' then 1 else 0 end) as SA,
       sum(case when dnorm.Recommend_harbor = ''SD'' then 1 else 0 end) as SA
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Treats_fairly, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Treats_fairly is not null then 1 else 0 end) as total2,
       ''Harbor treats me fairly, with respect and courtesy'', 
       8,
       sum(case when dnorm.Treats_fairly = ''SA'' then 1 else 0 end) as SA,
       sum(case when dnorm.Treats_fairly = ''A'' then 1 else 0 end) as SA,
       sum(case when dnorm.Treats_fairly = ''N'' then 1 else 0 end) as SA,
       sum(case when dnorm.Treats_fairly = ''D'' then 1 else 0 end) as SA,
       sum(case when dnorm.Treats_fairly = ''SD'' then 1 else 0 end) as SA
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location ; 

with dnorm as (
    select BatchNo, First_choice, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.First_choice is not null then 1 else 0 end) as total2,
       ''Of all the service providers I know of, Harbor is my first choice'', 
       9,
       sum(case when dnorm.First_choice = ''SA'' then 1 else 0 end) as SA,
       sum(case when dnorm.First_choice = ''A'' then 1 else 0 end) as SA,
       sum(case when dnorm.First_choice = ''N'' then 1 else 0 end) as SA,
       sum(case when dnorm.First_choice = ''D'' then 1 else 0 end) as SA,
       sum(case when dnorm.First_choice = ''SD'' then 1 else 0 end) as SA
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location ; 

with dnorm as (
    select BatchNo, Comfortable_safe, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)

INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Comfortable_safe is not null then 1 else 0 end) as total2,
       ''The location where I receive services is comforable and safe'',
        10,
       sum(case when dnorm.Comfortable_safe = ''SA'' then 1 else 0 end),
       sum(case when dnorm.Comfortable_safe = ''A'' then 1 else 0 end),
       sum(case when dnorm.Comfortable_safe = ''N'' then 1 else 0 end),
       sum(case when dnorm.Comfortable_safe = ''D'' then 1 else 0 end),
       sum(case when dnorm.Comfortable_safe = ''SD'' then 1 else 0 end)
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Neat_clean, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Neat_clean is not null then 1 else 0 end) as total2,
       ''The Location where I receive services is neat and clean'', 
       11,
       sum(case when dnorm.Neat_clean = ''SA'' then 1 else 0 end) as SA,
       sum(case when dnorm.Neat_clean = ''A'' then 1 else 0 end) as SA,
       sum(case when dnorm.Neat_clean = ''N'' then 1 else 0 end) as SA,
       sum(case when dnorm.Neat_clean = ''D'' then 1 else 0 end) as SA,
       sum(case when dnorm.Neat_clean = ''SD'' then 1 else 0 end) as SA
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location; 

with dnorm as (
    select BatchNo, Respects_time, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)

INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Respects_time is not null then 1 else 0 end) as total2,
       ''Harbor respects my time, does not keep me waiting, and responds to any concerns or questions in a reasonable time frame'',
        12,
       sum(case when dnorm.Respects_time = ''SA'' then 1 else 0 end),
       sum(case when dnorm.Respects_time = ''A'' then 1 else 0 end),
       sum(case when dnorm.Respects_time = ''N'' then 1 else 0 end),
       sum(case when dnorm.Respects_time = ''D'' then 1 else 0 end),
       sum(case when dnorm.Respects_time = ''SD'' then 1 else 0 end)
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Reasonable_time, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Reasonable_time is not null then 1 else 0 end) as total2,
       ''What do you think is a "reasonable" time frame for responses'', 
       14,
       sum(case when dnorm.Reasonable_time = ''48HR'' then 1 else 0 end),
       sum(case when dnorm.Reasonable_time = ''24HR'' then 1 else 0 end),
       sum(case when dnorm.Reasonable_time = ''EOD'' then 1 else 0 end),
       sum(case when dnorm.Reasonable_time = ''1HR'' then 1 else 0 end),
       0
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location ; 

with dnorm as (
    select BatchNo, Staff_listens_carefully, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)

INSERT INTO #temp 
select dnorm.location, count(*) as total,
       sum(case when dnorm.Staff_listens_carefully is not null then 1 else 0 end) as total2,
       ''Staff listens carefully to me and understands my concerns and needs'',
        13,
       sum(case when dnorm.Staff_listens_carefully = ''SA'' then 1 else 0 end) as SA,
       sum(case when dnorm.Staff_listens_carefully = ''A'' then 1 else 0 end) as SA,
       sum(case when dnorm.Staff_listens_carefully = ''N'' then 1 else 0 end) as SA,
       sum(case when dnorm.Staff_listens_carefully = ''D'' then 1 else 0 end) as SA,
       sum(case when dnorm.Staff_listens_carefully = ''SD'' then 1 else 0 end) as SA
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Age, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp_l 
select dnorm.location, count(batchno) as total,
       sum(case when dnorm.Age is not null then 1 else 0 end) as total2,
       ''Age'',       
        20,
	count(case when  dnorm.Age<=5 then 1 end),  
	count(case when  dnorm.Age<=17 and dnorm.Age>5 then 1 end) ,
	count(case when  dnorm.Age<=25 and dnorm.Age>17 then 1 end) ,
	count(case when  dnorm.Age<=35 and dnorm.Age>25 then 1 end) ,
	count(case when  dnorm.Age<=45 and dnorm.Age>35 then 1 end) ,
	count(case when  dnorm.Age<=65 and dnorm.Age>45 then 1 end) ,
	count(case when dnorm.Age >65 then 1 end)
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Gender, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp_l 
select dnorm.location, count(batchno) as total,
       sum(case when dnorm.Gender is not null then 1 else 0 end) as total2,
       ''Gender'',
       22,
       count(case when gender =''F'' then 1 end),
       count(case when  gender =''M'' then 1 end),
       0,0,0,0,0 
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select Batchno, Caucasian, Asian, Native_Amer, Hispanic, Hawaiian, African_Amer, Other_Ethnic, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp_l 
select dnorm.location, count(batchno) as total,
    (count(case when dnorm.Caucasian =''Y'' then 1 end) +	count(case when dnorm.Asian =''AS'' then 1 end) +
	count(case when dnorm.Native_Amer =''NA'' then 1 end) + count(case when dnorm.Hispanic =''HI'' then 1 end) +
	count(case when dnorm.Hawaiian =''HA'' then 1 end) +	count(case when dnorm.African_Amer =''AA'' then 1 end) +
	count(case when dnorm.Other_Ethnic =''OT'' then 1 end)),
	''Ethnic Background / Race'',
        21,
	count(case when dnorm.Caucasian =''Y'' then 1 end) ,
	count(case when dnorm.Asian =''AS'' then 1 end) ,
	count(case when dnorm.Native_Amer =''NA'' then 1 end) ,
	count(case when dnorm.Hispanic =''HI'' then 1 end),
	count(case when dnorm.Hawaiian =''HA'' then 1 end),
	count(case when dnorm.African_Amer =''AA'' then 1 end),
	count(case when dnorm.Other_Ethnic =''OT'' then 1 end)
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

with dnorm as (
    select BatchNo, Education, date_completed, Location
    from custom_teleform_customer_satisfaction_survey
    unpivot (val for location in (Secor, Twenty_Second, Monroe, Defiance, Central, School_Based, Quest, CSH)) as unpvt
)
INSERT INTO #temp_l 
select dnorm.location, count(batchno) as total,
       sum(case when dnorm.Education is not null then 1 else 0 end) as total2,
	''Highest level of education completed'',
        23,
	count(case when  education =''EG'' then 1 end),   
	count(case when education=''SH''then 1 end),	
	count(case when education=''HG'' then 1 end),
	count(case when education=''SC'' then 1 end) ,     
	count(case when  education =''FY'' then 1 end) ,
	count(case when  education =''GD'' then 1 end) ,
	0  
from dnorm 
where 	dnorm.date_completed>= @beg_date
and 	dnorm.date_completed < dateadd(day,1,@end_date)
and 	dnorm.location IN (SELECT l.Location FROM @TempLocation l)
GROUP BY dnorm.location;

insert into #temp2	
select 
	CASE WHEN total <>0 THEN round(convert(float,a)/total*100,0) ELSE 0 end as a,
	CASE WHEN total <>0 THEN round(convert(float,b)/total*100,0) ELSE 0 end as b,
	CASE WHEN total <>0 THEN round(convert(float,c)/total*100,0) ELSE 0 end as c,
	CASE WHEN total <>0 THEN round(convert(float,d)/total*100,0) ELSE 0 end as d,
	CASE WHEN total <>0 THEN round(convert(float,e)/total*100,0) ELSE 0 end as e,
	ans,
	ans_order,	
	total2,
	total,
	location,
	case when total <> 0
	then(convert(float,e)+convert(float,d)*2+convert(float,c)*3+convert(float,b)*4+convert(float,a)*5)/total
	else 0
	end as final
from #temp  t

insert into #temp2_l -- (a, b, c,d, e, f, g, ans_order, ans, total2, total, location)	
select 
	CASE WHEN total <>0 THEN round(convert(float,a)/total*100,0) ELSE 0 end as a,
	CASE WHEN total <>0 THEN round(convert(float,b)/total*100,0) ELSE 0 end as b,
	CASE WHEN total <>0 THEN round(convert(float,c)/total*100,0) ELSE 0 end as c,
	CASE WHEN total <>0 THEN round(convert(float,d)/total*100,0) ELSE 0 end as d,
	CASE WHEN total <>0 THEN round(convert(float,e)/total*100,0) ELSE 0 end as e,
	CASE WHEN total <>0 THEN round(convert(float,f)/total*100,0) ELSE 0 end as f,
	CASE WHEN total <>0 THEN round(convert(float,g)/total*100,0) ELSE 0 end as g,
	ans,
	ans_order,	
	total2,
	total,
	location
from #temp_l t

create table #jcaho ( 	location varchar(15),
			jcaho float)

insert into #jcaho
select location,sum(average)/13
from #temp2
where ans_order in (1,2,3,4,5,6,7,8,9,10,11,12,14)
group by location

insert into #temp3
select t2.*, j.jcaho
from #temp2 t2
join  #jcaho j
on t2.location=j.location

select  ''part1'' as report_half,
	a,
	b,
	c,
	d,
	e,
	0 as f,
	0 as g,
	total2,
	total,
	ANS_ORDER,
	ans,
	location,
	average,
	 jcaho,
	--@db_name as dbName,
	--convert(varchar(10), @beg_date, 101) as bdate,
	--convert(varchar(10), @end_date, 101) as edate,
	case when ans_order = 13
		then 0
		else average end as real_avg
from #temp3

union all 
select  ''part2'' as report_half,
	a,
	b,
	c,
	d,
	e,
	 f,
	 g,
	total2,
	total,
	ANS_ORDER,
	ans,
	location,
	0 as average,
	0 as jcaho,
	--@db_name as dbName,
	--convert(varchar(10), @bdate, 101) as bdate,
	--convert(varchar(10), @edate, 101) as edate,
	0 as real_avg
from #temp2_l
ORDER BY location, ans_order 


DROP TABLE #temp 
DROP TABLE #temp_l  
DROP TABLE #temp2
DROP TABLE #temp2_l
DROP TABLE #temp3
DROP TABLE #jcaho 
END

' 
END
GO
