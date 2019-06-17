/****** Object:  StoredProcedure [dbo].[ssp_CMDashBoardProviders]    Script Date: 01/14/2015 15:06:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMDashBoardProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMDashBoardProviders]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMDashBoardProviders]    Script Date: 01/14/2015 15:06:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

 CREATE  PROCEDURE [dbo].[ssp_CMDashBoardProviders]   
(                      
@UserID int,            
@InsurerID int                       
)                      
As                      
Begin                      
/*********************************************************************/                                      
/* Stored Procedure: dbo.ssp_DashBoardProviders                */                                  
/* Copyright: 2005 Provider Claim Management System             */                                      
/* Creation Date:  11/09/2005                                    */                                      
/*                                                                   */                                      
/* Purpose: It gets the Provider Information for the  DashBoard of a user            */                                     
/* Description:   1.Counts ContractExpires,IncompleteDataEntry,CurrentActiver,ContractCapital for each isurers of a users */                
/*                2.Displays contractExpires,IncompleteDataEntry,CurrentActiver,ContractCapital for a user by summing all insurer assosiated with him                */                                    
/* Input Parameters: @UserID,@InsurerID            */                                    
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
/*  Date         Author       Purpose                                    */                                      
/*  11/11/2005   Vikrant      Create                       */               
/*  05/10/2012   Sanjay Bhardwaj      Modify Task#2573                    */                                      
/*               Task#2573 Description : Dashboard- Contracts with cap at   
                 90% includes every contract from the beginning of time.  
                 This should only be active contracts.
    02/12/2014   Shruthi.S  Moved sp from 2.x.Since, credentialing logic wasn't there.Ref #2 	Care Management to SmartCare
*/
/* 03/27/2014 Shruthi.S Changed UserInsurers to staffInsurers.#1.1 Care management to SC.*/
/* 11/08/2014 Shruthi.S Excluded status='A' check and startdate,enddate check if contracts cap 90% doesn't have these in the list page Provider Contract.Ref #2.1 CM to SC.*/
/* 10/12/2014 Shruthi.S Reverted StaffProviders Join changes which was added as ref #14.Since, this check was not required for Insurers widgets.Included StaffInsurers permissions.Ref #43 Care Management to SmartCare Env. Issues Tracking.*/
/* 12-Jan-2015 SuryaBalan Added Condition wrf Task 331 Care Management to SmartCare Env. Issues Tracking Task 331 Fixed Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProv 	*/
/* 14-Jan-2015 Arjun K R  All select statement is changed to get the correct count which match the list page */
/* 16-Jan-2015 Arjun K R  In Select Statement c.ContractId is changed to p.ProviderId for the count  */
/* 7-Dec-2015 Vamsi N  what:Added alias name to end date 
                       why:Core Bugs#1914 */
/*********************************************************************/                                       
 
