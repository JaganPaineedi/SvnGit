CREATE TABLE #tempprocedurecodeInsert
(
ProcedureCodeID int
)

insert into #tempprocedurecodeInsert select ProcedureCodeID from ProcedureCodes where 
DisplayAs in ('Indvid SUD','SUD Group - OP')

IF EXISTS (SELECT * FROM #tempprocedurecodeInsert)
BEGIN 
DECLARE @ProcedureCodeID INT
DECLARE #FETCHTEMPPROCEDURECODE CURSOR FAST_FORWARD
FOR 
SELECT ProcedureCodeID FROM #tempprocedurecodeInsert
OPEN #FETCHTEMPPROCEDURECODE
FETCH #FETCHTEMPPROCEDURECODE INTO @ProcedureCodeID
WHILE @@fetch_status = 0
BEGIN
--Procedure Start 
DECLARE @ProgramId INT
DECLARE @LocationId INT 
DECLARE @Degree INT 
DECLARE @Staff INT 
DECLARE @ServiceAreaId INT 
DECLARE @PlaceOfServieId INT 
DECLARE @ProcedureRateIdCombination INT

create table #groupcombination (
ProgramId int,
LocationId int,
Degree int,
StaffId int,
ServiceAreaId int,
PlaceOfServieId int,
ProcedureRateIdCombination int
)

create table #deletegroupcombinationlist (
ProgramId int,
LocationId int,
Degree int,
StaffId int,
ServiceAreaId int,
PlaceOfServieId int,
ProcedureRateIdCombination int
)

create table #tableProcedureRatePrograms
(
ProgramId int,
ProcedureRateId int
)

create table #tableProcedureRateLocations
(
LocationId int ,
ProcedureRateId int
)

create table #tableProcedureRateDegrees
(
Degree int ,
ProcedureRateId int
)


create table #tableProcedureRateStaff
(
Staff int ,
ProcedureRateId int
)

create table #tableProcedureRateServiceAreas
(
ServiceAreaId int ,
ProcedureRateId int
)

create table #tableProcedureRatePlacesOfServices
(
PlaceOfServieId int ,
ProcedureRateId int
)

declare @ProcedureRateId int
declare #Procedureduplication cursor FAST_FORWARD 
for
Select ProcedureRateId From ProcedureRates where ProcedureCodeId=@ProcedureCodeID

open #Procedureduplication

fetch #Procedureduplication into @ProcedureRateId
  WHILE @@fetch_status = 0
                BEGIN	
                
                if exists (select * from ProcedureRatePrograms where ProcedureRateId=@ProcedureRateId and ISNULL(RecordDeleted,'N')='N')
                begin
                insert into #tableProcedureRatePrograms 
                select ProgramId,ProcedureRateId from ProcedureRatePrograms 
                where ProcedureRateId=@ProcedureRateId and ISNULL(RecordDeleted,'N')='N'
                end
                else
                begin
                 insert into #tableProcedureRatePrograms (ProgramId,ProcedureRateId) values (-1,@ProcedureRateId)
                end
                
                if exists (select * from ProcedureRateLocations where ProcedureRateId=@ProcedureRateId 
                  and ISNULL(RecordDeleted,'N')='N')
                 begin
                insert into #tableProcedureRateLocations select LocationId,
                ProcedureRateId from ProcedureRateLocations 
                where ProcedureRateId=@ProcedureRateId and ISNULL(RecordDeleted,'N')='N'
                 end
                 else
                 begin
                 insert into #tableProcedureRateLocations (LocationId,ProcedureRateId)values(-1,@ProcedureRateId)
                 end
                
                
                 if exists (select * from ProcedureRateDegrees where ProcedureRateId=@ProcedureRateId 
                  and ISNULL(RecordDeleted,'N')='N')
                 begin
                insert into #tableProcedureRateDegrees select Degree,
                ProcedureRateId from ProcedureRateDegrees 
                where ProcedureRateId=@ProcedureRateId and ISNULL(RecordDeleted,'N')='N'
                 end
                 else
                 begin
                 insert into #tableProcedureRateDegrees (Degree,ProcedureRateId)values(-1,@ProcedureRateId)
                 end
                 
                 if exists (select * from ProcedureRateStaff where ProcedureRateId=@ProcedureRateId 
                  and ISNULL(RecordDeleted,'N')='N')
                 begin
                insert into #tableProcedureRateStaff select StaffId,
                ProcedureRateId from ProcedureRateStaff 
                where ProcedureRateId=@ProcedureRateId and ISNULL(RecordDeleted,'N')='N'
                 end
                 else
                 begin
                 insert into #tableProcedureRateStaff (Staff,ProcedureRateId)values(-1,@ProcedureRateId)
                 end
                
                
                  if exists (select * from ProcedureRateServiceAreas where ProcedureRateId=@ProcedureRateId 
                  and ISNULL(RecordDeleted,'N')='N')
                 begin
                insert into #tableProcedureRateServiceAreas select ServiceAreaId,
                ProcedureRateId from ProcedureRateServiceAreas 
                where ProcedureRateId=@ProcedureRateId and ISNULL(RecordDeleted,'N')='N'
                 end
                 else
                 begin
                 insert into #tableProcedureRateServiceAreas (ServiceAreaId,ProcedureRateId)values(-1,@ProcedureRateId)
                 end
                 
                   if exists (select * from ProcedureRatePlacesOfServices where ProcedureRateId=@ProcedureRateId 
                  and ISNULL(RecordDeleted,'N')='N')
                 begin
                insert into #tableProcedureRatePlacesOfServices select PlaceOfServieId,
                ProcedureRateId from ProcedureRatePlacesOfServices 
                where ProcedureRateId=@ProcedureRateId and ISNULL(RecordDeleted,'N')='N'
                 end
                 else
                 begin
                 insert into #tableProcedureRatePlacesOfServices (PlaceOfServieId,ProcedureRateId)values(-1,@ProcedureRateId)
                 end
                 
				FETCH #Procedureduplication INTO @ProcedureRateId
                END
			CLOSE #Procedureduplication
            DEALLOCATE #Procedureduplication
            
