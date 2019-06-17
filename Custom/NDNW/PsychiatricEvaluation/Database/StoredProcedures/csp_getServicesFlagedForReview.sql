/****** Object:  StoredProcedure [dbo].[csp_getServicesFlagedForReview]    Script Date: 06/08/2015 14:43:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[csp_getServicesFlagedForReview] (
	 @ClientId INT
	,@SortColumn varchar(36)
	,@Sort varchar(12)
	)
AS
BEGIN
	/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Service"
-- Purpose: Script for Task #823 - Woods Customizations
--  
-- Author:  Dhanil Manuel
-- Date:    12-31-2014
-- *****History****  
-- Modified By		Modified Date		Purpose
-- Malathi Shiva	06/Jan/2014			Added ScreenId parameter to create hyperlink as it is in ServiceNote list page

*********************************************************************************/

	
	DECLARE @Services table
	(
	  serviceId int,
	  DocumentId int,
	  ScreenId int,
	  DateOfService datetime,
	  DOS varchar(32),
	  [Status] varchar(32),
	  ProcedureCode varchar(128),
	  Document varchar(128),
	  Clinician varchar(128),
	  Program varchar(128),
	  Comment varchar(max)
	);

	
insert into @Services select 
		s.serviceId,
		d.DocumentId,
		sc.ScreenId,
		s.DateOfService,
		(CONVERT(varchar(20),  s.DateOfService,101) + ' ' +  RIGHT(CONVERT(VARCHAR,s.DateOfService,0),6)) as DOS,
	    gcs.CodeName AS [Status],
		pc.ProcedureCodeName AS [ProcedureCode],
		pc.ProcedureCodeName AS [Document],
        (st.FirstName+', '+st.LastName) as Clinician,
        p.ProgramName ,
        s.Comment
 
from Services s    
         --join CustomServices cs on cs.ServiceId = s.ServiceId                                      
         join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId                                                       
         join GlobalCodes gcs on gcs.GlobalCodeId = s.Status  
         join Programs p on p.ProgramId = s.ProgramId                                                                  
         left join Staff st on st.StaffId = s.ClinicianId   
         left join Locations loc on s.LocationId = loc.LocationId 
         left join documents d on d.ServiceId = s.ServiceId    
         join Screens sc on d.DocumentCodeId = sc.DocumentCodeId                                                         
   where s.ClientId = @ClientId  
  --and cs.PsychiatristReview = 'Y'
   and isnull(s.RecordDeleted,'N') <> 'Y'   
   and isnull(d.RecordDeleted,'N') <> 'Y'  
   and d.Status = 22 
    
 if(@SortColumn = 'DOS' and @Sort = 'asc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by DateOfService asc end
  if(@SortColumn = 'DOS' and @Sort = 'desc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by DateOfService desc end
 if(@SortColumn = 'Status' and @Sort = 'asc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Status asc end
  if(@SortColumn = 'Status' and @Sort = 'desc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Status desc end
  if(@SortColumn = 'ProcedureCode' and @Sort = 'asc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by ProcedureCode asc end
  if(@SortColumn = 'ProcedureCode' and @Sort = 'desc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by ProcedureCode desc end
  if(@SortColumn = 'Document' and @Sort = 'asc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Document asc end
  if(@SortColumn = 'Document' and @Sort = 'desc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Document desc end
   if(@SortColumn = 'Clinician' and @Sort = 'asc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Clinician asc end
  if(@SortColumn = 'Clinician' and @Sort = 'desc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Clinician desc end
    if(@SortColumn = 'Program' and @Sort = 'asc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Program asc end
  if(@SortColumn = 'Program' and @Sort = 'desc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Program desc end
 
 if(@SortColumn = 'Comment' and @Sort = 'asc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Comment asc end
  if(@SortColumn = 'Comment' and @Sort = 'desc')begin
 select serviceId,DocumentId,ScreenId,DateOfService,DOS,[Status],ProcedureCode,Document,Clinician,Program,Comment from @Services order by Comment desc end


END

--Checking For Errors             
IF (@@error != 0)
BEGIN
	RAISERROR 20006 '[csp_getServicesFlagedForReview] : An Error Occured'

	RETURN
END

GO
