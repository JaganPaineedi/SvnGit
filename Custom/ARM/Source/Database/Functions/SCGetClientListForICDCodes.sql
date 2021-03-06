/****** Object:  UserDefinedFunction [dbo].[SCGetClientListForICDCodes]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientListForICDCodes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SCGetClientListForICDCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientListForICDCodes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  
-- =============================================  
-- Author:  <Author,Damanpreet>  
-- Create date: <Create Date, 27July2011>  
-- Description: <Description, To Get the List of Clients based on DxCodes and DxConditions>  
-- Called By :  ClientList page stored procedure [ssp_ListPageSCClientLists]  
-- =============================================  
CREATE FUNCTION [dbo].[SCGetClientListForICDCodes]  
(  
 @ICDCode varchar(6),  
 @DiagnosisCondition varchar(2),  
 @Text varchar(20)  
)  
RETURNS @DiagnosisClients TABLE (ClientId INT)  
AS  
BEGIN  
 DECLARE @ClientId INT  
   
if(@Text = ''ICDCodes'')  
 if @DiagnosisCondition = ''E''   
 Begin  
 Insert into @DiagnosisClients(ClientId)  
 select distinct(C.ClientId) from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DiagnosesIIICodes DC on DC.DocumentVersionId = DV.DocumentVersionId  AND DC.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 and  DC.ICDCode = @ICDCode and  ISNULL(DC.RecordDeleted, ''N'') = ''N''    
  
 End  
   
 if @DiagnosisCondition = ''N''   
 Begin  
 Insert into @DiagnosisClients(ClientId)  
 select ClientId from Clients Cl   
 where  not exists (select distinct(C.ClientId) from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''     
 INNER JOIN DiagnosesIIICodes DC on DC.DocumentVersionId = DV.DocumentVersionId  AND DC.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 and  DC.ICDCode = @ICDCode and  ISNULL(DC.RecordDeleted, ''N'') = ''N'' and C.ClientId=Cl.ClientId)  
   
    End  
      
else if(@Text = ''DSMCodes'')   
    if @DiagnosisCondition = ''E''   
 Begin  
 Insert into @DiagnosisClients(ClientId)  
 select distinct(C.ClientId)from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DiagnosesIAndII DxIANDII on DxIANDII.DocumentVersionId = DV.DocumentVersionId  AND DxIANDII.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 Inner Join DiagnosisDSMCodes DDC on DxIANDII.DSMCode=DDC.DSMCode and  ISNULL(DxIANDII.RecordDeleted, ''N'') = ''N''  
 and DDC.ICDCode = @ICDCode  
 End  
   
 if @DiagnosisCondition = ''N''   
 Begin  
 Insert into @DiagnosisClients(ClientId)  
 select ClientId from Clients Cl   
 where  not exists (select distinct(C.ClientId)from Clients C   
 INNER JOIN Documents D on  C.ClientId = D.ClientId and  ISNULL(D.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DocumentVersions DV on  D.CurrentDocumentVersionId = DV.DocumentVersionId  and  ISNULL(DV.RecordDeleted, ''N'') = ''N''  
 INNER JOIN DiagnosesIAndII DxIANDII on DxIANDII.DocumentVersionId = DV.DocumentVersionId  AND DxIANDII.DocumentVersionId = dbo.SCGetClientLatestDiagnosisDocumentVersionId(C.ClientId)   
 Inner Join DiagnosisDSMCodes DDC on DxIANDII.DSMCode=DDC.DSMCode and  ISNULL(DxIANDII.RecordDeleted, ''N'') = ''N''  
 and DDC.ICDCode = @ICDCode and C.ClientId=Cl.ClientId)   
    End  
  
      
    Return   
END  ' 
END
GO
