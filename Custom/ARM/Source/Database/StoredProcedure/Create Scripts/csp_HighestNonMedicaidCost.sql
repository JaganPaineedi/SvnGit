/****** Object:  StoredProcedure [dbo].[csp_HighestNonMedicaidCost]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HighestNonMedicaidCost]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HighestNonMedicaidCost]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HighestNonMedicaidCost]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--/*
CREATE PROCEDURE [dbo].[csp_HighestNonMedicaidCost] 	
	@beg_date datetime = null,
	@end_date datetime = null,
	@top_count int = 35
					
AS
BEGIN
--BEGIN TRAN
--	UPDATE cstm_report_counter 
--	SET counts = counts + 1   
--	WHERE obj_id = object_id( ''csp_highest_non_medicaid_cost2'')
--COMMIT TRAN
--*/

/****************************************************************/
/* Stored Procedure: csp_HighestNonMedicaidCost					*/
/* Creation Date:    06/21/2012									*/
/* Copyright:    Harbor Behavioral Healthcare					*/
/*																*/
/* Purpose:    Quality Improvement Reports						*/
/*																*/
/* Called By:  highest medicaid cost							*/
/*																*/
/* Updates:														*/
/*  Date		Author		Purpose								*/
/*  06/21/2012	JJN			Created	-							*/
/*							This is a translation of			*/
/*							csp_highest_non_medicaid_cost2 from	*/
/*							Psych database						*/
/****************************************************************/

DECLARE @dbName varchar(20)
SELECT  @dbname = db_name()

DECLARE	 @b_date datetime
DECLARE	 @e_date datetime

SELECT  @b_date = convert(datetime, @beg_date)
SELECT  @e_date = convert(datetime, @end_date)

select @top_count=@top_count+1

CREATE TABLE #temp (patient_id char(10),
                    episode_id char(10),
                    clinical_transaction_no int,
                    registration datetime null,
                    close_date datetime null,
                    lname varchar(20),
                    fname varchar(20),
                    amount money)


CREATE TABLE #location (patient_id char(10),
                        location   char(10))

-- #temp2 only holds top 35 highest cost clients
CREATE TABLE #TEMP2 (index_num  int,
                     patient_id CHAR(10), 
                     amount     money,
                     registration datetime null,
                     close_date datetime null,
                     lname varchar(20),
                     fname varchar(20),
                     location char(10))


INSERT INTO #temp
SELECT  distinct bl.ClientId as patient_id,
		episode_id=NULL, --episode_id does not exist
       	clinical_transaction_number=pct.ServiceId,
        registration_date=NULL,--p.registration_date,
        episode_close_date=NULL,--p.episode_close_date,
       	lname=p.LastName,
        fname=p.FirstName, 
        bl.amount
FROM ARLedger bl
JOIN Charges bt on bt.ChargeId = bl.ChargeId
JOIN Services pct ON pct.ServiceId=bt.ServiceId
JOIN ProcedureCodes ct ON ct.ProcedureCodeId=pct.ProcedureCodeId
JOIN Clients p ON p.ClientId=bl.ClientId-- and p.episode_id=bl.episode_id
JOIN ClientAddresses pa ON pa.ClientId = p.ClientId
JOIN CoveragePlans cp ON cp.CoveragePlanId = bl.CoveragePlanId
WHERE   bl.amount > 0 
AND pct.DateofService >= @b_date 
AND pct.DateofService < dateadd(day,1,@e_date)	
AND (cp.DisplayAs like ''DFNON%'' or cp.coverageplanid like ''MHNON%'')
AND pa.Address is not null-- and p.county=''LUCAS''
AND pct.status = 75

DECLARE	 @patient_id char(10)
DECLARE	 @cost money
DECLARE	 @registration datetime 
DECLARE	 @close_date   datetime,
         @lname varchar(20),
         @fname varchar(20),
         @location char(10),
		 @sp_id int
DECLARE	 @counter int


SELECT	 @counter=0

DECLARE	 cur_patient cursor            -- DECLARE A CURSOR TO PUT ONLY TOP @top_count HIGHEST COST CLIENTS INTO THE #TEMP2
FOR
SELECT 	t.patient_id, 
       		sum(t.amount) as cost,
       		t.registration,
      		t.close_date,
       		t.lname,
      		t.fname,
       		pc.location

FROM		#temp t
LEFT  JOIN 	CustomClients pc with (nolock)

	ON   	pc.ClientId=t.patient_id-- and pc.episode_id=t.episode_id
 	and pc.location is not null

GROUP BY	t.patient_id, t.registration,t.close_date ,t.lname, t.fname, pc.location

ORDER BY	sum(t.amount) desc


OPEN  cur_patient


FETCH   cur_patient
INTO	@patient_id,
        @cost, 
        @registration, 
        @close_date,
        @lname,
        @fname,
        @location 
	
SELECT 	@counter=1  -- initialize the counter to 1

WHILE	@counter<@top_count   -- loop to select number of top count depending on the number user enters 
BEGIN
        	INSERT INTO #temp2 (  index_num ,
                                       patient_id,
                                       amount,
                                       registration,
                                       lname,
                                       fname,
                                       location)
                  VALUES  ( @counter,
                            @patient_id,
                            @cost,
                            @registration,
                            @lname,
                            @fname,
                            @location
		        )
                   
         	FETCH  	cur_patient
		INTO	@patient_id,
                        @cost, 
    			@registration, 
     			@close_date,
     			@lname,
     			@fname,
    			@location 
		SELECT @counter= @counter+1   -- increment the counter
END                                                               -- end of loop
CLOSE	 cur_patient
DEALLOCATE cur_patient

SELECT 	t2.patient_id,
		p.lastname,
		p.firstname,
		--t2.episode_id,
		proc_cron=pct.DateofService,
		ProcedureCodeName=ct.DisplayAs,
		gc.CodeName as Status,
               	@beg_date as b_date,
               	@end_date as e_date,
		@dbname as dbname

FROM	 #temp2 t2
JOIN	Services pct
	ON       t2.patient_id=pct.ClientId
JOIN GlobalCodes gc ON gc.GlobalCodeId = pct.Status AND gc.Category = ''SERVICESTATUS''
join 	ProcedureCodes ct
	ON	ct.ProcedureCodeId=pct.ProcedureCodeId
JOIN 	Clients p with (nolock)
	ON	p.ClientId=pct.ClientId
	--AND	p.episode_id=pct.episode_id
WHERE pct.status <> 76
AND pct.DateofService >= @b_date 
AND pct.DateofService < dateadd(day,1,@e_date)	


END
' 
END
GO
