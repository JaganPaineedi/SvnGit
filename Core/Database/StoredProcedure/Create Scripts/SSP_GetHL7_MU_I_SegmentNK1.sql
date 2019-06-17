/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentNK1]    Script Date: 06/09/2016 23:33:50 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_I_SegmentNK1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentNK1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentNK1]    Script Date: 06/09/2016 23:33:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentNK1] 
	 @VendorId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ClientID INT
	,@ClientImmunizationId INT
	,@NK1SegmentRaw NVARCHAR(max) OUTPUT
AS
--===================================          
-- DESC : Gets diagnosescode an description based on the clientId.           
--    As the diagnoses is a document in SC we fetch all ICD codes            
--    and its description for the documents which are signed (valid) 
-- Author: Varun         
--===================================          
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @NK1Segment NVARCHAR(max)
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @ClientContactId iNT
		DECLARE @FirstName VARCHAR(50)
		DECLARE @LastName VARCHAR(50)
		DECLARE @MiddleName VARCHAR(50)
		DECLARE @RelationShipCode VARCHAR(50)
		DECLARE @RelationShipName VARCHAR(50)
		DECLARE @AddressType INT
		DECLARE @Address VARCHAR(500)
		DECLARE @City VARCHAR(50)
		DECLARE @State VARCHAR(50)
		DECLARE @Zip INT
		DECLARE @PhoneNumberText VARCHAR(50)
		DECLARE @PhoneType  INT

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'NK1'

		CREATE TABLE #tempGuardianTable (
			SetId INT identity(1, 1)
			,ClientContactId INT
			,FirstName VARCHAR(50)
			,LastName VARCHAR(50)
			,MiddleName VARCHAR(50)
			,RelationShipCode VARCHAR(50)
			,RelationShipName VARCHAR(50)
			,AddressType INT
			,Address VARCHAR(500)
			,City VARCHAR(50)
			,State VARCHAR(50)
			,Zip INT
			,PhoneNumberText VARCHAR(50)
			,PhoneType  INT
			);


		WITH ClientContacts_CTE (
		ClientContactId
			,FirstName
			,LastName
			,MiddleName
			,RelationShipCode
			,RelationShipName
			)
		AS (
			SELECT DISTINCT
	 CC.ClientContactId
	,CC.FirstName
	,CC.LastName
	,CC.MiddleName
	,GC.ExternalCode2
	,GC.Code
	From ClientContacts CC
	JOIN Clients C on CC.ClientId=C.ClientId 
	JOIN GlobalCodes GC on GC.GlobalCodeId=CC.Relationship
	WHERE C.ClientId=@ClientID
	AND ISNULL(CC.RecordDeleted,'N')<>'Y'
	AND ISNULL(GC.RecordDeleted,'N')<>'Y'
			)
		--ORDER by DV.DocumentVersionId DESC)          
		INSERT INTO #tempGuardianTable (
			 ClientContactId 
			,FirstName
			,LastName
			,MiddleName
			,RelationShipCode
			,RelationShipName
			)
		SELECT ClientContactId 
			,FirstName
			,LastName
			,MiddleName
			,RelationShipCode
			,RelationShipName
		FROM ClientContacts_CTE CC

		UPDATE #tempGuardianTable
		SET AddressType= (SELECT TOP 1 CCA.AddressType
		FROM ClientContactAddresses CCA
		WHERE CCA.ClientContactId=#tempGuardianTable.ClientContactId AND ISNULL(CCA.RecordDeleted,'N')<>'Y'
		Order By CCA.AddressType)

		UPDATE #tempGuardianTable
		SET Address=CCA.Address
		,City=CCA.City
		,State=CCA.State
		,Zip=CCA.Zip
	    FROM ClientContactAddresses CCA
		WHERE CCA.AddressType= #tempGuardianTable.AddressType
		AND CCA.ClientContactId= #tempGuardianTable.ClientContactId

		UPDATE #tempGuardianTable
		SET PhoneType= (SELECT TOP 1 CCP.PhoneType
		FROM ClientContactPhones CCP
		WHERE CCP.ClientContactId=#tempGuardianTable.ClientContactId AND ISNULL(CCP.RecordDeleted,'N')<>'Y'
		Order By CCP.PhoneType)

		UPDATE #tempGuardianTable
		SET PhoneNumberText = CCP.PhoneNumberText
	    FROM ClientContactPhones CCP
		WHERE CCP.PhoneType= #tempGuardianTable.PhoneType
		AND CCP.ClientContactId= #tempGuardianTable.ClientContactId AND ISNULL(CCP.RecordDeleted,'N')<>'Y'
		
		DECLARE @Counter INT
		DECLARE @TotalClientContacts INT

		SET @Counter = 1

		SELECT @TotalClientContacts= count(*)
		FROM #tempGuardianTable

		DECLARE ClientContactsCRSR CURSOR LOCAL SCROLL STATIC
		FOR
		SELECT SetId
			,ClientContactId
			,FirstName
			,LastName
			,MiddleName
			,RelationShipCode
			,RelationShipName
			,AddressType
			,Address
			,City
			,State
			,Zip
			,PhoneNumberText
			,PhoneType
		FROM #tempGuardianTable

		OPEN ClientContactsCRSR

		FETCH NEXT
		FROM ClientContactsCRSR
		INTO @SetId
			,@ClientContactId
		    ,@FirstName
			,@LastName
			,@MiddleName
			,@RelationShipCode
			,@RelationShipName
			,@AddressType
			,@Address
			,@City
			,@State
			,@Zip
			,@PhoneNumberText
			,@PhoneType

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @PrevString NVARCHAR(max)

			SELECT @PrevString = ISNULL(@NK1Segment, '')
			SET @NK1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @LastName + @CompChar + @FirstName + @CompChar + ISNULL(@MiddleName,'NA') + @CompChar + @CompChar +@CompChar +@CompChar +'L'
			+ @FieldChar + ISNULL(@RelationShipCode,'') + @CompChar + ISNULL(@RelationShipName,'')  + @CompChar + 'HL70063' + @FieldChar + ISNULL(@Address,'') + @CompChar + @CompChar +ISNULL(@City,'')+ @CompChar+ ISNULL(@State ,'') + @CompChar + ISNULL(CAST(@Zip AS varchar),'') + @CompChar + 'USA' + @CompChar + 'P'
			+ @FieldChar + @CompChar + 'PRN' + @CompChar + CASE CAST(@PhoneType AS INT) WHEN 30 THEN 'PH' WHEN 34 THEN 'CP' WHEN 36 THEN 'FX' END + @CompChar+ @CompChar+ @CompChar + SUBSTRING ( @PhoneNumberText , 1 , 3 ) + @CompChar + SUBSTRING ( @PhoneNumberText , 4 , LEN(@PhoneNumberText) )
			SELECT @NK1Segment = @PrevString + @NK1Segment + CHAR(13)
			FETCH NEXT
			FROM ClientContactsCRSR
			INTO @SetId
			,@ClientContactId
		    ,@FirstName
			,@LastName
			,@MiddleName
			,@RelationShipCode
			,@RelationShipName
			,@AddressType
			,@Address
			,@City
			,@State
			,@Zip
			,@PhoneNumberText
			,@PhoneType
		END

		CLOSE ClientContactsCRSR

		DEALLOCATE ClientContactsCRSR

		SET @NK1SegmentRaw = ISNULL(LTRIM(RTRIM(STUFF(@NK1Segment, LEN(@NK1Segment), 1, ''))), '')
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_I_SegmentNK1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		INSERT INTO ErrorLog (
			ErrorMessage
			,VerboseInfo
			,DataSetInfo
			,ErrorType
			,CreatedBy
			,CreatedDate
			)
		VALUES (
			@Error
			,NULL
			,NULL
			,'HL7 Procedure Error'
			,'SmartCare'
			,GetDate()
			)
	END CATCH
END
GO