set @ProcedureRateId =0
declare @count int=0
declare #ProcedureduplicationCombination cursor FAST_FORWARD 
for
Select ProcedureRateId From ProcedureRates where ProcedureCodeId=@ProcedureCodeID
--select ProgramId,LocationId,Degree,StaffId,ServiceAreaId,PlaceOfServieId,count(*) from #groupcombination

open #ProcedureduplicationCombination

fetch #ProcedureduplicationCombination into @ProcedureRateId
  WHILE @@fetch_status = 0
                BEGIN
					if(@count=0)
					begin
					SET @count=@count+1;
					
					INSERT INTO #groupcombination 
					select  ProgramId,LocationId,Degree,Staff,ServiceAreaId,PlaceOfServieId,pl.ProcedureRateId 
					from #tableProcedureRatePrograms pp 
					inner join #tableProcedureRateLocations pl on pl.ProcedureRateId=pp.ProcedureRateId
					inner join #tableProcedureRateDegrees pd on pd.ProcedureRateId=pl.ProcedureRateId
					inner join #tableProcedureRateStaff ps on ps.ProcedureRateId=pd.ProcedureRateId
					inner join #tableProcedureRateServiceAreas pa on pa.ProcedureRateId=ps.ProcedureRateId
					inner join #tableProcedureRatePlacesOfServices pps on pps.ProcedureRateId=pa.ProcedureRateId
					where pl.ProcedureRateId=@ProcedureRateId
					
					end
					else
					begin
					DECLARE #divideduplicateCombinations cursor fast_forward
					for 
					select  ProgramId,LocationId,Degree,Staff,ServiceAreaId,PlaceOfServieId
					from #tableProcedureRatePrograms pp 
					inner join #tableProcedureRateLocations pl on pl.ProcedureRateId=pp.ProcedureRateId
					inner join #tableProcedureRateDegrees pd on pd.ProcedureRateId=pl.ProcedureRateId
					inner join #tableProcedureRateStaff ps on ps.ProcedureRateId=pd.ProcedureRateId
					inner join #tableProcedureRateServiceAreas pa on pa.ProcedureRateId=ps.ProcedureRateId
					inner join #tableProcedureRatePlacesOfServices pps on pps.ProcedureRateId=pa.ProcedureRateId
					where pl.ProcedureRateId=@ProcedureRateId
					
					open #divideduplicateCombinations
					
					fetch #divideduplicateCombinations into @ProgramId,@LocationId,@Degree,@Staff,@ServiceAreaId,@PlaceOfServieId
					
					WHILE @@fetch_status = 0
						BEGIN
		                	IF NOT EXISTS(SELECT * FROM #groupcombination 
		                	WHERE ProgramId=@ProgramId 
		                	AND LocationId=@LocationId AND @Degree=@Degree AND StaffId=@Staff 
		                	AND ServiceAreaId=@ServiceAreaId AND PlaceOfServieId=@PlaceOfServieId )
		                	BEGIN
		                	INSERT INTO #groupcombination(ProgramId,LocationId,Degree,StaffId,
									 ServiceAreaId,PlaceOfServieId,ProcedureRateIdCombination) VALUES 
									(@ProgramId,@LocationId,@Degree,@Staff,@ServiceAreaId,@PlaceOfServieId,@ProcedureRateId)
									
		                	END
		                	else
		                	begin
		                	INSERT INTO #deletegroupcombinationlist(ProgramId,LocationId,Degree,StaffId,
									 ServiceAreaId,PlaceOfServieId,ProcedureRateIdCombination) VALUES 
									(@ProgramId,@LocationId,@Degree,@Staff,@ServiceAreaId,@PlaceOfServieId,@ProcedureRateId)
		                	end
		                	
		                	
		                	fetch #divideduplicateCombinations into @ProgramId,@LocationId,@Degree,@Staff,@ServiceAreaId,@PlaceOfServieId
		                	
						end
						
						CLOSE #divideduplicateCombinations
						DEALLOCATE #divideduplicateCombinations
					
					end

                FETCH #ProcedureduplicationCombination INTO @ProcedureRateId
                end
    
    	    CLOSE #ProcedureduplicationCombination
            DEALLOCATE #ProcedureduplicationCombination
    


