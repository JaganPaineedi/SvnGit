/****** Object:  StoredProcedure [dbo].[ssp_SCInitializeDocumentLetters]    Script Date: 04-12-2018 17:59:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInitializeDocumentLetters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInitializeDocumentLetters]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitializeDocumentLetters]    Script Date: 04-12-2018 17:59:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[ssp_SCInitializeDocumentLetters]   
 @ClientID int,                  
 @StaffID int,                
 @CustomParameters xml        
AS      
  
      
/************************************************************************/                                                                    
/* Stored Procedure: ssp_SCInitializeDocumentLetters        */                                                           
/*        */                                                                    
/* Creation Date:            */                                                                    
/*                  */                                                                    
/* Purpose: Initialize Data for scsp_SCInitializeDocumentLetters       */                                                                   
/* Input Parameters: ClientId, StaffId, CustomParamters        */                                                                  
/* Output Parameters:             */                                                                    
/* Purpose: Use For Letter Template Documents/Service Notes           */                                                          
/* Calls:                */                                                                    
/*                  */                                                                    
/* Author:               
History  
12/04/2018 Msood What: Calling SCSP as per customer requirements    
     Why: ViaQuest - Customizations Task #2  
          
/*1 Feb 2019 PradeepT  What:Removed StaffId parameter hard coded value.Made null check of local sql variable.  */
/*                     Why:Hard coded Staff id parameter may say incorrect current user. */
/*                     We are concanating the value of declared local sql variables and if any one have null value */ 
/*                     then the result becomes null and hence initialization does not work as per task Unison EIT-#526   */                                                             
/*********************************************************************/  */  
  
BEGIN      
 Begin try        
     
    Declare  @ClientName varchar(500)      
    Declare @ClientAddress varchar(1000)      
    Declare @CurrentUser varchar(500)      
    Declare @PrimaryClinician varchar(500)      
    Declare @ClientDOB datetime      
    Declare @CurrentDate varchar(1000)      
    Declare @CurrentDateTime varchar(1000)   
    Declare @CurrentdateTimePlus14 varchar(1000)  
    Declare @ClientPrefix varchar(25)  
    Declare @ClinicianPhoneNumber varchar(100)        
    Declare @DocumentCodeId int      
    Declare @idoc int      
    Declare @TemplateText varchar(max)      
    
 -- Msood 12/04/2018  
   IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCInitializeDocumentLetters]') AND type in (N'P', N'PC'))          
 BEGIN          
  EXEC scsp_SCInitializeDocumentLetters @ClientID, @StaffID,  @CustomParameters     
 END  
 Else   
    --Setting value for custom Parameters      
    select  @ClientName= (ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')),@ClientDOB=DOB from Clients where ClientId =@ClientID      
       
    select @ClientAddress=ISNULL(display,'') from ClientAddresses where ClientId =@ClientID      
        
    select @CurrentUser =ISNULL(UserCode,'') from Staff where StaffId=@StaffID   
      
    Declare @TempPrefix varchar(25)  
    Declare @TempMartialStatus int  
    Declare @TempSex varchar(1)  
      
    SELECT @TempPrefix = ISNULL(Prefix,''), @TempMartialStatus = ISNULL(MaritalStatus,''), @TempSex = ISNULL(Sex,'')  
    FROM Clients   
    WHERE ClientId = @ClientID  
      
    SET @ClientPrefix = ISNULL(@TempPrefix,'')  
                
    select @PrimaryClinician = ISNULL((ISNULL(s.FirstName, '') + ' ' + ISNULL(s.LastName, '')) + ISNULL(', ' + gcDegree.CodeName, ''), ''),@ClinicianPhoneNumber=isnull(PhoneNumber,'________________')  
    from  dbo.Clients as c  
    LEFT join dbo.Staff as s on s.StaffId = c.PrimaryClinicianId  
    LEFT outer join dbo.GlobalCodes as gcDegree on gcDegree.GlobalCodeId = s.Degree  
    where c.ClientId = @ClientId  
      
 set @CurrentDate= case DATEPART(MONTH, GETDATE())  
 when 1 then 'January'  
 when 2 then 'February'  
 when 3 then 'March'  
 when 4 then 'April'  
 when 5 then 'May'  
 when 6 then 'June'  
 when 7 then 'July'  
 when 8 then 'August'  
 when 9 then 'September'  
 when 10 then 'October'  
 when 11 then 'November'  
 when 12 then 'December'  
 end + ' ' + CAST(DATEPART(DAY, GETDATE()) as varchar) + ', ' + CAST(DATEPART(YEAR, GETDATE()) as varchar)  
   
 set @CurrentDateTime= CAST(GETDATE() as varchar)  
   
 set @CurrentdateTimePlus14= convert(varchar(max),(getdate()+14), 101)  
          
    set @DocumentCodeId=0;      
    exec sp_xml_preparedocument @idoc output, @CustomParameters      
          
    select @DocumentCodeId = DocumentCodeId      
 from openxml(@idoc, 'Root/Parameters',1) with (DocumentCodeId  int  '@DocumentCodeId')      
       
 if(@DocumentCodeId!=0)  
 begin  
 select @TemplateText=TextTemplate from DocumentCodes where DocumentCodeId=@DocumentCodeId       
  
 select @TemplateText = REPLACE(@TemplateText,'<clientName>',@ClientName)  
  
 select @TemplateText= REPLACE(@TemplateText,'<clientAddress>',ISNULL(@ClientAddress,''))      
  
 select @TemplateText= REPLACE(@TemplateText,'<currentUser>',ISNULL(@CurrentUser,''))   
       
  
 select @TemplateText= REPLACE(@TemplateText,'<clientDOB>',@ClientDOB)      
  
 select @TemplateText= REPLACE(@TemplateText,'<currentDate>',@CurrentDate)      
  
 select @TemplateText= REPLACE(@TemplateText,'<currentDateTime>',@CurrentDateTime)      
  
 select @TemplateText= REPLACE(@TemplateText,'<primaryClinician>',ISNULL(@PrimaryClinician,''))  
   
 select @TemplateText= REPLACE(@TemplateText,'<CurrentDateTimePlus14>',ISNULL(@CurrentdateTimePlus14,''))  
   
 select @TemplateText= REPLACE(@TemplateText,'<clientPrefix>',ISNULL(@ClientPrefix,''))  
   
    select @TemplateText= dbo.fn_ReplaceParametersDocumentLetters(@TemplateText,'<primaryClinicianPhoneNumber>',@ClinicianPhoneNumber)          
  
end  
  
Select TOP 1 'TextDocuments' AS TableName, -1 as 'DocumentVersionId'                    
,@TemplateText as TextData                          
,'' as CreatedBy,                                  
getdate() as CreatedDate,                                  
'' as ModifiedBy,                                  
getdate() as ModifiedDate                                    
from systemconfigurations s left outer join TextDocuments                                                                                    
on s.Databaseversion = -1         
 end try                                                            
                                                                                                     
BEGIN CATCH          
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCInitializeDocumentLetters')                                                                                           
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