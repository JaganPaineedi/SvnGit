/****** Object:  StoredProcedure [dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_all]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_all]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_all]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_all]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE  [dbo].[csp_Report_custom_teleform_customer_satisfaction_survey_all]
			@beg_date DATETIME,
			@end_date DATETIME
AS
--*/
/*********************************************************************/
/* Stored Procedure:  csp_Report_customer_satisfaction_survey_all    */
/* Creation Date:    04/27/2004                                      */
/* Copyright:  Harbor Behavioral Healthcare							 */
/*                                                                   */
/* Updates:                                                          */
/*   Date                  Author      Purpose                       */
/*   04/27/2004          Li          Created                         */
/*   04/19/05		Brian 		Modification		                 */
/*   02/09/06		Jess	added nolock                             */
/*	 12/12/12		MSR		Updated for new Survey.				 	 */
/*								                                     */
/*********************************************************************/
/*
DECLARE
			@beg_date DATETIME,
			@end_date DATETIME
			
SELECT
			@beg_date = ''2011-01-01'',
			@end_date = CONVERT(CHAR(10), GETDATE(),110)
--*/
declare @db_name varchar(20)
select @db_name = db_name()

--declare @bdate datetime
--declare @edate datetime

--select @bdate=convert(datetime,@beg_date)
--select @edate=convert(datetime,@end_date)


--if @bdate < ''1/1/05''
--	select @bdate = ''1/1/05 00:00:00.000''