DECLARE @AllInsurers VARCHAR(1)               
SELECT TOP 1 @AllInsurers =  AllInsurers FROM staff WHERE staffid=@UserID   
DECLARE @AllProviders VARCHAR(1)               
SELECT TOP 1 @AllProviders =  allproviders FROM staff WHERE staffid=@UserID   
                                            
          
 	 
    SELECT Distinct count(p.ProviderId) as ContractExpires
       FROM   Providers p 
       LEFT JOIN Sites s  ON p.ProviderId = s.ProviderId   AND p.PrimarySiteId = s.SiteId 
       LEFT JOIN contracts c  ON c.ProviderId = p.ProviderId AND Isnull(c.RecordDeleted, 'N') = 'N' 
       AND ( (c.InsurerId IN (SELECT InsurerId FROM  StaffInsurers WHERE  StaffId = @UserID  AND Isnull(RecordDeleted,'N') = 'N')) OR @AllInsurers='Y')
       WHERE  Isnull(p.recorddeleted, 'N') = 'N'  AND Isnull(s.recorddeleted, 'N') = 'N'          
       AND (@AllProviders='Y'  OR  EXISTS(SELECT 1 FROM  StaffProviders SP WHERE p.ProviderId= sp.ProviderId AND sp.StaffId=@UserID AND isnull(SP.RecordDeleted,'N')='N'))
       AND (c.InsurerId=@InsurerID OR @InsurerID=0)
       --added aliasname c by vamsi 
       AND (Datediff(d, Getdate(), c.Enddate) <=90 ) and (Datediff(d, Getdate(), c.Enddate) > 0) and c.ContractId IS NOT NULL    
           
      

             
 --IncompleteDataEntry            
		
	SELECT Distinct count(p.ProviderId) as IncompleteDataEntry
       FROM   Providers p 
       LEFT JOIN Sites s  ON p.ProviderId = s.ProviderId   AND p.PrimarySiteId = s.SiteId 
       LEFT JOIN contracts c  ON c.ProviderId = p.ProviderId AND Isnull(c.RecordDeleted, 'N') = 'N' 
       AND ( (c.InsurerId IN (SELECT InsurerId FROM  StaffInsurers WHERE  StaffId = @UserID  AND Isnull(RecordDeleted,'N') = 'N')) OR @AllInsurers='Y')
       WHERE  Isnull(p.recorddeleted, 'N') = 'N'  AND Isnull(s.recorddeleted, 'N') = 'N'
       AND (@AllProviders='Y'  OR  EXISTS(SELECT 1 FROM  StaffProviders SP WHERE p.ProviderId= sp.ProviderId AND sp.StaffId=@UserID AND isnull(SP.RecordDeleted,'N')='N')) 
       AND (c.InsurerId=@InsurerID OR @InsurerID=0)  
       AND (p.Active='Y' and p.DataEntryComplete='N')       
		    
               
   
      
 --CurrentActive            
     SELECT Distinct count(p.ProviderId) as CurrentActive
       FROM   Providers p 
       LEFT JOIN Sites s  ON p.ProviderId = s.ProviderId   AND p.PrimarySiteId = s.SiteId 
       LEFT JOIN contracts c  ON c.ProviderId = p.ProviderId AND Isnull(c.RecordDeleted, 'N') = 'N' 
       AND ( (c.InsurerId IN (SELECT InsurerId FROM  StaffInsurers WHERE  StaffId = @UserID  AND Isnull(RecordDeleted,'N') = 'N')) OR @AllInsurers='Y')
       WHERE  Isnull(p.recorddeleted, 'N') = 'N'  AND Isnull(s.recorddeleted, 'N') = 'N'
       AND (@AllProviders='Y'  OR  EXISTS(SELECT 1 FROM  StaffProviders SP WHERE p.ProviderId= sp.ProviderId AND sp.StaffId=@UserID AND isnull(SP.RecordDeleted,'N')='N')) 
       AND (c.InsurerId=@InsurerID OR @InsurerID=0)  
       AND (p.Active='Y' and c.[Status]='A')
       AND c.StartDate <= Convert(varchar(30),Getdate(),101) 
       AND c.EndDate >= Convert(varchar(30),Getdate(),101) AND c.ContractId IS NOT NULL
       

    
      
 --ContractCapital       
     SELECT Distinct count(p.ProviderId) as ContractCapital
       FROM   Providers p 
       LEFT JOIN Sites s  ON p.ProviderId = s.ProviderId   AND p.PrimarySiteId = s.SiteId 
       LEFT JOIN contracts c  ON c.ProviderId = p.ProviderId AND Isnull(c.RecordDeleted, 'N') = 'N' 
       AND ( (c.InsurerId IN (SELECT InsurerId FROM  StaffInsurers WHERE  StaffId = @UserID  AND Isnull(RecordDeleted,'N') = 'N')) OR @AllInsurers='Y')
       WHERE  Isnull(p.recorddeleted, 'N') = 'N'  AND Isnull(s.recorddeleted, 'N') = 'N'
       AND (@AllProviders='Y'  OR  EXISTS(SELECT 1 FROM  StaffProviders SP WHERE p.ProviderId= sp.ProviderId AND sp.StaffId=@UserID AND isnull(SP.RecordDeleted,'N')='N')) 
       AND (c.InsurerId=@InsurerID OR @InsurerID=0)  
       AND (ISNULL(ClaimsApprovedAndPaid, 0) / ISNULL(TotalAmountCap, -1) *  100 >=90)
            
            
      
      
