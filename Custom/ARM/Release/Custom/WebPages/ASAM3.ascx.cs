
namespace SHS.SmartCare
{
    public partial class ASAM3 : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            ASAMDynamic1.TableNameCustomASAMLevelOfCares = "CustomASAMLevelOfCares";
            ASAMDynamic1.TableNameCustomASAMPlacements = "CustomASAMPlacements";
            ASAMDynamic1.ColumnNameLeftDimensionDescription = "Dimension5Description";
            ASAMDynamic1.ColumnNameRightDimensionDescription = "Dimension6Description";
            ASAMDynamic1.ColumnNameLeftDimensionLevelOfCare = "Dimension5LevelOfCare";
            ASAMDynamic1.ColumnNameRightDimensionLevelOfCare = "Dimension6LevelOfCare";
            ASAMDynamic1.ColumnNameLevelOfCareName = "LevelOfCareName";
            ASAMDynamic1.Value = "ASAMLevelOfCareId";
            ASAMDynamic1.TextValueLeftDimensionDescription = "Dimension5Description";
            ASAMDynamic1.TextValueRightDimensionDescription = "Dimension6Description";
            ASAMDynamic1.ColumnNameLeftDimensionNeed = "Dimension5Need";
            ASAMDynamic1.ColumnNameRightDimensionNeed = "Dimension6Need";

            ASAMDynamic1.LeftDimensionDescriptionTitle = "Dimension 5: Relapse, Continued Use, Continued Problem Potential";
            ASAMDynamic1.RightDimensionDescriptionTitle = "Dimension 6: Recovery Environment";
            ASAMDynamic1.LeftDimensionNeedTitle = "Describe Dimension 5 Problem/Need";
            ASAMDynamic1.RightDimensionNeedTitle = "Describe Dimension 6 Problem/Need";

            ASAMDynamic1.BindDimensions();
        }
    }
}
