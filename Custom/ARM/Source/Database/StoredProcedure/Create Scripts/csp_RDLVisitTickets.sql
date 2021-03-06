/****** Object:  StoredProcedure [dbo].[csp_RDLVisitTickets]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLVisitTickets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLVisitTickets]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLVisitTickets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_RDLVisitTickets](  
 @SelectedDate   datetime,  
 @ReceptionViewId  int,  
 @Status     varchar(100)  
)  
AS  
BEGIN  
   
 DECLARE @ServiceStatuses TABLE(  
  Status int  
 )  
   
 INSERT INTO @ServiceStatuses(  
  Status  
 )  
   
 SELECT GlobalCodeId  
 FROM GlobalCodes  
 WHERE ( @Status = 6852 AND globalCodeId IN (70,71) ) OR  
    ( @Status = 6853 AND globalCodeId IN (72,73) ) OR  
    ( @Status = 6851 AND globalCodeId IN (70) ) OR  
    ( @Status = 0 AND globalCodeId IN (70,71,72,73,76,75) )  
      
 DECLARE @Results TABLE(  
  ClientId int,  
  ServiceId int,  
  StaffId int  
 )  
   
 INSERT INTO @Results(  
  ClientId,  
  ServiceId,  
  StaffId  
 )  
 SELECT svc.ClientId,  
     svc.ServiceId,  
        s.StaffId  
 FROM Services svc  
 LEFT JOIN Staff s on svc.ClinicianId = s.StaffId  
 join @ServiceStatuses as ss on ss.Status = svc.Status  
 JOIN Clients cl ON svc.ClientId = cl.ClientId
 WHERE datediff(day,svc.DateOfService,@SelectedDate) = 0 AND   
    --Work through the receptionViews  
       EXISTS ( SELECT *       
       FROM ReceptionViews rv  
       LEFT JOIN ReceptionViewLocations rvl on rv.ReceptionViewId = rvl.ReceptionViewId  
          LEFT JOIN ReceptionViewPrograms rvp on rv.ReceptionViewId = rvp.ReceptionViewId  
          LEFT JOIN ReceptionViewStaff rvs on rv.ReceptionViewId = rvs.ReceptionViewId  
          WHERE rv.ReceptionViewId = @ReceptionViewId AND  
             ( rv.AllLocations = ''Y'' OR svc.LocationId = rvl.LocationId ) AND  
             ( rv.AllPrograms = ''Y'' OR svc.ProgramId = rvp.ProgramId ) AND  
             ( rv.AllStaff = ''Y'' OR svc.clinicianId = rvs.StaffId )  
     ) AND  
    ISNULL(svc.RecordDeleted,''N'') = ''N'' AND   
    ISNULL(s.RecordDeleted,''N'') = ''N''  
    order by svc.DateOfService, cl.LastName, cl.FirstName
  
 SELECT * FROM @Results  
END  
  
' 
END
GO
