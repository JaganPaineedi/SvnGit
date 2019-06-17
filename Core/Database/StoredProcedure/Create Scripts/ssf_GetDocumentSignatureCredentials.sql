IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'ssf_GetDocumentSignatureCredentials') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION ssf_GetDocumentSignatureCredentials
GO
 
 CREATE FUNCTION [dbo].[ssf_GetDocumentSignatureCredentials] (@StaffId int,@DocumentVersionId int) returns varchar(500)    
  
/*********************************************************************/  
/* Function: dbo.ssf_GetDocumentSignatureCredentials                                     */  
/* Creation Date:   12/12/2012                                     */  
/*                                                                  */  
/* Purpose: Simple function to get a combined valid degree        */  
/*          with coma seperated for staff id.                       */  
/* Input Parameters:               */  
/* @incoming int             */  
/*                                                                  */  
/* Returns:               */  
/* varchar(500)               */  
/*                                                                  */  
/*                                                                  */  
/* Updates:                                                         */  
/*   Date     Author      Purpose                                   */  
/*  07/09/2018  Veena     Created from csf_GetDocumentSignatureCredentials A Renewed Mind - Support #917       */  
/*********************************************************************/  
as    
begin    
    
 declare @Result varchar(max)  
  
SELECT   @Result=COALESCE(@Result + ', ', '') + GlobalCodes.CodeName  
FROM         DocumentSignatureCredentials INNER JOIN  
                      DocumentSignatures ON DocumentSignatureCredentials.SignatureId = DocumentSignatures.SignatureId INNER JOIN  
                      DocumentVersions ON DocumentSignatures.SignedDocumentVersionId = DocumentVersions.DocumentVersionId INNER JOIN  
                      GlobalCodes ON DocumentSignatureCredentials.Degree = GlobalCodes.GlobalCodeId  
                      WHERE DocumentVersions.DocumentVersionId = @DocumentVersionId and DocumentSignatures.StaffId = @StaffId  
                        
  If(@Result IS NULL)  
  SELECT   @Result=COALESCE(@Result + ', ', '') +  GC.CodeName  
    FROM Staff S   
    JOIN StaffLicenseDegrees SLD on SLD.StaffId = S.StaffId  
    JOIN GlobalCOdes GC on GC.GlobalCOdeId = SLD.LicenseTypeDegree   
    WHERE S.StaffID = @StaffId AND  
          ISNULL(SLD.RecordDeleted,'N')='N' and  ISNULL(GC.RecordDeleted,'N')='N' and   
          CAST(CONVERT(VARCHAR(10), SLD.StartDate, 101) AS DATETIME) <= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME)    
          and CAST(ISNULL(CONVERT(VARCHAR(10), SLD.EndDate, 101),  
          '12/31/2299') AS DATETIME) >= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME)  
             
 return  ' , '+ @Result  
end 