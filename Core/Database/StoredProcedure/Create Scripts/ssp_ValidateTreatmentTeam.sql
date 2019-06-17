IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateTreatmentTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateTreatmentTeam]
GO

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ssp_ValidateTreatmentTeam]   
@CurrentUserId Int,          
@ScreenKeyId Int       
      
AS          
/******************************************************************************                                          
**  File: [ssp_ValidateTreatmentTeam]                                      
**  Name: [ssp_ValidateTreatmentTeam]                  
**  Desc: For Validation  on Treatment Team page
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Venkatesh MR                
**  Date:  14/03/2018
**  Description: Ref- Task #187 Texas Go Live Build Issues                                  
*******************************************************************************                                          
**  Change History                                          
*******************************************************************************                                          
**  Date:        Author:			 Description:   
 27-April-2018   Sachin				 What : Calling to scsp_ValidateTreatmentTeam, Removed the End date validation from scsp_ValidateTreatmentTeam stored procedure as Boundless does not required.
									 Why  : Boundless Build Cycle Tasks #30  
 03-Sep-2018     Dasari Sunil		 What : Removed the End date validation from ssp_ValidateTreatmentTeam stored procedure added as part of Texas Go Live Build Issues #187.
									 Why  : It is requiring an end date for the treatment team member and this should be an optional field and not a required field.
									 Porter Starke-Environment Issues Tracking #19                                      
*******************************************************************************/                                        
          
Begin                                                        
                  
  Begin try       
  
   IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ValidateTreatmentTeam]'))
	    Begin
	          EXEC scsp_ValidateTreatmentTeam @CurrentUserId , @ScreenKeyId 
			  return
	    END	
	    
	            
--*TABLE CREATE*--                       
DECLARE  @ClientTreatmentTeamMembers TABLE(              
		ClientTreatmentTeamMemberId	int
		,CreatedBy	VARCHAR(200)
		,CreatedDate DateTime
		,ModifiedBy	VARCHAR(200)
		,ModifiedDate	DateTime
		,RecordDeleted	Char(1)
		,DeletedBy	VARCHAR(200)
		,DeletedDate	datetime
		,ClientId	int
		,StaffId	int
		,ClientContactId	int
		,MemberType	char(1)
		,Active	Char(1)
		,StartDate	datetime
		,EndDate	datetime
		,FirstName	VARCHAR(100)
		,LastName	VARCHAR(100)
		,Suffix	varchar(10)
		,TreatmentTeamRole	int
		,Email	VARCHAR(100)
		,Organization	varchar(100)
		,Comments	VARCHAR(MAX) 
)              
              
--*INSERT LIST*--                
INSERT INTO @ClientTreatmentTeamMembers(              
    ClientTreatmentTeamMemberId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,ClientId
	,StaffId
	,ClientContactId
	,MemberType
	,Active
	,StartDate
	,EndDate
	,FirstName
	,LastName
	,Suffix
	,TreatmentTeamRole
	,Email
	,Organization
	,Comments
)              
--*Select LIST*--                  
SELECT ClientTreatmentTeamMemberId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,ClientId
	,StaffId
	,ClientContactId
	,MemberType
	,Active
	,StartDate
	,EndDate
	,FirstName
	,LastName
	,Suffix
	,TreatmentTeamRole
	,Email
	,Organization
	,Comments        
from ClientTreatmentTeamMembers C               
where  C.ClientTreatmentTeamMemberId=@ScreenKeyId  and isnull(RecordDeleted,'N')<>'Y'                   
            

DECLARE @validationReturnTable TABLE        
(          
TableName varchar(200),              
ColumnName varchar(200),      
ErrorMessage varchar(1000),
ValidationOrder INT      
)           
Insert into @validationReturnTable        
(          
TableName,              
ColumnName,              
ErrorMessage,
ValidationOrder       
)              
              
Select 'ClientTreatmentTeamMembers', 'MemberType', 'Member Type is required',1           
FROM @ClientTreatmentTeamMembers         
WHERE MemberType is NULL         
        
Union          
Select 'ClientTreatmentTeamMembers', 'StartDate', 'Start Date is required',2             
FROM @ClientTreatmentTeamMembers         
WHERE StartDate is NULL        
        
--Union          
--Select 'ClientTreatmentTeamMembers', 'EndDate', 'End Date is required',3              
--FROM @ClientTreatmentTeamMembers         
--WHERE EndDate is NULL    

Union          
Select 'ClientTreatmentTeamMembers', 'FirstName', 'First Name is required',4              
FROM @ClientTreatmentTeamMembers         
WHERE FirstName is NULL AND MemberType='E'

Union          
Select 'ClientTreatmentTeamMembers', 'LastName', 'Last Name is required',5             
FROM @ClientTreatmentTeamMembers         
WHERE LastName is NULL AND MemberType='E'

Union          
Select 'ClientTreatmentTeamMembers', 'ClientContactId', 'Contact is required',6              
FROM @ClientTreatmentTeamMembers         
WHERE ClientContactId is NULL AND MemberType='C'

Union          
Select 'ClientTreatmentTeamMembers', 'StaffId', 'Staff is required',7              
FROM @ClientTreatmentTeamMembers         
WHERE StaffId is NULL AND MemberType='S'

Union          
Select 'ClientTreatmentTeamMembers', 'StaffId', 'End Date should be greater than or equal to start date',8              
FROM @ClientTreatmentTeamMembers         
WHERE CAST(EndDate AS Date)< CAST(StartDate AS Date)


        
Select TableName, ColumnName, ErrorMessage,ValidationOrder        
from @validationReturnTable  order by ValidationOrder       
        
IF Exists (Select * From @validationReturnTable)        
Begin         
 select 1  as ValidationStatus        
End        
Else        
Begin        
 Select 0 as ValidationStatus        
End        
          
              
end try                                                            
                                                                                            
BEGIN CATCH                
              
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_ValidateTreatmentTeam]')                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
END CATCH                                      
END                 
              
              
              
        
              
              
  
  