IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_ValidateCustomDocumentCANS')
	BEGIN
		DROP  Procedure  csp_ValidateCustomDocumentCANS
	END

GO
CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentCANS]  --2353   
  @DocumentVersionId Int            
as            
/**********************************************************************/                                                                                            
 /* Stored Procedure:csp_ValidateCustomDocumentCANS   */                                                                                   
 /* Creation Date: 06/06/2013                                          */                                                                                            
  /* Author: Md Hussain Khusro  */                
/* Purpose:To validate 'CANS' document    */  
/* Input Parameters:  @DocumentVersionId      */             
/* Output Parameters:               */ 
      
/* Updates:                                                          */    
/*   Date		  Author				Purpose                                    */    
 /* 20-Nov-2013  Md Hussain Khusro  Added 13 New Validation for Life Domain Section wrt task #120 Philhaven Development*/ 
 /*	25/Nov/2013	 Md Hussain Khusro	Added 3 New Columns and removed 6 existing columns wrt task #120 Philhaven Developement	*/

/*********************************************************************/ 
 /*********************************************************************/                                                           
            
Begin                                                          
                
 Begin try             
     
     
DECLARE @CustomDocumentCANS TABLE (          
		DocumentVersionId			int,			
		DocumentType				int,			
		Psychosis					char,
		AngerManagement				char,
		SubstanceAbuse				char,
		DepressionAnxiety			char,
		Attachment					char,
		AttentionDefictImpluse		char,
		AdjustmenttoTrauma			char,
		OppositionalBehavior		char,
		AntisocialBehavior			char,
		[Safety]					char,
		Resources					char,
		Supervision					char,
		Knowledge					char,
		Involvement					char,
		Organization				char,
		Development					char,
		PhysicalBehavioralHealth	char,
		ResidentialStability		char,
		Abuse						char,
		Neglect						char,
		Exploitation				char,
		Permanency					char,
		ChildSafety					char,
		EmotionalCloseness			char,
		Family						char,
		Optimism					char,
		Vocational					char,
		Resiliency					char,
		Educational					char,
		Interpersonal				char,
		Resourcefulness				char,
		CommunityLife				char,
		TalentInterests				char,
		SpiritualReligious			char,
		RelationPerformance			char,
		DangertoSelf				char,
		ViolentThinking				char,
		Elopement					char,
		SocialBehavior				char,
		OtherSelfHarm				char,
		DangertoOthers				char,
		CrimeDelinquency			char,
		Commitment					char,
		SexuallyAbusive				char,
		SchoolBehavior				char,
		SexualDevelopment			char,
		SeverityofUse				char,
		DurationofUse				char,
		PeerInfluences				char,
		StageofRecovery				char,
		ParentalInfluences			char,
		PhysicalAbuse				char,
		EmotionalAbuse				char,
		WitnessofViolence			char,
		SexualAbuse					char,
		MedicalTrauma				char,
		LDFFamily					char,
		LDFSchoolBehavior			char,
		LDFSleep					char,
		LDFLivingSituation			char,
		LDFSchoolAttendance 		char,
		LDFJobFunctioning			char,
		LDFSchoolAchievement		char,
		LDFPhysicalMedical			char,	
		LDFSexualDevelopment		char,	
		LDFIntellectualDevelopmental char
)     
            
      
--*INSERT LIST*--              
INSERT INTO @CustomDocumentCANS(            
			DocumentVersionId,				
			DocumentType,
			Psychosis,
			AngerManagement,
			SubstanceAbuse,
			DepressionAnxiety,
			Attachment,
			AttentionDefictImpluse,
			AdjustmenttoTrauma,
			OppositionalBehavior,
			AntisocialBehavior,
			[Safety],
			Resources,
			Supervision,
			Knowledge,
			Involvement,
			Organization,
			Development,
			PhysicalBehavioralHealth,
			ResidentialStability,
			Abuse,
			Neglect,
			Exploitation,
			Permanency,
			ChildSafety,
			EmotionalCloseness,
			Family,
			Optimism,
			Vocational,
			Resiliency,
			Educational,
			Interpersonal,
			Resourcefulness,
			CommunityLife,
			TalentInterests,
			SpiritualReligious,
			RelationPerformance,
			DangertoSelf,
			ViolentThinking,
			Elopement,
			SocialBehavior,
			OtherSelfHarm,
			DangertoOthers,
			CrimeDelinquency,
			Commitment,
			SexuallyAbusive,
			SchoolBehavior,
			SexualDevelopment,
			SeverityofUse,
			DurationofUse,
			PeerInfluences,
			StageofRecovery,
			ParentalInfluences,
			PhysicalAbuse,
			EmotionalAbuse,
			WitnessofViolence,
			SexualAbuse,
			MedicalTrauma,
			LDFFamily,
			LDFSchoolBehavior,
			LDFSleep,
			LDFLivingSituation,
			LDFSchoolAttendance,
			LDFJobFunctioning,
			LDFSchoolAchievement,
			LDFPhysicalMedical,				
			LDFSexualDevelopment,			
			LDFIntellectualDevelopmental
)
            