--Final Step to remove duplicate combination from procedure rates 

		DECLARE #finalstagetoremoveduplication cursor fast_forward 
		for 
		select ProgramId,LocationId,Degree,staffid,ServiceAreaId,PlaceOfServieId,ProcedureRateIdCombination from #deletegroupcombinationlist
		open #finalstagetoremoveduplication

		fetch #finalstagetoremoveduplication into @ProgramId,@LocationId,@Degree,@Staff,@ServiceAreaId,@PlaceOfServieId,@ProcedureRateId

		while @@FETCH_STATUS = 0
		begin
				 
				update ProcedureRatePrograms set RecordDeleted='Y',DeletedBy='HDDatacorrection' where ProcedureRateId=@ProcedureRateId and ProgramId=@ProgramId
				update ProcedureRateLocations set RecordDeleted='Y',DeletedBy='HDDatacorrection' where ProcedureRateId=@ProcedureRateId and LocationId=@LocationId
				update ProcedureRateDegrees  set RecordDeleted='Y',DeletedBy='HDDatacorrection' where ProcedureRateId=@ProcedureRateId and Degree=@Degree
				update ProcedureRateStaff set RecordDeleted='Y',DeletedBy='HDDatacorrection' where ProcedureRateId=@ProcedureRateId and StaffId=@Staff
				update ProcedureRateServiceAreas set RecordDeleted='Y',DeletedBy='HDDatacorrection' where ProcedureRateId=@ProcedureRateId 
				and ServiceAreaId=@ServiceAreaId
				update ProcedureRatePlacesOfServices set RecordDeleted='Y',DeletedBy='HDDatacorrection' where ProcedureRateId=@ProcedureRateId 
				and PlaceOfServieId=@PlaceOfServieId
				 
				
	   fetch #finalstagetoremoveduplication into @ProgramId,@LocationId,@Degree,@Staff,@ServiceAreaId,@PlaceOfServieId,@ProcedureRateId

		end
		
		    CLOSE #finalstagetoremoveduplication
            DEALLOCATE #finalstagetoremoveduplication


           -- select * from #groupcombination 
            
            --Select * From #deletegroupcombinationlist
            
            drop table #groupcombination
			drop table #deletegroupcombinationlist
            drop table #tableProcedureRatePrograms
            drop table #tableProcedureRateLocations
            drop table #tableProcedureRateDegrees
            drop table #tableProcedureRateStaff
            drop table #tableProcedureRateServiceAreas
            drop table #tableProcedureRatePlacesOfServices
--Procedure End
FETCH #FETCHTEMPPROCEDURECODE INTO @ProcedureCodeID
END
	
CLOSE #FETCHTEMPPROCEDURECODE
DEALLOCATE #FETCHTEMPPROCEDURECODE
END

DROP TABLE #tempprocedurecodeInsert
