/****** Object:  StoredProcedure [dbo].[csp_GetClinicianForService]    Script Date: 12/23/2013 11:45:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetClinicianForService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetClinicianForService]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetClinicianForService]    Script Date: 12/23/2013 11:45:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
  
      
CREATE procedure [dbo].[csp_GetClinicianForService]                 
 -- Add the parameters for the stored procedure here                
    @ClientId int,  
    @DateOfService datetime = null,  
    @ProgramId int,  
    @AttendingId int,  
    @ProcedureCodeId int,  
    @LocationId int,  
    @PlaceOfServiceId int,  
    @ClinicianId int  
as   
begin               
/*********************************************************************/                                                                                      
 /* Stored Procedure: [csp_GetAttendingForService]              */                                                                             
 /* Creation Date:  2/August/2011                                     */                                                                                      
 /* Purpose: To get The Data In Procedure Table For Service            */                                                                                    
 /* Input Parameters:@ClientId, @DateOfService, @ProgramId, @ClinicianId,               
      @ProcedureCodeId, @LocationId, @PlaceOfServiceId  */                
  /* Output Parameters:   */          
  /*Returns The Table of Staff  */                                                                                      
 /* Called By:                                                       */                                                                            
 /* Data Modifications:                                              */                                                                                      
 /*   Updates:                                                       */                                                                                      
 /*   Date               Author                                       */                                                                                      
 /*   2/August/2011      Minakshi      Created                       */      
 /*   19/August/2011     Damanpreet    Modified                        */                                                                                    
 /*   23/Dec/2013        Manju P       Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes */                     
 /*   27 Dec 2013        Manju P       Modified to add orderby clause as StaffName. What/Why: Task: Core Bugs #1315 Staff Detail Changes  */
/********************************************************************/                   
    begin try                
        begin                
            select  S.StaffId as ClinicianId,  
                    --S.LastName + ', ' + S.FirstName as ClinicianName, 
                    S.DisplayAs as ClinicianName, 
                    -1 as ProgramId,  
                    '' as ProgramName,  
                    -1 as LocationId,  
                    '' as LocationName,  
                    -1 as ProcedureCodeId,  
                    '' as ProcedureCodeName,  
                    -1 as AttendingId,  
                    '' as AttendingName  
            from    Staff S  
            where   (Active = 'Y' and ISNULL(S.RecordDeleted, 'N') <> 'Y')  
    or (s.StaffId = @ClinicianId)  
   order by s.DisplayAs, s.StaffId  
        end              
    end try                
    begin catch                                                                                           
        declare @Error varchar(8000)                                                               
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'  
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
                     'csp_GetAttendingForService') + '*****'  
            + CONVERT(varchar, ERROR_LINE()) + '*****'  
            + CONVERT(varchar, ERROR_SEVERITY()) + '*****'  
            + CONVERT(varchar, ERROR_STATE())                                                                                            
        raiserror                                                                                             
  (                                                               
   @Error, -- Message text.                                                                                            
   16, -- Severity.                                                                                            
   1 -- State.                                                                                            
  ) ;                                                                                            
    end catch                  
end   
GO  