--*Select LIST*--                
select             
			a.DocumentVersionId,				
			a.DocumentType,
			a.Psychosis,
			a.AngerManagement,
			a.SubstanceAbuse,
			a.DepressionAnxiety,
			a.Attachment,
			a.AttentionDefictImpluse,
			a.AdjustmenttoTrauma,
			a.OppositionalBehavior,
			a.AntisocialBehavior,
			a.[Safety],
			a.Resources,
			a.Supervision,
			a.Knowledge,
			a.Involvement,
			a.Organization,
			a.Development,
			a.PhysicalBehavioralHealth,
			a.ResidentialStability,
			a.Abuse,
			a.Neglect,
			a.Exploitation,
			a.Permanency,
			a.ChildSafety,
			a.EmotionalCloseness,
 			b.Family,
			b.Optimism,
			b.Vocational,
			b.Resiliency,
			b.Educational,
			b.Interpersonal,
			b.Resourcefulness,
			b.CommunityLife,
			b.TalentInterests,
			b.SpiritualReligious,
			b.RelationPerformance,
			b.DangertoSelf,
			b.ViolentThinking,
			b.Elopement,
			b.SocialBehavior,
			b.OtherSelfHarm,
			b.DangertoOthers,
			b.CrimeDelinquency,
			b.Commitment,
			b.SexuallyAbusive,
			b.SchoolBehavior,
			b.SexualDevelopment,
			c.SeverityofUse,
			c.DurationofUse,
			c.PeerInfluences,
			c.StageofRecovery,
			c.ParentalInfluences,
			c.PhysicalAbuse,
			c.EmotionalAbuse,
			c.WitnessofViolence,
			c.SexualAbuse,
			c.MedicalTrauma,
			a.LDFFamily,
			a.LDFSchoolBehavior,
			a.LDFSleep,
			a.LDFLivingSituation,
			a.LDFSchoolAttendance,
			a.LDFJobFunctioning,
			a.LDFSchoolAchievement,
			a.LDFPhysicalMedical,				
			a.LDFSexualDevelopment,			
			a.LDFIntellectualDevelopmental       
            
from CustomDocumentCANSGenerals a left join CustomDocumentCANSModules c on c.DocumentVersionId=a.DocumentVersionId 
left join CustomDocumentCANSYouthStrengths b on b.DocumentVersionId=a.DocumentVersionId
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,'N')<>'Y' and isnull(b.RecordDeleted,'N')<>'Y'  and isnull(c.RecordDeleted,'N')<>'Y' 

           
      
Create table #validationReturnTable            
(TableName varchar(50),            
ColumnName varchar(50),            
ErrorMessage varchar(1000) ,
PageIndex int           
)            
--This validation returns three fields            
--Field1 = TableName            
--Field2 = ColumnName            
--Field3 = ErrorMessage  

 
 Insert into #validationReturnTable
 (
 TableName,
 ColumnName,
 ErrorMessage,
 PageIndex
 
 )
 
Select 'CustomDocumentCANSGenerals', 'DocumentType', 'Please Select- Document Type from General Tab', 1
From @CustomDocumentCANS WHERE isnull(DocumentType,'')='' 

Union
            
Select 'CustomDocumentCANSGenerals', 'Psychosis', 'Please Select - Psychosis from Problem Presentation Section in General Tab'   ,1       
FROM @CustomDocumentCANS WHERE isnull(Psychosis,'')=''  

Union            
Select 'CustomDocumentCANSGenerals', 'AngerManagement', 'Please Select - Anger Management from Problem Presentation Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(AngerManagement,'')=''  

Union            
Select 'CustomDocumentCANSGenerals', 'SubstanceAbuse', 'Please Select - Substance Abuse from Problem Presentation Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(SubstanceAbuse,'')=''          
    
