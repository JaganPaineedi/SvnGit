/****** Object:  StoredProcedure [dbo].[csp_BillingClinicians]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BillingClinicians]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_BillingClinicians]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BillingClinicians]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE  [dbo].[csp_BillingClinicians]      
      
As        
                
Begin                
/*********************************************************************/                  
/* Stored Procedure: dbo.csp_BillingClinicians     */         
        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC         */                  
        
/* Creation Date:  16/02/2007           */                  
/*                                                                   */                  
/* Purpose: Fills Billing Clinicians */                 
/*                                                                   */                
/* Input Parameters: */                
/*                                                                   */                   
/* Output Parameters:             */                  
/*                                                                   */                  
/* Return:        */                  
/*                                                                   */                  
/* Called By: getBillingClinicians Method in DBTGroup note in "Always Online Application"    */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/*   Updates:                                                          */                  
        
/*       Date              Author                  Purpose                                    */                  
/*  16/02/2007         Sony John               Created                                    */                  
/*********************************************************************/                   
      

        
select staff.StaffId,rtrim(ltrim(staff.FirstName)),rtrim(ltrim(staff.LastName)),staff.Active,staff.RecordDeleted,    
rtrim(ltrim(isnull(staff.lastName,''''))) + '', '' + rtrim(ltrim(isnull(staff.FirstName,''''))) + '' '' + isnull(GlobalCodes.CodeName,'''') as StaffNameWithDegree      
FROM Staff left outer join globalcodes on staff.degree = globalcodes.globalcodeid       
where staff.clinician=''Y''  and  Staff.Active=''Y''    --order by staff.LastName              





        
  --Checking For Errors        
  If (@@error!=0)        
  Begin        
   RAISERROR  20006   ''csp_BillingClinicians: An Error Occured''         
   Return        
   End                 
                
        
End
' 
END
GO
