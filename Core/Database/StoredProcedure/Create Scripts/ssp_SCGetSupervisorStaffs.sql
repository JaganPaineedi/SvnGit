
/****** Object:  StoredProcedure [dbo].[ssp_SCGetSupervisorStaffs]    Script Date: 07/23/2015 12:35:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSupervisorStaffs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSupervisorStaffs]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSupervisorStaffs]    Script Date: 07/23/2015 12:35:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetSupervisorStaffs]             
(@SupervisorId int)            
AS            
                  
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_SCGetSupervisorStaffs                   */                        
/* Purpose:  Fills the shared table for SupervisorStaffs             */                        
/*                                                                   */                        
/* Input Parameters: @SupervisorId  = StaffId                        */                        
/*                                                                   */                        
/* Output Parameters:   None                                         */                        
/*                                                                   */                        
/*                                                                   */                        
/* Called By:      getSharedTabelsData() in MSDE                     */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/* Date          Author       Purpose                                */                        
/* 25 Jan  2008  Rohit Verma  Created                                */    
/* 08.26.2010 avoss   order by StaffName                             */   
/* 12.26.2013 Manju P To get DisplayAs as StaffName from staff table.*/  
/*                    What/Why: Task: Core Bugs #1315 Staff Detail Changes */  
/* 23rd July 2015 Munish Sood addded Staff.Active check as per Harbor 3.5 Implementation Task #258     */
/*********************************************************************/                                         
Begin            
Select S.StaffId, IsNull(S.DisplayAs,'') as StaffName            
From Staff S             
Join StaffSupervisors Ss On (Ss.StaffId =  S.StaffId)            
Where Ss.SupervisorId = @SupervisorId            
and IsNull(Ss.RecordDeleted,'N')='N'            
and IsNull(S.RecordDeleted,'N')='N' 
and IsNull(S.Active,'Y')='Y'            
           
order by StaffName --IsNull(S.FirstName,'')+' '+IsNull(S.LastName,'')    
    
    
IF (@@error!=0)                  
    BEGIN                  
        RAISERROR  20002 'ssp_SCGetSupervisorStaffs: An Error Occured'                  
    END                  
            
End  
GO


