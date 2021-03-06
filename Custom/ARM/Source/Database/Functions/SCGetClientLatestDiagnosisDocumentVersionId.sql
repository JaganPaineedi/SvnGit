/****** Object:  UserDefinedFunction [dbo].[SCGetClientLatestDiagnosisDocumentVersionId]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientLatestDiagnosisDocumentVersionId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SCGetClientLatestDiagnosisDocumentVersionId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientLatestDiagnosisDocumentVersionId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  
-- =============================================  
-- Author:  <Author,Shifali>  
-- Create date: <Create Date, 27July2011>  
-- Description: <Description, To Get the Latest Diagnosis DocumentVersionId for a Client>  
-- Called By :  ClientList page stored procedure [ssp_ListPageSCClientLists]  
-- =============================================  
CREATE FUNCTION [dbo].[SCGetClientLatestDiagnosisDocumentVersionId]  
(  
 @ClientId INT  
)  
RETURNS INT  
AS  
BEGIN  
 DECLARE @DocumentVersionId INT  
 SELECT TOP 1 @DocumentVersionId = D.CurrentDocumentVersionId                                                                 
 FROM Documents D WHERE D.ClientId = @ClientId                                                                  
 and D.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101))                                                                 
 and D.Status = 22                                                                                                  
 and D.DocumentCodeId =5                                                                 
 and ISNULL(D.RecordDeleted,''N'')<>''Y''                                                                 
 ORDER BY D.EffectiveDate DESC,ModifiedDate DESC   
 Return @DocumentVersionId  
END  ' 
END
GO
