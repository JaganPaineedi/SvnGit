
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMGetFileDetails]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetFileDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[ssp_PMGetFileDetails]                                
 @ERFileId int,                                          
 @Processed char                                                                                   
As                                                                                              
                                                                                                      
Begin                                                                                                      
    
/******************************************************************************     
** File: ssp_PMGetFileDetails.sql    
** Name: ssp_PMGetFileDetails    
** Desc:      
**     
**     
** This template can be customized:     
**     
** Return values: Filter Values -  Electronic Remittance    
**     
** Called by:     
**     
** Parameters:     
** Input Output     
** ---------- -----------     
** N/A   Dropdown values    
** Auth: Mary Suma    
** Date: 09/23/2011    
*******************************************************************************     
** Change History     
*******************************************************************************     
** Date:    Author:    Description:     
** 09/23/2011  Mary Suma   Query to return values for Electronic Remittance    
--------    --------    ---------------     
** 09/27/2011  Mary Suma   Replaced * with column names    
** 08/10/2012  Mary Suma   Removed Segments for Performance and truncate TExt to 550 - handled in code
**01/20/2018   Deej		   Adding two more columns in ERFiles table selection 
*******************************************************************************/    
BEGIN TRY                                       
  SELECT     
    ERFileId,    
    FileName,  
    ImportDate,   
    SUBSTRING(FileText,0,550) AS FileText ,    
    --FileText,
    ERSenderId,    
    ApplyAdjustments,    
    ApplyTransfers,    
    TotalPayments,    
    Processed,    
    DoNotProcess,    
    Processing,    
    ProcessingStartTime,    
    RowIdentifier,    
    CreatedBy,    
    CreatedDate,    
    ModifiedBy,    
    ModifiedDate,    
    RecordDeleted,    
    DeletedDate,    
    DeletedBy,
	AccountingPeriodId,
	PaymentDate     
  FROM ERFiles WHERE ERFileID= @ERFileId AND ISNULL(Processed,'N') = @Processed  AND ISNULL(RecordDeleted,'N') = 'N'                                                  
               
  SELECT top 1 ERF.ERFileID,ERS.SenderName,ERS.SenderID,ERS.SegmentDelimiter,ERS.ElementDelimiter,                                                             
  CASE ISNULL(PA.PayerName ,'N')                                      
     WHEN 'N' THEN ''                                                                   
     ELSE PA.PayerName                                                                                          
    END                                                                                
   +                                                             
    CASE ISNULL(PL.CoveragePlanName,'N')                                                                  
    WHEN 'N' THEN ''                                                   
    ELSE  '-' + PL.CoveragePlanName                                                
   END AS  PayerPlanName,                                                    
  ERF.ImportDate,ERF.ApplyAdjustments,ERF.ApplyTransfers,ERF.Processed,ERF.DoNotProcess,ERF.Processing,ERF.ProcessingStartTime,ERB.PaymentID,PAY.Amount,ERF.FileText FROM ERFiles ERF INNER JOIN                                                               
  
    
  ERSenders ERS ON ERF.ERSenderID=ERS.ERSenderID  AND ISNULL(ERS.RecordDeleted,'N') = 'N'                                                                
  LEFT JOIN Payers PA ON ERS.PayerId=PA.PayerId  AND ISNULL(PA.RecordDeleted,'N') = 'N'                                                                     
  LEFT JOIN CoveragePlans PL ON ERS.PlanId=PL.CoveragePlanId  AND ISNULL(PL.RecordDeleted,'N') = 'N'                                                         
  LEFT JOIN ERBatches ERB ON ERB.ERFileID=ERF.ERFileID AND ISNULL(ERB.RecordDeleted,'N') = 'N'                                                           
  LEFT JOIN Payments PAY ON PA.PayerId = PAY.PayerId  AND ISNULL(PAY.RecordDeleted,'N') = 'N'                                                                 
  WHERE  ERF.ERFileID= @ERFileId AND ISNULL(ERF.Processed,'N') =@Processed AND ISNULL(ERF.RecordDeleted,'N') = 'N'                                                                              
                                                   
                                              
                            
  SELECT     
    ERFileParsingErrorId,    
    ERFileParsingErrors.ERFileId,    
    ERFileParsingErrors.ERFileSegmentId,    
    ERFileParsingErrors.LineNumber,    
    ErrorMessage,    
    LineDataText,    
    ERFileParsingErrors.RowIdentifier,    
    ERFileParsingErrors.CreatedBy,    
    ERFileParsingErrors.CreatedDate,    
    ERFileParsingErrors.ModifiedBy    
   FROM ERFileParsingErrors                              
    INNER JOIN ERFileSegments ON ERFileSegments.ERFileSegmentId=ERFileParsingErrors.ERFileSegmentId                            
    WHERE ERFileSegments.ErFileId=@ERFileId AND  ISNULL(ERFileParsingErrors.RecordDeleted,'N') = 'N'                            
        
                 
  ---PaymentDetails   AND  FinancialActivityID                  
       SELECT PA.PaymentId,PA.Amount,PA.UnPostedAmount,FinancialActivityID FROM Payments PA    RIGHT JOIN ERBatches ERB ON ERB.PaymentId=PA.PaymentId     
  --Check Details
       SELECT ERBatchId,
       CONVERT(varchar(15),ERBatchId)+  ' - ' + CONVERT(varchar(15),CheckAmount) + ' - '+ CONVERT(varchar(15),CheckNumber) AS CheckDetails,PaymentId,ERFileId FROM ERBatches WHERE ISNULL(Recorddeleted,'N')='N'                             
            
          
                                 
                  
    
 END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMGetFileDetails')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED     
    
END    
            
GO
         