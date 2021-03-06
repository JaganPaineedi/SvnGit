/****** Object:  StoredProcedure [dbo].[ssp_SCValidateChangeAuthor]    Script Date: 11/18/2011 16:26:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateChangeAuthor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateChangeAuthor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ssp_SCValidateChangeAuthor]    
@StaffId varchar(30),     
@ProcedureCodeId int = null,     
@ProgramId int = null,     
@LocationId int = null    
/********************************************************************************    
-- Stored Procedure: dbo.ssp_SCValidateChangeAuthor      
--    
-- Copyright: 2007 Streamline Healthcate Solutions    
--    
-- Creation Date:    10.20.2007                                               
--        
Input Parameters : StaffId,ProcedureCodeID,ProgaramID & LocationID                                                                   
-- Purpose: To Validate Author in relation to Staff Procedures,Programs & Location  
--    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 10.20.2007  SFarber     Created.      
-- 12 Aug 2015 Arjun K R   Modified: If the staff do not have procedures and locations set up and instead the service note uses the program to determine the procedures and locations. Task #182 CEI Environment Issues Tracking.        
-- 04/20/2017  jcarlson	   Keystone Customizations 55 - Modified to handle changes to ProgramProcedures table
*********************************************************************************/    
as   

DECLARE @flag INT

IF (@LocationId !=0)
	BEGIN
		SET @flag=(SELECT COUNT(*) FROM StaffProcedures   
		INNER JOIN StaffPrograms ON StaffPrograms.Staffid=StaffProcedures.Staffid  
		INNER JOIN StaffLocations ON StaffLocations.Staffid=StaffProcedures.Staffid  
		WHERE StaffProcedures.Staffid=@StaffId and StaffProcedures.Procedurecodeid=@ProcedureCodeId and StaffPrograms.Programid=@ProgramId  
		AND StaffLocations.Locationid=@LocationId)  
	END 

ELSE
	BEGIN
		SET @flag=(SELECT COUNT(*) FROM StaffProcedures   
		INNER JOIN StaffPrograms ON StaffPrograms.Staffid=StaffProcedures.Staffid  
		WHERE StaffProcedures.Staffid=@StaffId AND StaffProcedures.Procedurecodeid=@ProcedureCodeId AND StaffPrograms.Programid=@ProgramId)  
    END


-- Added  By Arjun K R 12 Aug 2015 
IF (@flag=0) 
	BEGIN
		 IF (@LocationId !=0)
			 BEGIN   
		          SET @flag = (SELECT COUNT(*) FROM  StaffPrograms SP
		          INNER JOIN PROGRAMS P ON SP.Programid=P.ProgramId
				  INNER JOIN ProgramLocations PL ON P.Programid=PL.ProgramId
				  WHERE P.Programid=@ProgramId AND SP.StaffId=@StaffId
				  AND ISNULL(P.RecordDeleted,'N')='N'
				  AND ISNULL(PL.RecordDeleted,'N')='N'
				  AND ISNULL(SP.RecordDeleted,'N')='N'
				  and exists ( Select 1
							   from ProgramProcedures as pp 
							   where pp.ProgramID = p.ProgramId
							   and isnull(pp.RecordDeleted,'N')='N'
							   and ( (pp.StartDate <= Convert(Date,GetDate()) or pp.StartDate is null)
							         AND 
									 (pp.EndDate >= convert(Date,GetDate()) or pp.EndDate is null )
								   )							       
							   )
							 )
			END
		ELSE 
			      SET @flag = (SELECT COUNT(*) FROM  StaffPrograms SP 
		          INNER JOIN PROGRAMS P ON SP.Programid=P.ProgramId
				  WHERE P.Programid=@ProgramId AND SP.StaffId=@StaffId
				  AND ISNULL(P.RecordDeleted,'N')='N'
				  AND ISNULL(SP.RecordDeleted,'N')='N'
				  				  and exists ( Select 1
							   from ProgramProcedures as pp 
							   where pp.ProgramID = p.ProgramId
							   and isnull(pp.RecordDeleted,'N')='N'
							   and ( (pp.StartDate <= Convert(Date,GetDate()) or pp.StartDate is null)
							         AND 
									 (pp.EndDate >= convert(Date,GetDate()) or pp.EndDate is null )
								   )							       
							   ))
	END 
  
 
SELECT @flag


--Execute SP_EXECUTESQL   @FilterSting 
  
   --Checking For Errors                
  If (@@error!=0)                
  Begin                
   RAISERROR('ssp_SCValidateChangeAuthor: An Error Occured',16,1)                 
   Return                
   End

