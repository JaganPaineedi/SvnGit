/****** Object:  UserDefinedFunction [dbo].[GetContactData]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContactData]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetContactData]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContactData]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






CREATE FUNCTION [dbo].[GetContactData]
(@ClientId int )

RETURNS @rettable TABLE (ClientContactId int ,
		ClientId int , 
		Relationship int , 
		FirstName varchar(100),
		LastName varchar (100), 
		MiddleName varchar (100), 
		Prefix varchar (100), 
		Suffix varchar (100), 
		FinanciallyResponsible varchar (100) ,
		Organization varchar (100), 
		DOB varchar (100),	
		Guardian varchar (100), 
		EmergencyContact varchar (100), 
		ListAs varchar (100),
		Email varchar (100),
		Comment varchar (100),
		RowIdentifier varchar (100),
		ExternalReferenceId varchar (100),
		CreatedBy varchar (100), 
		CreatedDate datetime, 
		ModifiedBy varchar (100), 
		ModifiedDate datetime, 
		RecordDeleted varchar (100), 
		DeletedDate datetime,
		DeletedBy varchar (100),
		CodeName  varchar(100), 
		RadioButton varchar (100)  ,--For ClientContactId Radio Button - TOBE Removed	
                          Phone varchar (100),
		Address varchar (100) )

AS  

BEGIN 

	DECLARE @TempClientContactData  TABLE (ClientContactId int ,
		ClientId int , 
		Relationship int , 
		FirstName varchar(100),
		LastName varchar (100), 
		MiddleName varchar (100), 
		Prefix varchar (100), 
		Suffix varchar (100), 
		FinanciallyResponsible varchar (100) ,
		Organization varchar (100), 
		DOB varchar (100),	
		Guardian varchar (100), 
		EmergencyContact varchar (100), 
		ListAs varchar (100),
		Email varchar (100),
		Comment varchar (100),
		RowIdentifier varchar (100),
		ExternalReferenceId varchar (100),
		CreatedBy varchar (100), 
		CreatedDate datetime, 
		ModifiedBy varchar (100), 
		ModifiedDate datetime, 
		RecordDeleted varchar (100), 
		DeletedDate datetime,
		DeletedBy varchar (100),
		CodeName  varchar(100), 
		RadioButton varchar (100)  ,--For ClientContactId Radio Button - TOBE Removed	
                          Phone varchar (100),
		Address varchar (100) )


	DECLARE @ClientContactId int

	DECLARE CurClientContactId  cursor for 
	select ClientContactId from clientcontacts
	WHERE ClientId = @ClientId  AND (RecordDeleted = ''N'' ) 

	open CurClientContactId

	FETCH NEXT FROM CurClientContactId INTO @ClientContactId

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		INSERT @TempClientContactData
		SELECT
		CC.ClientContactId , CC.ClientId, CC.Relationship, CC.FirstName, CC.LastName, CC.MiddleName, 
		CC.Prefix, CC.Suffix, CC.FinanciallyResponsible, CC.Organization, CONVERT(VARCHAR,CC.DOB,101) AS DOB,	
		CC.Guardian, CC.EmergencyContact, CC.ListAs, CC.Email, 	CC.Comment, CC.RowIdentifier, CC.ExternalReferenceId, CC.CreatedBy, 
		CC.CreatedDate, CC.ModifiedBy, CC.ModifiedDate, CC.RecordDeleted, CC.DeletedDate, CC.DeletedBy,
		GC.CodeName,	''N'' AS RadioButton ,--For ClientContactId Radio Button - TOBE Removed	
		 dbo.GetContactphone(@ClientContactId) as Phone  ,dbo.GetContactAddress(@ClientContactId) as Address


		FROM
			clientcontacts CC
		
		INNER JOIN
			GlobalCodes GC
		ON 
			CC.Relationship = GC.GlobalCodeId
		WHERE 
			CC.ClientId=@ClientId
			AND CC.ClientContactId = @ClientContactId		
			AND (CC.RecordDeleted = ''N'' OR CC.RecordDeleted IS NULL)



		FETCH NEXT FROM CurClientContactId INTO @ClientContactId
	END
	
close  CurClientContactId

deallocate CurClientContactId



INSERT @rettable
select ClientContactId ,ClientId , Relationship , FirstName ,LastName , MiddleName , 
Prefix , Suffix , FinanciallyResponsible ,Organization , DOB ,Guardian , EmergencyContact , 
ListAs ,Email ,Comment ,RowIdentifier ,	ExternalReferenceId ,CreatedBy , CreatedDate , ModifiedBy , ModifiedDate , 
RecordDeleted , DeletedDate ,DeletedBy ,CodeName  , RadioButton  ,--For ClientContactId Radio Button - TOBE Removed	
Phone ,Address   from @TempClientContactData

return 

END












' 
END
GO
