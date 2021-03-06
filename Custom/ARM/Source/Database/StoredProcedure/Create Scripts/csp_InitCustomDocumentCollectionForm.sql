/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentCollectionForm]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentCollectionForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentCollectionForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentCollectionForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	Procedure [dbo].[csp_InitCustomDocumentCollectionForm]    
 @ClientID int,                
 @StaffID int,              
 @CustomParameters xml      
AS    
BEGIN    
 Begin try      
 set @StaffID=1
    Declare @FinanciallyResponsible varchar(500)    
    Declare @ClientName varchar(500)    
    Declare @ClientAddress varchar(1000) 
    Declare @ClientStreet varchar(200)   
    Declare @ClientCity varchar(150)   
    Declare @ClientState varchar(20)   
    Declare @ClientZip varchar(50)   
    Declare @ClientSSN varchar(50)   
    Declare @ClientPhone varchar(50)   

    Declare @ClientInsurance varchar(500)   
    Declare @ClientInsuredID varchar(500)   


    Declare @CurrentUser varchar(500)    
    Declare @PrimaryClinician varchar(500)    
    Declare @ClientDOB char(10)    
    Declare @CurrentDate varchar(1000)    
    Declare @CurrentDateTime varchar(1000) 
    Declare @CurrentdateTimePlus14 varchar(1000)
    Declare @ClientPrefix varchar(25)
    Declare @ClinicianPhoneNumber varchar(100)      
    Declare @DocumentCodeId int    
    Declare @idoc int    
    Declare @TemplateText varchar(max)    

	SELECT	@FinanciallyResponsible =	(	CASE	WHEN	(	SELECT	C.FinanciallyResponsible
																FROM	Clients C
																WHERE	ClientId = @ClientID
															) = ''Y''
													THEN	(	SELECT	(ISNULL(C.FirstName, '''') + '' '' + ISNULL(C.LastName, ''''))
																FROM	Clients C
																WHERE	C.ClientId = @ClientID
															)
													ELSE	(	SELECT	(ISNULL(CC.FirstName, '''') + '' '' + ISNULL(CC.LastName, ''''))
																FROM	ClientContacts CC
																WHERE	CC.ClientId = @ClientID
																AND		CC.FinanciallyResponsible = ''Y''
															)
											END
										)

    select  @ClientName= (ISNULL(FirstName, '''') + '' '' + ISNULL(LastName, '''')),
			@ClientDOB=convert(varchar, DOB, 101),
			@ClientSSN=SSN from Clients where ClientId =@ClientID    
        
    --Setting value for custom Parameters    
    select  @ClientName= (ISNULL(FirstName, '''') + '' '' + ISNULL(LastName, '''')),
			@ClientDOB=convert(varchar, DOB, 101),
			@ClientSSN=SSN from Clients where ClientId =@ClientID    
        print @ClientName
    select @ClientAddress=display from ClientAddresses where ClientId =@ClientID    
        print @ClientAddress
    select @CurrentUser =UserCode from Staff where StaffId=@StaffID 
    
    select	@ClientStreet = address,
			@ClientCity = City,
			@ClientState = State,
			@ClientZip = Zip
		from	ClientAddresses where ClientId =@ClientID    
        print @ClientStreet

    select	@ClientPhone = PhoneNumber
		from	ClientPhones where ClientId =@ClientID    


	SELECT	@ClientInsurance = CP.CoveragePlanName,
			@ClientInsuredID = CCP.InsuredId
	FROM	CoveragePlans CP
	JOIN	ClientCoveragePlans CCP
	ON		CP.CoveragePlanId = CCP.CoveragePlanId
	JOIN	ClientCoverageHistory CCH
	ON		CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
	WHERE	CCH.COBOrder = 1
	AND		(	CCH.EndDate IS NULL
			OR	CCH.EndDate > GETDATE()
			)
	AND		CCP.ClientId = @ClientID
    
    
    Declare @TempPrefix varchar(25)
    Declare @TempMartialStatus int
    Declare @TempSex varchar(1)
    
    SELECT @TempPrefix = Prefix, @TempMartialStatus = MaritalStatus, @TempSex = Sex
    FROM Clients 
    WHERE ClientId = @ClientID
    
    SET @ClientPrefix = ISNULL(@TempPrefix,'''')
    
    --SET @ClientPrefix = CASE WHEN @TempPrefix IS NOT NULL THEN @TempPrefix
    --                         WHEN @TempSex = ''M'' THEN ''Mr. ''
    --                         WHEN @TempSex = ''F'' AND @TempMartialStatus IN (20123,20164,20170,20177) THEN ''Ms. ''
    --                         WHEN @TempSex = ''F'' AND @TempMartialStatus = 20154 THEN ''Mrs. ''
				--			 ELSE ''''
				--	    END
        
    select @PrimaryClinician = ISNULL((ISNULL(s.FirstName, '''') + '' '' + ISNULL(s.LastName, '''')) + ISNULL('', '' + gcDegree.CodeName, ''''), ''''),@ClinicianPhoneNumber=isnull(PhoneNumber,''________________'')
    from  dbo.Clients as c
    LEFT join dbo.Staff as s on s.StaffId = c.PrimaryClinicianId
    LEFT outer join dbo.GlobalCodes as gcDegree on gcDegree.GlobalCodeId = s.Degree
    where c.ClientId = @ClientId
    
 set @CurrentDate= case DATEPART(MONTH, GETDATE())
	when 1 then ''January''
	when 2 then ''February''
	when 3 then ''March''
	when 4 then ''April''
	when 5 then ''May''
	when 6 then ''June''
	when 7 then ''July''
	when 8 then ''August''
	when 9 then ''September''
	when 10 then ''October''
	when 11 then ''November''
	when 12 then ''December''
	end + '' '' + CAST(DATEPART(DAY, GETDATE()) as varchar) + '', '' + CAST(DATEPART(YEAR, GETDATE()) as varchar)
	
 set @CurrentDateTime= CAST(GETDATE() as varchar)
 
 set @CurrentdateTimePlus14= convert(varchar(max),(getdate()+14), 101)
        
    set @DocumentCodeId=0;    
    exec sp_xml_preparedocument @idoc output, @CustomParameters    
        
    select @DocumentCodeId = DocumentCodeId    
 from openxml(@idoc, ''Root/Parameters'',1) with (DocumentCodeId  int  ''@DocumentCodeId'')    
     
 if(@DocumentCodeId!=0)
 begin
	select @TemplateText=TextTemplate from DocumentCodes where DocumentCodeId=@DocumentCodeId     

	select @TemplateText = REPLACE(@TemplateText,''<financiallyResponsible>'',@FinanciallyResponsible)
	select @TemplateText = REPLACE(@TemplateText,''<clientName>'',@ClientName)

	select @TemplateText= REPLACE(@TemplateText,''<clientAddress>'',@ClientAddress)    
	select @TemplateText= REPLACE(@TemplateText,''<clientStreet>'',@ClientStreet)    
	select @TemplateText= REPLACE(@TemplateText,''<clientCity>'',@ClientCity)    
	select @TemplateText= REPLACE(@TemplateText,''<clientState>'',@ClientState)    
	select @TemplateText= REPLACE(@TemplateText,''<clientZip>'',@ClientZip)    
	select @TemplateText= REPLACE(@TemplateText,''<clientPhone>'',@ClientPhone)    

	select @TemplateText= REPLACE(@TemplateText,''<currentUser>'',@CurrentUser)    

	select @TemplateText= REPLACE(@TemplateText,''<clientSSN>'',@ClientSSN)    
	select @TemplateText= REPLACE(@TemplateText,''<clientDOB>'',@ClientDOB)    

	select @TemplateText= REPLACE(@TemplateText,''<clientInsurance>'',@ClientInsurance)    
	select @TemplateText= REPLACE(@TemplateText,''<clientInsuredId>'',@ClientInsuredID)    

	select @TemplateText= REPLACE(@TemplateText,''<currentDate>'',@CurrentDate)    

	select @TemplateText= REPLACE(@TemplateText,''<currentDateTime>'',@CurrentDateTime)    

	select @TemplateText= REPLACE(@TemplateText,''<primaryClinician>'',@PrimaryClinician)
	
	select @TemplateText= REPLACE(@TemplateText,''<CurrentDateTimePlus14>'',@CurrentdateTimePlus14)
	
	select @TemplateText= REPLACE(@TemplateText,''<clientPrefix>'',@ClientPrefix)
	
    select @TemplateText= dbo.fn_ReplaceParametersDocumentLetters(@TemplateText,''<primaryClinicianPhoneNumber>'',@ClinicianPhoneNumber)        

end

Select TOP 1 ''TextDocuments'' AS TableName, -1 as ''DocumentVersionId''                  
,@TemplateText as TextData                        
,'''' as CreatedBy,                                
getdate() as CreatedDate,                                
'''' as ModifiedBy,                                
getdate() as ModifiedDate                                  
from systemconfigurations s left outer join TextDocuments                                                                                  
on s.Databaseversion = -1       
 end try                                                          
                                                                                                   
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCInitializeDocumentLetters'')                                                                                         
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + ''*****'' + Convert(varchar,ERROR_STATE())                                      
 RAISERROR                                                                                         
 (       
  @Error, -- Message text.                                                                                        
  16, -- Severity.                                                            
  1 -- State.                                                                                        
 );                                                                                      
END CATCH                                     
END 
' 
END
GO
