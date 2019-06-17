  
  
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_RDLDFAReportHTML]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_RDLDFAReportHTML]
END
Go       
CREATE PROCEDURE ssp_RDLDFAReportHTML   
@DocumentVersionId INT        
AS  
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_GetDFAReportHTML            */                  
/* Copyright:             */                  
/* Creation Date:  12-06-2017                                  */                  
/*                                                                   */                  
/* Purpose: RDL SP          */                 
/*                                                                   */                
/* Input Parameters:       */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return: */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*  Date          Author      Purpose                                    */                  
/* 06/12/2017   Rajesh S      Created                                    */  
/* 10/11/2017	jcarlson		added logic to return ClientName,DOB,ClientId,EffectiveDate,DocumentName,OrganizationName         */  
/*********************************************************************/      
BEGIN        

Declare @OrgName varchar(max) 
select @OrgName = a.AgencyName
from dbo.Agency as a
        
SELECT       
a.CreatedBy      
,a.CreatedDate      
,a.ModifiedBy      
,a.ModifiedDate      
,a.RecordDeleted      
,a.DeletedDate      
,a.DeletedBy      
,a.DocumentVersionId      
,a.DocumentRDLHTML      
, @OrgName as OrganizationName
, c.FirstName + ' ' + c.LastName as ClientName
, c.ClientId as ClientId
, d.EffectiveDate
, convert(varchar(10),c.DOB,101) as DOB
, dc.DocumentName
FROM DocumentRDLHTMLs as a
Join DocumentVersions as dv on a.DocumentVersionId = dv.DocumentVersionId
Join Documents as d on dv.DocumentId = d.DocumentId
JOin Clients as c on d.ClientId = c.ClientId
Join Documentcodes as dc on d.DocumentCodeId = dc.DocumentcodEId
WHERE a.DocumentVersionId = @DocumentVersionId      
        
        
      
END    
  
  



