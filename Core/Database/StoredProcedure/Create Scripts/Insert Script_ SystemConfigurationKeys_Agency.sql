
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AgencyName') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'AgencyName' 
				,AgencyName
				,'Agency Name' 
				,'Agency Name' 
				,'N' 
				,'Agency Name in Agency Table' 
				,'Agency' 
				FROM Agency 
   END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AgencyName FROM Agency)
		   ,AcceptedValues = 'Agency Name'
		   ,[Description]= 'Agency Name'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Agency Name in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='AgencyName';
   END	   
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AbbreviatedAgencyName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'AbbreviatedAgencyName' 
				,AbbreviatedAgencyName
				,'Abbreviated Agency Name' 
				,'Abbreviated Agency Name' 
				,'N' 
				,'Abbreviated Agency Name in Agency Table' 
				,'Agency' 
				FROM Agency 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AbbreviatedAgencyName FROM Agency)
		   ,AcceptedValues = 'Abbreviated Agency Name'
		   ,[Description]= 'Abbreviated Agency Name'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Abbreviated Agency Name in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='AbbreviatedAgencyName';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Address') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'Address' 
				,[Address]
				,'Agency Address' 
				,'Address' 
				,'N' 
				,'Address in Agency Table' 
				,'Agency' 
				FROM Agency 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select [Address] FROM Agency)
		   ,AcceptedValues = 'Agency Address'
		   ,[Description]= 'Address'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Address in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='Address';
   END	  
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'City') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'City' 
				,City
				,'Agency City'
				,'City' 
				,'N' 
				,'City in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select City FROM Agency)
		   ,AcceptedValues = 'Agency City'
		   ,[Description]= 'City'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'City in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='City';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'State') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'State' 
				,[State]
				,'Agency State'
				,'State' 
				,'N' 
				,'State in Agency Table' 
				,'Agency' 
				FROM Agency 
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select [State] FROM Agency)
		   ,AcceptedValues = 'Agency State'
		   ,[Description]= 'State'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'State in Agency Table'  
		   ,SourceTableName= 'Agency'
			WHERE [Key]='State';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ZipCode') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ZipCode' 
				,ZipCode
				,'Agency ZipCode'
				,'ZipCode' 
				,'N' 
				,'ZipCode in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ZipCode FROM Agency)
		   ,AcceptedValues = 'Agency ZipCode'
		   ,[Description]= 'ZipCode'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'ZipCode in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='ZipCode';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AddressDisplay') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'AddressDisplay' 
				,AddressDisplay
				,'Agency Address Display'
				,'Address Display' 
				,'N' 
				,'Address Display in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AddressDisplay FROM Agency)
		   ,AcceptedValues = 'Agency Address Display'
		   ,[Description]= 'Address Display'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Address Display in Agency Table'
		   ,SourceTableName= 'Agency'
			WHERE [Key]='AddressDisplay';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PaymentAddress') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PaymentAddress' 
				,PaymentAddress 
				,'Payment Address'
				,'Payment Address' 
				,'N' 
				,'Payment Address in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PaymentAddress FROM Agency)
		   ,AcceptedValues = 'Payment Address'
		   ,[Description]= 'Payment Address'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Payment Address in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='PaymentAddress';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PaymentCity') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PaymentCity' 
				,PaymentCity
				,'Payment City'
				,'Payment City' 
				,'N' 
				,'Payment City in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PaymentCity FROM Agency)
		   ,AcceptedValues = 'Payment City'
		   ,[Description]= 'Payment City'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Payment City in Agency Table'  
		   ,SourceTableName= 'Agency'
			WHERE [Key]='PaymentCity';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PaymentState') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PaymentState' 
				,PaymentState
				,'Payment State'
				,'Payment State' 
				,'N' 
				,'Payment State in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PaymentState FROM Agency)
		   ,AcceptedValues = 'Payment State'
		   ,[Description]= 'Payment State'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Payment State in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='PaymentState';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PaymentZip') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PaymentZip' 
				,PaymentZip
				,'Payment ZipCode'
				,'Payment Zip' 
				,'N' 
				,'Payment Zip in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PaymentZip FROM Agency)
		   ,AcceptedValues = 'Payment ZipCode'
		   ,[Description]= 'Payment Zip'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Payment Zip in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='PaymentZip';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PaymentAddressDisplay') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PaymentAddressDisplay' 
				,PaymentAddressDisplay 
				,'Payment Address Display'
				,'Payment Address Display' 
				,'N' 
				,'Payment Address Display in Agency Table' 
				,'Agency'
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PaymentAddressDisplay FROM Agency)
		   ,AcceptedValues = 'Payment Address Display'
		   ,[Description]= 'Payment Address Display'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Payment Address Display in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='PaymentAddressDisplay';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'TaxId') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'TaxId' 
				,TaxId
				,'Tax Id'
				,'Tax Id' 
				,'N' 
				,'Tax Id in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select TaxId FROM Agency)
		   ,AcceptedValues = 'Tax Id'
		   ,[Description]= 'Tax Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Tax Id in Agency Table'  
		   ,SourceTableName= 'Agency'
			WHERE [Key]='TaxId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MainPhone') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'MainPhone' 
				,MainPhone 
				,'Main Phone'
				,'Main Phone' 
				,'N' 
				,'Main Phone in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select MainPhone FROM Agency)
		   ,AcceptedValues = 'Main Phone'
		   ,[Description]= 'Main Phone'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Main Phone in Agency Table'
		   ,SourceTableName= 'Agency'
			WHERE [Key]='MainPhone';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'IntakePhone') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'IntakePhone' 
				,IntakePhone 
				,'Intake Phone'
				,'Intake Phone' 
				,'N' 
				,'Intake Phone in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select IntakePhone FROM Agency)
		   ,AcceptedValues = 'Intake Phone'
		   ,[Description]= 'Intake Phone'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Intake Phone in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='IntakePhone';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BillingPhone') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'BillingPhone' 
				,BillingPhone
				,'Billing Phone'
				,'Billing Phone' 
				,'N' 
				,'Billing Phone in Agency Table' 
				,'Agency'
				FROM Agency 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select BillingPhone FROM Agency)
		   ,AcceptedValues = 'Billing Phone'
		   ,[Description]= 'Billing Phone'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Billing Phone in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='BillingPhone';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BillingContact') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'BillingContact' 
				,BillingContact
				,'Billing Contact'
				,'Billing Contact' 
				,'N' 
				,'Billing Contact in Agency Table' 
				,'Agency' 
				FROM Agency 
   END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select BillingContact FROM Agency)
		   ,AcceptedValues = 'Billing Contact'
		   ,[Description]= 'Billing Contact'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Billing Contact in Agency Table'  
		   ,SourceTableName= 'Agency'
			WHERE [Key]='BillingContact';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NationalProviderId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'NationalProviderId' 
				,NationalProviderId
				,'National Provider Id'
				,'National Provider Id' 
				,'N' 
				,'National Provider Id'
				,'Agency' 
				FROM Agency 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NationalProviderId FROM Agency)
		   ,AcceptedValues = 'National Provider Id'
		   ,[Description]= 'National Provider Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'National Provider Id'
		   ,SourceTableName= 'Agency'
			WHERE [Key]='NationalProviderId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FaxNumber') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'FaxNumber' 
				,FaxNumber
				,'Fax Number'
				,'Fax Number' 
				,'N' 
				,'Fax Number in Agency Table' 
				,'Agency' 
				FROM Agency
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select FaxNumber FROM Agency)
		   ,AcceptedValues = 'Fax Number'
		   ,[Description]= 'Fax Number'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Fax Number in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='FaxNumber';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BillingEmail') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'BillingEmail' 
				,BillingEmail
				,'Billing Email'
				,'Billing Email' 
				,'N' 
				,'Billing Email in Agency Table' 
				,'Agency' 
				FROM Agency 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select BillingEmail FROM Agency)
		   ,AcceptedValues = 'Billing Email'
		   ,[Description]= 'Billing Email'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Billing Email in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='BillingEmail';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BillingTaxonomy') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'BillingTaxonomy' 
				,BillingTaxonomy 
				,'Billing Taxonomy'
				,'Billing Taxonomy' 
				,'N' 
				,'Billing Taxonomy in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select BillingTaxonomy FROM Agency)
		   ,AcceptedValues = 'Billing Taxonomy'
		   ,[Description]= 'Billing Taxonomy'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Billing Taxonomy in Agency Table' 
		   ,SourceTableName= 'Agency'
			WHERE [Key]='BillingTaxonomy';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CountyFIPS') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'CountyFIPS' 
				,CountyFIPS 
				,'County FIPS must be from Counties Table'
				,'County FIPS' 
				,'N' 
				,'County FIPS in Agency Table' 
				,'Agency' 
				FROM Agency 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select CountyFIPS FROM Agency)
		   ,AcceptedValues = 'County FIPS must be from Counties Table'
		   ,[Description]= 'County FIPS'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'County FIPS in Agency Table'
		   ,SourceTableName= 'Agency'
			WHERE [Key]='CountyFIPS';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProviderId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProviderId' 
				,ProviderId 
				,'Provider Id must be from Providers list'
				,'Provider Id' 
				,'N' 
				,'Provider Id in Agency Table' 
				,'Agency' 
				FROM Agency 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProviderId FROM Agency)
		   ,AcceptedValues = 'Provider Id must be from Providers list'
		   ,[Description]= 'Provider Id' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Provider Id in Agency Table'  
		   ,SourceTableName= 'Agency'
			WHERE [Key]='ProviderId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

--select * from Agency
----AgencyId
--			AgencyName
----CreatedBy
----CreatedDate
----ModifiedBy
----ModifiedDate
--			AbbreviatedAgencyName
--			Address
--			City
--			State
--			ZipCode
--			AddressDisplay
--			PaymentAddress
--			PaymentCity
--			PaymentState
--			PaymentZip
--			PaymentAddressDisplay
--			TaxId
--			CountyFIPS
--			MainPhone
--			IntakePhone
--			BillingPhone
--			BillingContact
--			ProviderId
--			NationalProviderId
--			FaxNumber
--			BillingEmail
--			BillingTaxonomy
