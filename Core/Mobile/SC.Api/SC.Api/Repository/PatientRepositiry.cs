using System;
using System.Collections.Generic;
using System.Linq;
using SC.Api.Models;
using SC.Data;
using System.Data.SqlClient;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Core.Objects;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Xml;
using System.IO;
using System.Xml.Serialization;
using System.Web;
using Newtonsoft.Json.Linq;
using System.Data;

namespace SC.Api
{
    /// <summary>
    /// PatientRepositiry used for all the patient filling related functionalities
    /// </summary>
    public class PatientRepositiry : IPatientRepository
    {
        public SCMobile _ctx;
        /// <summary>
        /// Constructor of PatientRepositiry
        /// </summary>
        /// <param name="ctx"></param>
        public PatientRepositiry(SCMobile ctx)
        {
            _ctx = ctx;
        }
        

            /// <summary>
            /// Get ClientId based on Identifiers
            /// </summary>
            /// <param name="Id"></param>        
            /// <returns></returns>
        public string GetClientId(string SSN, string FirstName, string LastName, DateTime? DOB)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetClientId(SSN, FirstName, LastName, DOB, OutputParamter);
                return Convert.ToString(OutputParamter.Value);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetClientId method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Patient information based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public PatientDetailsModel GetPatientInformation(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                PatientDetailsModel _patient = new PatientDetailsModel();
                _patient.PatientDemographicDetails = GetDemographicDetails(Id, Type, fromDate, toDate);
                _patient.Allergies = GetAllergies(Id, Type, fromDate, toDate);
                _patient.CurrentMedications = GetCurrentMedications(Id, Type, fromDate, toDate);
                _patient.ActiveProblems = GetActiveProblems(Id, Type, fromDate, toDate);
                _patient.MostRecentEncounters = GetMostRecentEncounters(Id, Type, fromDate, toDate);
                _patient.Immunizations = GetImmunizations(Id, Type, fromDate, toDate);
                _patient.SocialHistory = GetSocialHistory(Id, Type, fromDate, toDate);
                _patient.VitalSigns = GetVitalSigns(Id, Type, fromDate, toDate);
                _patient.PlanOfTreatment = GetPlanOfTreatment(Id, Type, fromDate, toDate);
                _patient.Goals = GetGoals(Id, Type, fromDate, toDate);
                _patient.UniqueDeviceIdentifier = GetUDI(Id, Type, fromDate, toDate);
                _patient.HistoryOfProcedures = GetHistoryOfProcedures(Id, Type, fromDate, toDate);
                _patient.StudiesSummary = GetStudiesSummary(Id, Type, fromDate, toDate);
                _patient.LaboratoryTests = GetLaboratoryTests(Id, Type, fromDate, toDate);
                _patient.CareTeamMembers = GetCareTeamMembers(Id, Type, fromDate, toDate);
               
            return _patient;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetPatientInformation method." + ex.Message);
                throw excep;
            }
        }


