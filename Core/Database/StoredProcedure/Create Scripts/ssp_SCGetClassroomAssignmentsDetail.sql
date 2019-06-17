
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClassroomAssignmentsDetail]    Script Date: 06/04/2018 15:57:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClassroomAssignmentsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClassroomAssignmentsDetail]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetClassroomAssignmentsDetail]    Script Date: 06/04/2018 15:57:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[ssp_SCGetClassroomAssignmentsDetail] 
@ClassroomAssignmentId INT  
  
/*********************************************************************/  
/* Stored Procedure: dbo.ssp_SCGetSchoolDistrictDetail              */  
/* Copyright:Streamline Healthcare Solutions,  LLC             */  
/* Creation Date:    02/Apr/2018                                         */  
/* Created By : Pradeep Kumar Yadav                                                                */  
/* Purpose:  Used in getdata() for Classroom Assignments Detail Page  */  
/*                                                                   */  
/* Input Parameters: @ClassroomAssignmentId   */  
/*                                                                   */  
/* Output Parameters:   None                */  
/*                                                                   */  
/*********************************************************************/ 
AS
Begin
	Begin Try
		Select ClassroomAssignmentId
			  ,CreatedBy
	          ,CreatedDate
	          ,ModifiedBy
	          ,ModifiedDate
	          ,RecordDeleted
	          ,DeletedBy
	          ,DeletedDate
	          ,AcademicTermId
	          ,ClientId
	          ,ClassRoomId
	          ,StartDate
	          ,EndDate
	          ,GradeLevel
	     From ClassroomAssignments
	     Where ClassroomAssignmentId=@ClassroomAssignmentId
	     End Try
			BEGIN catch 
				DECLARE @Error VARCHAR(8000) 

					SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_SCGetClassroomAssignmentsDetail]') 
                       + '*****' + CONVERT(VARCHAR, Error_line()) 
                       + '*****' + CONVERT(VARCHAR, Error_severity()) 
                       + '*****' + CONVERT(VARCHAR, Error_state()) 

					RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
      END catch 

End



GO


