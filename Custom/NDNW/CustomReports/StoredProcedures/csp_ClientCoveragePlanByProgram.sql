If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.csp_ClientCoveragePlanByProgram') 
                  And Type In ( N'P', N'PC' )) 
	Drop Procedure dbo.csp_ClientCoveragePlanByProgram
Go

Set Ansi_Nulls On
Set Quoted_Identifier On
Go

/*********************************************************************************             
**  File: csp_ClientCoveragePlanByProgram.sql 
**  Name: csp_ClientCoveragePlanByProgram 
**  Desc: This report list all clients and coverage plans for each program.
**                   
**  Created By:  Paul Ongwela 
**  Date:		 October 28, 2015 
**
...............................................................................                  
..  Change History                   
...............................................................................                  
..  Date:		Author:				Description:                   
..  --------	--------			-------------------------------------------    
..  10/28/2015  Paul Ongwela        Created.
..
..
**********************************************************************************/

Create Procedure dbo.csp_ClientCoveragePlanByProgram
	 @CoveragePlanId Int
	,@ClientId Int
	,@ProgramId Int

As

Begin

-- Set NoCount On added to prevent extra result sets from interfering with
-- statements such as SELECT, INSERT, UPDATE, and DELETE... 
Set NoCount On;

With Report As (
	Select p.ProgramId
		  ,p.ProgramCode As ProgramName
		  ,c.LastName + ', ' + c.FirstName As ClientName
		  ,Coalesce(ccp.ClientId,cpg.ClientId) As ClientID
		  , cp.CoveragePlanId
		  , cp.DisplayAs As CoveragePlan
		  , ccp.ClientCoveragePlanId
		  ,ROW_NUMBER() OVER(PARTITION BY p.ProgramCode, c.LastName + ', ' + c.FirstName, Coalesce(ccp.ClientId,cpg.ClientId)
			ORDER BY p.ProgramCode, c.LastName + ', ' + c.FirstName) AS PlanNo
	From Programs p
		Left Join ClientPrograms cpg On p.ProgramId = cpg.ProgramId
			And IsNull(cpg.RecordDeleted,'N')='N'
		Left Join Clients c On cpg.ClientId = c.ClientId
			And IsNull(c.RecordDeleted,'N')='N'
		Left Join ClientCoveragePlans ccp On c.ClientId = ccp.ClientId
			And IsNull(ccp.RecordDeleted,'N')='N'
		Left Join CoveragePlans cp On ccp.CoveragePlanId = cp.CoveragePlanId
			And IsNull(cp.RecordDeleted,'N')='N'
	Where IsNull(p.RecordDeleted,'N')='N'
		And (@ProgramId Is Null Or @ProgramId = p.ProgramId)
		And (@CoveragePlanId Is Null Or @CoveragePlanId = cp.CoveragePlanId)
		And (@ClientId Is Null Or @ClientId = c.ClientId)
	Group By p.ProgramId, p.ProgramCode
		  ,c.LastName + ', ' + c.FirstName 
		  ,Coalesce(ccp.ClientId,cpg.ClientId)
		  , cp.CoveragePlanId, cp.DisplayAs 
		  , ccp.ClientCoveragePlanId
)
Select ProgramName, ClientName, ClientId, CoveragePlan
From Report
where PlanNo < 5

End

Go
