/****** Object:  StoredProcedure [dbo].[csp_ServiceNoteProgramId]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteProgramId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ServiceNoteProgramId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteProgramId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- Stored Procedure

CREATE PROCEDURE [dbo].[csp_ServiceNoteProgramId](      
 @ClientId int,      
 @DateOfService datetime,      
 @ProgramId int,      
 @AttendingId int,      
 @ProcedureCodeId int,      
 @LocationId int,      
 @PlaceOfServiceId int,      
 @ClinicianId int      
)      

AS      
BEGIN      

IF @DateofService IS NULL      
 SET @DateOfService = GETDATE()      

DECLARE @Results TABLE(      
 AttendingId int,      
 AttendingName varchar(1),      
 ProgramId int,      
 ProgramName varchar(250),      
 LocationId int,      
 LocationName varchar(1),      
 ProcedureCodeId int,      
 ProcedureCodeName varchar(1),      
 ClinicianId int,      
 ClinicianName varchar(1)      
)      

 -- Get team list      
 INSERT INTO @Results(      
 AttendingId,      
 AttendingName,      
 ProgramId,      
 ProgramName,      
 LocationId,      
 LocationName,      
 ProcedureCodeId,      
 ProcedureCodeName,      
 ClinicianId,      
 ClinicianName      
 )      
 SELECT DISTINCT -1,      
        '''',      
     p.ProgramId,       
     p.ProgramName,      
     -1,      
     '''',      
     -1,      
     '''',      
     -1,      
     ''''      
 FROM ClientPrograms cp      
 LEFT JOIN Programs p ON p.ProgramId = cp.ProgramId AND ISNULL(p.RecordDeleted,''N'') = ''N''      
 WHERE cp.ClientId = @ClientId AND      
       p.ProgramId <> 329 AND      -- No episode program      
       p.Active = ''Y'' and      
       CONVERT(DATE,cp.RequestedDate,101) <= CONVERT(DATE,@DateOfService,101) AND    
       --( CONVERT(DATE,cp.EnrolledDate,101) <= CONVERT(DATE,@DateOfService,101) OR      
       --  ( cp.EnrolledDate IS NULL AND      
       --    CONVERT(DATE,cp.RequestedDate,101) <= CONVERT(DATE,@DateOfService,101) ) ) AND      
       ( cp.DischargedDate IS NULL OR      
         CONVERT(DATE,cp.DischargedDate,101) >= CONVERT(DATE,@DateOfService,101) ) AND      
       ISNULL(cp.RecordDeleted,''N'') = ''N''  AND    
       EXISTS ( SELECT *     
                FROM ProgramProcedures pp    
                WHERE pp.ProgramId = p.ProgramId)    

 -- Add ''No Episode'' team if no episodes open at date of service      
 IF NOT EXISTS( SELECT *      
       FROM ClientEpisodes ce      
       WHERE ce.ClientId = @ClientId AND      
       ce.RegistrationDate <= @DateOfService AND      
       ( ce.DischargeDate >= cast(@DateOfService as Date) OR      
         ce.DischargeDate IS NULL ) AND      
       ISNULL(ce.RecordDeleted,''N'') = ''N'' )      
 BEGIN      
  INSERT INTO @Results(      
   AttendingId,      
   AttendingName,      
   ProgramId,      
   ProgramName,      
   LocationId,      
   LocationName,      
   ProcedureCodeId,      
   ProcedureCodeName,      
   ClinicianId,      
   ClinicianName      
  )      
  select     
   -1,      
   '''',      
   p.ProgramId,      
   p.ProgramCode,      
   -1,      
   '''',      
   -1,      
   '''',      
   -1,      
   ''''      
  from Programs p    
  JOIN GlobalCodes gc ON (p.ProgramType = gc.GlobalCodeId)    
  where gc.Category = ''PROGRAMTYPE''    
  and gc.Code = ''NO EPISODE''  order by p.ProgramCode  --added by jaswinder to sort the programs  
 END        
SELECT * FROM @Results      

END 
' 
END
GO
