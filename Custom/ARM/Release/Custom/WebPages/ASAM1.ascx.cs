
namespace SHS.SmartCare
{
    public partial class ASAM1 : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            ASAMDynamic1.TableNameCustomASAMLevelOfCares = "CustomASAMLevelOfCares";
            ASAMDynamic1.TableNameCustomASAMPlacements = "CustomASAMPlacements";
            ASAMDynamic1.ColumnNameLeftDimensionDescription = "Dimension1Description";
            ASAMDynamic1.ColumnNameRightDimensionDescription = "Dimension2Description";

            ASAMDynamic1.ColumnNameLeftDimensionLevelOfCare = "Dimension1LevelOfCare";
            ASAMDynamic1.ColumnNameRightDimensionLevelOfCare = "Dimension2LevelOfCare";

            ASAMDynamic1.ColumnNameLevelOfCareName = "LevelOfCareName";
            ASAMDynamic1.Value = "ASAMLevelOfCareId";
            ASAMDynamic1.TextValueLeftDimensionDescription = "Dimension1Description";
            ASAMDynamic1.TextValueRightDimensionDescription = "Dimension2Description";
            ASAMDynamic1.ColumnNameLeftDimensionNeed = "Dimension1Need";
            ASAMDynamic1.ColumnNameRightDimensionNeed = "Dimension2Need";

            ASAMDynamic1.LeftDimensionDescriptionTitle = "Dimension 1: Alcohol Intoxication and/or Withdrawal Potential";
            ASAMDynamic1.RightDimensionDescriptionTitle = "Dimension 2: Biomedical Conditions and Complications";
            ASAMDynamic1.LeftDimensionNeedTitle = "Describe Dimension 1 Problem/Need";
            ASAMDynamic1.RightDimensionNeedTitle = "Describe Dimension 2 Problem/Need";


            ASAMDynamic1.BindDimensions();
            //CustomGrid.Bind(ParentDetailPageObject.ScreenId);
            //LiteralControl _literalControlHTML = null;

        }
    }
}
