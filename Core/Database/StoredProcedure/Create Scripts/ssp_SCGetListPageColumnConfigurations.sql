IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetListPageColumnConfigurations')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetListPageColumnConfigurations;
    END;
                    GO

CREATE PROCEDURE ssp_SCGetListPageColumnConfigurations
    @ScreenId INT
  , @StaffId INT
  , @ViewId INT = -1
AS /******************************************************************************
**		File: 
**		Name: ssp_SCGetListPageColumnConfigurations
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 3/23/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      3/23/2017          jcarlson                created
**		5/18/2017			jcarlson			Renaissance Dev Items 630.5 - normalize the sort order field
**		5/25/2017			jcarlson			Renaissance Dev Items 630.6 -- Added in staff Id parameter
**		5/31/2017		jcarlson				Renaissance Dev Items 630.6 -- Do not limit by staff, improved logic for views that have null sort orders
*******************************************************************************/
    BEGIN
					 
		--Detemine if the view has been deleted or is no longer active
        IF EXISTS ( SELECT  1
                    FROM    dbo.ListPageColumnConfigurations AS a
                    WHERE   a.ListPageColumnConfigurationId = @ViewId
                            AND a.ScreenId = @ScreenId
                            AND @ViewId <> -1
                            AND ( a.Active = 'N'
                                  OR ISNULL(a.RecordDeleted, 'N') = 'Y'
                                ) ) --View Id was hard deleted
            OR ( ( NOT EXISTS ( SELECT  1
                                FROM    dbo.ListPageColumnConfigurations AS a
                                WHERE   a.ListPageColumnConfigurationId = @ViewId )
                 AND @ViewId <> -1 )
               )
            BEGIN
                --use the default view for the screen
                SET @ViewId = -1;
            END; 

								 
        SELECT  a.ListPageColumnConfigurationId, b.ListPageColumnConfigurationColumnId, a.StaffId, a.ViewName, a.Active, a.DefaultView, b.FieldName, b.Caption,
                b.DisplayAs, b.SortOrder, b.ShowColumn, b.Width, b.Fixed, a.Template, CASE WHEN b.SortOrder IS NOT NULL THEN 'Y' ELSE 'N' END AS HasSort
        INTO    #Results
        FROM    ListPageColumnConfigurations AS a
        JOIN    ListPageColumnConfigurationColumns AS b ON a.ListPageColumnConfigurationId = b.ListPageColumnConfigurationId
                                                           AND ISNULL(b.RecordDeleted, 'N') = 'N'
        WHERE   ISNULL(a.RecordDeleted, 'N') = 'N'
                AND a.ScreenId = @ScreenId
                AND a.Active = 'Y'
                AND ( 
				--first pull in if view Id selected
                      ( a.ListPageColumnConfigurationId = @ViewId )
						--if no view Id, pull in default view
                      OR ( @ViewId = -1
                           AND ISNULL(a.DefaultView, 'N') = 'Y'
                           AND ISNULL(a.Template, 'N') = 'N'
                           AND ISNULL(a.Active, 'N') = 'Y'
                         )
						--else pull in original ( template ) view
                      OR ( @ViewId = -1
                           AND NOT EXISTS ( SELECT  1
                                            FROM    dbo.ListPageColumnConfigurations AS ac
                                            WHERE   ISNULL(ac.RecordDeleted, 'N') = 'N'
                                                    AND ac.ScreenId = @ScreenId
                                                    AND ISNULL(ac.DefaultView, 'N') = 'Y'
                                                    AND ISNULL(ac.Active, 'N') = 'Y'
                                                    AND ISNULL(ac.Template, 'N') = 'N' )
                           AND ISNULL(a.Template, 'N') = 'Y'
                         )
                    );
		DECLARE @MaxSortOrder INT 
		SELECT @MaxSortOrder = MAX(SortOrder)
		FROM #Results

		--if not sort order is present, use the template order, the selected views order always take priority over the template order
        UPDATE  r
        SET     r.SortOrder = r3.SortOrder
        FROM    #Results AS r
        JOIN    ( SELECT    b.FieldName,ISNULL(@MaxSortOrder,0) + ROW_NUMBER() OVER( ORDER BY b.SortOrder) AS SortOrder
                  FROM      dbo.ListPageColumnConfigurations AS a
				  JOIN dbo.ListPageColumnConfigurationColumns AS b ON b.ListPageColumnConfigurationId = a.ListPageColumnConfigurationId
                  WHERE ISNULL(a.RecordDeleted,'N')='N'
				  AND a.Active = 'Y'
				  AND ISNULL(a.Template,'N')='Y'
                ) AS r3 ON r.FieldName = r3.FieldName
		WHERE r.HasSort = 'N'
		--if two fields have the same order after updating with template, give priority to the selected view 
        SELECT  ListPageColumnConfigurationId, StaffId, ViewName, Active, DefaultView, FieldName, Caption, DisplayAs,
                ROW_NUMBER() OVER ( ORDER BY SortOrder,HasSort ) AS SortOrder, ShowColumn, Width, Fixed, Template
        FROM    #Results;



    END;
					GO