        /// <summary>
        /// To get Get Summary Of Care CCD XML
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public string GetSummaryOfCareCCDXML(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            _ctx.Database.Initialize(force: false);

            var cmd = _ctx.Database.Connection.CreateCommand();
            cmd.CommandText = "[dbo].[ssp_GetSummaryOfCareCCDXML]";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            var strSummaryOfCareCCDXML = "";
            XmlDocument doc = new XmlDocument();
            try
            {
                _ctx.Database.Connection.Open();
                cmd.Parameters.Add(new SqlParameter("ClientId", Id));
                cmd.Parameters.Add(new SqlParameter("Type", Type));
                cmd.Parameters.Add(new SqlParameter("DocumentVersionId", DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("FromDate", fromDate));
                cmd.Parameters.Add(new SqlParameter("ToDate", toDate));
                cmd.Parameters.Add(new SqlParameter("OutputComponentXML", SqlDbType.NVarChar, -1));
                cmd.Parameters["OutputComponentXML"].Direction = ParameterDirection.Output;
                
                cmd.ExecuteScalar();
                
                strSummaryOfCareCCDXML = Convert.ToString(cmd.Parameters["OutputComponentXML"].Value);
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(strSummaryOfCareCCDXML);
                strSummaryOfCareCCDXML = xmlDoc.InnerXml;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetSummaryOfCareCCDXML method." + ex.Message);
                throw excep;
            }
            finally
            { _ctx.Database.Connection.Close(); }

            return strSummaryOfCareCCDXML;
        }


        /// <summary>
        /// Get Demographic Details based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<PatientDemographicDetailsModel> GetDemographicDetails(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetPatientDemographicDetails(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<PatientDemographicDetailsModel> _patient = new List<PatientDemographicDetailsModel>();
                List<AnimalModel> _animals = new List<AnimalModel>();
                List<CommunicationModel> _communication = new List<CommunicationModel>();
                List<LinkModel> _links = new List<LinkModel>();               

                _patient = JsonConvert.DeserializeObject<List<PatientDemographicDetailsModel>>(json).ToList();
                _animals = JsonConvert.DeserializeObject<List<AnimalModel>>(json).ToList();
                _links = JsonConvert.DeserializeObject<List<LinkModel>>(json).ToList();
               
                _patient.ForEach(a => a.Animal = JsonConvert.DeserializeObject<List<AnimalModel>>(json).ToList());
                _patient.ForEach(a => a.Link = JsonConvert.DeserializeObject<List<LinkModel>>(json).ToList());
                               

                int i = 0;
                foreach (var _animal in _animals)
                {
                    _patient[i].Animal.Clear();
                    _patient[i].Animal.Add(_animal);
                    i = i + 1;
                }
                

                i = 0;
                foreach (var _link in _links)
                {
                    _patient[i].Link.Clear();
                    _patient[i].Link.Add(_link);
                    i = i + 1;
                }

                _patient.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _patient.ForEach(a => a.Name = GetHumanName(Id, "DemographicHumanName", Type, fromDate, toDate));
                _patient.ForEach(a => a.Address = GetAddress(Id, "DemographicPatientAddress", Type, fromDate, toDate));
                _patient.ForEach(a => a.Telecom = GetTelecom(Id, "DemographicTelecom", Type, fromDate, toDate));
                //_patient.ForEach(a => a.Telecom.ForEach(b => b. = GetCoding(Id, "MaritalStatus", Type, fromDate, toDate)));

                _patient.ForEach(a => a.Contact = GetPatientContactPerson(Id, Type, fromDate, toDate));
                _patient.ForEach(a => a.Contact.ForEach(b => b.Relationship = GetCodeableConcept(Id, "Relationship", Type, fromDate, toDate)));
                _patient.ForEach(a => a.Contact.ForEach(b => b.Relationship.ForEach(c => c.Coding = GetCoding(Id, "Relationship", Type, fromDate, toDate))));
               
                _patient.ForEach(a => a.MaritalStatus = GetCodeableConcept(Id, "MaritalStatus", Type, fromDate, toDate));
                _patient.ForEach(a => a.MaritalStatus.ForEach(b => b.Coding = GetCoding(Id, "MaritalStatus", Type, fromDate, toDate)));

                _patient.ForEach(a => a.Communication = JsonConvert.DeserializeObject<List<CommunicationModel>>(json).ToList());
                _patient.ForEach(a => a.Communication.ForEach(b => b.CommunicationLanguage = GetCodeableConcept(Id, "Language", Type, fromDate, toDate)));
                _patient.ForEach(a => a.Communication.ForEach(b => b.CommunicationLanguage.ForEach(c => c.Coding = GetCoding(Id, "Language", Type, fromDate, toDate))));

                _patient.ForEach(a => a.Animal.ForEach(b => b.Species = GetCodeableConcept(Id, "Species", Type, fromDate, toDate)));
                _patient.ForEach(a => a.Animal.ForEach(b => b.Species.ForEach(c => c.Coding = GetCoding(Id, "Species", Type, fromDate, toDate))));

                _patient.ForEach(a => a.Animal.ForEach(b => b.Breed = GetCodeableConcept(Id, "Breed", Type, fromDate, toDate)));
                _patient.ForEach(a => a.Animal.ForEach(b => b.Breed.ForEach(c => c.Coding = GetCoding(Id, "Breed", Type, fromDate, toDate))));

                _patient.ForEach(a => a.Animal.ForEach(b => b.GenderStatus = GetCodeableConcept(Id, "GenderStatus", Type, fromDate, toDate)));
                _patient.ForEach(a => a.Animal.ForEach(b => b.GenderStatus.ForEach(c => c.Coding = GetCoding(Id, "GenderStatus", Type, fromDate, toDate))));

                //List<AttachmentModel> _attachment = new List<AttachmentModel>();
                _patient.ForEach(a => a.Photo = GetAttachment(Id, "DemographicPhoto", Type, fromDate, toDate));
                //_attachment = GetAttachment(Id, "PlanOfTreatmentActivityProgress", Type, fromDate, toDate);
                //i = 0;
                //if (_attachment != null)
                //{
                //    foreach (var _ann in _attachment)
                //    {
                //        _patient[i].Activity[0].ActivityProgress.Clear();
                //        _patient[i].Activity[0].ActivityProgress.Add(_ann);
                //        i = i + 1;
                //    }
                //}

                return _patient;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetDemographicDetails method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Get Allergies based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<AllergiesModel> GetAllergies(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetAllergies(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<AllergiesModel> _allergies = new List<AllergiesModel>();
                List<AllergiesReactionModel> _allergiesReaction = new List<AllergiesReactionModel>();
                //List<PeriodModel> _period = new List<PeriodModel>();
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _allergies = JsonConvert.DeserializeObject<List<AllergiesModel>>(json).ToList();
                _allergies.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
               // _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();

                _allergiesReaction = JsonConvert.DeserializeObject<List<AllergiesReactionModel>>(json).ToList();
                _allergies.ForEach(a => a.Reaction = JsonConvert.DeserializeObject<List<AllergiesReactionModel>>(json).ToList());
                //_allergies.ForEach(a => a.OnsetPeriod = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());
               
                //CodeableConcept - Code
                _allergies.ForEach(a => a.Code = GetCodeableConcept(Id, "AllergiesCode", Type, fromDate, toDate));
                _allergies.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "AllergiesCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "AllergiesCode", Type, fromDate, toDate);
                int i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _allergies[i].Code[0].Coding.Clear();
                        _allergies[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //i = 0;
                //foreach (var _prd in _period)
                //{
                //    _allergies[i].OnsetPeriod.Clear();
                //    _allergies[i].OnsetPeriod.Add(_prd);
                //    i = i + 1;
                //}
                
                i = 0;
                foreach (var _reaction in _allergiesReaction)
                {
                    _allergies[i].Reaction.Clear();
                    _allergies[i].Reaction.Add(_reaction);
                    i = i + 1;
                }

                //CodeableConcept -Reaction Substance
                _allergies.ForEach(a => a.Reaction.ForEach(b => b.Substance = GetCodeableConcept(Id, "Substance", Type, fromDate, toDate)));
                _allergies.ForEach(a => a.Reaction.ForEach(b => b.Substance.ForEach(c => c.Coding = GetCoding(Id, "Substance", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "Substance", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _allergies[i].Reaction[0].Substance[0].Coding.Clear();
                        _allergies[i].Reaction[0].Substance[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //CodeableConcept -Reaction Manifestation
                _allergies.ForEach(a => a.Reaction.ForEach(b => b.Manifestation = GetCodeableConcept(Id, "Manifestation", Type, fromDate, toDate)));
                _allergies.ForEach(a => a.Reaction.ForEach(b => b.Manifestation.ForEach(c => c.Coding = GetCoding(Id, "Manifestation", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "Manifestation", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _allergies[i].Reaction[0].Manifestation[0].Coding.Clear();
                        _allergies[i].Reaction[0].Manifestation[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
               
                //CodeableConcept -Reaction ExposureRoute
                _allergies.ForEach(a => a.Reaction.ForEach(b => b.ExposureRoute = GetCodeableConcept(Id, "ExposureRoute", Type, fromDate, toDate)));
                _allergies.ForEach(a => a.Reaction.ForEach(b => b.ExposureRoute.ForEach(c => c.Coding = GetCoding(Id, "ExposureRoute", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ExposureRoute", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _allergies[i].Reaction[0].ExposureRoute[0].Coding.Clear();
                        _allergies[i].Reaction[0].ExposureRoute[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Annotation - Allergies Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _allergies.ForEach(a => a.Note = GetAnnotation(Id, "AllergiesNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "AllergiesNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _allergies[i].Note.Clear();
                        _allergies[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                //Annotation - Allergies ReactionNote
                _allergies.ForEach(a => a.Reaction.ForEach(b => b.ReactionNote = GetAnnotation(Id, "AllergiesReactionNote", Type, fromDate, toDate)));
                _annotation = GetAnnotation(Id, "AllergiesReactionNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _allergies[i].Reaction[0].ReactionNote.Clear();
                        _allergies[i].Reaction[0].ReactionNote.Add(_ann);
                        i = i + 1;
                    }
                }

                return _allergies;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetAllergies method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Get Current Medications based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<CurrentMedicationsModel> GetCurrentMedications(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetCurrentMedications(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<CurrentMedicationsModel> _medication = new List<CurrentMedicationsModel>();
                List<CurrentMedicationsIngredientModel> _medicationsIngredient = new List<CurrentMedicationsIngredientModel>();
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _medication = JsonConvert.DeserializeObject<List<CurrentMedicationsModel>>(json).ToList();
                _medicationsIngredient = JsonConvert.DeserializeObject<List<CurrentMedicationsIngredientModel>>(json);

                _medication.ForEach(a => a.Ingredient = JsonConvert.DeserializeObject<List<CurrentMedicationsIngredientModel>>(json).ToList());

                //CodeableConcept - Code
                _medication.ForEach(a => a.Code = GetCodeableConcept(Id, "CurrentMedicationsCode", Type, fromDate, toDate));
                _medication.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "CurrentMedicationsCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "CurrentMedicationsCode", Type, fromDate, toDate);
                int i = 0;
                if (_coding != null && _medication.Count >= _coding.Count)
                {
                    foreach (var _code in _coding)
                    {
                        _medication[i].Code[0].Coding.Clear();
                        _medication[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Form
                _medication.ForEach(a => a.Form = GetCodeableConcept(Id, "CurrentMedicationsForm", Type, fromDate, toDate));
                _medication.ForEach(a => a.Form.ForEach(b => b.Coding = GetCoding(Id, "CurrentMedicationsForm", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "CurrentMedicationsForm", Type, fromDate, toDate);
                if (_coding != null)
                { 
                    i = 0;
                    foreach (var _code in _coding)
                    {
                        _medication[i].Form[0].Coding.Clear();
                        _medication[i].Form[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                i = 0;
                foreach (var _ingredient in _medicationsIngredient)
                {
                    _medication[i].Ingredient.Clear();
                    _medication[i].Ingredient.Add(_ingredient);
                    i = i + 1;
                }
                //CodeableConcept - Ingredient ItemCodeableConcept
                _medication.ForEach(a => a.Ingredient.ForEach(b => b.ItemCodeableConcept = GetCodeableConcept(Id, "IngredientItemCodeableConcept", Type, fromDate, toDate)));
                _medication.ForEach(a => a.Ingredient.ForEach(b => b.ItemCodeableConcept.ForEach(c => c.Coding = GetCoding(Id, "IngredientItemCodeableConcept", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "IngredientItemCodeableConcept", Type, fromDate, toDate);
                if (_coding != null)
                {
                    i = 0;
                    foreach (var _code in _coding)
                    {
                        _medication[i].Ingredient[0].ItemCodeableConcept[0].Coding.Clear();
                        _medication[i].Ingredient[0].ItemCodeableConcept[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Package
                List<CurrentMedicationsPackageModel> _medicationsPackage = new List<CurrentMedicationsPackageModel>();
                List<CurrentMedicationsPackageContentModel> _medicationsPackageContent = new List<CurrentMedicationsPackageContentModel>();
                List<CurrentMedicationsPackageBatchModel> _medicationsPackageBatch = new List<CurrentMedicationsPackageBatchModel>();
                                
                _medicationsPackage = JsonConvert.DeserializeObject<List<CurrentMedicationsPackageModel>>(json).ToList();
                _medication.ForEach(a => a.Package = JsonConvert.DeserializeObject<List<CurrentMedicationsPackageModel>>(json).ToList());
                i = 0;
                foreach (var _package in _medicationsPackage)
                {
                    _medication[i].Package.Clear();
                    _medication[i].Package.Add(_package);
                    i = i + 1;
                }

                //CodeableConcept - Container
                _medication.ForEach(a => a.Package.ForEach(b => b.Container = GetCodeableConcept(Id, "PackageContainer", Type, fromDate, toDate)));
                _medication.ForEach(a => a.Package.ForEach(b => b.Container.ForEach(c => c.Coding = GetCoding(Id, "PackageContainer", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "PackageContainer", Type, fromDate, toDate);
                if (_coding != null)
                {
                    i = 0;
                    foreach (var _code in _coding)
                    {
                        _medication[i].Package[0].Container[0].Coding.Clear();
                        _medication[i].Package[0].Container[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Package.Content
                _medicationsPackageContent = JsonConvert.DeserializeObject<List<CurrentMedicationsPackageContentModel>>(json).ToList();
                _medication.ForEach(a => a.Package.ForEach(b => b.Content = JsonConvert.DeserializeObject<List<CurrentMedicationsPackageContentModel>>(json).ToList()));
                i = 0;
                foreach (var _packageContent in _medicationsPackageContent)
                {
                    _medication[i].Package[0].Content.Clear();
                    _medication[i].Package[0].Content.Add(_packageContent);
                    i = i + 1;
                }

                //CodeableConcept - Content ItemCodeableConcept
                _medication.ForEach(a => a.Package.ForEach(b => b.Content.ForEach(c => c.ContentItemCodeableConcept = GetCodeableConcept(Id, "ContentItemCodeableConcept", Type, fromDate, toDate))));
                _medication.ForEach(a => a.Package.ForEach(b => b.Content.ForEach(c => c.ContentItemCodeableConcept.ForEach(d => d.Coding = GetCoding(Id, "ContentItemCodeableConcept", Type, fromDate, toDate)))));
                _coding = GetCoding(Id, "ContentItemCodeableConcept", Type, fromDate, toDate);
                if (_coding != null)
                {
                    i = 0;
                    foreach (var _code in _coding)
                    {
                        _medication[i].Package[0].Content[0].ContentItemCodeableConcept[0].Coding.Clear();
                        _medication[i].Package[0].Content[0].ContentItemCodeableConcept[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Package.Btach
                _medicationsPackageBatch = JsonConvert.DeserializeObject<List<CurrentMedicationsPackageBatchModel>>(json).ToList();
                _medication.ForEach(a => a.Package.ForEach(b => b.Batch = JsonConvert.DeserializeObject<List<CurrentMedicationsPackageBatchModel>>(json).ToList()));
                i = 0;
                foreach (var _packageBatch in _medicationsPackageBatch)
                {
                    _medication[i].Package[0].Batch.Clear();
                    _medication[i].Package[0].Batch.Add(_packageBatch);
                    i = i + 1;
                }


                //Quantity - CurrentMedications PackageContentAmount
                List<QuantityModel> _quantity = new List<QuantityModel>();

                _medication.ForEach(a => a.Package.ForEach(b => b.Content.ForEach(c => c.PackageContentAmount = GetQuantity(Id, "CurrentMedicationsPackageContentAmount", Type, fromDate, toDate))));
                _quantity = GetQuantity(Id, "CurrentMedicationsPackageContentAmount", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _medication[i].Package[0].Content[0].PackageContentAmount.Clear();
                        _medication[i].Package[0].Content[0].PackageContentAmount.Add(_qnt);
                        i = i + 1;
                    }
                }

                //Ratio
                List<RatioModel> _ratio = new List<RatioModel>();
                _medication.ForEach(a => a.Ingredient.ForEach(b => b.IngredientAmount = JsonConvert.DeserializeObject<List<RatioModel>>(json).ToList()));
                _ratio = JsonConvert.DeserializeObject<List<RatioModel>>(json).ToList();
                i = 0;
                if (_ratio != null && _ratio.Count > 0)
                {
                    foreach (var _rat in _ratio)
                    {
                        _medication[i].Ingredient[0].IngredientAmount.Clear();
                        _medication[i].Ingredient[0].IngredientAmount.Add(_rat);
                        i = i + 1;
                    }
                }

                //Ratio - CurrentMedications IngredientAmount Numerator               
                _quantity = GetQuantity(Id, "CurrentMedicationsIngredientAmountNumerator", Type, fromDate, toDate);

                _medication.ForEach(a => a.Ingredient.ForEach(b => b.IngredientAmount.ForEach(c => c.Numerator = GetQuantity(Id, "CurrentMedicationsIngredientAmountNumerator", Type, fromDate, toDate))));
                _quantity = GetQuantity(Id, "CurrentMedicationsIngredientAmountNumerator", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _medication[i].Ingredient[0].IngredientAmount[0].Numerator.Clear();
                        _medication[i].Ingredient[0].IngredientAmount[0].Numerator.Add(_qnt);
                        i = i + 1;
                    }
                }
                //Ratio - CurrentMedications IngredientAmount Denominator
                _medication.ForEach(a => a.Ingredient.ForEach(b => b.IngredientAmount.ForEach(c => c.Denominator = GetQuantity(Id, "CurrentMedicationsIngredientAmountDenominator", Type, fromDate, toDate))));
                _quantity = GetQuantity(Id, "CurrentMedicationsIngredientAmountDenominator", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _medication[i].Ingredient[0].IngredientAmount[0].Denominator.Clear();
                        _medication[i].Ingredient[0].IngredientAmount[0].Denominator.Add(_qnt);
                        i = i + 1;
                    }
                }
                

                //Attachment - CurrentMedications Image
                List<AttachmentModel> _attachment = new List<AttachmentModel>();
                _medication.ForEach(a => a.Image = GetAttachment(Id, "CurrentMedicationsImage", Type, fromDate, toDate));
                _attachment = GetAttachment(Id, "CurrentMedicationsImage", Type, fromDate, toDate);
                i = 0;
                if (_attachment != null)
                {
                    foreach (var _ann in _attachment)
                    {
                        _medication[i].Image.Clear();
                        _medication[i].Image.Add(_ann);
                        i = i + 1;
                    }
                }

                return _medication;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetCurrentMedications method." + ex.Message);
                throw excep;
            }
        }
        

        /// <summary>
        /// Get Active Problems based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<ActiveProblemsModel> GetActiveProblems(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetActiveProblems(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<ActiveProblemsModel> _activeProblems = new List<ActiveProblemsModel>();
                List<ActiveProblemsStageModel> _stage = new List<ActiveProblemsStageModel>();
                List<ActiveProblemsEvidenceModel> _evidence = new List<ActiveProblemsEvidenceModel>();
                List<PeriodModel> _period = new List<PeriodModel>();
                List<AbatementPeriodModel> _abatementPeriod = new List<AbatementPeriodModel>();
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _activeProblems = JsonConvert.DeserializeObject<List<ActiveProblemsModel>>(json).ToList();
                _stage = JsonConvert.DeserializeObject<List<ActiveProblemsStageModel>>(json).ToList();
                _evidence = JsonConvert.DeserializeObject<List<ActiveProblemsEvidenceModel>>(json).ToList();
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _abatementPeriod = JsonConvert.DeserializeObject<List<AbatementPeriodModel>>(json).ToList();

                _activeProblems.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _activeProblems.ForEach(a => a.Stage = JsonConvert.DeserializeObject<List<ActiveProblemsStageModel>>(json).ToList());
                _activeProblems.ForEach(a => a.Evidence = JsonConvert.DeserializeObject<List<ActiveProblemsEvidenceModel>>(json).ToList());

                _activeProblems.ForEach(a => a.OnsetPeriod = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());
                _activeProblems.ForEach(a => a.AbatementPeriod = JsonConvert.DeserializeObject<List<AbatementPeriodModel>>(json).ToList());
                int i = 0;
                foreach (var _prd in _period)
                {
                    _activeProblems[i].OnsetPeriod.Clear();
                    _activeProblems[i].OnsetPeriod.Add(_prd);
                    i = i + 1;
                }
                i = 0;
                foreach (var _abatement in _abatementPeriod)
                {
                    _activeProblems[i].AbatementPeriod.Clear();
                    _activeProblems[i].AbatementPeriod.Add(_abatement);
                    i = i + 1;
                }

                i = 0;
                foreach (var _stg in _stage)
                {
                    _activeProblems[i].Stage.Clear();
                    _activeProblems[i].Stage.Add(_stg);
                    i = i + 1;
                }
            
                i = 0;
                foreach (var _evd in _evidence)
                {
                    _activeProblems[i].Evidence.Clear();
                    _activeProblems[i].Evidence.Add(_evd);
                    i = i + 1;
                }

                //CodeableConcept - Category
                _activeProblems.ForEach(a => a.Category = GetCodeableConcept(Id, "ActiveProblemsCategory", Type, fromDate, toDate));
                _activeProblems.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "ActiveProblemsCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ActiveProblemsCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _activeProblems[i].Category[0].Coding.Clear();
                        _activeProblems[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Severity
                _activeProblems.ForEach(a => a.Severity = GetCodeableConcept(Id, "ActiveProblemsSeverity", Type, fromDate, toDate));
                _activeProblems.ForEach(a => a.Severity.ForEach(b => b.Coding = GetCoding(Id, "ActiveProblemsSeverity", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ActiveProblemsSeverity", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _activeProblems[i].Severity[0].Coding.Clear();
                        _activeProblems[i].Severity[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Code
                _activeProblems.ForEach(a => a.Code = GetCodeableConcept(Id, "ActiveProblemsCode", Type, fromDate, toDate));
                _activeProblems.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "ActiveProblemsCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ActiveProblemsCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _activeProblems[i].Code[0].Coding.Clear();
                        _activeProblems[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - BodySite
                _activeProblems.ForEach(a => a.BodySite = GetCodeableConcept(Id, "ActiveProblemsBodySite", Type, fromDate, toDate));
                _activeProblems.ForEach(a => a.BodySite.ForEach(b => b.Coding = GetCoding(Id, "ActiveProblemsBodySite", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ActiveProblemsBodySite", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _activeProblems[i].BodySite[0].Coding.Clear();
                        _activeProblems[i].BodySite[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Stage Summary
                _activeProblems.ForEach(a => a.Stage.ForEach(b => b.StageSummary = GetCodeableConcept(Id, "ActiveProblemsStageSummary", Type, fromDate, toDate)));
                _activeProblems.ForEach(a => a.Stage.ForEach(b => b.StageSummary.ForEach(c => c.Coding = GetCoding(Id, "ActiveProblemsStageSummary", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ActiveProblemsStageSummary", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _activeProblems[i].Stage[0].StageSummary[0].Coding.Clear();
                        _activeProblems[i].Stage[0].StageSummary[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Evidence Code
                _activeProblems.ForEach(a => a.Evidence.ForEach(b => b.EvidenceCode = GetCodeableConcept(Id, "ActiveProblemsEvidenceCode", Type, fromDate, toDate)));
                _activeProblems.ForEach(a => a.Evidence.ForEach(b => b.EvidenceCode.ForEach(c => c.Coding = GetCoding(Id, "ActiveProblemsEvidenceCode", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ActiveProblemsEvidenceCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _activeProblems[i].Evidence[0].EvidenceCode[0].Coding.Clear();
                        _activeProblems[i].Evidence[0].EvidenceCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Annotation - ActiveProblems Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _activeProblems.ForEach(a => a.Note = GetAnnotation(Id, "ActiveProblemsNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "ActiveProblemsNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _activeProblems[i].Note.Clear();
                        _activeProblems[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }

                return _activeProblems;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetActiveProblems method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Most Recent Encounters based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<MostRecentEncountersModel> GetMostRecentEncounters(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetMostRecentEncounters(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<MostRecentEncountersModel> _encounters = new List<MostRecentEncountersModel>();
                List<EncountersStatusHistoryModel> _statusHistory = new List<EncountersStatusHistoryModel>();
                List<EncountersClassHistoryModel> _classHistory = new List<EncountersClassHistoryModel>();
                List<EncountersParticipantModel> _participant = new List<EncountersParticipantModel>();
                List<EncountersDiagnosisModel> _diagnosis = new List<EncountersDiagnosisModel>();
                List<EncountersHospitalizationModel> _hospital = new List<EncountersHospitalizationModel>();
                List<EncountersLocationModel> _location = new List<EncountersLocationModel>();

                List<PeriodModel> _period = new List<PeriodModel>();
                List<EncountersStatusHistoryPeriodModel> _statusHistoryPeriod = new List<EncountersStatusHistoryPeriodModel>();
                List<EncountersClassHistoryPeriodModel> _classHistoryPeriod = new List<EncountersClassHistoryPeriodModel>();
                List<EncountersParticipantPeriodModel> _participantPeriod = new List<EncountersParticipantPeriodModel>();
                List<EncountersLocationPeriodModel> _locationPeriod = new List<EncountersLocationPeriodModel>();

                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _encounters = JsonConvert.DeserializeObject<List<MostRecentEncountersModel>>(json).ToList();
                _statusHistory = JsonConvert.DeserializeObject<List<EncountersStatusHistoryModel>>(json).ToList();
                _classHistory = JsonConvert.DeserializeObject<List<EncountersClassHistoryModel>>(json).ToList();
                _participant = JsonConvert.DeserializeObject<List<EncountersParticipantModel>>(json).ToList();
                _diagnosis = JsonConvert.DeserializeObject<List<EncountersDiagnosisModel>>(json).ToList();
                _hospital = JsonConvert.DeserializeObject<List<EncountersHospitalizationModel>>(json).ToList();
                _location = JsonConvert.DeserializeObject<List<EncountersLocationModel>>(json).ToList();

                _encounters.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _encounters.ForEach(a => a.StatusHistory = JsonConvert.DeserializeObject<List<EncountersStatusHistoryModel>>(json).ToList());
                _encounters.ForEach(a => a.ClassHistory = JsonConvert.DeserializeObject<List<EncountersClassHistoryModel>>(json).ToList());
                _encounters.ForEach(a => a.Participant = JsonConvert.DeserializeObject<List<EncountersParticipantModel>>(json).ToList());
                _encounters.ForEach(a => a.Diagnosis = JsonConvert.DeserializeObject<List<EncountersDiagnosisModel>>(json).ToList());
                _encounters.ForEach(a => a.Hospitalization = JsonConvert.DeserializeObject<List<EncountersHospitalizationModel>>(json).ToList());
                _encounters.ForEach(a => a.Location = JsonConvert.DeserializeObject<List<EncountersLocationModel>>(json).ToList());
                
                int i = 0;
                foreach (var _sh in _statusHistory)
                {
                    _encounters[i].StatusHistory.Clear();
                    _encounters[i].StatusHistory.Add(_sh);
                    i = i + 1;
                }
                i = 0;
                foreach (var _ch in _classHistory)
                {
                    _encounters[i].ClassHistory.Clear();
                    _encounters[i].ClassHistory.Add(_ch);
                    i = i + 1;
                }
                i = 0;
                foreach (var _part in _participant)
                {
                    _encounters[i].Participant.Clear();
                    _encounters[i].Participant.Add(_part);
                    i = i + 1;
                }
                i = 0;
                foreach (var _diag in _diagnosis)
                {
                    _encounters[i].Diagnosis.Clear();
                    _encounters[i].Diagnosis.Add(_diag);
                    i = i + 1;
                }
                i = 0;
                foreach (var _hptl in _hospital)
                {
                    _encounters[i].Hospitalization.Clear();
                    _encounters[i].Hospitalization.Add(_hptl);
                    i = i + 1;
                }
                i = 0;
                foreach (var _loc in _location)
                {
                    _encounters[i].Location.Clear();
                    _encounters[i].Location.Add(_loc);
                    i = i + 1;
                }

                //Period
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _statusHistoryPeriod = JsonConvert.DeserializeObject<List<EncountersStatusHistoryPeriodModel>>(json).ToList();
                _classHistoryPeriod = JsonConvert.DeserializeObject<List<EncountersClassHistoryPeriodModel>>(json).ToList();
                _participantPeriod = JsonConvert.DeserializeObject<List<EncountersParticipantPeriodModel>>(json).ToList();
                _locationPeriod = JsonConvert.DeserializeObject<List<EncountersLocationPeriodModel>>(json).ToList();

                _encounters.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());
                _encounters.ForEach(a => a.StatusHistory.ForEach(b => b.StatusHistoryPeriod = JsonConvert.DeserializeObject<List<EncountersStatusHistoryPeriodModel>>(json).ToList()));
                _encounters.ForEach(a => a.ClassHistory.ForEach(b => b.ClassHistoryPeriod = JsonConvert.DeserializeObject<List<EncountersClassHistoryPeriodModel>>(json).ToList()));
                _encounters.ForEach(a => a.Participant.ForEach(b => b.ParticipantPeriod = JsonConvert.DeserializeObject<List<EncountersParticipantPeriodModel>>(json).ToList()));
                _encounters.ForEach(a => a.Location.ForEach(b => b.LocationPeriod = JsonConvert.DeserializeObject<List<EncountersLocationPeriodModel>>(json).ToList()));

                i = 0;
                foreach (var _prd in _period)
                {
                    _encounters[i].Period.Clear();
                    _encounters[i].Period.Add(_prd);
                    i = i + 1;
                }
                i = 0;
                foreach (var _prd in _statusHistoryPeriod)
                {
                    _encounters[i].StatusHistory[0].StatusHistoryPeriod.Clear();
                    _encounters[i].StatusHistory[0].StatusHistoryPeriod.Add(_prd);
                    i = i + 1;
                }
                i = 0;
                foreach (var _prd in _classHistoryPeriod)
                {
                    _encounters[i].ClassHistory[0].ClassHistoryPeriod.Clear();
                    _encounters[i].ClassHistory[0].ClassHistoryPeriod.Add(_prd);
                    i = i + 1;
                }
                i = 0;
                foreach (var _prd in _participantPeriod)
                {
                    _encounters[i].Participant[0].ParticipantPeriod.Clear();
                    _encounters[i].Participant[0].ParticipantPeriod.Add(_prd);
                    i = i + 1;
                }
                i = 0;
                foreach (var _prd in _locationPeriod)
                {
                    _encounters[i].Location[0].LocationPeriod.Clear();
                    _encounters[i].Location[0].LocationPeriod.Add(_prd);
                    i = i + 1;
                }

                //CodeableConcept - Type
                _encounters.ForEach(a => a.Type = GetCodeableConcept(Id, "EncountersType", Type, fromDate, toDate));
                _encounters.ForEach(a => a.Type.ForEach(b => b.Coding = GetCoding(Id, "EncountersType", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "EncountersType", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Type[0].Coding.Clear();
                        _encounters[i].Type[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Priority
                _encounters.ForEach(a => a.Priority = GetCodeableConcept(Id, "EncountersPriority", Type, fromDate, toDate));
                _encounters.ForEach(a => a.Priority.ForEach(b => b.Coding = GetCoding(Id, "EncountersPriority", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "EncountersPriority", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Priority[0].Coding.Clear();
                        _encounters[i].Priority[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Participant Type
                _encounters.ForEach(a => a.Participant.ForEach(b => b.ParticipantType = GetCodeableConcept(Id, "EncountersParticipantType", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Participant.ForEach(b => b.ParticipantType.ForEach(c => c.Coding = GetCoding(Id, "EncountersParticipantType", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersParticipantType", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Participant[0].ParticipantType[0].Coding.Clear();
                        _encounters[i].Participant[0].ParticipantType[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Reason
                _encounters.ForEach(a => a.Reason = GetCodeableConcept(Id, "EncountersReason", Type, fromDate, toDate));
                _encounters.ForEach(a => a.Reason.ForEach(b => b.Coding = GetCoding(Id, "EncountersReason", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "EncountersReason", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Reason[0].Coding.Clear();
                        _encounters[i].Reason[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Diagnosis Type
                _encounters.ForEach(a => a.Diagnosis.ForEach(b => b.DiagnosisRole = GetCodeableConcept(Id, "EncountersDiagnosisRole", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Diagnosis.ForEach(b => b.DiagnosisRole.ForEach(c => c.Coding = GetCoding(Id, "EncountersDiagnosisRole", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersDiagnosisRole", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Diagnosis[0].DiagnosisRole[0].Coding.Clear();
                        _encounters[i].Diagnosis[0].DiagnosisRole[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Hospitalization AdmitSource
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationAdmitSource = GetCodeableConcept(Id, "EncountersHospitalizationAdmitSource", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationAdmitSource.ForEach(c => c.Coding = GetCoding(Id, "EncountersHospitalizationAdmitSource", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersHospitalizationAdmitSource", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Hospitalization[0].HospitalizationAdmitSource[0].Coding.Clear();
                        _encounters[i].Hospitalization[0].HospitalizationAdmitSource[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - EncountersHospitalization ReAdmission
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationReAdmission = GetCodeableConcept(Id, "EncountersHospitalizationReAdmission", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationReAdmission.ForEach(c => c.Coding = GetCoding(Id, "EncountersHospitalizationReAdmission", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersHospitalizationReAdmission", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Hospitalization[0].HospitalizationReAdmission[0].Coding.Clear();
                        _encounters[i].Hospitalization[0].HospitalizationReAdmission[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Hospitalization DietPreference
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationDietPreference = GetCodeableConcept(Id, "EncountersHospitalizationDietPreference", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationDietPreference.ForEach(c => c.Coding = GetCoding(Id, "EncountersHospitalizationDietPreference", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersHospitalizationDietPreference", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Hospitalization[0].HospitalizationDietPreference[0].Coding.Clear();
                        _encounters[i].Hospitalization[0].HospitalizationDietPreference[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Hospitalization SpecialCourtesy
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationSpecialCourtesy = GetCodeableConcept(Id, "EncountersHospitalizationSpecialCourtesy", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationSpecialCourtesy.ForEach(c => c.Coding = GetCoding(Id, "EncountersHospitalizationSpecialCourtesy", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersHospitalizationSpecialCourtesy", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Hospitalization[0].HospitalizationSpecialCourtesy[0].Coding.Clear();
                        _encounters[i].Hospitalization[0].HospitalizationSpecialCourtesy[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Hospitalization SpecialArrangement
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationSpecialArrangement = GetCodeableConcept(Id, "EncountersHospitalizationSpecialArrangement", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationSpecialArrangement.ForEach(c => c.Coding = GetCoding(Id, "EncountersHospitalizationSpecialArrangement", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersHospitalizationSpecialArrangement", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Hospitalization[0].HospitalizationSpecialArrangement[0].Coding.Clear();
                        _encounters[i].Hospitalization[0].HospitalizationSpecialArrangement[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Hospitalization DischargeDisposition
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationDischargeDisposition = GetCodeableConcept(Id, "EncountersHospitalizationDischargeDisposition", Type, fromDate, toDate)));
                _encounters.ForEach(a => a.Hospitalization.ForEach(b => b.HospitalizationDischargeDisposition.ForEach(c => c.Coding = GetCoding(Id, "EncountersHospitalizationDischargeDisposition", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "EncountersHospitalizationDischargeDisposition", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _encounters[i].Hospitalization[0].HospitalizationDischargeDisposition[0].Coding.Clear();
                        _encounters[i].Hospitalization[0].HospitalizationDischargeDisposition[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                return _encounters;                
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetMostRecentEncounters method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Immunizations based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<ImmunizationsModel> GetImmunizations(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetImmunizations(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<ImmunizationsModel> _immunization = new List<ImmunizationsModel>();
                List<ImmunizationsPractitionerModel> _practitioner = new List<ImmunizationsPractitionerModel>();
                List<ImmunizationsExplanationModel> _explanation = new List<ImmunizationsExplanationModel>();
                List<ImmunizationsReactionModel> _reaction = new List<ImmunizationsReactionModel>();
                List<ImmunizationsVaccinationProtocolModel> _vaccProtocol = new List<ImmunizationsVaccinationProtocolModel>();

                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _immunization = JsonConvert.DeserializeObject<List<ImmunizationsModel>>(json).ToList();
                _practitioner = JsonConvert.DeserializeObject<List<ImmunizationsPractitionerModel>>(json).ToList();
                _explanation = JsonConvert.DeserializeObject<List<ImmunizationsExplanationModel>>(json).ToList();
                _reaction = JsonConvert.DeserializeObject<List<ImmunizationsReactionModel>>(json).ToList();
                _vaccProtocol = JsonConvert.DeserializeObject<List<ImmunizationsVaccinationProtocolModel>>(json).ToList();
                
                _immunization.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _immunization.ForEach(a => a.Practitioner = JsonConvert.DeserializeObject<List<ImmunizationsPractitionerModel>>(json).ToList());
                _immunization.ForEach(a => a.Explanation = JsonConvert.DeserializeObject<List<ImmunizationsExplanationModel>>(json).ToList());
                _immunization.ForEach(a => a.Reaction = JsonConvert.DeserializeObject<List<ImmunizationsReactionModel>>(json).ToList());
                _immunization.ForEach(a => a.VaccinationProtocol = JsonConvert.DeserializeObject<List<ImmunizationsVaccinationProtocolModel>>(json).ToList());

                int i = 0;
                foreach (var _pract in _practitioner)
                {
                    _immunization[i].Practitioner.Clear();
                    _immunization[i].Practitioner.Add(_pract);
                    i = i + 1;
                }
                i = 0;
                foreach (var _expl in _explanation)
                {
                    _immunization[i].Explanation.Clear();
                    _immunization[i].Explanation.Add(_expl);
                    i = i + 1;
                }
                i = 0;
                foreach (var _react in _reaction)
                {
                    _immunization[i].Reaction.Clear();
                    _immunization[i].Reaction.Add(_react);
                    i = i + 1;
                }
                i = 0;
                foreach (var _vacc in _vaccProtocol)
                {
                    _immunization[i].VaccinationProtocol.Clear();
                    _immunization[i].VaccinationProtocol.Add(_vacc);
                    i = i + 1;
                }

                //CodeableConcept - VaccineCode
                _immunization.ForEach(a => a.VaccineCode = GetCodeableConcept(Id, "ImmunizationVaccineCode", Type, fromDate, toDate));
                _immunization.ForEach(a => a.VaccineCode.ForEach(b => b.Coding = GetCoding(Id, "ImmunizationVaccineCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ImmunizationVaccineCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].VaccineCode[0].Coding.Clear();
                        _immunization[i].VaccineCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - ReportOrigin
                _immunization.ForEach(a => a.ReportOrigin = GetCodeableConcept(Id, "ImmunizationReportOrigin", Type, fromDate, toDate));
                _immunization.ForEach(a => a.ReportOrigin.ForEach(b => b.Coding = GetCoding(Id, "ImmunizationReportOrigin", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ImmunizationReportOrigin", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].ReportOrigin[0].Coding.Clear();
                        _immunization[i].ReportOrigin[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Site
                _immunization.ForEach(a => a.Site = GetCodeableConcept(Id, "ImmunizationSite", Type, fromDate, toDate));
                _immunization.ForEach(a => a.Site.ForEach(b => b.Coding = GetCoding(Id, "ImmunizationSite", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ImmunizationSite", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].Site[0].Coding.Clear();
                        _immunization[i].Site[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Route
                _immunization.ForEach(a => a.Route = GetCodeableConcept(Id, "ImmunizationRoute", Type, fromDate, toDate));
                _immunization.ForEach(a => a.Route.ForEach(b => b.Coding = GetCoding(Id, "ImmunizationRoute", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "ImmunizationRoute", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].Route[0].Coding.Clear();
                        _immunization[i].Route[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - PractitionerRole
                _immunization.ForEach(a => a.Practitioner.ForEach(b => b.PractitionerRole = GetCodeableConcept(Id, "ImmunizationPractitionerRole", Type, fromDate, toDate)));
                _immunization.ForEach(a => a.Practitioner.ForEach(b => b.PractitionerRole.ForEach(c => c.Coding = GetCoding(Id, "ImmunizationPractitionerRole", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ImmunizationPractitionerRole", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].Practitioner[0].PractitionerRole[0].Coding.Clear();
                        _immunization[i].Practitioner[0].PractitionerRole[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - ExplanationReason
                _immunization.ForEach(a => a.Explanation.ForEach(b => b.ExplanationReason = GetCodeableConcept(Id, "ImmunizationExplanationReason", Type, fromDate, toDate)));
                _immunization.ForEach(a => a.Explanation.ForEach(b => b.ExplanationReason.ForEach(c => c.Coding = GetCoding(Id, "ImmunizationExplanationReason", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ImmunizationExplanationReason", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].Explanation[0].ExplanationReason[0].Coding.Clear();
                        _immunization[i].Explanation[0].ExplanationReason[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - ExplanationReasonNotGiven
                _immunization.ForEach(a => a.Explanation.ForEach(b => b.ExplanationReasonNotGiven = GetCodeableConcept(Id, "ImmunizationExplanationReasonNotGiven", Type, fromDate, toDate)));
                _immunization.ForEach(a => a.Explanation.ForEach(b => b.ExplanationReasonNotGiven.ForEach(c => c.Coding = GetCoding(Id, "ImmunizationExplanationReasonNotGiven", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ImmunizationExplanationReasonNotGiven", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].Explanation[0].ExplanationReasonNotGiven[0].Coding.Clear();
                        _immunization[i].Explanation[0].ExplanationReasonNotGiven[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - VaccinationProtocolTargetDisease
                _immunization.ForEach(a => a.VaccinationProtocol.ForEach(b => b.VaccinationProtocolTargetDisease = GetCodeableConcept(Id, "ImmunizationVaccinationProtocolTargetDisease", Type, fromDate, toDate)));
                _immunization.ForEach(a => a.VaccinationProtocol.ForEach(b => b.VaccinationProtocolTargetDisease.ForEach(c => c.Coding = GetCoding(Id, "ImmunizationVaccinationProtocolTargetDisease", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ImmunizationVaccinationProtocolTargetDisease", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].VaccinationProtocol[0].VaccinationProtocolTargetDisease[0].Coding.Clear();
                        _immunization[i].VaccinationProtocol[0].VaccinationProtocolTargetDisease[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - VaccinationProtocolDoseStatus
                _immunization.ForEach(a => a.VaccinationProtocol.ForEach(b => b.VaccinationProtocolDoseStatus = GetCodeableConcept(Id, "ImmunizationVaccinationProtocolDoseStatus", Type, fromDate, toDate)));
                _immunization.ForEach(a => a.VaccinationProtocol.ForEach(b => b.VaccinationProtocolDoseStatus.ForEach(c => c.Coding = GetCoding(Id, "ImmunizationVaccinationProtocolDoseStatus", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ImmunizationVaccinationProtocolDoseStatus", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].VaccinationProtocol[0].VaccinationProtocolDoseStatus[0].Coding.Clear();
                        _immunization[i].VaccinationProtocol[0].VaccinationProtocolDoseStatus[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - VaccinationProtocolDoseStatusReason
                _immunization.ForEach(a => a.VaccinationProtocol.ForEach(b => b.VaccinationProtocolDoseStatusReason = GetCodeableConcept(Id, "ImmunizationVaccinationProtocolDoseStatusReason", Type, fromDate, toDate)));
                _immunization.ForEach(a => a.VaccinationProtocol.ForEach(b => b.VaccinationProtocolDoseStatusReason.ForEach(c => c.Coding = GetCoding(Id, "ImmunizationVaccinationProtocolDoseStatusReason", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "ImmunizationVaccinationProtocolDoseStatusReason", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _immunization[i].VaccinationProtocol[0].VaccinationProtocolDoseStatusReason[0].Coding.Clear();
                        _immunization[i].VaccinationProtocol[0].VaccinationProtocolDoseStatusReason[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Quantity - Immunizations DoseQuantity
                List<QuantityModel> _quantity = new List<QuantityModel>();

                _immunization.ForEach(a => a.DoseQuantity = GetQuantity(Id, "ImmunizationsDoseQuantity", Type, fromDate, toDate));
                _quantity = GetQuantity(Id, "ImmunizationsDoseQuantity", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _immunization[i].DoseQuantity.Clear();
                        _immunization[i].DoseQuantity.Add(_qnt);
                        i = i + 1;
                    }
                }

                //Annotation - Immunizations Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _immunization.ForEach(a => a.Note = GetAnnotation(Id, "ImmunizationsNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "ImmunizationsNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _immunization[i].Note.Clear();
                        _immunization[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                return _immunization;                
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetImmunizations method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Social History based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<SocialHistoryModel> GetSocialHistory(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetSocialHistory(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<SocialHistoryModel> _social = new List<SocialHistoryModel>();
                List<SocialHistoryConditionModel> _condition = new List<SocialHistoryConditionModel>();

                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _social = JsonConvert.DeserializeObject<List<SocialHistoryModel>>(json).ToList();
                _condition = JsonConvert.DeserializeObject<List<SocialHistoryConditionModel>>(json).ToList();

                _social.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _social.ForEach(a => a.Condition = JsonConvert.DeserializeObject<List<SocialHistoryConditionModel>>(json).ToList());

                int i = 0;
                foreach (var _cnd in _condition)
                {
                    _social[i].Condition.Clear();
                    _social[i].Condition.Add(_cnd);
                    i = i + 1;
                }

                //CodeableConcept - SocialHistory NotDoneReason
                _social.ForEach(a => a.NotDoneReason = GetCodeableConcept(Id, "SocialHistoryNotDoneReason", Type, fromDate, toDate));
                _social.ForEach(a => a.NotDoneReason.ForEach(b => b.Coding = GetCoding(Id, "SocialHistoryNotDoneReason", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "SocialHistoryNotDoneReason", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _social[i].NotDoneReason[0].Coding.Clear();
                        _social[i].NotDoneReason[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - SocialHistory Relationship
                _social.ForEach(a => a.Relationship = GetCodeableConcept(Id, "SocialHistoryRelationship", Type, fromDate, toDate));
                _social.ForEach(a => a.Relationship.ForEach(b => b.Coding = GetCoding(Id, "SocialHistoryRelationship", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "SocialHistoryRelationship", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _social[i].Relationship[0].Coding.Clear();
                        _social[i].Relationship[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - SocialHistory ReasonCode
                _social.ForEach(a => a.ReasonCode = GetCodeableConcept(Id, "SocialHistoryReasonCode", Type, fromDate, toDate));
                _social.ForEach(a => a.ReasonCode.ForEach(b => b.Coding = GetCoding(Id, "SocialHistoryReasonCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "SocialHistoryReasonCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _social[i].ReasonCode[0].Coding.Clear();
                        _social[i].ReasonCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - SocialHistory ConditionCode
                _social.ForEach(a => a.Condition.ForEach(b => b.ConditionCode = GetCodeableConcept(Id, "SocialHistoryConditionCode", Type, fromDate, toDate)));
                _social.ForEach(a => a.Condition.ForEach(b => b.ConditionCode.ForEach(c => c.Coding = GetCoding(Id, "SocialHistoryConditionCode", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "SocialHistoryConditionCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _social[i].Condition[0].ConditionCode[0].Coding.Clear();
                        _social[i].Condition[0].ConditionCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - SocialHistory ConditionOutcome
                _social.ForEach(a => a.Condition.ForEach(b => b.ConditionOutcome = GetCodeableConcept(Id, "SocialHistoryConditionOutcome", Type, fromDate, toDate)));
                _social.ForEach(a => a.Condition.ForEach(b => b.ConditionOutcome.ForEach(c => c.Coding = GetCoding(Id, "SocialHistoryConditionOutcome", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "SocialHistoryConditionOutcome", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _social[i].Condition[0].ConditionOutcome[0].Coding.Clear();
                        _social[i].Condition[0].ConditionOutcome[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Annotation - SocialHistory Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _social.ForEach(a => a.Note = GetAnnotation(Id, "SocialHistoryNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "SocialHistoryNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _social[i].Note.Clear();
                        _social[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                //Annotation - SocialHistory ConditionNote
                _social.ForEach(a => a.Condition.ForEach(b => b.ConditionNote = GetAnnotation(Id, "SocialHistoryConditionNote", Type, fromDate, toDate)));
                _annotation = GetAnnotation(Id, "SocialHistoryConditionNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _social[i].Condition[0].ConditionNote.Clear();
                        _social[i].Condition[0].ConditionNote.Add(_ann);
                        i = i + 1;
                    }
                }

                return _social;                
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetSocialHistory method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Vital Signs based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<VitalSignsModel> GetVitalSigns(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetVitalSigns(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<VitalSignsModel> _vitalSigns = new List<VitalSignsModel>();
                List<VitalSignsRequesterModel> _requester = new List<VitalSignsRequesterModel>();
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();
                
                _vitalSigns = JsonConvert.DeserializeObject<List<VitalSignsModel>>(json).ToList();
                _vitalSigns.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _vitalSigns.ForEach(a => a.Requisition = GetIdentifier(Id, Type, fromDate, toDate));

                _requester = JsonConvert.DeserializeObject<List<VitalSignsRequesterModel>>(json).ToList();
                _vitalSigns.ForEach(a => a.Requester = JsonConvert.DeserializeObject<List<VitalSignsRequesterModel>>(json).ToList());
                int i = 0;
                foreach (var _req in _requester)
                {
                    _vitalSigns[i].Requester.Clear();
                    _vitalSigns[i].Requester.Add(_req);
                    i = i + 1;
                }
                
                //CodeableConcept - VitalSigns Category
                _vitalSigns.ForEach(a => a.Category = GetCodeableConcept(Id, "VitalSignsCategory", Type, fromDate, toDate));
                _vitalSigns.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "VitalSignsCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "VitalSignsCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _vitalSigns[i].Category[0].Coding.Clear();
                        _vitalSigns[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - VitalSigns Code
                _vitalSigns.ForEach(a => a.Code = GetCodeableConcept(Id, "VitalSignsCode", Type, fromDate, toDate));
                _vitalSigns.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "VitalSignsCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "VitalSignsCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _vitalSigns[i].Code[0].Coding.Clear();
                        _vitalSigns[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - VitalSigns PerformerType
                _vitalSigns.ForEach(a => a.PerformerType = GetCodeableConcept(Id, "VitalSignsPerformerType", Type, fromDate, toDate));
                _vitalSigns.ForEach(a => a.PerformerType.ForEach(b => b.Coding = GetCoding(Id, "VitalSignsPerformerType", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "VitalSignsPerformerType", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _vitalSigns[i].PerformerType[0].Coding.Clear();
                        _vitalSigns[i].PerformerType[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - VitalSigns ReasonCode
                _vitalSigns.ForEach(a => a.ReasonCode = GetCodeableConcept(Id, "VitalSignsReasonCode", Type, fromDate, toDate));
                _vitalSigns.ForEach(a => a.ReasonCode.ForEach(b => b.Coding = GetCoding(Id, "VitalSignsReasonCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "VitalSignsReasonCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _vitalSigns[i].ReasonCode[0].Coding.Clear();
                        _vitalSigns[i].ReasonCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - VitalSigns BodySite
                _vitalSigns.ForEach(a => a.BodySite = GetCodeableConcept(Id, "VitalSignsBodySite", Type, fromDate, toDate));
                _vitalSigns.ForEach(a => a.BodySite.ForEach(b => b.Coding = GetCoding(Id, "VitalSignsBodySite", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "VitalSignsBodySite", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _vitalSigns[i].BodySite[0].Coding.Clear();
                        _vitalSigns[i].BodySite[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Annotation - VitalSigns Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _vitalSigns.ForEach(a => a.Note = GetAnnotation(Id, "VitalSignsNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "VitalSignsNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _vitalSigns[i].Note.Clear();
                        _vitalSigns[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }

                return _vitalSigns;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetVitalSigns method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Plan Of Treatment based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<PlanOfTreatmentModel> GetPlanOfTreatment(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetPlanOfTreatment(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<PlanOfTreatmentModel> _treatment = new List<PlanOfTreatmentModel>();
                List<PlanOfTreatmentActivityModel> _activity = new List<PlanOfTreatmentActivityModel>();
                List<PlanOfTreatmentActivityDetailModel> _details = new List<PlanOfTreatmentActivityDetailModel>();

                List<PeriodModel> _period = new List<PeriodModel>();
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();               

                _treatment = JsonConvert.DeserializeObject<List<PlanOfTreatmentModel>>(json).ToList();
                _activity = JsonConvert.DeserializeObject<List<PlanOfTreatmentActivityModel>>(json).ToList();
                _details = JsonConvert.DeserializeObject<List<PlanOfTreatmentActivityDetailModel>>(json).ToList();
                
                _treatment.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _treatment.ForEach(a => a.Activity = JsonConvert.DeserializeObject<List<PlanOfTreatmentActivityModel>>(json).ToList());
                                
                int i = 0;
                foreach (var _act in _activity)
                {
                    _treatment[i].Activity.Clear();
                    _treatment[i].Activity.Add(_act);
                    i = i + 1;
                }

                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail = JsonConvert.DeserializeObject<List<PlanOfTreatmentActivityDetailModel>>(json).ToList()));

                i = 0;
                foreach (var _detail in _details)
                {
                    _treatment[i].Activity[0].Detail.Clear();
                    _treatment[i].Activity[0].Detail.Add(_detail);
                    i = i + 1;
                }

                //Period
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _treatment.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());
              
                i = 0;
                foreach (var _prd in _period)
                {
                    _treatment[i].Period.Clear();
                    _treatment[i].Period.Add(_prd);
                    i = i + 1;
                }
                
                //CodeableConcept - PlanOfTreatment Category
                _treatment.ForEach(a => a.Category = GetCodeableConcept(Id, "PlanOfTreatmentCategory", Type, fromDate, toDate));
                _treatment.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "PlanOfTreatmentCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "PlanOfTreatmentCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _treatment[i].Category[0].Coding.Clear();
                        _treatment[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - PlanOfTreatment ActivityOutcomeCodeableConcept
                _treatment.ForEach(a => a.Activity.ForEach(b => b.ActivityOutcomeCodeableConcept = GetCodeableConcept(Id, "PlanOfTreatmentActivityOutcomeCodeableConcept", Type, fromDate, toDate)));
                _treatment.ForEach(a => a.Activity.ForEach(b => b.ActivityOutcomeCodeableConcept.ForEach(c => c.Coding = GetCoding(Id, "PlanOfTreatmentActivityOutcomeCodeableConcept", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "PlanOfTreatmentActivityOutcomeCodeableConcept", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _treatment[i].Activity[0].ActivityOutcomeCodeableConcept[0].Coding.Clear();
                        _treatment[i].Activity[0].ActivityOutcomeCodeableConcept[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - PlanOfTreatment Activity Detail Category
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailCategory = GetCodeableConcept(Id, "PlanOfTreatmentActivityDetailCategory", Type, fromDate, toDate))));
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailCategory.ForEach(d => d.Coding = GetCoding(Id, "PlanOfTreatmentActivityDetailCategory", Type, fromDate, toDate)))));
                _coding = GetCoding(Id, "PlanOfTreatmentActivityDetailCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _treatment[i].Activity[0].Detail[0].ActivityDetailCategory[0].Coding.Clear();
                        _treatment[i].Activity[0].Detail[0].ActivityDetailCategory[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - PlanOfTreatment Activity Detail Code
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailCode = GetCodeableConcept(Id, "PlanOfTreatmentActivityDetailCode", Type, fromDate, toDate))));
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailCode.ForEach(d => d.Coding = GetCoding(Id, "PlanOfTreatmentActivityDetailCode", Type, fromDate, toDate)))));
                _coding = GetCoding(Id, "PlanOfTreatmentActivityDetailCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _treatment[i].Activity[0].Detail[0].ActivityDetailCode[0].Coding.Clear();
                        _treatment[i].Activity[0].Detail[0].ActivityDetailCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - PlanOfTreatment ActivityDetailReasonCode
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailReasonCode = GetCodeableConcept(Id, "PlanOfTreatmentActivityDetailReasonCode", Type, fromDate, toDate))));
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailReasonCode.ForEach(d => d.Coding = GetCoding(Id, "PlanOfTreatmentActivityDetailReasonCode", Type, fromDate, toDate)))));
                _coding = GetCoding(Id, "PlanOfTreatmentActivityDetailReasonCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _treatment[i].Activity[0].Detail[0].ActivityDetailReasonCode[0].Coding.Clear();
                        _treatment[i].Activity[0].Detail[0].ActivityDetailReasonCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - PlanOfTreatment ActivityDetailProductCodeableConcept
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailProductCodeableConcept = GetCodeableConcept(Id, "PlanOfTreatmentActivityDetailProductCodeableConcept", Type, fromDate, toDate))));
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailProductCodeableConcept.ForEach(d => d.Coding = GetCoding(Id, "PlanOfTreatmentActivityDetailProductCodeableConcept", Type, fromDate, toDate)))));
                _coding = GetCoding(Id, "PlanOfTreatmentActivityDetailProductCodeableConcept", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _treatment[i].Activity[0].Detail[0].ActivityDetailProductCodeableConcept[0].Coding.Clear();
                        _treatment[i].Activity[0].Detail[0].ActivityDetailProductCodeableConcept[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }


                //Quantity - PlanOfTreatment ActivityDetailDailyAmount
                List<QuantityModel> _quantity = new List<QuantityModel>();

                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailDailyAmount = GetQuantity(Id, "PlanOfTreatmentActivityDetailDailyAmount", Type, fromDate, toDate))));
                _quantity = GetQuantity(Id, "PlanOfTreatmentActivityDetailDailyAmount", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _treatment[i].Activity[0].Detail[0].ActivityDetailDailyAmount.Clear();
                        _treatment[i].Activity[0].Detail[0].ActivityDetailDailyAmount.Add(_qnt);
                        i = i + 1;
                    }
                }

                //Quantity - PlanOfTreatment ActivityDetailQuantity
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailQuantity = GetQuantity(Id, "PlanOfTreatmentActivityDetailQuantity", Type, fromDate, toDate))));
                _quantity = GetQuantity(Id, "PlanOfTreatmentActivityDetailQuantity", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _treatment[i].Activity[0].Detail[0].ActivityDetailQuantity.Clear();
                        _treatment[i].Activity[0].Detail[0].ActivityDetailQuantity.Add(_qnt);
                        i = i + 1;
                    }
                }

                //Annotation - PlanOfTreatment Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _treatment.ForEach(a => a.Note = GetAnnotation(Id, "PlanOfTreatmentNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "PlanOfTreatmentNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _treatment[i].Note.Clear();
                        _treatment[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                //Annotation - PlanOfTreatment ActivityProgress
                _treatment.ForEach(a => a.Activity.ForEach(b => b.ActivityProgress = GetAnnotation(Id, "PlanOfTreatmentActivityProgress", Type, fromDate, toDate)));
                _annotation = GetAnnotation(Id, "PlanOfTreatmentActivityProgress", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _treatment[i].Activity[0].ActivityProgress.Clear();
                        _treatment[i].Activity[0].ActivityProgress.Add(_ann);
                        i = i + 1;
                    }
                }
                //Timing - PlanOfTreatment ActivityDetailScheduledTiming
                List<TimingModel> _timing = new List<TimingModel>();
                _treatment.ForEach(a => a.Activity.ForEach(b => b.Detail.ForEach(c => c.ActivityDetailScheduledTiming = GetTiming(Id, "PlanOfTreatmentActivityDetailScheduledTiming", Type, fromDate, toDate))));
                _timing = GetTiming(Id, "PlanOfTreatmentActivityDetailScheduledTiming", Type, fromDate, toDate);
                i = 0;
                if (_timing != null)
                {
                    foreach (var _time in _timing)
                    {
                        _treatment[i].Activity[0].Detail[0].ActivityDetailScheduledTiming.Clear();
                        _treatment[i].Activity[0].Detail[0].ActivityDetailScheduledTiming.Add(_time);
                        i = i + 1;
                    }
                }
                return _treatment;                
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetPlanOfTreatment method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Goals based based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<GoalsModel> GetGoals(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetGoals(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<GoalsModel> _goals = new List<GoalsModel>();
                List<GoalsTargetModel> _targets = new List<GoalsTargetModel>();

                _goals = JsonConvert.DeserializeObject<List<GoalsModel>>(json).ToList();
                _targets = JsonConvert.DeserializeObject<List<GoalsTargetModel>>(json).ToList();

                _goals.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _goals.ForEach(a => a.Target = JsonConvert.DeserializeObject<List<GoalsTargetModel>>(json).ToList());

                int i = 0;
                foreach (var _target in _targets)
                {
                    _goals[i].Target.Clear();
                    _goals[i].Target.Add(_target);
                    i = i + 1;
                }

                //CodeableConcept - Goals Category
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _goals.ForEach(a => a.Category = GetCodeableConcept(Id, "GoalsCategory", Type, fromDate, toDate));
                _goals.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "GoalsCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "GoalsCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _goals[i].Category[0].Coding.Clear();
                        _goals[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Goals Priority
                _goals.ForEach(a => a.Priority = GetCodeableConcept(Id, "GoalsPriority", Type, fromDate, toDate));
                _goals.ForEach(a => a.Priority.ForEach(b => b.Coding = GetCoding(Id, "GoalsPriority", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "GoalsPriority", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _goals[i].Priority[0].Coding.Clear();
                        _goals[i].Priority[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Goals Description
                _goals.ForEach(a => a.Description = GetCodeableConcept(Id, "GoalsDescription", Type, fromDate, toDate));
                _goals.ForEach(a => a.Description.ForEach(b => b.Coding = GetCoding(Id, "GoalsDescription", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "GoalsDescription", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _goals[i].Description[0].Coding.Clear();
                        _goals[i].Description[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Goals TargetMeasure
                _goals.ForEach(a => a.Target.ForEach(b => b.TargetMeasure = GetCodeableConcept(Id, "GoalsTargetMeasure", Type, fromDate, toDate)));
                _goals.ForEach(a => a.Target.ForEach(b => b.TargetMeasure.ForEach(c => c.Coding = GetCoding(Id, "GoalsTargetMeasure", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "GoalsTargetMeasure", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _goals[i].Target[0].TargetMeasure[0].Coding.Clear();
                        _goals[i].Target[0].TargetMeasure[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - Goals OutcomeCode
                _goals.ForEach(a => a.OutcomeCode = GetCodeableConcept(Id, "GoalsOutcomeCode", Type, fromDate, toDate));
                _goals.ForEach(a => a.OutcomeCode.ForEach(b => b.Coding = GetCoding(Id, "GoalsOutcomeCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "GoalsOutcomeCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _goals[i].OutcomeCode[0].Coding.Clear();
                        _goals[i].OutcomeCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Quantity - Goals TargetDetailQuantity
                List<QuantityModel> _quantity = new List<QuantityModel>();

                _goals.ForEach(a => a.Target.ForEach(b => b.TargetDetailQuantity = GetQuantity(Id, "GoalsTargetDetailQuantity", Type, fromDate, toDate)));
                _quantity = GetQuantity(Id, "GoalsTargetDetailQuantity", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _goals[i].Target[0].TargetDetailQuantity.Clear();
                        _goals[i].Target[0].TargetDetailQuantity.Add(_qnt);
                        i = i + 1;
                    }
                }

                //Annotation - Goals Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _goals.ForEach(a => a.Note = GetAnnotation(Id, "GoalsNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "GoalsNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _goals[i].Note.Clear();
                        _goals[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                return _goals;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetGoals method." + ex.Message);
                throw excep;
            }
        }
        

        /// <summary>
        /// Get History Of Procedures based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<HistoryOfProceduresModel> GetHistoryOfProcedures(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetHistoryOfProcedures(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<HistoryOfProceduresModel> _procedures = new List<HistoryOfProceduresModel>();
                List<HistoryOfProceduresPerformerModel> _performers = new List<HistoryOfProceduresPerformerModel>();
                List<HistoryOfProceduresFocalDeviceModel> _focalDevices = new List<HistoryOfProceduresFocalDeviceModel>();

                _procedures = JsonConvert.DeserializeObject<List<HistoryOfProceduresModel>>(json).ToList();
                _performers = JsonConvert.DeserializeObject<List<HistoryOfProceduresPerformerModel>>(json).ToList();
                _focalDevices = JsonConvert.DeserializeObject<List<HistoryOfProceduresFocalDeviceModel>>(json).ToList();
                
                _procedures.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _procedures.ForEach(a => a.Performer = JsonConvert.DeserializeObject<List<HistoryOfProceduresPerformerModel>>(json).ToList());
                _procedures.ForEach(a => a.FocalDevice = JsonConvert.DeserializeObject<List<HistoryOfProceduresFocalDeviceModel>>(json).ToList());

                int i = 0;
                foreach (var _performer in _performers)
                {
                    _procedures[i].Performer.Clear();
                    _procedures[i].Performer.Add(_performer);
                    i = i + 1;
                }
                i = 0;
                foreach (var _focalDevice in _focalDevices)
                {
                    _procedures[i].FocalDevice.Clear();
                    _procedures[i].FocalDevice.Add(_focalDevice);
                    i = i + 1;
                }
                //Period
                List<PeriodModel> _period = new List<PeriodModel>();
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _procedures.ForEach(a => a.PerformedPeriod = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());               
                i = 0;
                foreach (var _prd in _period)
                {
                    _procedures[i].PerformedPeriod.Clear();
                    _procedures[i].PerformedPeriod.Add(_prd);
                    i = i + 1;
                }

                //CodeableConcept - HistoryOfProcedures NotDoneReason
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _procedures.ForEach(a => a.NotDoneReason = GetCodeableConcept(Id, "HistoryOfProceduresNotDoneReason", Type, fromDate, toDate));
                _procedures.ForEach(a => a.NotDoneReason.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresNotDoneReason", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresNotDoneReason", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].NotDoneReason[0].Coding.Clear();
                        _procedures[i].NotDoneReason[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures Category
                _procedures.ForEach(a => a.Category = GetCodeableConcept(Id, "HistoryOfProceduresCategory", Type, fromDate, toDate));
                _procedures.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].Category[0].Coding.Clear();
                        _procedures[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures Code
                _procedures.ForEach(a => a.Code = GetCodeableConcept(Id, "HistoryOfProceduresCode", Type, fromDate, toDate));
                _procedures.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].Code[0].Coding.Clear();
                        _procedures[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures PerformerRole
                _procedures.ForEach(a => a.Performer.ForEach(b => b.PerformerRole = GetCodeableConcept(Id, "HistoryOfProceduresPerformerRole", Type, fromDate, toDate)));
                _procedures.ForEach(a => a.Performer.ForEach(b => b.PerformerRole.ForEach(c => c.Coding = GetCoding(Id, "HistoryOfProceduresPerformerRole", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "HistoryOfProceduresPerformerRole", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].Performer[0].PerformerRole[0].Coding.Clear();
                        _procedures[i].Performer[0].PerformerRole[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures ReasonCode
                _procedures.ForEach(a => a.ReasonCode = GetCodeableConcept(Id, "HistoryOfProceduresReasonCode", Type, fromDate, toDate));
                _procedures.ForEach(a => a.ReasonCode.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresReasonCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresReasonCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].ReasonCode[0].Coding.Clear();
                        _procedures[i].ReasonCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures BodySite
                _procedures.ForEach(a => a.BodySite = GetCodeableConcept(Id, "HistoryOfProceduresBodySite", Type, fromDate, toDate));
                _procedures.ForEach(a => a.BodySite.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresBodySite", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresBodySite", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].BodySite[0].Coding.Clear();
                        _procedures[i].BodySite[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures Outcome
                _procedures.ForEach(a => a.Outcome = GetCodeableConcept(Id, "HistoryOfProceduresOutcome", Type, fromDate, toDate));
                _procedures.ForEach(a => a.Outcome.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresOutcome", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresOutcome", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].Outcome[0].Coding.Clear();
                        _procedures[i].Outcome[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures Complication
                _procedures.ForEach(a => a.Complication = GetCodeableConcept(Id, "HistoryOfProceduresComplication", Type, fromDate, toDate));
                _procedures.ForEach(a => a.Complication.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresComplication", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresComplication", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].Complication[0].Coding.Clear();
                        _procedures[i].Complication[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures FollowUp
                _procedures.ForEach(a => a.FollowUp = GetCodeableConcept(Id, "HistoryOfProceduresFollowUp", Type, fromDate, toDate));
                _procedures.ForEach(a => a.FollowUp.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresFollowUp", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresFollowUp", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].FollowUp[0].Coding.Clear();
                        _procedures[i].FollowUp[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures FocalDeviceAction 
                _procedures.ForEach(a => a.FocalDevice.ForEach(b => b.FocalDeviceAction = GetCodeableConcept(Id, "HistoryOfProceduresFocalDeviceAction", Type, fromDate, toDate)));
                _procedures.ForEach(a => a.FocalDevice.ForEach(b => b.FocalDeviceAction.ForEach(c => c.Coding = GetCoding(Id, "HistoryOfProceduresFocalDeviceAction", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "HistoryOfProceduresFocalDeviceAction", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].FocalDevice[0].FocalDeviceAction[0].Coding.Clear();
                        _procedures[i].FocalDevice[0].FocalDeviceAction[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - HistoryOfProcedures UsedCode
                _procedures.ForEach(a => a.UsedCode = GetCodeableConcept(Id, "HistoryOfProceduresUsedCode", Type, fromDate, toDate));
                _procedures.ForEach(a => a.UsedCode.ForEach(b => b.Coding = GetCoding(Id, "HistoryOfProceduresUsedCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "HistoryOfProceduresUsedCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _procedures[i].UsedCode[0].Coding.Clear();
                        _procedures[i].UsedCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Annotation - HistoryOfProcedures Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _procedures.ForEach(a => a.Note = GetAnnotation(Id, "HistoryOfProceduresNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "HistoryOfProceduresNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _procedures[i].Note.Clear();
                        _procedures[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                return _procedures;
            }


            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetHistoryOfProcedures method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Studies Summary based on Identifiers
        /// </summary>
        /// <param name="Id"></param>        
        /// <returns></returns>
        public List<StudiesSummaryModel> GetStudiesSummary(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetStudiesSummary(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<StudiesSummaryModel> _summary = new List<StudiesSummaryModel>();
                List<StudiesSummaryReferenceRangeModel> _referenceRange = new List<StudiesSummaryReferenceRangeModel>();
                List<StudiesSummaryRelatedModel> _related = new List<StudiesSummaryRelatedModel>();
                List<StudiesSummaryComponentModel> _component = new List<StudiesSummaryComponentModel>();

                _summary = JsonConvert.DeserializeObject<List<StudiesSummaryModel>>(json).ToList();
                _referenceRange = JsonConvert.DeserializeObject<List<StudiesSummaryReferenceRangeModel>>(json).ToList();
                _related = JsonConvert.DeserializeObject<List<StudiesSummaryRelatedModel>>(json).ToList();
                _component = JsonConvert.DeserializeObject<List<StudiesSummaryComponentModel>>(json).ToList();

                _summary.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _summary.ForEach(a => a.ReferenceRange = JsonConvert.DeserializeObject<List<StudiesSummaryReferenceRangeModel>>(json).ToList());
                _summary.ForEach(a => a.Related = JsonConvert.DeserializeObject<List<StudiesSummaryRelatedModel>>(json).ToList());
                _summary.ForEach(a => a.Component = JsonConvert.DeserializeObject<List<StudiesSummaryComponentModel>>(json).ToList());

                int i = 0;
                foreach (var _ref in _referenceRange)
                {
                    _summary[i].ReferenceRange.Clear();
                    _summary[i].ReferenceRange.Add(_ref);
                    i = i + 1;
                }
                i = 0;
                foreach (var _rel in _related)
                {
                    _summary[i].Related.Clear();
                    _summary[i].Related.Add(_rel);
                    i = i + 1;
                }
                i = 0;
                foreach (var _comp in _component)
                {
                    _summary[i].Component.Clear();
                    _summary[i].Component.Add(_comp);
                    i = i + 1;
                }

                //Period
                List<PeriodModel> _period = new List<PeriodModel>();
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _summary.ForEach(a => a.EffectivePeriod = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());
                i = 0;
                foreach (var _prd in _period)
                {
                    _summary[i].EffectivePeriod.Clear();
                    _summary[i].EffectivePeriod.Add(_prd);
                    i = i + 1;
                }

                List<ValuePeriodModel> _valuePeriod = new List<ValuePeriodModel>();
                _valuePeriod = JsonConvert.DeserializeObject<List<ValuePeriodModel>>(json).ToList();
                _summary.ForEach(a => a.ValuePeriod = JsonConvert.DeserializeObject<List<ValuePeriodModel>>(json).ToList());
                i = 0;
                foreach (var _prd in _valuePeriod)
                {
                    _summary[i].ValuePeriod.Clear();
                    _summary[i].ValuePeriod.Add(_prd);
                    i = i + 1;
                }

                List<ComponentValuePeriodModel> _componentValuePeriod = new List<ComponentValuePeriodModel>();
                _componentValuePeriod = JsonConvert.DeserializeObject<List<ComponentValuePeriodModel>>(json).ToList();
                _summary.ForEach(a => a.Component.ForEach(b => b.ComponentValuePeriod = JsonConvert.DeserializeObject<List<ComponentValuePeriodModel>>(json).ToList()));
                i = 0;
                foreach (var _prd in _componentValuePeriod)
                {
                    _summary[i].Component[0].ComponentValuePeriod.Clear();
                    _summary[i].Component[0].ComponentValuePeriod.Add(_prd);
                    i = i + 1;
                }

                //CodeableConcept - StudiesSummary Category
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _summary.ForEach(a => a.Category = GetCodeableConcept(Id, "StudiesSummaryCategory", Type, fromDate, toDate));
                _summary.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "StudiesSummaryCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "StudiesSummaryCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].Category[0].Coding.Clear();
                        _summary[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary Code
                _summary.ForEach(a => a.Code = GetCodeableConcept(Id, "StudiesSummaryCode", Type, fromDate, toDate));
                _summary.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "StudiesSummaryCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "StudiesSummaryCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].Code[0].Coding.Clear();
                        _summary[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary DataAbsentReason
                _summary.ForEach(a => a.DataAbsentReason = GetCodeableConcept(Id, "StudiesSummaryDataAbsentReason", Type, fromDate, toDate));
                _summary.ForEach(a => a.DataAbsentReason.ForEach(b => b.Coding = GetCoding(Id, "StudiesSummaryDataAbsentReason", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "StudiesSummaryDataAbsentReason", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].DataAbsentReason[0].Coding.Clear();
                        _summary[i].DataAbsentReason[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary Interpretation
                _summary.ForEach(a => a.Interpretation = GetCodeableConcept(Id, "StudiesSummaryInterpretation", Type, fromDate, toDate));
                _summary.ForEach(a => a.Interpretation.ForEach(b => b.Coding = GetCoding(Id, "StudiesSummaryInterpretation", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "StudiesSummaryInterpretation", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].Interpretation[0].Coding.Clear();
                        _summary[i].Interpretation[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary BodySite
                _summary.ForEach(a => a.BodySite = GetCodeableConcept(Id, "StudiesSummaryBodySite", Type, fromDate, toDate));
                _summary.ForEach(a => a.BodySite.ForEach(b => b.Coding = GetCoding(Id, "StudiesSummaryBodySite", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "StudiesSummaryBodySite", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].BodySite[0].Coding.Clear();
                        _summary[i].BodySite[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary Method
                _summary.ForEach(a => a.Method = GetCodeableConcept(Id, "StudiesSummaryMethod", Type, fromDate, toDate));
                _summary.ForEach(a => a.Method.ForEach(b => b.Coding = GetCoding(Id, "StudiesSummaryMethod", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "StudiesSummaryMethod", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].Method[0].Coding.Clear();
                        _summary[i].Method[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary ReferenceRangeType
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeType = GetCodeableConcept(Id, "StudiesSummaryReferenceRangeType", Type, fromDate, toDate)));
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeType.ForEach(c => c.Coding = GetCoding(Id, "StudiesSummaryReferenceRangeType", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "StudiesSummaryReferenceRangeType", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].ReferenceRange[0].ReferenceRangeType[0].Coding.Clear();
                        _summary[i].ReferenceRange[0].ReferenceRangeType[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary ReferenceRangeAppliesTo
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeAppliesTo = GetCodeableConcept(Id, "StudiesSummaryReferenceRangeAppliesTo", Type, fromDate, toDate)));
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeAppliesTo.ForEach(c => c.Coding = GetCoding(Id, "StudiesSummaryReferenceRangeAppliesTo", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "StudiesSummaryReferenceRangeAppliesTo", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].ReferenceRange[0].ReferenceRangeAppliesTo[0].Coding.Clear();
                        _summary[i].ReferenceRange[0].ReferenceRangeAppliesTo[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary ComponentCode
                _summary.ForEach(a => a.Component.ForEach(b => b.ComponentCode = GetCodeableConcept(Id, "StudiesSummaryComponentCode", Type, fromDate, toDate)));
                _summary.ForEach(a => a.Component.ForEach(b => b.ComponentCode.ForEach(c => c.Coding = GetCoding(Id, "StudiesSummaryComponentCode", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "StudiesSummaryComponentCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].Component[0].ComponentCode[0].Coding.Clear();
                        _summary[i].Component[0].ComponentCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary ComponentDataAbsentReason
                _summary.ForEach(a => a.Component.ForEach(b => b.ComponentDataAbsentReason = GetCodeableConcept(Id, "StudiesSummaryComponentDataAbsentReason", Type, fromDate, toDate)));
                _summary.ForEach(a => a.Component.ForEach(b => b.ComponentDataAbsentReason.ForEach(c => c.Coding = GetCoding(Id, "StudiesSummaryComponentDataAbsentReason", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "StudiesSummaryComponentDataAbsentReason", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].Component[0].ComponentDataAbsentReason[0].Coding.Clear();
                        _summary[i].Component[0].ComponentDataAbsentReason[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - StudiesSummary ComponentInterpretation
                _summary.ForEach(a => a.Component.ForEach(b => b.ComponentInterpretation = GetCodeableConcept(Id, "StudiesSummaryComponentInterpretation", Type, fromDate, toDate)));
                _summary.ForEach(a => a.Component.ForEach(b => b.ComponentInterpretation.ForEach(c => c.Coding = GetCoding(Id, "StudiesSummaryComponentInterpretation", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "StudiesSummaryComponentInterpretation", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _summary[i].Component[0].ComponentInterpretation[0].Coding.Clear();
                        _summary[i].Component[0].ComponentInterpretation[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                
                //Quantity - StudiesSummary StudiesSummaryReferenceRangeLow
                List<QuantityModel> _quantity = new List<QuantityModel>();
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeLow = GetQuantity(Id, "StudiesSummaryReferenceRangeLow", Type, fromDate, toDate)));
                _quantity = GetQuantity(Id, "StudiesSummaryReferenceRangeLow", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _summary[i].ReferenceRange[0].ReferenceRangeLow.Clear();
                        _summary[i].ReferenceRange[0].ReferenceRangeLow.Add(_qnt);
                        i = i + 1;
                    }
                }
                //Quantity - StudiesSummary StudiesSummaryReferenceRangeHigh
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeHigh = GetQuantity(Id, "StudiesSummaryReferenceRangeHigh", Type, fromDate, toDate)));
                _quantity = GetQuantity(Id, "StudiesSummaryReferenceRangeHigh", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _summary[i].ReferenceRange[0].ReferenceRangeHigh.Clear();
                        _summary[i].ReferenceRange[0].ReferenceRangeHigh.Add(_qnt);
                        i = i + 1;
                    }
                }

                //Range
                List<RangeModel> _range = new List<RangeModel>();
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeAge = JsonConvert.DeserializeObject<List<RangeModel>>(json).ToList()));
                 _range = JsonConvert.DeserializeObject<List<RangeModel>>(json).ToList();
                i = 0;
                if (_range != null && _range.Count > 0)
                {
                    foreach (var _ran in _range)
                    {
                        _summary[i].ReferenceRange[0].ReferenceRangeAge.Clear();
                        _summary[i].ReferenceRange[0].ReferenceRangeAge.Add(_ran);
                        i = i + 1;
                    }
                }

                //Range - StudiesSummary StudiesSummaryReferenceRangeLow
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeAge.ForEach(c => c.Low = GetQuantity(Id, "StudiesSummaryReferenceRangeAgeLow", Type, fromDate, toDate))));
                _quantity = GetQuantity(Id, "StudiesSummaryReferenceRangeAgeLow", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _summary[i].ReferenceRange[0].ReferenceRangeAge[0].Low.Clear();
                        _summary[i].ReferenceRange[0].ReferenceRangeAge[0].Low.Add(_qnt);
                        i = i + 1;
                    }
                }
                //Range - StudiesSummary StudiesSummaryReferenceRangeAgeHeigh
                _summary.ForEach(a => a.ReferenceRange.ForEach(b => b.ReferenceRangeAge.ForEach(c => c.High = GetQuantity(Id, "StudiesSummaryReferenceRangeAgeHigh", Type, fromDate, toDate))));
                _quantity = GetQuantity(Id, "StudiesSummaryReferenceRangeAgeHigh", Type, fromDate, toDate);
                i = 0;
                if (_quantity != null)
                {
                    foreach (var _qnt in _quantity)
                    {
                        _summary[i].ReferenceRange[0].ReferenceRangeAge[0].High.Clear();
                        _summary[i].ReferenceRange[0].ReferenceRangeAge[0].High.Add(_qnt);
                        i = i + 1;
                    }
                }

                return _summary;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetStudiesSummary method." + ex.Message);
                throw excep;
            }
        }


        /// <summary>
        /// Get Laboratory Tests based on Identifiers
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public List<LaboratoryTestsModel> GetLaboratoryTests(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetLaboratoryTests(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<LaboratoryTestsModel> _lab = new List<LaboratoryTestsModel>();
                List<LaboratoryTestsPerformerModel> _performer = new List<LaboratoryTestsPerformerModel>();
                List<LaboratoryTestsImagingModel> _image = new List<LaboratoryTestsImagingModel>();

                _lab = JsonConvert.DeserializeObject<List<LaboratoryTestsModel>>(json).ToList();
                _performer = JsonConvert.DeserializeObject<List<LaboratoryTestsPerformerModel>>(json).ToList();
                _image = JsonConvert.DeserializeObject<List<LaboratoryTestsImagingModel>>(json).ToList();
                                
                _lab.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _lab.ForEach(a => a.Performer = JsonConvert.DeserializeObject<List<LaboratoryTestsPerformerModel>>(json).ToList());
                _lab.ForEach(a => a.Imaging = JsonConvert.DeserializeObject<List<LaboratoryTestsImagingModel>>(json).ToList());

                int i = 0;
                foreach (var _perform in _performer)
                {
                    _lab[i].Performer.Clear();
                    _lab[i].Performer.Add(_perform);
                    i = i + 1;
                }
                i = 0;
                foreach (var _img in _image)
                {
                    _lab[i].Imaging.Clear();
                    _lab[i].Imaging.Add(_img);
                    i = i + 1;
                }

                //CodeableConcept - LaboratoryTests Category
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _lab.ForEach(a => a.Category = GetCodeableConcept(Id, "LaboratoryTestsCategory", Type, fromDate, toDate));
                _lab.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "LaboratoryTestsCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "LaboratoryTestsCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _lab[i].Category[0].Coding.Clear();
                        _lab[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - LaboratoryTests Code
                _lab.ForEach(a => a.Code = GetCodeableConcept(Id, "LaboratoryTestsCode", Type, fromDate, toDate));
                _lab.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "LaboratoryTestsCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "LaboratoryTestsCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _lab[i].Code[0].Coding.Clear();
                        _lab[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - LaboratoryTests Performer Role
                _lab.ForEach(a => a.Performer.ForEach(b => b.PerformerRole = GetCodeableConcept(Id, "LaboratoryTestsPerformerRole", Type, fromDate, toDate)));
                _lab.ForEach(a => a.Performer.ForEach(b => b.PerformerRole.ForEach(c => c.Coding = GetCoding(Id, "LaboratoryTestsPerformerRole", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "LaboratoryTestsPerformerRole", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _lab[i].Performer[0].PerformerRole[0].Coding.Clear();
                        _lab[i].Performer[0].PerformerRole[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //CodeableConcept - LaboratoryTests CodedDiagnosis
                _lab.ForEach(a => a.CodedDiagnosis = GetCodeableConcept(Id, "LaboratoryTestsCodedDiagnosis", Type, fromDate, toDate));
                _lab.ForEach(a => a.CodedDiagnosis.ForEach(b => b.Coding = GetCoding(Id, "LaboratoryTestsCodedDiagnosis", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "LaboratoryTestsCodedDiagnosis", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _lab[i].CodedDiagnosis[0].Coding.Clear();
                        _lab[i].CodedDiagnosis[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Attachment - LaboratoryTests PresentedForm
                List<AttachmentModel> _attachment = new List<AttachmentModel>();
                _lab.ForEach(a => a.PresentedForm = GetAttachment(Id, "LaboratoryTestsPresentedForm", Type, fromDate, toDate));
                _attachment = GetAttachment(Id, "LaboratoryTestsPresentedForm", Type, fromDate, toDate);
                i = 0;
                if (_attachment != null)
                {
                    foreach (var _ann in _attachment)
                    {
                        _lab[i].PresentedForm.Clear();
                        _lab[i].PresentedForm.Add(_ann);
                        i = i + 1;
                    }
                }

                return _lab;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetLaboratoryTests method." + ex.Message);
                throw excep;
            }
        }


        /// <summary>
        /// Get Care Team Member(s) based on Identifiers
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public List<CareTeamMembersModel> GetCareTeamMembers(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetCareTeamMembers(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<CareTeamMembersModel> _careTeam = new List<CareTeamMembersModel>();
                List<CareTeamMembersParticipantModel> _participants = new List<CareTeamMembersParticipantModel>();

                _careTeam = JsonConvert.DeserializeObject<List<CareTeamMembersModel>>(json).ToList();
                _participants = JsonConvert.DeserializeObject<List<CareTeamMembersParticipantModel>>(json).ToList();

                _careTeam.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _careTeam.ForEach(a => a.Participant = JsonConvert.DeserializeObject<List<CareTeamMembersParticipantModel>>(json).ToList());

                int i = 0;
                foreach (var _participant in _participants)
                {
                    _careTeam[i].Participant.Clear();
                    _careTeam[i].Participant.Add(_participant);
                    i = i + 1;
                }

                //Period
                List<PeriodModel> _period = new List<PeriodModel>();
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _careTeam.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());
                i = 0;
                foreach (var _prd in _period)
                {
                    _careTeam[i].Period.Clear();
                    _careTeam[i].Period.Add(_prd);
                    i = i + 1;
                }

                List<ParticipantPeriodModel> _participantPeriod = new List<ParticipantPeriodModel>();
                _participantPeriod = JsonConvert.DeserializeObject<List<ParticipantPeriodModel>>(json).ToList();
                _careTeam.ForEach(a => a.Participant.ForEach(b => b.ParticipantPeriod = JsonConvert.DeserializeObject<List<ParticipantPeriodModel>>(json).ToList()));
                i = 0;
                foreach (var _prd in _participantPeriod)
                {
                    _careTeam[i].Participant[0].ParticipantPeriod.Clear();
                    _careTeam[i].Participant[0].ParticipantPeriod.Add(_prd);
                    i = i + 1;
                }

                //CodeableConcept - CareTeamMembers Category
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _careTeam.ForEach(a => a.Category = GetCodeableConcept(Id, "CareTeamMembersCategory", Type, fromDate, toDate));
                _careTeam.ForEach(a => a.Category.ForEach(b => b.Coding = GetCoding(Id, "CareTeamMembersCategory", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "CareTeamMembersCategory", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _careTeam[i].Category[0].Coding.Clear();
                        _careTeam[i].Category[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - CareTeamMembers ParticipantRole
                _careTeam.ForEach(a => a.Participant.ForEach(b => b.ParticipantRole = GetCodeableConcept(Id, "CareTeamMembersParticipantRole", Type, fromDate, toDate)));
                _careTeam.ForEach(a => a.Participant.ForEach(b => b.ParticipantRole.ForEach(c => c.Coding = GetCoding(Id, "CareTeamMembersParticipantRole", Type, fromDate, toDate))));
                _coding = GetCoding(Id, "CareTeamMembersParticipantRole", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _careTeam[i].Participant[0].ParticipantRole[0].Coding.Clear();
                        _careTeam[i].Participant[0].ParticipantRole[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //CodeableConcept - CareTeamMembers ReasonCode
                _careTeam.ForEach(a => a.ReasonCode = GetCodeableConcept(Id, "CareTeamMembersReasonCode", Type, fromDate, toDate));
                _careTeam.ForEach(a => a.ReasonCode.ForEach(b => b.Coding = GetCoding(Id, "CareTeamMembersReasonCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "CareTeamMembersReasonCode", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _careTeam[i].ReasonCode[0].Coding.Clear();
                        _careTeam[i].ReasonCode[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Annotation - CareTeamMembers Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _careTeam.ForEach(a => a.Note = GetAnnotation(Id, "CareTeamMembersNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "CareTeamMembersNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _careTeam[i].Note.Clear();
                        _careTeam[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                return _careTeam;                
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetCareTeamMembers method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Unique Device Identifier(s) for a Patient’s Implantable Device(s) based on Identifiers
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public List<UDIModel> GetUDI(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.ssp_GetUDI(Id, Type, null, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<UDIModel> _udi = new List<UDIModel>();
                List<UDIIdentifierModel> _udiIdentifier = new List<UDIIdentifierModel>();

                _udi = JsonConvert.DeserializeObject<List<UDIModel>>(json).ToList();
                _udiIdentifier = JsonConvert.DeserializeObject<List<UDIIdentifierModel>>(json).ToList();

                _udi.ForEach(a => a.Identifier = GetIdentifier(Id, Type, fromDate, toDate));
                _udi.ForEach(a => a.Udi = JsonConvert.DeserializeObject<List<UDIIdentifierModel>>(json).ToList());

                int i = 0;
                foreach (var __udiIdent in _udiIdentifier)
                {
                    _udi[i].Udi.Clear();
                    _udi[i].Udi.Add(__udiIdent);
                    i = i + 1;
                }

                //ContactPoint - UniqueDeviceIdentifier Contact
                List<ContactPointModel> _contact = new List<ContactPointModel>();
                _udi.ForEach(a => a.Contact = GetTelecom(Id, "UniqueDeviceIdentifierContact", Type, fromDate, toDate));
                _contact = GetTelecom(Id, "UniqueDeviceIdentifierContact", Type, fromDate, toDate);
                i = 0;
                if (_contact != null)
                {
                    foreach (var _cont in _contact)
                    {
                        _udi[i].Contact.Clear();
                        _udi[i].Contact.Add(_cont);
                        i = i + 1;
                    }
                }

                //CodeableConcept - UniqueDeviceIdentifier Type
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();
                List<CodingModel> _coding = new List<CodingModel>();

                _udi.ForEach(a => a.Type = GetCodeableConcept(Id, "UniqueDeviceIdentifierType", Type, fromDate, toDate));
                _udi.ForEach(a => a.Type.ForEach(b => b.Coding = GetCoding(Id, "UniqueDeviceIdentifierType", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "UniqueDeviceIdentifierType", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _udi[i].Type[0].Coding.Clear();
                        _udi[i].Type[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }
                //CodeableConcept - UniqueDeviceIdentifier Safety
                _udi.ForEach(a => a.Safety = GetCodeableConcept(Id, "UniqueDeviceIdentifierSafety", Type, fromDate, toDate));
                _udi.ForEach(a => a.Safety.ForEach(b => b.Coding = GetCoding(Id, "UniqueDeviceIdentifierSafety", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "UniqueDeviceIdentifierSafety", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _udi[i].Safety[0].Coding.Clear();
                        _udi[i].Safety[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                //Annotation - UniqueDeviceIdentifier Note
                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _udi.ForEach(a => a.Note = GetAnnotation(Id, "UniqueDeviceIdentifierNote", Type, fromDate, toDate));
                _annotation = GetAnnotation(Id, "UniqueDeviceIdentifierNote", Type, fromDate, toDate);
                i = 0;
                if (_annotation != null)
                {
                    foreach (var _ann in _annotation)
                    {
                        _udi[i].Note.Clear();
                        _udi[i].Note.Add(_ann);
                        i = i + 1;
                    }
                }
                return _udi;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetUDI method." + ex.Message);
                throw excep;
            }
        }


        public List<IdentifierModel> GetIdentifier(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetIdentifier(Id, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<IdentifierModel> _identifier = new List<IdentifierModel>();
                List<PeriodModel> _period = new List<PeriodModel>();

                _identifier = JsonConvert.DeserializeObject<List<IdentifierModel>>(json).ToList();
                _identifier.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());

                return _identifier;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetIdentifier method." + ex.Message);
                throw excep;
            }
        }
        public List<HumanNameModel> GetHumanName(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetHumanName(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<HumanNameModel> _name = new List<HumanNameModel>();
                List<PeriodModel> _period = new List<PeriodModel>();

                _name = JsonConvert.DeserializeObject<List<HumanNameModel>>(json).ToList();
                _name.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());

                //Period
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _name.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());
                int i = 0;
                foreach (var _prd in _period)
                {
                    _name[i].Period.Clear();
                    _name[i].Period.Add(_prd);
                    i = i + 1;
                }

                return _name;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetHumanName method." + ex.Message);
                throw excep;
            }
        }
        public List<AddressModel> GetAddress(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetAddress(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<AddressModel> _address = new List<AddressModel>();
                List<PeriodModel> _period = new List<PeriodModel>();

                _address = JsonConvert.DeserializeObject<List<AddressModel>>(json).ToList();
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _address.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());

                int i = 0;
                foreach (var _pd in _period)
                {
                    _address[i].Period.Clear();
                    _address[i].Period.Add(_pd);
                    i = i + 1;
                }

                return _address;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetAddress method." + ex.Message);
                throw excep;
            }
        }
        public List<ContactPointModel> GetTelecom(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {

                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetTelecom(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<ContactPointModel> _telecom = new List<ContactPointModel>();
                List<PeriodModel> _period = new List<PeriodModel>();

                _telecom = JsonConvert.DeserializeObject<List<ContactPointModel>>(json).ToList();
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();
                _telecom.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());

                int i = 0;
                foreach (var _prd in _period)
                {
                    _telecom[i].Period.Clear();
                    _telecom[i].Period.Add(_prd);
                    i = i + 1;
                }

                return _telecom;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetTelecom method." + ex.Message);
                throw excep;
            }
        }
        public List<ContactPersonModel> GetPatientContactPerson(int Id, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetPatientContactPerson(Id, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;


                List<ContactPersonModel> _contactPerson = new List<ContactPersonModel>();
                List<HumanNameModel> _contactPersonName = new List<HumanNameModel>();
                List<ContactPointModel> _contactPersonTelecom = new List<ContactPointModel>();
                List<AddressModel> _contactPersonAddress = new List<AddressModel>();
                List<PeriodModel> _period = new List<PeriodModel>();

                _contactPerson = JsonConvert.DeserializeObject<List<ContactPersonModel>>(json).ToList();
                _contactPersonName = GetHumanName(Id, "DemographicContactPersonHumanName", Type, fromDate, toDate);
                _contactPersonTelecom = GetTelecom(Id, "DemographicContactPersonTelecom", Type, fromDate, toDate);
                _contactPersonAddress = GetAddress(Id, "DemographicPatientContactPersonAddress", Type, fromDate, toDate);
                _period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList();

                _contactPerson.ForEach(a => a.Name = GetHumanName(Id, "DemographicContactPersonHumanName", Type, fromDate, toDate));
                _contactPerson.ForEach(a => a.Telecom = GetTelecom(Id, "DemographicContactPersonTelecom", Type, fromDate, toDate));
                _contactPerson.ForEach(a => a.Address = GetAddress(Id, "DemographicPatientContactPersonAddress", Type, fromDate, toDate));
                _contactPerson.ForEach(a => a.Period = JsonConvert.DeserializeObject<List<PeriodModel>>(json).ToList());


                int i = 0;
                foreach (var _cpName in _contactPersonName)
                {
                    _contactPerson[i].Name.Clear();
                    _contactPerson[i].Name.Add(_cpName);
                    i = i + 1;
                }

                i = 0;
                foreach (var _cpTelecom in _contactPersonTelecom)
                {
                    _contactPerson[i].Telecom.Clear();
                    _contactPerson[i].Telecom.Add(_cpTelecom);
                    i = i + 1;
                }

                i = 0;
                foreach (var _cpa in _contactPersonAddress)
                {
                    _contactPerson[i].Address.Clear();
                    _contactPerson[i].Address.Add(_cpa);
                    i = i + 1;
                }

                i = 0;
                foreach (var _pd in _period)
                {
                    _contactPerson[i].Period.Clear();
                    _contactPerson[i].Period.Add(_pd);
                    i = i + 1;
                }


                return _contactPerson;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetPatientContactPerson method." + ex.Message);
                throw excep;
            }
        }
        public List<CodeableConceptModel> GetCodeableConcept(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                List<CodeableConceptModel> _codeableConcept = new List<CodeableConceptModel>();

                var strText = "";
                if (Text == "Relationship") strText = "Relationship";
                else if (Text == "MaritalStatus") strText = "MaritalStatus";
                else if (Text == "Language") strText = "Language";
                else if (Text == "Species") strText = "Species";
                else if (Text == "Breed") strText = "Breed";
                else if (Text == "GenderStatus") strText = "GenderStatus";

                else if (Text == "AllergiesCode") strText = "Code";
                else if (Text == "Substance") strText = "Substance";
                else if (Text == "Manifestation") strText = "Manifestation";
                else if (Text == "ExposureRoute") strText = "ExposureRoute";

                else if (Text == "CurrentMedicationsCode") strText = "Code";
                else if (Text == "CurrentMedicationsForm") strText = "Form";
                else if (Text == "IngredientItemCodeableConcept") strText = "ItemCodeableConcept";
                else if (Text == "PackageContainer") strText = "Container";
                else if (Text == "ContentItemCodeableConcept") strText = "ItemCodeableConcept";

                else if (Text == "ActiveProblemsCategory") strText = "Category";
                else if (Text == "ActiveProblemsSeverity") strText = "Severity";
                else if (Text == "ActiveProblemsCode") strText = "Code";
                else if (Text == "ActiveProblemsBodySite") strText = "BodySite";
                else if (Text == "ActiveProblemsStageSummary") strText = "Summary";
                else if (Text == "ActiveProblemsEvidenceCode") strText = "Code";
                //Encounter
                else if (Text == "EncountersType") strText = "Type";
                else if (Text == "EncountersPriority") strText = "Priority";
                else if (Text == "EncountersParticipantType") strText = "Type";
                else if (Text == "EncountersReason") strText = "Reason";
                else if (Text == "EncountersDiagnosisRole") strText = "Role";
                else if (Text == "EncountersHospitalizationAdmitSource") strText = "AdmitSource";
                else if (Text == "EncountersHospitalizationReAdmission") strText = "ReAdmission";
                else if (Text == "EncountersHospitalizationDietPreference") strText = "DietPreference";
                else if (Text == "EncountersHospitalizationSpecialCourtesy") strText = "SpecialCourtesy";
                else if (Text == "EncountersHospitalizationSpecialArrangement") strText = "SpecialArrangement";
                else if (Text == "EncountersHospitalizationDischargeDisposition") strText = "DischargeDisposition";

                else if (Text == "ImmunizationVaccineCode") strText = "VaccineCode";
                else if (Text == "ImmunizationReportOrigin") strText = "ReportOrigin";
                else if (Text == "ImmunizationSite") strText = "Site";
                else if (Text == "ImmunizationRoute") strText = "Route";
                else if (Text == "ImmunizationPractitionerRole") strText = "Role";
                else if (Text == "ImmunizationExplanationReason") strText = "Reason";
                else if (Text == "ImmunizationExplanationReasonNotGiven") strText = "ReasonNotGiven";
                else if (Text == "ImmunizationVaccinationProtocolTargetDisease") strText = "TargetDisease";
                else if (Text == "ImmunizationVaccinationProtocolDoseStatus") strText = "DoseStatus";
                else if (Text == "ImmunizationVaccinationProtocolDoseStatusReason") strText = "DoseStatusReason";

                else if (Text == "SocialHistoryNotDoneReason") strText = "NotDoneReason";
                else if (Text == "SocialHistoryRelationship") strText = "Relationship";
                else if (Text == "SocialHistoryReasonCode") strText = "ReasonCode";
                else if (Text == "SocialHistoryConditionCode") strText = "Code";
                else if (Text == "SocialHistoryConditionOutcome") strText = "Outcome";

                else if (Text == "VitalSignsCategory") strText = "Category";
                else if (Text == "VitalSignsCode") strText = "Code";
                else if (Text == "VitalSignsDataAbsentReason") strText = "DataAbsentReason";
                else if (Text == "VitalSignsInterpretation") strText = "Interpretation";
                else if (Text == "VitalSignsBodySite") strText = "BodySite";
                else if (Text == "VitalSignsMethod") strText = "Method";

                else if (Text == "PlanOfTreatmentCategory") strText = "Category";
                else if (Text == "PlanOfTreatmentActivityOutcomeCodeableConcept") strText = "OutcomeCodeableConcept";
                else if (Text == "PlanOfTreatmentActivityDetailCategory") strText = "Category";
                else if (Text == "PlanOfTreatmentActivityDetailCode") strText = "Code";
                else if (Text == "PlanOfTreatmentActivityDetailReasonCode") strText = "ReasonCode";
                else if (Text == "PlanOfTreatmentActivityDetailProductCodeableConcept") strText = "ProductCodeableConcept";

                else if (Text == "GoalsCategory") strText = "Category";
                else if (Text == "GoalsPriority") strText = "Priority";
                else if (Text == "GoalsDescription") strText = "Description";
                else if (Text == "GoalsTargetMeasure") strText = "Measure";
                else if (Text == "GoalsOutcomeCode") strText = "OutcomeCode";

                else if (Text == "HistoryOfProceduresNotDoneReason") strText = "NotDoneReason";
                else if (Text == "HistoryOfProceduresCategory") strText = "Category";
                else if (Text == "HistoryOfProceduresCode") strText = "Code";
                else if (Text == "HistoryOfProceduresPerformerRole") strText = "Role";
                else if (Text == "HistoryOfProceduresReasonCode") strText = "ReasonCode";
                else if (Text == "HistoryOfProceduresBodySite") strText = "BodySite";
                else if (Text == "HistoryOfProceduresOutcome") strText = "Outcome";
                else if (Text == "HistoryOfProceduresComplication") strText = "Complication";
                else if (Text == "HistoryOfProceduresFollowUp") strText = "FollowUp";
                else if (Text == "HistoryOfProceduresFocalDeviceAction") strText = "Action";
                else if (Text == "HistoryOfProceduresUsedCode") strText = "UsedCode";

                else if (Text == "StudiesSummaryCategory") strText = "Category";
                else if (Text == "StudiesSummaryCode") strText = "Code";
                else if (Text == "StudiesSummaryDataAbsentReason") strText = "DataAbsentReason";
                else if (Text == "StudiesSummaryInterpretation") strText = "Interpretation";
                else if (Text == "StudiesSummaryBodySite") strText = "BodySite";
                else if (Text == "StudiesSummaryMethod") strText = "Method";
                else if (Text == "StudiesSummaryReferenceRangeType") strText = "Type";
                else if (Text == "StudiesSummaryReferenceRangeAppliesTo") strText = "AppliesTo";
                else if (Text == "StudiesSummaryComponentCode") strText = "Code";
                else if (Text == "StudiesSummaryComponentDataAbsentReason") strText = "DataAbsentReason";
                else if (Text == "StudiesSummaryComponentInterpretation") strText = "Interpretation";

                else if (Text == "LaboratoryTestsCategory") strText = "Category";
                else if (Text == "LaboratoryTestsCode") strText = "Code";
                else if (Text == "LaboratoryTestsPerformerRole") strText = "Role";
                else if (Text == "LaboratoryTestsCodedDiagnosis") strText = "Diagnosis";

                else if (Text == "CareTeamMembersCategory") strText = "Category";
                else if (Text == "CareTeamMembersParticipantRole") strText = "Role";
                else if (Text == "CareTeamMembersReasonCode") strText = "ReasonCode";

                else if (Text == "UniqueDeviceIdentifierType") strText = "Type";
                else if (Text == "UniqueDeviceIdentifierSafety") strText = "Safety";

                //Timing
                else if (Text == "TimingCode") strText = "Code";

                var json = Convert.ToString(@"[{""Text"":""" + strText + @"""} ]");
                _codeableConcept = JsonConvert.DeserializeObject<List<CodeableConceptModel>>(json).ToList();
                //_codeableConcept.ForEach(a => a.Coding = GetCoding(Id, Type, fromDate, toDate));

                return _codeableConcept;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetCodeableConcept method." + ex.Message);
                throw excep;
            }
        }
        public List<CodingModel> GetCoding(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetCodeableConcept(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;
                return JsonConvert.DeserializeObject<List<CodingModel>>(json).ToList();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetIdentifier method." + ex.Message);
                throw excep;
            }
        }
        public List<AttachmentModel> GetAttachment(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetAttachment(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<AttachmentModel> _attachment = new List<AttachmentModel>();
                _attachment = JsonConvert.DeserializeObject<List<AttachmentModel>>(json).ToList();

                return _attachment;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetTelecom method." + ex.Message);
                throw excep;
            }
        }
        public List<MetaDataModel> GetMetaData(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetMetaData(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<MetaDataModel> _meta = new List<MetaDataModel>();
                _meta = JsonConvert.DeserializeObject<List<MetaDataModel>>(json).ToList();


                List<CodingModel> _coding = new List<CodingModel>();
                _meta.ForEach(a => a.Security = GetCoding(Id, "MetaDataSecurity", Type, fromDate, toDate));
                _coding = GetCoding(Id, "MetaDataSecurity", Type, fromDate, toDate);
                int i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _meta[i].Security.Clear();
                        _meta[i].Security.Add(_code);
                        i = i + 1;
                    }
                }
                _meta.ForEach(a => a.Tag = GetCoding(Id, "MetaDataTag", Type, fromDate, toDate));
                _coding = GetCoding(Id, "MetaDataTag", Type, fromDate, toDate);
                i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _meta[i].Tag.Clear();
                        _meta[i].Tag.Add(_code);
                        i = i + 1;
                    }
                }
                return _meta;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetTelecom method." + ex.Message);
                throw excep;
            }
        }
        public List<AnnotationModel> GetAnnotation(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetAnnotation(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<AnnotationModel> _annotation = new List<AnnotationModel>();
                _annotation = JsonConvert.DeserializeObject<List<AnnotationModel>>(json).ToList();

                return _annotation;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetTelecom method." + ex.Message);
                throw excep;
            }
        }
        public List<TimingModel> GetTiming(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetTiming(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                List<TimingModel> _timing = new List<TimingModel>();
                List<CodingModel> _coding = new List<CodingModel>();
                _timing = JsonConvert.DeserializeObject<List<TimingModel>>(json).ToList();

                _timing.ForEach(a => a.Code = GetCodeableConcept(Id, "TimingCode", Type, fromDate, toDate));
                _timing.ForEach(a => a.Code.ForEach(b => b.Coding = GetCoding(Id, "TimingCode", Type, fromDate, toDate)));
                _coding = GetCoding(Id, "TimingCode", Type, fromDate, toDate);
                int i = 0;
                if (_coding != null)
                {
                    foreach (var _code in _coding)
                    {
                        _timing[i].Code[0].Coding.Clear();
                        _timing[i].Code[0].Coding.Add(_code);
                        i = i + 1;
                    }
                }

                return _timing;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetTelecom method." + ex.Message);
                throw excep;
            }
        }
        public List<QuantityModel> GetQuantity(int Id, string Text, string Type, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetQuantity(Id, Text, Type, fromDate, toDate, OutputParamter);
                var json = Convert.ToString(OutputParamter.Value);
                if (json == "" || json == null) return null;

                return JsonConvert.DeserializeObject<List<QuantityModel>>(json).ToList();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientRepositiry.GetQuantity method." + ex.Message);
                throw excep;
            }
        }

    }
}