Union            
Select 'CustomDocumentCANSGenerals', 'DepressionAnxiety', 'Please Select - Depression/Anxiety from Problem Presentation Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(DepressionAnxiety,'')=''          
    
    
Union            
Select 'CustomDocumentCANSGenerals', 'Attachment', 'Please Select - Attachment from Problem Presentation Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(Attachment,'')=''    
       
Union            
Select 'CustomDocumentCANSGenerals', 'AttentionDefictImpluse', 'Please Select - Attention Defict/Impluse from Problem Presentation Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(AttentionDefictImpluse,'')=''           
    
Union            
Select 'CustomDocumentCANSGenerals', 'AdjustmenttoTrauma', 'Please Select - Adjustment to Trauma from Problem Presentation Section in General Tab'     ,1        
FROM @CustomDocumentCANS WHERE isnull(AdjustmenttoTrauma,'')=''           


Union            
Select 'CustomDocumentCANSGenerals', 'OppositionalBehavior', 'Please Select - Oppositional Behavior from Problem Presentation Section in General Tab'     ,1        
FROM @CustomDocumentCANS WHERE isnull(OppositionalBehavior,'')=''           
    
Union            
Select 'CustomDocumentCANSGenerals', 'AntisocialBehavior', 'Please Select - Antisocial Behavior from Problem Presentation Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(AntisocialBehavior,'')=''  

Union            
Select 'CustomDocumentCANSGenerals', 'Safety', 'Please Select - Safety from Caregiver Needs & Strengths Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull([Safety],'')=''  

Union            
Select 'CustomDocumentCANSGenerals', 'Resources', 'Please Enter - Resources from Caregiver Needs & Strengths Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(Resources,'')=''   

Union            
Select 'CustomDocumentCANSGenerals', 'Supervision', 'Please Select - Supervision from Caregiver Needs & Strengths Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(Supervision,'')='' 

Union            
Select 'CustomDocumentCANSGenerals', 'Knowledge', 'Please Select - Knowledge from Caregiver Needs & Strengths Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(Knowledge,'')='' 

Union            
Select 'CustomDocumentCANSGenerals', 'Involvement', 'Please Select - Involvement from Caregiver Needs & Strengths Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(Involvement,'')=''          
    
Union            
Select 'CustomDocumentCANSGenerals', 'Organization', 'Please Select - Organization from Caregiver Needs & Strengths Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(Organization,'')=''          
    
    
Union            
Select 'CustomDocumentCANSGenerals', 'Development', 'Please Select - Development from Caregiver Needs & Strengths Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(Development,'')=''    
    
Union            
Select 'CustomDocumentCANSGenerals', 'PhysicalBehavioralHealth', 'Please Select - Physical/Behavioral Health from Caregiver Needs & Strengths Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(PhysicalBehavioralHealth,'')=''           
    
Union            
Select 'CustomDocumentCANSGenerals', 'ResidentialStability', 'Please Select - Residential Stability from Caregiver Needs & Strengths Section in General Tab'     ,1        
FROM @CustomDocumentCANS WHERE isnull(ResidentialStability,'')=''           


Union            
Select 'CustomDocumentCANSGenerals', 'Abuse', 'Please Select - Abuse from Child Safety Section in General Tab'     ,1        
FROM @CustomDocumentCANS WHERE isnull(Abuse,'')=''           
    
Union            
Select 'CustomDocumentCANSGenerals', 'Neglect', 'Please Select - Neglect from Child Safety Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(Neglect,'')=''  

Union            
Select 'CustomDocumentCANSGenerals', 'Exploitation', 'Please Select - Exploitation from Child Safety Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(Exploitation,'')=''  

Union            
Select 'CustomDocumentCANSGenerals', 'Permanency', 'Please Enter - Permanency from Child Safety Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(Permanency,'')=''   

Union            
Select 'CustomDocumentCANSGenerals', 'ChildSafety', 'Please Select - Child Safety from Child Safety Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(ChildSafety,'')='' 

Union            
Select 'CustomDocumentCANSGenerals', 'EmotionalCloseness', 'Please Select - Emotional Closeness to Perpetrator from Child Safety Section in General Tab' ,1            
FROM @CustomDocumentCANS WHERE isnull(EmotionalCloseness,'')='' 

Union
Select 'CustomDocumentCANSYouthStrengths', 'Family', 'Please Select - Family from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2
From @CustomDocumentCANS WHERE isnull(Family,'')='' 

