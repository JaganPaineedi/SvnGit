/****** Object:  StoredProcedure [dbo].[csp_Report_All_Clinician_Case_Load]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_All_Clinician_Case_Load]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_All_Clinician_Case_Load]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_All_Clinician_Case_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--/*
CREATE PROCEDURE [dbo].[csp_Report_All_Clinician_Case_Load]
	-- Add the parameters for the stored procedure here
	@StaffId		Int
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Clinician_Case_Load		              	*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Determine Case Load of each Clinician                      	*/
/*                                                                   	*/
/* Input Parameters: @StaffId			     			     			*/
/*								     									*/
/* Description: Create table of Clients for each Clinician to be used   */
/*	to populate pulldown on forms						      			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@StaffId		Int

SELECT
	@StaffId		= 1565
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @Temp1 TABLE
	(
		ClientNo	Int,
		ClientName	Varchar(100)
	)
	
 Declare  @UsePrimaryProgramForCaseload char(1), @PrimaryProgramId int                     
  
select  @UsePrimaryProgramForCaseload = UsePrimaryProgramForCaseload,                      
@PrimaryProgramId = PrimaryProgramId                      
FROM  Staff where Staffid=@StaffId  

INSERT INTO @Temp1 
VALUES (0, ''All Clients'')         

insert into @temp1                      
select distinct c.ClientId, rtrim(c.LastName) + '', '' + rtrim(c.FirstName) FirstName       
from Clients c                                 
left JOIN ClientPrograms cp
ON c.ClientId = cp.ClientId 
and cp.status <> 5 
and isnull(cp.recordDeleted,''N'')<>''Y''
where c.active = ''Y''  
and IsNull(c.RecordDeleted,''N'')<>''Y''                    
and (( c.PrimaryClinicianID = @StaffId)                  
OR                  
(isnull(@UsePrimaryProgramForCaseload,''N'') = ''Y''                  
and cp.ProgramId = @PrimaryProgramId))                                     
                                 
insert into @temp1                      
select distinct c.ClientId, rtrim(c.LastName) + '', '' + rtrim(c.FirstName) FirstName       
from Clients c                      
left JOIN ClientEpisodes ce 
ON (c.ClientId = ce.ClientId
and c.CurrentEpisodeNumber = ce.EpisodeNumber)
and Isnull(c.RecordDeleted, ''N'') <> ''Y''                                             
JOIN Services srv 
ON (ce.ClientId = srv.ClientId) 
and Isnull(srv.RecordDeleted, ''N'') <> ''Y''                                             
where                       
c.active = ''Y''                      
and srv.ClinicianId = @StaffId                      
and  srv.DateOfService >= DATEADD(month, -3, convert(datetime, convert(varchar,getdate(),101)) )                       
and Isnull(c.RecordDeleted,'''') <> ''Y''                   
and srv.status not in (72, 73, 76) -- Global Code for No Show, Cancel, Error
and  not exists                      
(select * from @Temp1 p                      
where c.ClientId = p.ClientNo)

	SELECT * FROM @Temp1 order by ClientName 
	
END

' 
END
GO
