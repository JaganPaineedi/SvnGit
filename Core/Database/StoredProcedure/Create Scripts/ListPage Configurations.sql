IF EXISTS ( SELECT 1
			FROM dbo.ListPageColumnConfigurations AS a
			WHERE ISNULL(a.Template,'N') = 'Y'
			OR a.ViewName = 'Original'
			)
			BEGIN
			DELETE FROM a FROM dbo.ListPageColumnConfigurationColumns AS a
			JOIN dbo.ListPageColumnConfigurations AS b ON b.ListPageColumnConfigurationId = a.ListPageColumnConfigurationId
			AND ( ISNULL(b.Template,'Y') = 'Y' OR b.ViewName = 'Original' )

			DELETE FROM dbo.ListPageColumnConfigurations WHERE ISNULL(Template,'N') = 'Y' OR ViewName = 'Original'
			END 
INSERT INTO dbo.ListPageColumnConfigurations ( ScreenId, StaffId,
                                                ViewName, Active, DefaultView,Template )
SELECT 907, NULL, 'Original','Y',NULL,'Y'
DECLARE @Id INT 

SET @Id = SCOPE_IDENTITY()

INSERT INTO dbo.ListPageColumnConfigurationColumns ( 
                                          ListPageColumnConfigurationId, FieldName, Caption, DisplayAs, SortOrder, ShowColumn, Width, Fixed )
SELECT @Id,'DisplayAs','Bed','Bed',0,'Y',75,'Y'
UNION ALL
SELECT @Id,'ClientName','Client Name','Client Name',1,'Y',150,'Y'
UNION ALL
SELECT @Id,'LegalStatusOrders','Legal Status Orders','Legal Status',2,'Y',100,'Y'
UNION ALL
SELECT @Id,'LegalStatus','Legal Status','Legal Status',3,'N',80,'Y'
UNION ALL
SELECT @Id,'UO','UO','UO',4,'Y',50,NULL
UNION ALL
SELECT @Id,'MAR','MAR','MAR',5,'Y',150,NULL
UNION ALL
SELECT @Id,'OrderLevel','Level','Level',6,'Y',150,NULL
UNION ALL
SELECT @Id,'Observations','Observations','Observations',7,'Y',250,NULL
UNION ALL
SELECT @Id,'Precautions','Precautions','Precautions',8,'Y',100,NULL
UNION ALL 
SELECT @Id,'PrecautionCodes','Precaution Codes','Precaution Codes',9,'N',250, NULL
UNION ALL
SELECT @Id,'Therapist','Therapist','Therapist',10,'Y',150,NULL
UNION ALL
SELECT @Id,'Attending','Attending','Attending',11,'Y',150,NULL
UNION ALL
SELECT @Id,'DOA','DOA','DOA',12,'Y',100,NULL
UNION ALL
SELECT @Id,'EDD','EDD','EDD',13,'Y',100,NULL
UNION ALL
SELECT @Id,'LCD','LCD','LCD',14,'Y',100,NULL
UNION ALL
SELECT @Id,'LOS','LOS','LOS',15,'Y',100,NULL
UNION ALL
SELECT @Id,'MiscellaneousText','Med/Misc','Med/Misc',16,'Y',60,NULL
UNION ALL
SELECT @Id,'DandAText','D&A','D&A',17,'Y',50,NULL
UNION ALL
SELECT @Id,'Unit','Unit','Unit',18,'Y',150,NULL
UNION ALL
SELECT @Id,'PrimaryPlan','Primary Plan','Primary Plan',19,'Y',200,NULL
UNION ALL
SELECT @Id,'ClientsAge','Age','Age',20,'N',50,NULL
UNION ALL
SELECT @Id,'ClientGender','Gender','Gender',21,'N',60,NULL
UNION ALL
SELECT @Id,'ClientFlags','Flags','Flags',22,'N',200,NULL
UNION ALL
SELECT @Id,'PapersToCourt','PTC','PTC',23,'Y',75,NULL
UNION ALL
SELECT @Id,'CompetencyStatus','Competency','Competency',24,'Y',75,NULL