Union
            
Select 'CustomDocumentCANSYouthStrengths', 'Optimism', 'Please Select - Optimism from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2      
FROM @CustomDocumentCANS WHERE isnull(Optimism,'')=''  

Union            
Select 'CustomDocumentCANSYouthStrengths', 'Vocational', 'Please Select - Vocational from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2      
FROM @CustomDocumentCANS WHERE isnull(Vocational,'')=''  

Union            
Select 'CustomDocumentCANSYouthStrengths', 'Resiliency', 'Please Select - Resiliency from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2          
FROM @CustomDocumentCANS WHERE isnull(Resiliency,'')=''          
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'Educational', 'Please Select - Educational from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2          
FROM @CustomDocumentCANS WHERE isnull(Educational,'')=''          
    
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'Interpersonal', 'Please Select - Interpersonal from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2
FROM @CustomDocumentCANS WHERE isnull(Interpersonal,'')=''    
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'Resourcefulness', 'Please Select - Resourcefulness from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2        
FROM @CustomDocumentCANS WHERE isnull(Resourcefulness,'')=''           
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'CommunityLife', 'Please Select - Community Life from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2  
FROM @CustomDocumentCANS WHERE isnull(CommunityLife,'')=''           


Union            
Select 'CustomDocumentCANSYouthStrengths', 'TalentInterests', 'Please Select - Talent/Interests from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2        
FROM @CustomDocumentCANS WHERE isnull(TalentInterests,'')=''           
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'SpiritualReligious', 'Please Select - Spiritual/Religious from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2           
FROM @CustomDocumentCANS WHERE isnull(SpiritualReligious,'')=''  

Union            
Select 'CustomDocumentCANSYouthStrengths', 'RelationPerformance', 'Please Select - Relation Performance from Youth Strengths Section in Youth Strengths & Needs Tab'   ,2        
FROM @CustomDocumentCANS WHERE isnull(RelationPerformance,'')=''  

Union            
Select 'CustomDocumentCANSYouthStrengths', 'DangertoSelf', 'Please Select - Danger to Self from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2   
FROM @CustomDocumentCANS WHERE isnull(DangertoSelf,'')=''   

Union            
Select 'CustomDocumentCANSYouthStrengths', 'ViolentThinking', 'Please Select - Violent Thinking from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2          
FROM @CustomDocumentCANS WHERE isnull(ViolentThinking,'')='' 

Union            
Select 'CustomDocumentCANSYouthStrengths', 'Elopement', 'Please Select - Elopement from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2        
FROM @CustomDocumentCANS WHERE isnull(Elopement,'')='' 

Union            
Select 'CustomDocumentCANSYouthStrengths', 'SocialBehavior', 'Please Select - Social Behavior from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2       
FROM @CustomDocumentCANS WHERE isnull(SocialBehavior,'')=''          
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'OtherSelfHarm', 'Please Select - Other Self Harm from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2          
FROM @CustomDocumentCANS WHERE isnull(OtherSelfHarm,'')=''          
    
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'DangertoOthers', 'Please Select - Danger to Others from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2     
FROM @CustomDocumentCANS WHERE isnull(DangertoOthers,'')=''    
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'CrimeDelinquency', 'Please Select - Crime/Delinquency from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2         
FROM @CustomDocumentCANS WHERE isnull(CrimeDelinquency,'')=''           
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'Commitment', 'Please Select - Commitment to Self-Control from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2   
FROM @CustomDocumentCANS WHERE isnull(Commitment,'')=''           


Union            
Select 'CustomDocumentCANSYouthStrengths', 'SexuallyAbusive', 'Please Select - Sexually Abusive Behavior from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2         
FROM @CustomDocumentCANS WHERE isnull(SexuallyAbusive,'')=''           
    
Union            
Select 'CustomDocumentCANSYouthStrengths', 'SchoolBehavior', 'Please Select - School Behavior from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2             
FROM @CustomDocumentCANS WHERE isnull(SchoolBehavior,'')=''  

Union            
Select 'CustomDocumentCANSYouthStrengths', 'SexualDevelopment', 'Please Select - Sexual Development from Risk Behaviors Section in Youth Strengths & Needs Tab'   ,2            
FROM @CustomDocumentCANS WHERE isnull(SexualDevelopment,'')=''  

