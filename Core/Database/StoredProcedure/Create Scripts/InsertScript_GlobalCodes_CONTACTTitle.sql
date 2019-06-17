

-- Global codes script for category CONTACTTITLE and CONTACTTITLE related Global codes 
--Created By	Created Date:
--	bdsahu		10 NOV 2016
-- what:task #49 -ASPENPOINTE-SGL


/* Insert Category 'CONTRACTTYPE' in   GlobalCodeCategories */
IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='CONTACTTITLE')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('CONTACTTITLE',
			'CONTACTTITLE',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

/* Insert GlobalCOdes in GlobalCodes table for Category 'CONTACTTITLE' */
IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  Category='CONTACTTITLE' And Code='CEO') 
  BEGIN 
     
		INSERT INTO GlobalCodes 
				(
				Category, 
				CodeName, 
				Code,
				Active, 
				CannotModifyNameOrDelete) 
		VALUES  (
				'CONTACTTITLE', 
				'CEO',
				'CEO',
				'Y', 
				'N') 
             
  END 
  
  IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  Category='CONTACTTITLE' And Code='CFO') 
  BEGIN 
     
		INSERT INTO GlobalCodes 
				(
				Category, 
				CodeName, 
				Code,
				Active, 
				CannotModifyNameOrDelete) 
		VALUES  (
				'CONTACTTITLE', 
				'CFO',
				'CFO',
				'Y', 
				'N') 
           
  END
  
IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  Category='CONTACTTITLE' And Code='CONTRACTINGMANAGER') 
  BEGIN 
     
		INSERT INTO GlobalCodes 
				(
				Category, 
				CodeName, 
				Code,
				Active, 
				CannotModifyNameOrDelete) 
		VALUES  (
				'CONTACTTITLE', 
				'Contracting Manager',
				'CONTRACTINGMANAGER',
				'Y', 
				'N') 
             
  END
IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  Category='CONTACTTITLE' And Code='OWNER') 
  BEGIN 

		INSERT INTO GlobalCodes 
				(
				Category, 
				CodeName, 
				Code,
				Active, 
				CannotModifyNameOrDelete) 
		VALUES  (
				'CONTACTTITLE', 
				'Owner',
				'OWNER',
                'Y', 
				'N') 
                  
  END 
  
  IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  Category='CONTACTTITLE' And Code='CLINICALDIRECTOR') 
  BEGIN 
     
		INSERT INTO GlobalCodes 
				(
				Category, 
				CodeName, 
				Code,
				Active, 
				CannotModifyNameOrDelete) 
		VALUES  (
				'CONTACTTITLE', 
				'Clinical Director',
				'CLINICALDIRECTOR', 
                'Y', 
				'N') 
          
  END
  IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  Category='CONTACTTITLE' And Code='OTHER') 
  BEGIN 

		INSERT INTO GlobalCodes 
				(
				Category, 
				CodeName, 
				Code,
				Active, 
				CannotModifyNameOrDelete) 
		VALUES  (
				'CONTACTTITLE', 
				'OTHER',
				'Other',
				'Y', 
				'N') 
            
  END
  
  
  Update GlobalCodes Set Code='OTHER',Codename='Other' Where 
  Category='CONTACTTITLE' AND  Code='OTHER'