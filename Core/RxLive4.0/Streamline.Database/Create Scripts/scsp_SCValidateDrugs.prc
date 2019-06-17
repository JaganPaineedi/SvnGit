  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
CREATE        PROCEDURE  [dbo].[scsp_SCValidateDrugs]  
  
  
(  
 @DocumentCodeId int,  
 @DocumentId int,  
 @DrugId int,  
 @Dose varchar(25),  
 @Frequency int,  
 @Route int,  
 @Comment text,  
 @Strength varchar(25)  
)  
  
As  
          
Begin          
/*********************************************************************/            
/* Stored Procedure: dbo.scsp_SCValidateDrugs      */   
  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC         */            
  
/* Creation Date:  19/01/2007           */            
/*                                                                   */            
/* Purpose: validates current medication */           
/*                                                                   */          
/* Input Parameters: @DocumentCodeId,@DocumentId,@DocumentCodeId,@DocumentId,@DrugId,@Dose,@Frequency,@Route,@Comment,@Strength*/          
/*                                                                   */             
/* Output Parameters:             */            
/*                                                                   */            
/* Return: ReturnValue int,ErrorMessage         */            
/*                                                                   */            
/* Called By: ValidateDrugs Method in CurrentMedication UserControl in "Always Online Application"    */            
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/*                                                                   */            
/*   Updates:                                                          */            
  
/*       Date              Author                  Purpose                                    */            
/*  19/01/2007         Sony John               Created                                    */            
/*********************************************************************/             
 Declare @ReturnValue int ,@ErrorMessage Varchar(100)       
 set @ReturnValue=0  
 set @ErrorMessage='success'  
  
  
--MEDICATION ADMINISTRATION DRUG VALIDATION  
IF @DocumentCodeId = 118  
BEGIN  
  
 -- MEDICATION ADMINISTRATION FLUPHENAZINE VALIDATION & PROLIXIN  
 IF @DocumentCodeId in (118) AND @DrugId in (96, 57)   
  AND @Dose Not in ('12.5mg', '25mg', '37.5mg', '50mg', '62.5mg', '75mg', '87.5mg', '100mg', '112.5mg', '125mg')   
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Valid Dose: 12.5mg, 25mg, 37.5mg, 50mg, 62.5mg, 75mg, 87.5mg, 100mg, 112.5mg, 125mg'  
    
 END  
   
   
 IF @DocumentCodeId in (118) AND @DrugId in (96, 57)   
  AND @Strength Not in ('25mg/ml')   
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Valid Strength: 25mg/ml'  
    
 END  
   
   
 -- MEDICATION ADMINASTRATION HALDOL VALIDATION  
 IF @DocumentCodeId in (118) AND @DrugId in (38, 39)   
  AND @Strength in ('100mg/ml')  
  AND @Dose Not in ('25mg','30mg', '50mg', '75mg', '100mg', '125mg', '150mg',  
      '175mg', '200mg', '225mg', '250mg', '275mg', '300mg',  
      '325mg', '350mg', '375mg', '400mg', '425mg', '450mg',  
      '475mg', '500mg')   
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Please enter a valid dose.'  
   
 END    
   
 IF @DocumentCodeId in (118) AND @DrugId in (38, 39)   
  AND @Strength in ('50mg/ml')  
  AND @Dose Not in ('25mg', '37.5mg', '50mg', '75mg', '100mg', '125mg', '150mg',  
      '175mg', '200mg', '225mg', '250mg') -- added 37.5mg for Sally Wagle per Jeannie  
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Valid dose: 25mg, 37.5mg, 50mg, 75mg, 100mg, 125mg, 150mg, 175mg, 200mg, 225mg, 250mg'  
   
 END   
   
   
 IF @DocumentCodeId in (118) AND @DrugId in (38, 39)   
  AND @Strength not in ('50mg/ml', '100mg/ml')  
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Valid strength: 50mg/ml, 100mg/ml'  
   
 END   
   
   
 -- MEDICATION ADMINISTRATION RISPERDAL CONSTA  
 IF @DocumentCodeId in (118) AND @DrugId in (64)   
  AND @Dose Not in ('25mg', '37.5mg', '50mg')   
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Valid dose: 25mg, 37.5mg, 50mg'  
   
 END   
/*   
 IF @DocumentCodeId in (118) AND @DrugId in (64)   
  AND @Strength Not in ('50mg/ml')   
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Valid strength: 50mg/ml'  
   
 END   
*/   
   
 -- MEDICATION ADMINISTRATION CLOZARIL  
 IF @DocumentCodeId in (118) AND @DrugId in (15)   
  AND @Dose Not in ('25mg', '50mg', '75mg', '100mg', '125mg', '150mg',  
      '175mg', '200mg', '225mg', '250mg', '275mg',   
      '300mg', '325mg', '350mg', '375mg', '400mg', '425mg',  
      '450mg', '475mg', '500mg', '525mg', '550mg', '575mg',  
      '600mg', '625mg', '650mg', '675mg', '700mg', '725mg',  
      '750mg', '775mg', '800mg', '825mg', '850mg', '875mg',  
      '900mg')   
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Please enter a valid dose.'  
   
 END   
   
 IF @DocumentCodeId in (118) AND @DrugId in (15)   
  AND @Strength Not in ('25mg', '100mg', '200mg')   
 BEGIN  
  SET @ReturnValue = 1  
  SET @ErrorMessage = 'Valid strength: 25mg, 100mg, 200mg'  
   
 END   
  
  
  
END  
  
select @ReturnValue as Value ,@ErrorMessage  as Message  
  
  --Checking For Errors  
  If (@@error!=0)  
  Begin  
   RAISERROR  20006   'scsp_SCValidateDrugs: An Error Occured'   
   Return  
   End           
          
  
End  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   