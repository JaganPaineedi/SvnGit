/****** Object:  StoredProcedure [dbo].[ssp_InquiryClientInformation]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InquiryClientInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InquiryClientInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InquiryClientInformation]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InquiryClientInformation]         
 @ClientId INT ,        
 @InquiryId  INT = Null        
AS          
          
/********************************************************************************          
 *    Initial Registration - Inquiry - Client Information          
 *              
 * Purpose: Get client information for inquiry screen          
           
 * Author: Rk,Jeff Riley                 
 * Created: 09/19/2011                 
 * Task:    THRESHOLDSOFF1 - Development Phase I(Offshore) - Task # 7          
 *           
 * Modified By   Date Modified  Reason          
 * ------------------------------------------------------------------------------          
 * Pralyankar  March 28, 2012  Modified for changing Label "Marst Id" to "Client Id". and Added new Parameter InquiryId.        
 ** 08 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations.          
      
  ********************************************************************************/          
          
BEGIN                                                             
 BEGIN TRY           
           
DECLARE @ClientInfo varchar(max)          
DECLARE @LastInquiryDate datetime          
          
-- Member ID --------------------------------------------------------------------          
SET @ClientInfo = 'Client Id: ' + CAST(@ClientId AS varchar) + '\r\n'          
--SET @ClientInfo = 'Member Id: ' + CAST(@ClientId AS varchar) + '\r\n'          
          
-- Last Inquiry Date ------------------------------------------------------------          
IF isnull(@InquiryId,0) >0        
BEGIN        
 SET @LastInquiryDate = (SELECT MAX(ci.InquiryStartDateTime)          
      FROM Inquiries ci          
      WHERE ci.ClientId = @ClientId AND ci.InquiryId <> @InquiryId)          
END        
ELSE        
BEGIN        
 SET @LastInquiryDate = (SELECT MAX(ci.InquiryStartDateTime)          
      FROM Inquiries ci          
      WHERE ci.ClientId = @ClientId)          
END        
SET @ClientInfo = @ClientInfo + 'Last Inquiry Date: '          
          
-- Only append @LastInquiryDate if it is not null          
IF @LastInquiryDate IS NOT NULL          
 SET @ClientInfo = @ClientInfo + CONVERT(VARCHAR(20),@LastInquiryDate,1)          
           
-- Add newlines          
SET @ClientInfo = @ClientInfo + '\r\n' + '\r\n'          
           
-- Client Episode Information ---------------------------------------------------          
SELECT @ClientInfo = @ClientInfo +           
      'Episode ' +           
      CONVERT(VARCHAR(3),ce.EpisodeNumber) + '\r\n' +          
      'Opened: ' +           
      CASE WHEN ce.InitialRequestDate IS NOT NULL THEN CONVERT(VARCHAR(20),ce.InitialRequestDate,1) ELSE '' END +          
      '    Discharged: ' +           
      CASE WHEN ce.DischargeDate IS NOT NULL THEN CONVERT(VARCHAR(20),ce.DischargeDate,1) ELSE '' END +          
      '\r\n' + '\r\n'          
FROM ClientEpisodes ce          
WHERE ce.ClientId = @ClientId AND          
      ISNULL(ce.RecordDeleted,'N') = 'N'          
ORDER BY ce.EpisodeNumber DESC          
                
-- Coverage History Information-------------------------------------------------          
DECLARE @TempStartDate datetime          
DECLARE @TempEndDate datetime          
DECLARE @TempDisplayAs varchar(20)          
          
-- Add coverage history heading          
SET @ClientInfo = @ClientInfo + 'Coverage History' + '\r\n'          
          
IF (SELECT COUNT(1)          
 FROM Clients c          
 LEFT JOIN ClientCoveragePlans ccp on ccp.ClientId = c.ClientId          
 LEFT JOIN ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId          
 LEFT JOIN CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId          
 WHERE c.ClientId = @ClientId AND          
  cch.StartDate IS NOT NULL) > 0          
BEGIN          
          
DECLARE CoverageHistoryCursor CURSOR FOR          
SELECT cch.StartDate, cch.EndDate          
FROM Clients c          
LEFT JOIN ClientCoveragePlans ccp on ccp.ClientId = c.ClientId          
LEFT JOIN ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId          
LEFT JOIN CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId          
WHERE c.ClientId = @ClientId AND          
      cch.StartDate IS NOT NULL          
GROUP BY cch.StartDate, cch.EndDate          
ORDER BY cch.StartDate DESC          
OPEN CoverageHistoryCursor          
          
-- Get first Coverage History record          
FETCH NEXT FROM CoverageHistoryCursor          
INTO @TempStartDate,@TempEndDate          
          
-- Loop thru each Coverage History record          
WHILE @@FETCH_STATUS = 0          
 BEGIN          
           
  -- Add time period information          
  SET @ClientInfo = @ClientInfo +           
        CASE WHEN @TempStartDate IS NOT NULL THEN CONVERT(varchar(20),@TempStartDate,1) ELSE '' END +           
        ' - ' +           
        CASE WHEN @TempEndDate IS NOT NULL THEN CONVERT(varchar(20),@TempEndDate,1) ELSE 'Present' END          
  SET @ClientInfo = @ClientInfo + '\r\n'          
           
  -- Get all Coverage plans for the time period          
  DECLARE CoverageNameCursor CURSOR FOR          
  SELECT cp.DisplayAs          
  FROM CoveragePlans cp          
  LEFT JOIN ClientCoveragePlans ccp on ccp.CoveragePlanId = cp.CoveragePlanId          
  LEFT JOIN ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId          
  WHERE ccp.ClientId = @ClientId AND          
      cch.StartDate = @TempStartDate AND          
        (cch.EndDate = @TempEndDate OR          
         cch.EndDate IS NULL)          
  ORDER BY cch.COBOrder DESC          
  OPEN CoverageNameCursor          
            
  -- Get first coverage name record          
  FETCH NEXT FROM CoverageNameCursor          
  INTO @TempDisplayAs          
            
  -- Loop thru each coverage plan name          
  WHILE @@FETCH_STATUS = 0          
   BEGIN          
    -- Append coverage plan name          
    SET @ClientInfo = @ClientInfo + @TempDisplayAs + '\r\n'          
              
    -- Get next coverage plan name          
    FETCH NEXT FROM CoverageNameCursor          
    INTO @TempDisplayAs          
   END          
            
  CLOSE CoverageNameCursor          
  DEALLOCATE CoverageNameCursor          
            
  -- Add newline to separate time period info          
  SET @ClientInfo = @ClientInfo + '\r\n'          
            
  -- Get next Coverage History record          
  FETCH NEXT FROM CoverageHistoryCursor          
  INTO @TempStartDate,@TempEndDate          
            
 END          
          
CLOSE CoverageHistoryCursor          
DEALLOCATE CoverageHistoryCursor          
          
END          
ELSE          
 SET @ClientInfo = @ClientInfo + 'No Coverage History'          
          
SELECT @ClientInfo          
PRINT @ClientInfo          
           
 END TRY                                                
 BEGIN CATCH                             
 DECLARE @Error varchar(8000)                                                                              
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InquiryClientInformation')                                                    
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                
    + '*****' + Convert(varchar,ERROR_STATE())                                                                              
                                                            
    RAISERROR                                                                               
    (                                             
  @Error, -- Message text.                                                                              
  16, -- Severity.                                                                              
  1 -- State.                                                                              
    );                                                               
 End CATCH                                                                                                                     
                                                         
End
GO  