/****** Object:  StoredProcedure [dbo].[ssp_PMDashboardARSelClaimsNotYetBilledbyPayer]    Script Date: 11/18/2011 16:25:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMDashboardARSelClaimsNotYetBilledbyPayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMDashboardARSelClaimsNotYetBilledbyPayer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  

CREATE  Procedure [dbo].[ssp_PMDashboardARSelClaimsNotYetBilledbyPayer]
(
	@StaffId INT,
	@DOS Varchar(10)
)  
   
AS  
 BEGIN                                                              
	BEGIN TRY    
	/******************************************************************************    
		**  File: dbo.ssp_PMDashboardARSelClaimsNotYetBilledbyPayer.prc    
		**  Name: dbo.ssp_PMDashboardARSelClaimsNotYetBilledbyPayer    
		**  Desc: This SP returns the data required by dashboard  for Claims Not Yet Billed 
		**    
		**  This template can be customized:    
		**                  
		**  Return values:    
		**     
		**  Called by:       
		**                  
		**  Parameters:    
		**  Input       Output    
		**     ----------       -----------    
		**    
		**  Auth: Veena Mani 
		**  Date: 09/06/2015   
		*******************************************************************************    
		**  Change History    
		*******************************************************************************    
		**  Date:     Author:     Description:    
		**  --------  --------    -------------------------------------------    
		*******************************************************************************/  
 
				DECLARE @local_StaffId INT,
                @local_DOS   VARCHAR(10)
                
                SET @local_StaffId = @StaffId
                SET @local_DOS = @DOS 
                
CREATE TABLE #T1 ([Id] INT  IDENTITY (1, 1),  
PayerId INT,PayerName VARCHAR(50), [0-30] MONEY DEFAULT 0,[31-60] MONEY DEFAULT 0,  
[61-90] MONEY DEFAULT 0, [91-120] MONEY DEFAULT 0,[121-150] MONEY DEFAULT 0,[151-180] MONEY DEFAULT 0,  
[181-365] MONEY DEFAULT 0,[>1 Year] MONEY DEFAULT 0,Total MONEY DEFAULT 0,Filter VARCHAR(10) DEFAULT 'DOS')  
  
  
declare @CurrentDate datetime  
  
select @CurrentDate = convert(datetime, convert(varchar, getdate(), 101))  
  

  
insert into #T1 (  
       PayerId,  
       PayerName,  
       [0-30],  
       [31-60],  
       [61-90],  
       [91-120],  
       [121-150],  
       [151-180],  
       [181-365],  
       [>1 Year],  
       Total,  
       Filter)         
select d.PayerId, d.PayerName,  
[0-30] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) <= 30 then a.Balance else 0 end),  
[31-60] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 31 and 60 then a.Balance else 0 end),  
[61-90] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 61 and 90 then a.Balance else 0 end),  
[91-120] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 91 and 120 then a.Balance else 0 end),  
[121-150] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 121 and 150 then a.Balance else 0 end),  
[151-180] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 151 and 180 then a.Balance else 0 end),  
[181-365] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 181 and 365 then a.Balance else 0 end),  
[>1 Year] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) > 365 then a.Balance else 0 end),  
Total=sum(a.Balance),  
'DOS'  
FROM OpenCharges a  
JOIN Charges b				ON (a.ChargeId = b.ChargeId)							
	AND ISNULL(b.RecordDeleted,'N')='N'   
JOIN ClientCoveragePlans h	ON (b.ClientCoveragePlanId = h.ClientCoveragePlanId)  
	AND ISNULL(h.RecordDeleted,'N')='N'   
JOIN CoveragePlans c		ON  (h.CoveragePlanId = c.CoveragePlanId)  
	AND ISNULL(c.RecordDeleted,'N')='N'   
JOIN Services g				ON (b.ServiceId = g.ServiceId)  
	AND ISNULL(g.RecordDeleted,'N')='N'   
--Included to Fix Amounts
JOIN Clients cl				ON (cl.ClientId = g.ClientId)  		
	AND ISNULL(cl.RecordDeleted,'N')='N'
--JOIN ClientCoveragePlans b1 ON (b.ClientCoveragePlanId = b1.ClientCoveragePlanId)    
--	AND ISNULL(b1.RecordDeleted,'N')='N'   
join ProcedureCodes pc		ON pc.ProcedureCodeId = g.ProcedureCodeId   
	AND ISNULL(PC.RecordDeleted,'N')='N'  
--Moved this to join
join StaffClients sc		on sc.StaffId = @local_StaffId 
	and sc.ClientId = h.ClientId     
left join Staff st			on st.StaffId = g.ClinicianId 
	AND ISNULL(st.RecordDeleted,'N')='N'   
LEFT JOIN Payers d			ON  (c.PayerId = d.PayerId)  
	AND ISNULL(d.RecordDeleted,'N')='N'   
LEFT JOIN GlobalCodes e		ON (d.PayerType = e.GlobalcodeId)  
	AND ISNULL(e.RecordDeleted,'N')='N'   where 

b.LastBilledDate is null and isnull(c.Capitated,'N') <> 'Y' and isnull(b.DoNotBill,'N') <> 'Y'
group by d.PayerId, d.PayerName    
  
insert into #T1 (  
       PayerId,  
       PayerName,  
       [0-30],  
       [31-60],  
       [61-90],  
       [91-120],  
       [121-150],  
       [151-180],  
       [181-365],  
       [>1 Year],  
       Total,  
       Filter)         
select -1, 'Total',  
[0-30] = sum( [0-30] ),  
[31-60] = sum([31-60] ),  
[61-90] = sum( [61-90] ),  
[91-120] = sum( [91-120] ),  
[121-150] = sum([121-150] ),  
[151-180] = sum([151-180] ),  
[181-365] = sum([181-365] ),  
[>1 Year] = sum([>1 Year] ),  
Total=sum(Total),  
'DOS'  
FROM
#T1


SELECT		   [Id],PayerId,  
			   PayerName,
			   '$'+ISNULL(CONVERT(VARCHAR,[0-30],1) ,'0.00')AS [0-30],     --'1' Added by Gayathri for Currency
			   '$'+ISNULL(CONVERT(VARCHAR,[31-60],1),'0.00') AS [31-60],  
			   '$'+ISNULL(CONVERT(VARCHAR,[61-90],1),'0.00') AS [61-90],  
			   '$'+ISNULL(CONVERT(VARCHAR,[91-120],1) ,'0.00')AS [91-120],  
			   '$'+ISNULL(CONVERT(VARCHAR,[121-150],1) ,'0.00')AS [121-150],  
			   '$'+ISNULL(CONVERT(VARCHAR,[151-180],1) ,'0.00')AS [151-180],    
			   '$'+ISNULL(CONVERT(VARCHAR,[181-365],1) ,'0.00')AS [181-365],  
			   '$'+ISNULL(CONVERT(VARCHAR,[>1 Year],1) ,'0.00')AS [>1 Year],  
			   '$'+ISNULL(CONVERT(VARCHAR,Total,1),'0.00') AS Total,  
			   Filter  
		  FROM #T1  
END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMDashboardARSelClaimsNotYetBilledbyPayer')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END


GO

GO
