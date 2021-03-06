/****** Object:  StoredProcedure [dbo].[csp_SelectStafffAndSupervisor]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SelectStafffAndSupervisor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SelectStafffAndSupervisor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SelectStafffAndSupervisor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[csp_SelectStafffAndSupervisor]
   @ReportType AS Int
 AS
 
 BEGIN
 
 DECLARE @Staff TABLE 
 ( StaffId INT, Staffname VARCHAR(250) )
 INSERT INTO @Staff
         ( StaffId, Staffname )
   Select   -1 AS StaffID
         ,case when  @ReportType =1 
              Then '' Select A Supervisor'' 
              Else '' Select A Staff'' 
          END AS StaffName
 INSERT INTO @Staff
         ( StaffId, Staffname )
 
 SELECT  Distinct StaffID, 
	         LastName +'', '' + Firstname AS StaffName 
	   FROM Staff s
	   WHERE ( 
		(@ReportType = 1 AND s.Supervisor=''Y'' )
		OR ( @ReportType <> 1 and s.Active = ''Y'')
		)
	   --WHERE ISNULL(Supervisor,''N'')= 
									--CASE  WHEN @ReportType=1 
									--	 THEN ''Y''   --Is Supervisor
									--	 ELSE ''N''   --Is not a superviosr
								 --    End

--Get further supervisors
INSERT INTO @Staff
         ( StaffId, Staffname )
 	   SELECT  Distinct s.StaffID, 
	         s.LastName +'', '' + s.Firstname AS StaffName 
	   FROM Staff s
		JOIN dbo.StaffSupervisors ss ON ss.SupervisorId = s.StaffId
		WHERE @ReportType =1
		AND NOT EXISTS ( SELECT 1 FROM @Staff a WHERE a.StaffId = s.StaffId )
		 ORDER BY StaffName
        
        SELECT StaffId, StaffName FROM @Staff a 
        ORDER BY a.Staffname
         
 END
select * from staffsupervisors' 
END
GO
