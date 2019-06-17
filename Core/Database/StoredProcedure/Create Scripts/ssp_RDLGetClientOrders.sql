IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLGetClientOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLGetClientOrders]
GO      
    
CREATE PROCEDURE [dbo].[ssp_RDLGetClientOrders]     
 (    
 @DocumentVersionId INT    
    
)    
AS    
/******************************************************************************************     
  Created By   : Pabitra [ssp_RDLGetClientOrders] 1116296           
  Created Date : 13 June 2017             
  Description  : To get the orders          
  Called From  :ClientOrderUserControl.ashx       
    Date			Author          Description           
    08/21/2017		Pabitra         Texas Customizations#104  
    11/07/2017		Pabitra			Engineering Improvement Initiatives- NBL(I)#585 
    05/03/2018		Chethan N		What : Retrieving ClinicalLocation.
									Why : Engineering Improvement Initiatives- NBL(I) task #585. 
	03/07/2018		Chethan N		What : Added new column LocationId to ClientOrders table.
									Why : Engineering Improvement Initiatives- NBL(I)  task #667 
	05/Nov/2018     Irfan			What: Added condition to avoid populating of Rx Order
									Why: It was displaying multiple pages of "Rx Order" in Client Orders section on the PDF of Psychiatric Note as part of
										 PEP - Support Go Live: #70		
	14/11/2018		Neha     		What : Added 2 new columns 'Frequency' and 'Start Date' to ClientOrders Grid.
									Why : Engineering Improvement Initiatives- NBL(I)  task #713 									 							              
******************************************************************************************/     
BEGIN    
 BEGIN TRY    
       DECLARE @ClientId int      
  SELECT TOP 1     
  @ClientId=d.ClientId    
  From Documents d Join DocumentVersions dv ON Dv.DocumentId=d.DocumentId    
  Where dv.DocumentVersionId  =@DocumentVersionId    
        
   CREATE TABLE #Diagnosis (    
 ClientOrderId INT    
 ,DiagnosisName VARCHAR(max)    
 ) 
 
 INSERT INTO #Diagnosis     
 SELECT     
   D.ClientOrderId,(ICDCode + ' - ' + D.[Description]) AS DiagnosisName         
  FROM ClientOrders AS CO    
  LEFT JOIN Orders O ON O.OrderId=CO.OrderId  AND ISNULL(O.RecordDeleted, 'N') = 'N'       
 LEFT JOIN ClientOrdersDiagnosisIIICodes D ON D.ClientOrderId=CO.ClientOrderId  AND ISNULL(D.RecordDeleted, 'N') = 'N'      
  WHERE CO.ClientId=@ClientID AND ISNULL(CO.RecordDeleted,'N') = 'N'   
  
    SELECT     
    CO.ClientOrderId  AS GridClientOrderId          
   ,CO.CreatedBy           
   ,CO.CreatedDate           
   ,CO.ModifiedBy           
   ,CO.ModifiedDate          
   ,CO.RecordDeleted        
   ,CO.DeletedBy           
   ,CO.DeletedDate           
   ,O.OrderName  
   ,O.OrderId             
   ,L.LaboratoryName AS LabsName  
   ,L.LaboratoryId  AS LabId    
   ,REPLACE(REPLACE(STUFF(      
     (SELECT Distinct ', ' + QE.DiagnosisName    
     From #Diagnosis QE     
     Where  CO.ClientOrderId = QE.ClientOrderId                  
     FOR XML PATH(''))      
     ,1,1,'')      
     ,'&lt;','<'),'&gt;','>') AS DiagnosisName
	,LO.LocationCode AS ClinicalLocation  
	,OTF.DisplayName AS FrequencyName
	,CONVERT(VARCHAR(10), CO.OrderStartDateTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, CO.OrderStartDateTime, 100), 7)  AS StartDate    
  FROM ClientOrders AS CO          
  JOIN Orders O ON O.OrderId=CO.OrderId  AND ISNULL(O.RecordDeleted, 'N') = 'N'
  LEFT JOIN Laboratories AS L ON L.LaboratoryId = CO.LaboratoryId  AND ISNULL(L.RecordDeleted, 'N') = 'N' -- AND O.EMNoteOrder='Y'    
  LEFT JOIN Locations LO ON LO.LocationId = CO.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'  
  LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId  
  JOIN  Documents AS D ON D.InProgressDocumentVersionId = @DocumentVersionId
  WHERE (CO.DocumentVersionId = @DocumentVersionId OR
  (CO.ClientId = @ClientId AND CO.OrderType <> 'Labs' AND D.DocumentCodeId NOT IN (1653)))
      AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
							AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
							AND R.IntegerCodeId = O.OrderId ))
    AND ISNULL(CO.RecordDeleted, 'N') = 'N' 
      
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLGetClientOrders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                      
    16    
    ,-- Severity.                                                                                                      
    1 -- State.                                                                                                      
    );    
 END CATCH    
END    