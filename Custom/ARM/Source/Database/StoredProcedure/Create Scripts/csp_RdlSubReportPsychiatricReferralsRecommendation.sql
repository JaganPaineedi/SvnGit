/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPsychiatricReferralsRecommendation]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportPsychiatricReferralsRecommendation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportPsychiatricReferralsRecommendation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportPsychiatricReferralsRecommendation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_RdlSubReportPsychiatricReferralsRecommendation]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlSubReportPsychiatricReferralsRecommendation]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  13 July,2011                                       */                                                                                                                                    
/* Created By: Jagdeep Hundal                                                                  */                                                                                                                                    
/* Purpose:  Get Data from CustomPsychiatricReferrals */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                  
/*                                                                   */                                                                                                                                    
/* Output Parameters:   None                   */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Return:  0=success, otherwise an error number                     */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Called By:                                                        */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Calls:                                                            */                     
/* */                                              
/* Data Modifications:                   */                                                    
/*      */                                                                                   
/* Updates:               */                                                                            
/*   Date     Author            Purpose                             */                                                       
/*********************************************************************/              
                   
  SELECT CPR.ReferralId
      ,CPR.[DocumentVersionId]    
      ,CPR.[ReceivingStaffId]    
      ,CPR.[ServiceRecommended]    
      ,CPR.[ServiceAmount]    
      ,CPR.[ServiceUnitType]    
      ,CPR.[ServiceFrequency]    
      ,CPR.[AssessedNeedForReferral]    
      ,CPR.[ClientParticipatedReferral]     
      ,AuthorizationCodeName as  ServiceRecommendedText                           
      ,G.CodeName as ServiceFrequencyText                          
      ,S.LastName + '', '' +S.FirstName as ReceivingStaffIdText     
      ,Convert(Varchar,ServiceAmount) + '' '' + Unit.CodeName as ServiceUnitTypeText    
  FROM CustomDocumentPsychiatricEvaluationReferrals CPR                          
  inner join authorizationCodes A on CPR.ServiceRecommended=A.AuthorizationCodeId                           
  left join GlobalCodes G on G.GlobalCodeID = CPR.ServiceFrequency                          
  left join GlobalCodes Unit on Unit.GlobalCodeID = CPR.ServiceUnitType                          
  left join Staff S On S.StaffId =CPR.ReceivingStaffId                                                                      
  where CPR.DocumentVersionId=@DocumentVersionId and IsNull(CPR.RecordDeleted,''N'')=''N''            
                
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlSubReportPsychiatricReferralsRecommendation : An Error Occured''                             
   Return                            
   End                            
                     
                          
                
End
' 
END
GO
