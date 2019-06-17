/****** Object:  StoredProcedure [dbo].[csp_GetClinicianForService]    Script Date: 11/9/2015 9:26:40 PM ******/
DROP PROCEDURE [dbo].[csp_GetClinicianForService]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetClinicianForService]    Script Date: 11/9/2015 9:26:40 PM ******/
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
 /* Stored Procedure: [csp_GetClinicianForService]              */                                                                           
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
 /********************************************************************/                 
    begin try              
        begin              
            select  S.StaffId as ClinicianId,
                    S.LastName + ', ' + S.FirstName as ClinicianName,
                    -1 as ProgramId,
                    '' as ProgramName,
                    -1 as LocationId,
                    '' as LocationName,
                    -1 as ProcedureCodeId,
                    '' as ProcedureCodeName,
                    -1 as AttendingId,
                    '' as AttendingName
            from    Staff S
            where   (
				Active = 'Y' 
				and ISNULL(S.RecordDeleted, 'N') <> 'Y'
				and exists (
					select *
					from StaffPrograms as sp
					where sp.StaffId = S.StaffId
					and sp.ProgramId = @ProgramId
					and isnull(sp.RecordDeleted, 'N') = 'N'
				)
			)
            or (s.StaffId = @ClinicianId)
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


