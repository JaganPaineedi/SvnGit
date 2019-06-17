using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Web.Script.Serialization;


public partial class Custom_Registration_WebPages_RegistrationDocumentFormsAndAgreements : SHS.BaseLayer.ActivityPages.DataActivityTab
{
     public string jsonFormcomposition = "[]";

        public override void BindControls()
        {
            #region Forms
            using (DataView DataViewGlobalCodes = SHS.BaseLayer.BaseCommonFunctions.FillDropDown("XREGISTRATIONFORM", true, "", "CodeName", true))
            {
               
                if (DataViewGlobalCodes != null)
                {
                    DataViewGlobalCodes.Sort = "CodeName";
                  //  DataViewGlobalCodes.RowFilter = "GlobalCodeId is not null";
                  //  DropdownList1_CustomRegistrationFormsAndAgreements_Form.DataTableGlobalCodes = DataViewGlobalCodes.ToDataTable();
                  //DropdownList1_CustomRegistrationFormsAndAgreements_Form.FillDropDownDropGlobalCodes();
                  //  ListItem removeItem2 =DropdownList1_CustomRegistrationFormsAndAgreements_Form.Items.FindByValue("");
                  //DropdownList1_CustomRegistrationFormsAndAgreements_Form.Items.Remove(removeItem2);
                  //  ListItem item2 = new ListItem("", "-1");
                  // DropdownList1_CustomRegistrationFormsAndAgreements_Form.Items.Insert(0, item2);
                  // DropdownList1_CustomRegistrationFormsAndAgreements_Form.SelectedIndex = 0;

                   DropdownList1_CustomRegistrationFormsAndAgreements_Form.DataTextField = "CodeName";
                   DropdownList1_CustomRegistrationFormsAndAgreements_Form.DataValueField = "GlobalCodeId";
                   DropdownList1_CustomRegistrationFormsAndAgreements_Form.DataSource = DataViewGlobalCodes;
                   DropdownList1_CustomRegistrationFormsAndAgreements_Form.DataBind();
                }
            }
            #endregion

           

            #region Form Composition
            var FormList = (from p in SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomRegistrationFormsAndAgreements"].Copy().AsEnumerable()
                                     select new
                                     {
                                         CustomRegistrationFormAndAgreementId = p.Field<int?>("CustomRegistrationFormAndAgreementId"),
                                         Form = p.Field<int?>("Form") == null ? -1 : p.Field<int?>("Form"),
                                        // RelationshipOtherText = p.Field<string>("RelationshipOtherText") == null ? string.Empty : p.Field<string>("RelationshipOtherText"),
                                         //FirstName = p.Field<string>("FirstName") == null ? string.Empty : p.Field<string>("FirstName"),
                                         //LastName = p.Field<string>("LastName") == null ? string.Empty : p.Field<string>("LastName"),
                                         EnglishForm = p.Field<string>("EnglishForm") == null ? string.Empty : p.Field<string>("EnglishForm"),
                                         SpanishForm = p.Field<string>("SpanishForm") == null ? string.Empty : p.Field<string>("SpanishForm"),
                                         NoForm = p.Field<string>("NoForm") == null ? string.Empty : p.Field<string>("NoForm"),
                                         DeclinedForm = p.Field<string>("DeclinedForm") == null ? string.Empty : p.Field<string>("DeclinedForm"),
                                         NotApplicableForm = p.Field<string>("NotApplicableForm") == null ? string.Empty : p.Field<string>("NotApplicableForm"),
                                         
                                     }).ToList();
            var pjsonSerialiser = new JavaScriptSerializer();
            var pjson = pjsonSerialiser.Serialize(FormList);
            jsonFormcomposition = pjson.ToString();
            #endregion



        }

      
    }