--For Credentailing Count         
      
DECLARE @AllProviders1 VARCHAR(10)      
SELECT @AllProviders1=ISNULL(AllProviders,'N') FROM Staff WHERE staffid=@UserId      
IF(@AllProviders1 = 'Y')      
BEGIN    
  -- To Check if All Insurers is passed    
  IF(@insurerId=0)    
  BEGIN    
   SELECT COUNT(DISTINCT CredentialingId) AS Credentialing    
   FROM   Credentialing c      
   WHERE ISNULL(c.RecordDeleted,'N')='N'    
   AND c.[Status] = 2641      
   
  END    
    
-- If single Insurer is passed    
ELSE    
  BEGIN    
   SELECT COUNT(*)AS Credentialing      
   FROM       
   Credentialing c      
   WHERE ISNULL(c.RecordDeleted,'N')='N'    
   AND c.[Status] = 2641      
   AND c.PerformedBy=@InsurerId    
  END    
END      
ELSE      
BEGIN      
     
  IF(@insurerId=0)    
   BEGIN    
   ---------  
    
    SELECT COUNT(*)AS Credentialing      
    FROM Credentialing c     
    JOIN Providers P ON P.ProviderId=c.ProviderId   
    --join ProviderInsurers on ProviderInsurers.ProviderId=p.ProviderId    
    --join staffinsurers UI on UI.InsurerId=ProviderInsurers.InsurerId    
    WHERE --staffid=158 --and isnull(UI.RecordDeleted,'N')='N'    
     ISNULL(p.RecordDeleted,'N')='N'  and P.Active='Y'  
    --and isnull(ProviderInsurers.RecordDeleted,'N')='N'     
    AND ISNULL(c.RecordDeleted,'N')='N'      
    AND c.[Status] = 2641  
 
  AND (@AllProviders = 'Y'    OR  
               EXISTS (SELECT SI.ProviderId    
      FROM StaffProviders SI    
      WHERE ISNULL(SI.RecordDeleted,'N') <> 'Y'          
                    AND SI.StaffId = @UserId    
     AND C.ProviderId = SI.ProviderId AND @AllProviders = 'N'))     
     
     
    ------    
   END      
ELSE    
   BEGIN       
       SELECT COUNT(*)AS Credentialing      
    FROM Credentialing c     
 JOIN Providers P ON P.ProviderId=c.ProviderId   
    --join ProviderInsurers on ProviderInsurers.ProviderId=p.ProviderId    
    --join StaffInsurers UI on UI.InsurerId=ProviderInsurers.InsurerId    
    WHERE --StaffId=@UserId and isnull(UI.RecordDeleted,'N')='N'    
     ISNULL(p.RecordDeleted,'N')='N'  and P.Active='Y'  
    --and isnull(ProviderInsurers.RecordDeleted,'N')='N'     
    AND ISNULL(c.RecordDeleted,'N')='N'      
    AND c.[Status] = 2641      
    AND c.PerformedBy=@InsurerId   
    AND (@AllProviders = 'Y'    OR  
    EXISTS (SELECT SI.ProviderId    
      FROM StaffProviders SI    
      WHERE ISNULL(SI.RecordDeleted,'N') <> 'Y'          
                    AND SI.StaffId = @UserId    
     AND C.ProviderId = SI.ProviderId AND @AllProviders = 'N'))     
        
   END      
      
     
END    
    
    
    
    
--Checking For Errors      
IF (@@error!=0)  BEGIN  RAISERROR  20006  'ssp_DashBoardProviders: An Error Occured'     RETURN  END     
      
END    

GO


