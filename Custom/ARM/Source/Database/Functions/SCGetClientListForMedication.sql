/****** Object:  UserDefinedFunction [dbo].[SCGetClientListForMedication]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientListForMedication]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SCGetClientListForMedication]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetClientListForMedication]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  
  
-- =============================================  
-- Author:  <Author,Damanpreet>  
-- Create date: <Create Date, 27July2011>  
-- Description: <Description, To Get the List of Clients based on Medication>  
-- Called By :  ClientList page stored procedure [ssp_ListPageSCClientLists]  
-- =============================================  
CREATE FUNCTION [dbo].[SCGetClientListForMedication]  
(  
 @MedicationId int,  
 @Text varchar(20),  
 @MedicationCondition varchar(2)  
)  
RETURNS @MedicationClients TABLE (ClientId INT)  
AS  
BEGIN  
 DECLARE @ClientId INT  
   
 if(@Text = ''Id'')  
 begin  
  if @MedicationCondition = ''E''   
  Begin  
  Insert into @MedicationClients(ClientId)  
  select distinct(C.ClientId) from Clients C   
  Inner Join ClientMedications CM on C.ClientId = CM.ClientId and ISNULL(CM.RecordDeleted, ''N'')=''N''  
  --Inner Join MedicationCategoryMedicationNames MCMN on MCMN.MedicationNameId = CM.MedicationNameId  
  and CM.Discontinued =''N'' and ISNULL(C.RecordDeleted, ''N'')=''N''  
  AND CM.MedicationNameId = @MedicationId  
  End  
  ELSE IF(@MedicationCondition = ''N'' )  
  BEGIN  
  Insert into @MedicationClients(ClientId)  
  select distinct(C1.ClientId) from Clients C1   
  WHERE NOT EXISTS(select distinct(C.ClientId) from Clients C   
  Inner Join ClientMedications CM on C.ClientId = CM.ClientId and ISNULL(CM.RecordDeleted, ''N'')=''N''  
  --Inner Join MedicationCategoryMedicationNames MCMN on MCMN.MedicationNameId = CM.MedicationNameId  
  and CM.Discontinued =''N'' and ISNULL(C.RecordDeleted, ''N'')=''N''  
  AND CM.MedicationNameId = @MedicationId)  
  END  
 end  
   
   
 ELSE IF(@Text = ''Category'')  
 begin  
  if @MedicationCondition = ''E''   
  Begin  
  Insert into @MedicationClients(ClientId)  
  select distinct(C.ClientId) from Clients C   
  Inner Join ClientMedications CM on C.ClientId = CM.ClientId and ISNULL(CM.RecordDeleted, ''N'')=''N''  
  Inner Join MedicationCategoryMedicationNames MCMN on MCMN.MedicationNameId = CM.MedicationNameId  
  and CM.Discontinued =''N'' and ISNULL(C.RecordDeleted, ''N'')=''N''  
  AND MCMN.MedicationCategory = @MedicationId  
  End  
  ELSE IF(@MedicationCondition = ''N'' )  
  BEGIN  
  Insert into @MedicationClients(ClientId)  
  select distinct(C1.ClientId) from Clients C1   
  WHERE NOT EXISTS(select distinct(C.ClientId) from Clients C   
  Inner Join ClientMedications CM on C.ClientId = CM.ClientId and ISNULL(CM.RecordDeleted, ''N'')=''N''  
  Inner Join MedicationCategoryMedicationNames MCMN on MCMN.MedicationNameId = CM.MedicationNameId  
  and CM.Discontinued =''N'' and ISNULL(C.RecordDeleted, ''N'')=''N''  
  AND MCMN.MedicationCategory = @MedicationId)  
  END  
 end  
    Return   
END  ' 
END
GO