--if @edate < ''1/1/05''
--	begin
--		set @edate = ''1/2/05 00:00:00.000''
--	end
IF OBJECT_ID(''tempdb..#Temp'') IS NOT NULL BEGIN DROP TABLE #Temp END
IF OBJECT_ID(''tempdb..#Temp2'') IS NOT NULL BEGIN DROP TABLE #Temp2 END
IF OBJECT_ID(''tempdb..#jcaho'') IS NOT NULL BEGIN DROP TABLE #jcaho END

create table #temp( 	--lname varchar(30),
			--fname varchar(20),
			--super char(8),
			total2 int,
			total int,
			category varchar(10),
			category_order int,
			ans       varchar(300),
			ans_order int,
			e  	int,
			d	int,
			c	int,
			b	int,
			a	int)

create table #temp2 (	a float,
			b float,
			c float,
			d float,
			e float,
			ans_order int,
			ans	varchar(300),
			category_order int,
			category varchar(10),
			total2 int,
			total int,
			average float,
			jcaho float)
			
---- for staff
insert into #temp
select 	count(batchno),
	count( case	when t.Respects_time is not null
			then batchno
		end),
	''Service'',
	4,
	''Harbor respects my time, does not keep me waiting, and responds to any concerns or questions in a reasonable time frame.'',
	13,
	count(case when t.respects_time =''SD''
			then 1
		end) ,
	count(case when t.respects_time=''D''
			then 1
		end) ,
	count(case when t.respects_time=''N''
			then 1
		end) ,
	count(case when t.respects_time=''A''
			then 1
		end) ,
	count(case when t.respects_time=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date
 
insert into #temp
select 	count(batchno),
	count( case 	when t.reasonable_time is not null
			then batchno
		end),
	''Service'',
	4,
	''What do you think is a "reasonable" time frame for responses?'',
	14,
	0 ,
	count(case when t.reasonable_time=''48HR''
			then 1
		end) ,
	count(case when t.reasonable_time=''24HR''
			then 1
		end) ,
	count(case when t.reasonable_time=''EOD''
			then 1
		end) ,
	count(case when t.reasonable_time=''1HR''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno),
	count( case	 when t.Given_chances is not null
			then batchno
		end),
	''Quality'',
	1,
	''I am given chances to make decisions about my services:'',
	1,
	count(case when t.Given_chances = ''SD''
			then 1
		end) ,
	count(case when t.Given_chances = ''D''
			then 1
		end) ,
	count(case when t.Given_chances = ''N''
			then 1
		end) ,
	count(case when t.Given_chances = ''A''
			then 1
		end) ,
	count(case when t.Given_chances = ''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno),
	count( case	when t.needs_addressed is not null
			then  batchno
		end),
	''Quality'',
	1,
	''My needs have been or are being addressed:'',
	2,
	count(case when t.needs_addressed=''SD''
			then 1
		end) ,
	count(case when t.needs_addressed=''D''
			then 1
		end) ,
	count(case when t.needs_addressed=''N''
			then 1
		end) ,
	count(case when t.needs_addressed=''A''
			then 1
		end) ,
	count(case when t.needs_addressed=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno),
	count( case 	when t.protect_privacy is not null
			then  batchno
		end),
	''Quality'',
	1,
	''I feel as though Harbor works to protect my privacy and dignity:'',
	3,
	count(case when t.protect_privacy =''SD''
			then 1
		end) ,
	count(case when t.protect_privacy =''D''
			then 1
		end) ,
	count(case when t.protect_privacy =''N''
			then 1
		end) ,
	count(case when t.protect_privacy =''A''
			then 1
		end) ,
	count(case when t.protect_privacy =''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno),
	count( case	when t.treats_fairly is not null 
			then batchno
		end),
	''Quality'',
	1,
	''Harbor treats me fairly, with respect and courtesy.'',
	4,
	count(case when t.treats_fairly=''SD''
			then 1
		end) ,
	count(case when t.treats_fairly=''D''
			then 1
		end) ,
	count(case when t.treats_fairly=''N''
			then 1
		end) ,
	count(case when t.treats_fairly=''A''
			then 1
		end) ,
	count(case when t.treats_fairly=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno),
	count( case 	when t.staff_listens_carefully is not null 
			then batchno
		end),
	''Quality'',	
	1,
	''Staff listens carefully to me and understands my concerns and needs.'',
	5,
	count(case when t.staff_listens_carefully=''SD''
			then 1
		end) ,
	count(case when t.staff_listens_carefully=''D''
			then 1
		end) ,
	count(case when t.staff_listens_carefully=''N''
			then 1
		end) ,
	count(case when t.staff_listens_carefully=''A''
			then 1
		end) ,
	count(case when t.staff_listens_carefully=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno),
	count( case 	when t.comfortable_safe is not null
			then batchno
		end),
	''Facility'',
	2,
	''The location where I receive services is comforable and safe.'',
	6,
	count(case when t.comfortable_safe=''SD''
			then 1
		end) ,
	count(case when t.comfortable_safe=''D''
			then 1
		end) ,
	count(case when t.comfortable_safe=''N''
			then 1
		end) ,
	count(case when t.comfortable_safe=''A''
			then 1
		end) ,
	count(case when t.comfortable_safe=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date
 
insert into #temp
select 	count(batchno),
	count( case 	when t.neat_clean is not null
			then batchno
		end),
	''Facility'',
	2,
	''The Location where I receive services is neat and clean.'',
	7,
	count(case when t.neat_clean=''SD''
			then 1
		end) ,
	count(case when t.neat_clean=''D''
			then 1
		end) ,
	count(case when t.neat_clean=''N''
			then 1
		end) ,
	count(case when t.neat_clean=''A''
			then 1
		end) ,
	count(case when t.neat_clean=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno), 
	count(case when t.Services_helped is not null
			then batchno
		end ),
	''Overall'',
	3,
	''The Service I have had so far have helped my problem or situation. '',
	8,
	count(case when t.Services_helped =''SD''
			then 1
		end) ,
	count(case when t.Services_helped =''D''
			then 1
		end) ,
	count(case when t.Services_helped =''N''
			then 1
		end) ,
	count(case when t.Services_helped =''A''
			then 1
		end) ,
	count(case when t.Services_helped =''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp
select 	count(batchno),
	count( case 	when t.Choose_harbor is not null
			then batchno
		end),
	''Overall'',
	3,
	''I am likely to continue to choose Harbor.'',
	9,
	count(case when t.Choose_harbor = ''SD''
			then 1
		end) ,
	count(case when t.Choose_harbor = ''D''
			then 1
		end) ,
	count(case when t.Choose_harbor = ''N''
			then 1
		end) ,
	count(case when t.Choose_harbor = ''A''
			then 1
		end) ,
	count(case when t.Choose_harbor = ''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date
 
insert into #temp
select 	count(batchno),
	count( case 	when t.recommend_harbor is not null 
			then batchno
		end),
	''Overall'',
	3,
	''I would recommend Harbor to a friend or family member.'',
	10,
	count(case when t.recommend_harbor=''SD''
			then 1
		end) ,
	count(case when t.recommend_harbor=''D''
			then 1
		end) ,
	count(case when t.recommend_harbor=''N''
			then 1
		end) ,
	count(case when t.recommend_harbor=''A''
			then 1
		end) ,
	count(case when t.recommend_harbor=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date
 
insert into #temp
select 	count(batchno),
	count( case 	when t.first_choice is not null
			then batchno
		end),
	''Overall'',
	3,
	''Of all the service providers I know of, Harbor is my first choice.'',
	11,
	count(case when t.first_choice=''SD''
			then 1
		end) ,
	count(case when t.first_choice=''D''
			then 1
		end) ,
	count(case when t.first_choice=''N''
			then 1
		end) ,
	count(case when t.first_choice=''A''
			then 1
		end) ,
	count(case when t.first_choice=''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t with (nolock)
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date
 
insert into #temp
select 	count(batchno),
	count( case	when t.Overall_satis is not null
			then batchno
		end),
	''Overall'',
	3,
	''Overall, I am satisfied with Harbor:'',
	12,
	count(case when t.Overall_satis = ''SD''
			then 1
		end) ,
	count(case when t.Overall_satis = ''D''
			then 1
		end) ,
	count(case when t.Overall_satis = ''N''
			then 1
		end) ,
	count(case when t.Overall_satis = ''A''
			then 1
		end) ,
	count(case when t.Overall_satis = ''SA''
			then 1
		end) 
			
from 	dbo.custom_teleform_customer_satisfaction_survey t
where 	t.date_completed>= @beg_date
and 	t.date_completed < @end_date

insert into #temp2	
select 
	case when a <> 0
	then round(convert(float,a)/total*100,0)
	else 0 end as a,
	case when b <> 0
	then round(convert(float,b)/total*100,0) 
	else 0 end as b,
	case when c <> 0
	then round(convert(float,c)/total*100,0) 
	else 0 end as c,
	case when d <> 0
	then round(convert(float,d)/total*100,0) 
	else 0 end as d, 
	case when e <> 0
	then round(convert(float,e)/total*100,0) 
	else 0 end as e,
	ans_order,
	ans,
	t.category_order,
	t.category,
	total2,
	total,
	case when total <> 0
	then 
	((convert(float,a)*5)+(convert(float,b)*4)+(convert(float,c)*3)+(convert(float,d)*2)+(convert(float,e)))/total
	else 0 end as number,
	1
from #temp t

create table #jcaho ( jcaho float)

insert into #jcaho
select sum(average)/14
from #temp2
where ans_order in (1,2,3,4,5,6,7,8,9,10,11,12,13)

update #temp2
set jcaho= (select jcaho from #jcaho)

select -- ''part1'' as report_half,
	a,b,c,d,e,
	total2,
	total,
	case when ans_order = 14
		then 0
		else average end as average,
	--category,
	--category_order,
	ans_order,
	ans,
	jcaho,	
	--@db_name as dbName,
	convert(varchar(10), @beg_date, 101) as bdate,
	convert(varchar(10), @end_date, 101) as edate,
	case when ans_order = 14
		then 0
		else average end as real_avg
from #temp2
ORDER BY category_order, ans_order 

DROP TABLE #temp 
DROP TABLE #temp2

' 
END
GO