Union            
Select 'CustomDocumentCANSModules', 'SeverityofUse', 'Please Select - Severity of Use from Substance Abuse Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(SeverityofUse,'')='' and SubstanceAbuse in ('1','2','3')  


Union            
Select 'CustomDocumentCANSModules', 'DurationofUse', 'Please Select - Duration of Use from Substance Abuse Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(DurationofUse,'')='' and SubstanceAbuse in ('1','2','3')   

Union            
Select 'CustomDocumentCANSModules', 'PeerInfluences', 'Please Select - Peer Influences from Substance Abuse Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(PeerInfluences,'')='' and SubstanceAbuse in ('1','2','3')   

Union            
Select 'CustomDocumentCANSModules', 'StageofRecovery', 'Please Select - Stage of Recovery from Substance Abuse Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(StageofRecovery,'')='' and SubstanceAbuse in ('1','2','3')  

Union            
Select 'CustomDocumentCANSModules', 'ParentalInfluences', 'Please Select - Parental Influences from Substance Abuse Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(ParentalInfluences,'')=''  and SubstanceAbuse in ('1','2','3')  

Union            
Select 'CustomDocumentCANSModules', 'PhysicalAbuse', 'Please Select - Physical Abuse from STrauma Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(PhysicalAbuse,'')=''  and AdjustmenttoTrauma in ('1','2','3')

Union            
Select 'CustomDocumentCANSModules', 'EmotionalAbuse', 'Please Select - Emotional Abuse from Trauma Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(EmotionalAbuse,'')=''  and AdjustmenttoTrauma in ('1','2','3')

Union            
Select 'CustomDocumentCANSModules', 'WitnessofViolence', 'Please Select - Witness of Violence from Trauma Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(WitnessofViolence,'')=''  and AdjustmenttoTrauma in ('1','2','3')

Union            
Select 'CustomDocumentCANSModules', 'SexualAbuse', 'Please Select - Sexual Abuse from Trauma Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(SexualAbuse,'')=''  and AdjustmenttoTrauma in ('1','2','3')

Union            
Select 'CustomDocumentCANSModules', 'MedicalTrauma', 'Please Select - Medical Trauma from Trauma Module Section in Modules Tab'   ,3           
FROM @CustomDocumentCANS WHERE isnull(MedicalTrauma,'')=''  and AdjustmenttoTrauma in ('1','2','3')

Union            
Select 'CustomDocumentCANSGenerals', 'LDFFamily', 'Please Select - Family from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFFamily,'')=''   

Union            
Select 'CustomDocumentCANSGenerals', 'LDFSchoolBehavior', 'Please Select - School Behavior from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFSchoolBehavior,'')=''   

Union            
Select 'CustomDocumentCANSGenerals', 'LDFSleep', 'Please Select - Sleep from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFSleep,'')=''   
 
Union            
Select 'CustomDocumentCANSGenerals', 'LDFLivingSituation', 'Please Select - Living Situation from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFLivingSituation,'')=''   

Union            
Select 'CustomDocumentCANSGenerals', 'LDFSchoolAttendance', 'Please Select - School Attendance from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFSchoolAttendance,'')=''   

Union            
Select 'CustomDocumentCANSGenerals', 'LDFJobFunctioning', 'Please Select - Job Functioning from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFJobFunctioning,'')=''   

Union            
Select 'CustomDocumentCANSGenerals', 'LDFSchoolAchievement', 'Please Select - School Achievement from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFSchoolAchievement,'')=''

Union            
Select 'CustomDocumentCANSGenerals', 'LDFPhysicalMedical', 'Please Select - Physical/Medical from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFPhysicalMedical,'')=''

Union            
Select 'CustomDocumentCANSGenerals', 'LDFSexualDevelopment', 'Please Select - Sexual Development from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFSexualDevelopment,'')=''

Union            
Select 'CustomDocumentCANSGenerals', 'LDFIntellectualDevelopmental', 'Please Select - Intellectual/Developmental from Life Domain Functioning Section in General Tab'   ,1          
FROM @CustomDocumentCANS WHERE isnull(LDFIntellectualDevelopmental,'')=''


Select *  
from #validationReturnTable
             
end try                                                          
                                                                                        
BEGIN CATCH              
            
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ValidateCustomDocumentCANS')                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                       
 RAISERROR                                                                                         
 (                                                           
  @Error, -- Message text.                                                                                        
  16, -- Severity.                                                                                        
  1 -- State.                                                                                        
 );                                                                                     
END CATCH                                    
END    