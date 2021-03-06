/****** Object:  UserDefinedFunction [dbo].[SCGetClientListForDxCategory]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientListForDxCategory]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SCGetClientListForDxCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientListForDxCategory]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  
-- =============================================  
-- Author:  <Author,Damanpreet>  
-- Create date: <Create Date, 28July2011>  
-- Description: <Description, To Get the List of Clients based on DxCategories and DxCategoryConditions>  
-- Called By :  ClientList page stored procedure [ssp_ListPageSCClientLists]  
-- =============================================  
CREATE FUNCTION [dbo].[SCGetClientListForDxCategory]  
(  
 @DiagnosisCategory int,  
 @DiagnosisCategoryCondition varchar(2),  
 @Text varchar(20)  
)  
RETURNS @DxCategoryClients TABLE (ClientId INT)  
AS  
BEGIN  
 DECLARE @ClientId INT  
   
if(@Text = ''ICDCodes'')  
 if @DiagnosisCategoryCondition = ''E''   
 Begin  
 Insert into @DxCategoryClients(ClientId)  
 select distinct(C.ClientId) from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DiagnosesIIICodes DC on DC.DocumentVersionId = DV.DocumentVersionId  AND DC.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 and  DC.ICDCode in(select ICDCode from DiagnosisCategoryCodes where DiagnosisCategory=@DiagnosisCategory) and  ISNULL(DC.RecordDeleted, ''N'') = ''N''    
  
 End  
   
 if @DiagnosisCategoryCondition = ''N''   
 Begin  
 Insert into @DxCategoryClients(ClientId)  
 select ClientId from Clients Cl   
 where  not exists (select distinct(C.ClientId) from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DiagnosesIIICodes DC on DC.DocumentVersionId = DV.DocumentVersionId  AND DC.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 and  DC.ICDCode in(select ICDCode from DiagnosisCategoryCodes where DiagnosisCategory=@DiagnosisCategory) and  ISNULL(DC.RecordDeleted, ''N'') = ''N'' and C.ClientId=Cl.ClientId)  
   
    End  
      
else if(@Text = ''DSMCodes'')   
    if @DiagnosisCategoryCondition = ''E''   
 Begin  
 Insert into @DxCategoryClients(ClientId)  
 select distinct(C.ClientId)from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DiagnosesIAndII DxIANDII on DxIANDII.DocumentVersionId = DV.DocumentVersionId  AND DxIANDII.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 and ISNULL(DxIANDII.RecordDeleted, ''N'') = ''N''  
 and DxIANDII.DSMCode in(select DSMCode from DiagnosisCategoryCodes where DiagnosisCategory=@DiagnosisCategory)  
 End  
   
 if @DiagnosisCategoryCondition = ''N''   
 Begin  
 Insert into @DxCategoryClients(ClientId)  
 select ClientId from Clients Cl   
 where  not exists (select distinct(C.ClientId)from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DiagnosesIAndII DxIANDII on DxIANDII.DocumentVersionId = DV.DocumentVersionId  AND DxIANDII.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 and ISNULL(DxIANDII.RecordDeleted, ''N'') = ''N''  
 and DxIANDII.DSMCode in(select DSMCode from DiagnosisCategoryCodes where DiagnosisCategory=@DiagnosisCategory)and C.ClientId=Cl.ClientId)   
    End  
    return  
END  ' 
END
GO
