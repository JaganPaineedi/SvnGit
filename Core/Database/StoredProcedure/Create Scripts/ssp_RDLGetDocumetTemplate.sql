IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_RDLGetDocumetTemplate]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_RDLGetDocumetTemplate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO   
            
CREATE PROCEDURE [dbo].[ssp_RDLGetDocumetTemplate] 
/*********************************************************************************/  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose:
--  
-- Author:  Vaibhav khare  
-- Date:    29 10 2011  
--  
-- *****History****  
/* 2012-09-21   Vaibhav khare  Created          */  

/* 2012-06-19 Vaibhav Modifie Date for DOB */
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
/*********************************************************************************/  
  
	 @DocumentVersionId as int        

   
AS  
BEGIN   
 
	  
	Select DS.ClientId,
	-- Modified by   Revathi   20 Oct 2015
	case when  ISNULL(CS.ClientType,'I')='I' then ISNULL(CS.LastName,'')+','+ISNULL(CS.FirstName,'') else ISNULL(CS.OrganizationName,'') end AS Clientname, 
	 S.LastName+', '+S.FirstName AS StaffName, PNCT.ModifiedBy ,CS.Sex,CONVERT(VARCHAR,CS.DOB,101) AS DOB,
	CONVERT(VARCHAR,PNCT.CreatedDate,101) + ' ' +  ltrim(substring(Convert(varchar(19), PNCT.CreatedDate,100),12,6))+' '+ ltrim(substring(Convert(varchar(19), PNCT.CreatedDate,100),18,2)) AS CreatedDate               
	,PNCT.RDLHTML as TemplateHTML ,(select OrganizationName from SystemConfigurations) as agency 
	,CONVERT(VARCHAR(10), ds.EffectiveDate, 101)  as EffectiveDate   
	from DocumentProgressNotes PNCT 
	JOIN  DocumentVersions DV  ON PNCT.DocumentVersionId=DV.DocumentVersionId  
	JOIN  documents  ds ON  DV.DocumentId=DS.DocumentId  
	JOIN  Clients CS ON DS.ClientId=CS.ClientId 
	JOIN Staff S ON DV.AuthorId=S.StaffId 

	where dv.DocumentVersionId= @DocumentVersionId 
 

END  