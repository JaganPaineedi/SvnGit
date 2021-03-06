/****** Object:  StoredProcedure [dbo].[csp_GrowthChartData]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GrowthChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GrowthChartData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GrowthChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_GrowthChartData]
	@ClientId int,
	@GraphType int = 2, -- BioVisualTech Graph Type Id
	@TestingMode char(1) = ''N''
-- 2012.07.19 - t. remisoski - changed default value for missing data to -1.0
-- 2012.08.21 - t. remisoski - corrected "not exists" clause
as

declare @poundsToKgFactor decimal(9,8)
declare @inchesToCMFactor decimal(3,2)

set @poundsToKgFactor = 0.45359237
set @inchesToCMFactor = 2.54

--
-- Demographic data
--
select DATEDIFF(MONTH, c.DOB, GETDATE()) as Age, c.FirstName, c.LastName, c.ClientId, 
cast(case when c.Sex = ''M'' then 1 else 2 end as int) as Gender
from dbo.Clients as c
where c.ClientId = @ClientId

--
-- Health data
--
-- Age (in Months) / Height (in cm) / Weight (in kg) / Head Circumference / Date of Measurement
if @TestingMode = ''Y'' goto fake_results

select DATEDIFF(MONTH, c.DOB, dataEvents.DateRecorded) as AgeInMonths, 
	ISNULL(dataHeightWeight.HeightInCM, -1.0) as HeightInCM, 
	ISNULL(dataHeightWeight.WeightInKg, -1.0) as WeightInKg,
	ISNULL(dataHeadCirc.HeadCircumferenceInCM, -1.0) as HeadCircumferenceInCM, 
	dataEvents.DateRecorded
from (
	select DateRecorded
	from dbo.HealthData as hd
	where hd.ClientId = @ClientId
	and hd.HealthDataCategoryId in (1000, 1006)
	and ISNULL(hd.RecordDeleted, ''N'') <> ''Y''
	and not exists (
		select *
		from dbo.HealthData as hd2
		where hd2.ClientId = hd.ClientId
		and hd2.HealthDataCategoryId = hd.HealthDataCategoryId
		and hd2.DateRecorded = hd.DateRecorded
		and ISNULL(hd2.RecordDeleted, ''N'') <> ''Y''
		and hd2.HealthDataId > hd.HealthDataId
	)
) as dataEvents
LEFT join
(
	select DateRecorded, CAST(ItemValue1 * @inchesToCMFactor as decimal(6,2)) as HeightInCM, CAST(ItemValue2 * @poundsToKgFactor as decimal(6,2)) as WeightInKg
	from dbo.HealthData as hd
	where hd.ClientId = @ClientId
	and hd.HealthDataCategoryId = 1000
	and ISNULL(hd.RecordDeleted, ''N'') <> ''Y''
	and not exists (
		select *
		from dbo.HealthData as hd2
		where hd2.ClientId = hd.ClientId
		and hd2.HealthDataCategoryId = hd.HealthDataCategoryId
		and hd2.DateRecorded = hd.DateRecorded
		and ISNULL(hd2.RecordDeleted, ''N'') <> ''Y''
		and hd2.HealthDataId > hd.HealthDataId
	)
) as dataHeightWeight on dataHeightWeight.DateRecorded = dataEvents.DateRecorded
left join (
	select DateRecorded, CAST(ItemValue1 * @inchesToCMFactor as decimal(6,2)) as HeadCircumferenceInCM
	from dbo.HealthData as hd
	where hd.ClientId = @ClientId
	and hd.HealthDataCategoryId = 1006
	and ISNULL(hd.RecordDeleted, ''N'') <> ''Y''
	and not exists (
		select *
		from dbo.HealthData as hd2
		where hd2.ClientId = hd.ClientId
		and hd2.HealthDataCategoryId = hd.HealthDataCategoryId
		and hd2.DateRecorded = hd.DateRecorded
		and ISNULL(hd2.RecordDeleted, ''N'') <> ''Y''
		and hd2.HealthDataId > hd.HealthDataId
	)
) as dataHeadCirc on dataHeadCirc.DateRecorded = dataEvents.DateRecorded
cross join dbo.Clients as c
where c.ClientId = @ClientId
order by dataEvents.DateRecorded

return 0

-- for testing only!
fake_results:
declare @fakeResults table
(
	AgeInMonths int,
	HeightInCM decimal(6,2), 
	WeightInKg decimal(6,2), 
	HeadCircumferenceInCM decimal(6,2),
	DateRecorded datetime
)

declare @month int
declare @startDate datetime
declare @startHeight decimal(6,2)
declare @startWeight decimal(6,2)

select @month = 0, @startDate = ''1/1/2010'', @startHeight = 50.0, @startWeight = 4.5

while @month <= 60
begin
			
	insert into @fakeResults
			(
			 AgeInMonths,
			 HeightInCM,
			 WeightInKg,
			 HeadCircumferenceInCM,
			 DateRecorded
			)
	values  (
			@month,
			@StartHeight + CAST((1.5 * CAST(@month as decimal(6,2))) as decimal(6,2)),
			@startWeight + CAST((0.2 * CAST(@month as decimal(6,2))) as decimal(6,2)),
			35.0 + CAST((.8 * CAST(case when @month > 19 then null else @month end as decimal(6,2))) as decimal(6,2)),
			DATEADD(MONTH, @month, @startDate)
			)

	if @month < 36 set @month = @month + 1
	else set @month = @month + 7
	
end

select * from @fakeResults

return 0



' 
END
GO
