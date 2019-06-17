using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SC.Api.Models
{

    [Serializable]
    public class PatientIdentifiers
    {
        public string SSN { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public DateTime? DOB { get; set; }
    }
    [Serializable]
    public class PatientIdentifier
    {
        [Required]
        public int Id { get; set; }

        [Required]
        public PatientType Type { get; set; }

        [Required]
        public DateTime FromDate { get; set; }

        [Required]
        public DateTime ToDate { get; set; }
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum PatientType
    {
        Inpatient = 0,
        Outpatient = 1
    }
    public class PatientDetailsModel
    {
        public List<PatientDemographicDetailsModel> PatientDemographicDetails { get; set; }
        public List<AllergiesModel> Allergies { get; set; }
        public List<CurrentMedicationsModel> CurrentMedications { get; set; }
        public List<ActiveProblemsModel> ActiveProblems { get; set; }
        public List<MostRecentEncountersModel> MostRecentEncounters { get; set; }
        public List<ImmunizationsModel> Immunizations { get; set; }
        public List<SocialHistoryModel> SocialHistory { get; set; }
        public List<VitalSignsModel> VitalSigns { get; set; }
        public List<PlanOfTreatmentModel> PlanOfTreatment { get; set; }
        public List<GoalsModel> Goals { get; set; }        
        public List<HistoryOfProceduresModel> HistoryOfProcedures { get; set; }
        public List<StudiesSummaryModel> StudiesSummary { get; set; }
        public List<LaboratoryTestsModel> LaboratoryTests { get; set; }
        public List<CareTeamMembersModel> CareTeamMembers { get; set; }
        public List<UDIModel> UniqueDeviceIdentifier { get; set; }
    }

   
    public class PatientDemographicDetailsModel
    {
       
        //public int Id { get; set; }
        public List<IdentifierModel> Identifier { get; set; }          //"identifier" : [{ Identifier }], // An identifier for this patient
        public string Active { get; set; }                              // "active" : <boolean>, // Whether this patient's record is in active use
        public List<HumanNameModel> Name { get; set; }
        public List<ContactPointModel> Telecom { get; set; }             // "telecom" : [{ ContactPoint }], // A contact detail for the individual
        public string Gender { get; set; }              //"gender" : "<code>", // male | female | other | unknown
        public DateTime BirthDate { get; set; }         // "birthDate" : "<date>", // The date of birth for the individual

        public string Race { get; set; }        //Note: Added as part of G8 Document
        public string Ethnicity { get; set; }    //Note: Added as part of G8 Document
        public string SmokingStatus { get; set; }    //Note: Added as part of G8 Document

        // deceased[x]: Indicates if the individual is deceased or not. One of these 2:
        //public string DeceasedBoolean { get; set; }             //"deceasedBoolean" : <boolean>,
        public string DeceasedDateTime { get; set; }            //"deceasedDateTime" : "<dateTime>",
        public List<AddressModel> Address { get; set; }                     //"address" : [{ Address }], // Addresses for the individual
        public List<CodeableConceptModel> MaritalStatus { get; set; }               //"maritalStatus" : { CodeableConcept }, // Marital (civil) status of a patient

        // multipleBirth[x]: Whether patient is part of a multiple birth. One of these 2:
        //public string MultipleBirthBoolean { get; set; }        //"multipleBirthBoolean" : <boolean>,
        public string MultipleBirthInteger { get; set; }        //"multipleBirthInteger" : <integer>,                                                           
        public List<AttachmentModel> Photo { get; set; }                       // "photo" : [{ Attachment }], // Image of the patient
        public List<ContactPersonModel> Contact { get; set; }         // "contact" : [{ // A contact party (e.g. guardian, partner, friend) for the patient
        public List<AnimalModel> Animal { get; set; }               //"animal" : { // This patient is known to be an animal (non-human)
        public List<CommunicationModel> Communication { get; set; }       // A list of Languages which may be used to communicate with the patient about his or her health
        public string GeneralPractitioner { get; set; }         //"generalPractitioner" : [{ Reference(Organization | Practitioner) }], // Patient's nominated primary care provider
        public string ManagingOrganization { get; set; }        //"managingOrganization" : { Reference(Organization) }, // Organization that is the custodian of the patient record
        public List<LinkModel> Link { get; set; }                   // "link" : [{ // Link to another patient resource that concerns the same actual person
    }

    public class LinkModel
    {
        //[JsonProperty(PropertyName = "Other")]
        public string Other { get; set; }

        //[JsonProperty(PropertyName = "Type")]
        public string Type { get; set; }
    }
        public class CommunicationModel
    {
        [JsonProperty(PropertyName = "Language")]
        public List<CodeableConceptModel> CommunicationLanguage { get; set; }       // A list of Languages which may be used to communicate with the patient about his or her health
        
        public string Preferred { get; set; }
    }

    public class AnimalModel
    {
        //[JsonProperty(PropertyName = "Species")]
        public List<CodeableConceptModel> Species { get; set; }               //"animal" : { // This patient is known to be an animal (non-human)

        //[JsonProperty(PropertyName = "Breed")]
        public List<CodeableConceptModel> Breed { get; set; }

        //[JsonProperty(PropertyName = "GenderStatus")]
        public List<CodeableConceptModel> GenderStatus { get; set; }
    }
    public class ContactPersonModel
    {
        public List<CodeableConceptModel> Relationship { get; set; }
        public List<HumanNameModel> Name { get; set; }
        public List<ContactPointModel> Telecom { get; set; }
        public List<AddressModel> Address { get; set; }
        public string Gender { get; set; }
        public string Organization { get; set; }
        public List<PeriodModel> Period { get; set; }
    }
     public class AddressModel
    {
        public string Use { get; set; }       //"use" : "<code>", // home | work | temp | old - purpose of this address
        public string Type { get; set; }      //"type" : "<code>", // postal | physical | both
        public string Text { get; set; }      //"text" : "<string>", // Text representation of the address
        public string Line { get; set; }      //"line" : ["<string>"], // Street name, number, direction & P.O. Box etc.
        public string City { get; set; }      //"city" : "<string>", // Name of city, town etc.
        public string District { get; set; }  //"district" : "<string>", // District name (aka county)
        public string State { get; set; }     //"state" : "<string>", // Sub-unit of country (abbreviations ok)
        public string PostalCode { get; set; }//"postalCode" : "<string>", // Postal code for area
        public string Country { get; set; }   //"country" : "<string>", // Country (e.g. can be ISO 3166 2 or 3 letter code)
        public List<PeriodModel> Period { get; set; }    //"period" : { Period } // Time period when address was/is in use
    }
      
    //***************** End Demographic ********************

    public class AllergiesModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }     //External ids for this item       
        public string ClinicalStatus { get; set; }// active | inactive | resolved
        public string VerificationStatus { get; set; }// unconfirmed | confirmed | refuted | entered-in-error
        public string Type { get; set; }// allergy | intolerance - Underlying mechanism(if known)
        public string Category { get; set; }//food | medication | environment | biologic
        public string Criticality { get; set; }   //low | high | unable-to-assess
        public List<CodeableConceptModel> Code { get; set; } //102002 	Hemoglobin Okaloosa
        public string Patient { get; set; }
        public DateTime? OnsetDateTime { get; set; }
        //public int OnsetAge { get; set; }
        //public List<PeriodModel> OnsetPeriod { get; set; }
        //public string OnsetRange { get; set; }
        //public string OnsetString { get; set; }
        public DateTime? AssertedDate { get; set; }
        public string Recorder { get; set; }
        public string Asserter { get; set; }
        public DateTime? LastOccurrence { get; set; }
        public List<AnnotationModel> Note { get; set; }
        public List<AllergiesReactionModel> Reaction { get; set; }   //102002 	Hemoglobin Okaloosa       
    }
    public class AllergiesReactionModel
    {
        //[JsonProperty(PropertyName = "Substance")]
        public List<CodeableConceptModel> Substance { get; set; }   //102002 	Hemoglobin Okaloosa

        //[JsonProperty(PropertyName = "Manifestation")]
        public List<CodeableConceptModel> Manifestation { get; set; } //122003 	Choroidal hemorrhage

        //[JsonProperty(PropertyName = "Description")]
        public string ReactionDescription { get; set; }

        //[JsonProperty(PropertyName = "Onset")]
        public DateTime? ReactionOnset { get; set; }

        //[JsonProperty(PropertyName = "Severity")]
        public string ReactionSeverity { get; set; }

        //[JsonProperty(PropertyName = "ExposureRoute")]
        public List<CodeableConceptModel> ExposureRoute { get; set; }

        [JsonProperty(PropertyName = "Note")]
        public List<AnnotationModel> ReactionNote { get; set; }
    }
    //****************End Allergies ***********************

    public class CurrentMedicationsModel
    {
        //public int ClientId { get; set; }
        public List<CodeableConceptModel> Code { get; set; }      
        public string Status { get; set; }
        public bool? IsBrand { get; set; }
        public bool? IsOverTheCounter { get; set; }
        public string Manufacturer { get; set; }
        public List<CodeableConceptModel> Form { get; set; }
        public List<CurrentMedicationsIngredientModel> Ingredient { get; set; }
        public List<CurrentMedicationsPackageModel> Package { get; set; }        
        public List<AttachmentModel> Image { get; set; }
    }
    public class CurrentMedicationsIngredientModel
    {
        //[JsonProperty(PropertyName = "ItemCodeableConcept")]
        public List<CodeableConceptModel> ItemCodeableConcept { get; set; }

        //[JsonProperty(PropertyName = "ItemReference")]
        //public string IngredientItemReference { get; set; }

        [JsonProperty(PropertyName = "IsActive")]
        public string IngredientIsActive { get; set; }

        [JsonProperty(PropertyName = "Amount")]
        public List<RatioModel> IngredientAmount { get; set; }
    }
    public class CurrentMedicationsPackageModel
    {
        //[JsonProperty(PropertyName = "Container")]
        public List<CodeableConceptModel> Container { get; set; }
        public List<CurrentMedicationsPackageContentModel> Content{ get; set; }
        public List<CurrentMedicationsPackageBatchModel> Batch { get; set; }
    }

    public class CurrentMedicationsPackageContentModel
    {
        [JsonProperty(PropertyName = "ItemCodeableConcept")]
        public List<CodeableConceptModel> ContentItemCodeableConcept { get; set; }

        //[JsonProperty(PropertyName = "ItemReference")]
        //public string PackageContentItemReference { get; set; }

        [JsonProperty(PropertyName = "Amount")]
        public List<QuantityModel> PackageContentAmount { get; set; }
    }
    public class CurrentMedicationsPackageBatchModel
    {
        [JsonProperty(PropertyName = "LotNumber")]
        public string PackageBatchLotNumber { get; set; }

        [JsonProperty(PropertyName = "ExpirationDate")]
        public string PackageBatchExpirationDate { get; set; }
    }
    //***************End Current medications ************************

    public class ActiveProblemsModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }        //External ids for this item
        public string ClinicalStatus { get; set; } // active | recurrence | inactive | remission | resolved
        public string VerificationStatus { get; set; } // provisional | differential | confirmed | refuted | entered-in-error | unknown
        public List<CodeableConceptModel> Category { get; set; }     //problem-list-item | encounter-diagnosis
        public List<CodeableConceptModel> Severity { get; set; } //24484000 	Severe
        public List<CodeableConceptModel> Code { get; set; }        //122003 	Choroidal hemorrhage
        public List<CodeableConceptModel> BodySite { get; set; }  //106004 	Posterior carpal region
        public string Subject { get; set; }
        public string Context { get; set; }
        //public string OnsetDateTime { get; set; }
        //public string OnsetAge { get; set; }
        public List<PeriodModel> OnsetPeriod { get; set; }
        //public string OnsetRange { get; set; }
        //public string OnsetString { get; set; }

        //public string AbatementDateTime { get; set; }
        //public string AbatementAge { get; set; }
        //public string AbatementBoolean { get; set; }
        public List<AbatementPeriodModel> AbatementPeriod { get; set; }
        //public string AbatementRange { get; set; }
        //public string AbatementString { get; set; }
        public string AssertedDate { get; set; }
        public string Asserter { get; set; }
        public List<ActiveProblemsStageModel> Stage { get; set; }
        public string StageAssessment { get; set; }
        public List<ActiveProblemsEvidenceModel> Evidence { get; set; }
        public List<AnnotationModel> Note { get; set; }
    }
    public class ActiveProblemsEvidenceModel
    {
        [JsonProperty(PropertyName = "Code")]
        public List<CodeableConceptModel> EvidenceCode { get; set; }

        //[JsonProperty(PropertyName = "Detail")]
        public string EvidenceDetail { get; set; }
    }

    public class ActiveProblemsStageModel
    {
        [JsonProperty(PropertyName = "Summary")]
        public List<CodeableConceptModel> StageSummary { get; set; }

        [JsonProperty(PropertyName = "Assessment")]
        public string StageAssessment { get; set; }
    }

    public class AbatementPeriodModel
    {
        public DateTime? Start { get; set; }     //"start" : "<dateTime>", // C? Starting time with inclusive boundary        
        public DateTime? End { get; set; }       //"end" : "<dateTime>" // C? End time with inclusive boundary, if not ongoing
    }
    //******************End of ActiveProblems ***********************

    public class MostRecentEncountersModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string Status { get; set; }              //planned | arrived | triaged | in-progress | onleave | finished | cancelled +
        public List<EncountersStatusHistoryModel> StatusHistory { get; set; } //planned | arrived | triaged | in-progress | onleave | finished | cancelled +
        public string Class { get; set; }              // inpatient | outpatient | ambulatory | emergency +
        public List<EncountersClassHistoryModel> ClassHistory { get; set; }  // inpatient | outpatient | ambulatory | emergency +
        public List<CodeableConceptModel> Type { get; set; }            //ADMS Annual diabetes mellitus screening			
        public List<CodeableConceptModel> Priority { get; set; }        //A ASAP    As soon as possible, next highest priority after stat.
        public string Subject { get; set; }         //The patient ro group present at the encounter
        public string EpisodeOfCare { get; set; }   //Episode(s) of care that this encounter should be recorded against
        public string IncomingReferral { get; set; }
        public List<EncountersParticipantModel> Participant { get; set; }
        public string Appointment { get; set; }
        public List<PeriodModel> Period { get; set; }
        public string Length { get; set; }
        public List<CodeableConceptModel> Reason { get; set; }
        public List<EncountersDiagnosisModel> Diagnosis { get; set; }
        public string Account { get; set; }
        public List<EncountersHospitalizationModel> Hospitalization { get; set; } //Details about the admission to a healthcare service
        public List<EncountersLocationModel> Location { get; set; }        //Location the encounter takes place
        public string ServiceProvider { get; set; }
        public string PartOf { get; set; }
    }
    public class EncountersStatusHistoryModel
    {
        [JsonProperty(PropertyName = "Status")]
        public string StatusHistoryStatus { get; set; } //planned | arrived | triaged | in-progress | onleave | finished | cancelled +

        [JsonProperty(PropertyName = "Period")]
        public List<EncountersStatusHistoryPeriodModel> StatusHistoryPeriod { get; set; }        //The time that the episode was in the specified status
    }
    public class EncountersClassHistoryModel
    {
        [JsonProperty(PropertyName = "Class")]
        public string ClassHistoryClass { get; set; } //planned | arrived | triaged | in-progress | onleave | finished | cancelled +

        [JsonProperty(PropertyName = "Period")]
        public List<EncountersClassHistoryPeriodModel> ClassHistoryPeriod { get; set; }        //The time that the episode was in the specified status
    }

    public class EncountersParticipantModel
    {
        [JsonProperty(PropertyName = "Type")]
        public List<CodeableConceptModel> ParticipantType { get; set; }

        [JsonProperty(PropertyName = "Period")]
        public List<EncountersParticipantPeriodModel> ParticipantPeriod { get; set; }

        //[JsonProperty(PropertyName = "Individual")]
        public string ParticipantIndividual { get; set; }
    }
    public class EncountersDiagnosisModel
    {
        [JsonProperty(PropertyName = "Condition")]
        public string DiagnosisCondition { get; set; }

        [JsonProperty(PropertyName = "Role")]
        public List<CodeableConceptModel> DiagnosisRole { get; set; }

        [JsonProperty(PropertyName = "Rank")]
        public string DiagnosisRank { get; set; }
    }
    public class EncountersHospitalizationModel
    {
        [JsonProperty(PropertyName = "PreAdmissionIdentifier")]
        public string HospitalizationPreAdmissionIdentifier { get; set; } //Details about the admission to a healthcare service

        //[JsonProperty(PropertyName = "Origin")]
        public string HospitalizationOrigin { get; set; }

        [JsonProperty(PropertyName = "AdmitSource")]
        public List<CodeableConceptModel> HospitalizationAdmitSource { get; set; } //hosp-trans Transferred from other hospital

        [JsonProperty(PropertyName = "ReAdmission")]
        public List<CodeableConceptModel> HospitalizationReAdmission { get; set; }          //R Re-admission

        [JsonProperty(PropertyName = "DietPreference")]
        public List<CodeableConceptModel> HospitalizationDietPreference { get; set; }       //vegetarian Vegetarian

        [JsonProperty(PropertyName = "SpecialCourtesy")]
        public List<CodeableConceptModel> HospitalizationSpecialCourtesy { get; set; }     //EXT extended courtesy

        [JsonProperty(PropertyName = "SpecialArrangement")]
        public List<CodeableConceptModel> HospitalizationSpecialArrangement { get; set; }  //wheel Wheelchair

        [JsonProperty(PropertyName = "Destination")]
        public string HospitalizationDestination { get; set; }

        [JsonProperty(PropertyName = "DischargeDisposition")]
        public List<CodeableConceptModel> HospitalizationDischargeDisposition { get; set; } //home Home
    }
    public class EncountersLocationModel
    {
        //[JsonProperty(PropertyName = "Location")]
        public string LocationLocation { get; set; }        //Location the encounter takes place

        [JsonProperty(PropertyName = "Status")]
        public string LocationStatus { get; set; }  // planned | active | reserved | completed

        [JsonProperty(PropertyName = "Period")]
        public List<EncountersLocationPeriodModel> LocationPeriod { get; set; }
    }
    public class EncountersStatusHistoryPeriodModel
    {
        //[JsonProperty(PropertyName = "Start")]
        public string StatusHistoryPeriodStart { get; set; }        //Location the encounter takes place

        //[JsonProperty(PropertyName = "End")]
        public string StatusHistoryPeriodEnd { get; set; }  // planned | active | reserved | completed
    }
    public class EncountersClassHistoryPeriodModel
    {
        //[JsonProperty(PropertyName = "Start")]
        public string ClassHistoryPeriodStart { get; set; }        //Location the encounter takes place

        //[JsonProperty(PropertyName = "End")]
        public string ClassHistoryPeriodEnd { get; set; }  // planned | active | reserved | completed
    }
    public class EncountersParticipantPeriodModel
    {
        //[JsonProperty(PropertyName = "Start")]
        public string ParticipantPeriodStart { get; set; }        //Location the encounter takes place

        //[JsonProperty(PropertyName = "End")]
        public string ParticipantPeriodEnd { get; set; }  // planned | active | reserved | completed
    }
    public class EncountersLocationPeriodModel
    {
        //[JsonProperty(PropertyName = "Start")]
        public string LocationPeriodStart { get; set; }        //Location the encounter takes place

        //[JsonProperty(PropertyName = "End")]
        public string LocationPeriodEnd { get; set; }  // planned | active | reserved | completed
    }
    //******************End of Encounters ***********************
    
    public class ImmunizationsModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string Status { get; set; }       //completed | entered-in-error
        public string NotGiven { get; set; }
        public List<CodeableConceptModel> VaccineCode { get; set; } //01 DTP
        public string Patient { get; set; }
        public string Encounter { get; set; }
        public string Date { get; set; }
        public string PrimarySource { get; set; }
        public List<CodeableConceptModel> ReportOrigin { get; set; }    //provider Other Provider
        public string Location { get; set; }
        public string Manufacturer { get; set; }
        public string LotNumber { get; set; }
        public string ExpirationDate { get; set; }
        public List<CodeableConceptModel> Site { get; set; }        //LA Left arm
        public List<CodeableConceptModel> Route { get; set; }   //IM Injection, intramuscular
        public List<QuantityModel> DoseQuantity { get; set; }            
        public List<ImmunizationsPractitionerModel> Practitioner { get; set; }    //OP Ordering Provider
        public List<AnnotationModel> Note { get; set; }
        public List<ImmunizationsExplanationModel> Explanation { get; set; } //429060002 	Procedure to meet occupational requirement
        public List<ImmunizationsReactionModel> Reaction { get; set; }
        public List<ImmunizationsVaccinationProtocolModel> VaccinationProtocol { get; set; } //What protocol was followed
    }    
    public class ImmunizationsPractitionerModel
    {
        [JsonProperty(PropertyName = "Role")]
        public List<CodeableConceptModel> PractitionerRole { get; set; }    //OP Ordering Provider

        [JsonProperty(PropertyName = "Actor")]
        public string PractitionerActor { get; set; }
    }
    public class ImmunizationsExplanationModel
    {
        [JsonProperty(PropertyName = "Reason")]
        public List<CodeableConceptModel> ExplanationReason { get; set; } //429060002 	Procedure to meet occupational requirement

        [JsonProperty(PropertyName = "ReasonNotGiven")]
        public List<CodeableConceptModel> ExplanationReasonNotGiven { get; set; }   //IMMUNE immunity
    }
    public class ImmunizationsReactionModel
    {
        [JsonProperty(PropertyName = "Date")]
        public string ReactionDate { get; set; }

        [JsonProperty(PropertyName = "Detail")]
        public string ReactionDetail { get; set; }

        [JsonProperty(PropertyName = "Reported")]
        public string ReactionReported { get; set; }
    }
    public class ImmunizationsVaccinationProtocolModel
    {
        //[JsonProperty(PropertyName = "DoseSequence")]
        public string VaccinationProtocolDoseSequence { get; set; } //What protocol was followed

        //[JsonProperty(PropertyName = "Description ")]
        public string VaccinationProtocolDescription { get; set; }

        [JsonProperty(PropertyName = "Authority ")]
        public string VaccinationProtocolAuthority { get; set; }

        //[JsonProperty(PropertyName = "Series")]
        public string VaccinationProtocolSeries { get; set; }

        //[JsonProperty(PropertyName = "SeriesDoses")]
        public string VaccinationProtocolSeriesDoses { get; set; }

        [JsonProperty(PropertyName = "TargetDisease")]
        public List<CodeableConceptModel> VaccinationProtocolTargetDisease { get; set; }    //1857005 	Gestational rubella syndrome

        [JsonProperty(PropertyName = "DoseStatus")]
        public List<CodeableConceptModel> VaccinationProtocolDoseStatus { get; set; }   //count Counts

        [JsonProperty(PropertyName = "DoseStatusReason")]
        public List<CodeableConceptModel> VaccinationProtocolDoseStatusReason { get; set; } //advstorage Adverse storage condition
    }
    //******************End of Immunizations***********************

    public class SocialHistoryModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string Definition { get; set; }
        public string Status { get; set; }	//partial | completed | entered-in-error | health-unknown
        public string NotDone { get; set; }		//The taking of a family member's history did not occur
        public List<CodeableConceptModel> NotDoneReason { get; set; }	//subject-unknown Subject Unknown  
        public string Patient { get; set; }
        public string Date { get; set; }
        public string Name { get; set; }
        public List<CodeableConceptModel> Relationship { get; set; } //FAMMEMB family member			
        public string Gender { get; set; } // male | female | other | unknown		
        //public string BornPeriod { get; set; }
        public string BornDate { get; set; }
        //public string BornString { get; set; }
        public string AgeAge { get; set; }
        //public string AgeRange { get; set; }
        //public string AgeString { get; set; }
        public string EstimatedAge { get; set; }
        //public string DeceasedBoolean { get; set; }
        public string DeceasedAge { get; set; }
        //public string DeceasedRange { get; set; }
        //public string DeceasedDate { get; set; }
        //public string DeceasedString { get; set; }
        public List<CodeableConceptModel> ReasonCode { get; set; }	        //109006 	Anxiety disorder of childhood OR adolescence
        public string ReasonReference { get; set; }
        public List<AnnotationModel> Note { get; set; }
        public List<SocialHistoryConditionModel> Condition { get; set; }
    }
    public class SocialHistoryConditionModel
    {
        [JsonProperty(PropertyName = "Code")]
        public List<CodeableConceptModel> ConditionCode { get; set; }		  //109006 	Anxiety disorder of childhood OR adolescence

        [JsonProperty(PropertyName = "Outcome")]
        public List<CodeableConceptModel> ConditionOutcome { get; set; }       //109006 	Anxiety disorder of childhood OR adolescence

        [JsonProperty(PropertyName = "OnsetAge")]
        public string ConditionOnsetAge { get; set; }

        //[JsonProperty(PropertyName = "OnsetRange")]
        //public string ConditionOnsetRange { get; set; }

        //[JsonProperty(PropertyName = "OnsetPeriod")]
        //public string ConditionOnsetPeriod { get; set; }

        //[JsonProperty(PropertyName = "OnsetString")]
        //public string ConditionOnsetString { get; set; }

        [JsonProperty(PropertyName = "Note")]
        public List<AnnotationModel> ConditionNote { get; set; }
    }
    //******************End of SocialHistory***********************
    
    public class VitalSignsModel
    {
        public List<IdentifierModel> Identifier { get; set; }
        public string Definition { get; set; }
        public string BasedOn { get; set; }
        public string Replaces { get; set; }
        public List<IdentifierModel> Requisition { get; set; } //Identifier
        public string Status { get; set; }
        public string Intent { get; set; }
        public string Priority { get; set; }
        public bool? DoNotPerform { get; set; }
        public List<CodeableConceptModel> Category { get; set; }    //CodeableConcept
        public List<CodeableConceptModel> Code { get; set; }        //CodeableConcept
        public string Subject { get; set; }
        public string Context { get; set; }
        public DateTime? OccurrenceDateTime { get; set; } // occurrence[x]: When procedure should occur. One of these 3:
        //public string OccurrencePeriod { get; set; }
        //public string OccurrenceTiming { get; set; }
        public bool? asNeededBoolean { get; set; } //asNeeded[x]: Preconditions for procedure or diagnostic. One of these 2:
        //public string asNeededCodeableConcept { get; set; } //CodeableConcept
        public DateTime? AuthoredOn { get; set; }
        public List<VitalSignsRequesterModel> Requester { get; set; }
        public List<CodeableConceptModel> PerformerType { get; set; }   //CodeableConcept
        public List<CodeableConceptModel> ReasonCode { get; set; }  //CodeableConcept
        public string ReasonReference { get; set; }
        public string SupportingInfo { get; set; }
        public string Specimen { get; set; }
        public List<CodeableConceptModel> BodySite { get; set; }    //CodeableConcept
        public List<AnnotationModel> Note { get; set; }    //Annotation
        public string RelevantHistory { get; set; }
    }
    public class VitalSignsRequesterModel
    {
        [JsonProperty(PropertyName = "Agent")]
        public string RequesterAgent { get; set; }

        [JsonProperty(PropertyName = "OnBehalfOf")]
        public string RequesterOnBehalfOf { get; set; }
    }   

    public class PlanOfTreatmentModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string Definition { get; set; }
        public string BasedOn { get; set; }
        public string Replaces { get; set; }
        public string PartOf { get; set; }
        public string Status { get; set; }//draft | active | suspended | completed | entered-in-error | cancelled | unknown
        public string Intent { get; set; }
        public List<CodeableConceptModel> Category { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Subject { get; set; }
        public string Context { get; set; }
        public List<PeriodModel> Period { get; set; }
        public string Author { get; set; }
        public string CareTeam { get; set; }
        public string Addresses { get; set; }
        public string SupportingInfo { get; set; }
        public string Goal { get; set; }
        public List<PlanOfTreatmentActivityModel> Activity { get; set; }
        public List<AnnotationModel> Note { get; set; }
    }
    public class PlanOfTreatmentActivityModel
    {
        [JsonProperty(PropertyName = "OutcomeCodeableConcept")]
        public List<CodeableConceptModel> ActivityOutcomeCodeableConcept { get; set; }	//54777007 	Deficient knowledge

        [JsonProperty(PropertyName = "OutcomeReference")]
        public string ActivityOutcomeReference { get; set; }

        [JsonProperty(PropertyName = "Progress")]
        public List<AnnotationModel> ActivityProgress { get; set; }

        [JsonProperty(PropertyName = "Reference")]
        public string ActivityReference { get; set; }
        public List<PlanOfTreatmentActivityDetailModel> Detail { get; set; }
    }
    public class PlanOfTreatmentActivityDetailModel
    {
        [JsonProperty(PropertyName = "Category")]
        public List<CodeableConceptModel> ActivityDetailCategory { get; set; }//diet | drug | encounter | observation | procedure | supply | other

        [JsonProperty(PropertyName = "Definition")]
        public string ActivityDetailDefinition { get; set; }

        [JsonProperty(PropertyName = "Code")]
        public List<CodeableConceptModel> ActivityDetailCode { get; set; }  //104001 	Excision of lesion of patella

        [JsonProperty(PropertyName = "ReasonCode")]
        public List<CodeableConceptModel> ActivityDetailReasonCode { get; set; } //109006 	Anxiety disorder of childhood OR adolescence

        [JsonProperty(PropertyName = "ReasonReference")]
        public string ActivityDetailReasonReference { get; set; }

        [JsonProperty(PropertyName = "Goal")]
        public string ActivityDetailGoal { get; set; }

        [JsonProperty(PropertyName = "Status")]
        public string ActivityDetailStatus { get; set; }//not-started | scheduled | in-progress | on-hold | completed | cancelled | unknown

        //[JsonProperty(PropertyName = "StatusReason")]
        public string ActivityDetailStatusReason { get; set; }

        //[JsonProperty(PropertyName = "Prohibited")]
        public string ActivityDetailProhibited { get; set; }

        [JsonProperty(PropertyName = "ScheduledTiming")]
        public List<TimingModel> ActivityDetailScheduledTiming { get; set; }

        //[JsonProperty(PropertyName = "ScheduledPeriod")]
        //public string ActivityDetailScheduledPeriod { get; set; }

        //[JsonProperty(PropertyName = "ScheduledString")]
        //public string ActivityDetailScheduledString { get; set; }

        //[JsonProperty(PropertyName = "Location")]
        public string ActivityDetailLocation { get; set; }

        //[JsonProperty(PropertyName = "Performer")]
        public string ActivityDetailPerformer { get; set; }

        [JsonProperty(PropertyName = "ProductCodeableConcept")]
        public List<CodeableConceptModel> ActivityDetailProductCodeableConcept { get; set; }

        //[JsonProperty(PropertyName = "ProductReference")]
        //public string ActivityDetailProductReference { get; set; }

        [JsonProperty(PropertyName = "DailyAmount")]
        public List<QuantityModel> ActivityDetailDailyAmount { get; set; }

        [JsonProperty(PropertyName = "Quantity")]
        public List<QuantityModel> ActivityDetailQuantity { get; set; }

        [JsonProperty(PropertyName = "Description")]
        public string ActivityDetailDescription { get; set; }
    }
    //******************End of PlanOfTreatment***********************

    public class GoalsModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string Status { get; set; } //proposed | accepted | planned | in-progress | on-target | ahead-of-target | behind-target | sustaining | achieved | on-hold | cancelled | entered-in-error | rejected
        public List<CodeableConceptModel> Category { get; set; }    //dietary Dietary
        public List<CodeableConceptModel> Priority { get; set; }    //high-priority High Priority
        public List<CodeableConceptModel> Description { get; set; } //109006 	Anxiety disorder of childhood OR adolescence
        public string Subject { get; set; }
        public string StartDate { get; set; }
        //public string StartCodeableConcept { get; set; }
        public List<GoalsTargetModel> Target { get; set; }	
        public string StatusDate { get; set; }
        public string StatusReason { get; set; }
        public string ExpressedBy { get; set; }
        public string Addresses { get; set; }
        public List<AnnotationModel> Note { get; set; }
        public List<CodeableConceptModel> OutcomeCode { get; set; }	//109006 	Anxiety disorder of childhood OR adolescence
        public string OutcomeReference { get; set; }
    }
        public class GoalsTargetModel
    {
        [JsonProperty(PropertyName = "Measure")]
        public List<CodeableConceptModel> TargetMeasure { get; set; }	//1-8 	Acyclovir[Susceptibility]

        [JsonProperty(PropertyName = "DetailQuantity")]
        public List<QuantityModel> TargetDetailQuantity { get; set; }

        //[JsonProperty(PropertyName = "DetailRange")]
        //public List<RangeModel> TargetDetailRange { get; set; }

        //[JsonProperty(PropertyName = "DetailCodeableConcept")]
        //public string TargetDetailCodeableConcept { get; set; }

        [JsonProperty(PropertyName = "DueDate")]
        public string TargetDueDate { get; set; }

        //[JsonProperty(PropertyName = "DueDuration")]
        //public string TargetDueDuration { get; set; }
    }
    //******************End of Goals***********************

    public class HistoryOfProceduresModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string Definition { get; set; }
        public string BasedOn { get; set; }
        public string PartOf { get; set; }
        public string Status { get; set; }	        //preparation | in-progress | suspended | aborted | completed | entered-in-error | unknown
        public string NotDone { get; set; }		    //True if procedure was not performed as scheduled
        public List<CodeableConceptModel> NotDoneReason { get; set; }	//135809002 	Nitrate contraindicated
        public List<CodeableConceptModel> Category { get; set; }        //24642003 	Psychiatry procedure or service
        public List<CodeableConceptModel> Code { get; set; }	        //104001 	Excision of lesion of patella						
        public string Subject { get; set; }
        public string Context { get; set; }
        //public string PerformedDateTime { get; set; }
        public List<PeriodModel> PerformedPeriod { get; set; }
        public List<HistoryOfProceduresPerformerModel> Performer { get; set; }
        public string Location { get; set; }
        public List<CodeableConceptModel> ReasonCode { get; set; }	 //109006 	Anxiety disorder of childhood OR adolescence
        public string ReasonReference { get; set; }
        public List<CodeableConceptModel> BodySite { get; set; }	 //106004 	Posterior carpal region
        public List<CodeableConceptModel> Outcome { get; set; }      //385669000 	Successful	
        public string Report { get; set; }
        public List<CodeableConceptModel> Complication { get; set; }
        public string ComplicationDetail { get; set; }
        public List<CodeableConceptModel> FollowUp { get; set; }
        public List<AnnotationModel> Note { get; set; }
        public List<HistoryOfProceduresFocalDeviceModel> FocalDevice { get; set; } 
        public string UsedReference { get; set; }
        public List<CodeableConceptModel> UsedCode { get; set; } //156009 	Spine board
    }
    public class HistoryOfProceduresPerformerModel
    {
        [JsonProperty(PropertyName = "Role")]
        public List<CodeableConceptModel> PerformerRole { get; set; }//1421009 	Specialized surgeon

        [JsonProperty(PropertyName = "Actor")]
        public string PerformerActor { get; set; }
        
        public string OnBehalfOf { get; set; }
    }
    public class HistoryOfProceduresFocalDeviceModel
    {
        [JsonProperty(PropertyName = "Action")]
        public List<CodeableConceptModel> FocalDeviceAction { get; set; } //129265001 	Evaluation - action	

        [JsonProperty(PropertyName = "Manipulated")]
        public string FocalDeviceManipulated { get; set; }
    }
    //******************End of HistoryOfProcedures***********************

    public class StudiesSummaryModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string BasedOn { get; set; } //Reference(CarePlan|DeviceRequest|ImmunizationRecommendation|MedicationRequest|NutritionOrder|ProcedureRequest|ReferralRequest)
        public string Status { get; set; } //registered | preliminary | final | amended +	
        public List<CodeableConceptModel> Category { get; set; }//social-history Social History			
        public List<CodeableConceptModel> Code { get; set; } // 1-8 	Acyclovir[Susceptibility]
        public string Subject { get; set; }
        public string Context { get; set; }
        //public string EffectiveDateTime { get; set; }
        public List<PeriodModel> EffectivePeriod { get; set; }
        public string Issued { get; set; }
        public string Performer { get; set; }
        //public string ValueQuantity { get; set; }
        //public string ValueCodeableConcept { get; set; }
        //public string ValueString { get; set; }
        //public string ValueBoolean { get; set; }
        //public string ValueRange { get; set; }
        //public string ValueRatio { get; set; }
        //public string ValueSampledData { get; set; }
        //public string ValueAttachment { get; set; }
        //public string ValueTime { get; set; }
        //public string ValueDateTime { get; set; }
        public List<ValuePeriodModel> ValuePeriod { get; set; }
        public List<CodeableConceptModel> DataAbsentReason { get; set; } //asked Asked
        public List<CodeableConceptModel> Interpretation { get; set; }		 //	<	Off scale low
        public string Comment { get; set; }
        public List<CodeableConceptModel> BodySite { get; set; }//106004 	Posterior carpal region
        public List<CodeableConceptModel> Method { get; set; }	//58207001 	Competitive protein binding assay
        public string Specimen { get; set; }
        public string Device { get; set; }
        public List<StudiesSummaryReferenceRangeModel> ReferenceRange { get; set; }
        public List<StudiesSummaryRelatedModel> Related { get; set; }
        public List<StudiesSummaryComponentModel> Component { get; set; }
    }
    public class StudiesSummaryReferenceRangeModel
    {
        [JsonProperty(PropertyName = "Low")]
        public List<QuantityModel> ReferenceRangeLow { get; set; }

        [JsonProperty(PropertyName = "High")]
        public List<QuantityModel> ReferenceRangeHigh { get; set; }

        [JsonProperty(PropertyName = "Type")]
        public List<CodeableConceptModel> ReferenceRangeType { get; set; }

        [JsonProperty(PropertyName = "AppliesTo")]
        public List<CodeableConceptModel> ReferenceRangeAppliesTo { get; set; }

        [JsonProperty(PropertyName = "Age")]
        public List<RangeModel> ReferenceRangeAge { get; set; }

        [JsonProperty(PropertyName = "Text")]
        public string ReferenceRangeTest { get; set; }
    }
    public class StudiesSummaryRelatedModel
    {
        [JsonProperty(PropertyName = "Type")]
        public string RelatedType { get; set; }

        [JsonProperty(PropertyName = "Target")]
        public string RelatedTarget { get; set; }
    }
    public class StudiesSummaryComponentModel
    {
        [JsonProperty(PropertyName = "Code")]
        public List<CodeableConceptModel> ComponentCode { get; set; }//1-8 	Acyclovir[Susceptibility]

        //[JsonProperty(PropertyName = "ValueQuantity")]
        //public string ComponentValueQuantity { get; set; }

        //[JsonProperty(PropertyName = "ValueCodeableConcept")]
        //public string ComponentValueCodeableConcept { get; set; }

        //[JsonProperty(PropertyName = "ValueString")]
        //public string ComponentValueString { get; set; }

        //[JsonProperty(PropertyName = "ValueRange")]
        //public string ComponentValueRange { get; set; }

        //[JsonProperty(PropertyName = "ValueRatio")]
        //public string ComponentValueRatio { get; set; }

        //[JsonProperty(PropertyName = "ValueSampledData")]
        //public string ComponentValueSampledData { get; set; }

        //[JsonProperty(PropertyName = "ValueAttachment")]
        //public string ComponentValueAttachment { get; set; }

        //[JsonProperty(PropertyName = "ValueTime")]
        //public string ComponentValueTime { get; set; }

        //[JsonProperty(PropertyName = "ValueDateTime")]
        //public string ComponentValueDateTime { get; set; }

        [JsonProperty(PropertyName = "ValuePeriod")]
        public List<ComponentValuePeriodModel> ComponentValuePeriod { get; set; }

        [JsonProperty(PropertyName = "DataAbsentReason")]
        public List<CodeableConceptModel> ComponentDataAbsentReason { get; set; }

        [JsonProperty(PropertyName = "Interpretation")]
        public List<CodeableConceptModel> ComponentInterpretation { get; set; }

        [JsonProperty(PropertyName = "ReferenceRange")]
        public string ComponentReferenceRange { get; set; }
    }
    public class ValuePeriodModel
    {
        [JsonProperty(PropertyName = "Start")]
        public DateTime? ValuePeriodStart { get; set; }     //"start" : "<dateTime>", // C? Starting time with inclusive boundary        

        [JsonProperty(PropertyName = "End")]
        public DateTime? ValuePeriodEnd { get; set; }       //"end" : "<dateTime>" // C? End time with inclusive boundary, if not ongoing
    }
    public class ComponentValuePeriodModel
    {
        [JsonProperty(PropertyName = "Start")]
        public DateTime? ComponentValuePeriodStart { get; set; }     //"start" : "<dateTime>", // C? Starting time with inclusive boundary        

        [JsonProperty(PropertyName = "End")]
        public DateTime? ComponentValuePeriodEnd { get; set; }       //"end" : "<dateTime>" // C? End time with inclusive boundary, if not ongoing
    }
    //******************End of StudiesSummary***********************    

    public class LaboratoryTestsModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string BasedOn { get; set; }
        public string Status { get; set; }
        public List<CodeableConceptModel> Category { get; set; }
        public List<CodeableConceptModel> Code { get; set; }
        public string Subject { get; set; }
        public string Context { get; set; }
        public string EffectiveDateTime { get; set; }
        //public string EffectivePeriod { get; set; }
        public string Issued { get; set; }
        public List<LaboratoryTestsPerformerModel> Performer { get; set; }
        public string Specimen { get; set; }
        public string Result { get; set; }
        public List<LaboratoryTestsImagingModel> Imaging { get; set; }
        public string Conclusion { get; set; }
        public List<CodeableConceptModel> CodedDiagnosis { get; set; }
        public List<AttachmentModel> PresentedForm { get; set; }
    }
    public class LaboratoryTestsPerformerModel
    {
        [JsonProperty(PropertyName = "Role")]
        public List<CodeableConceptModel> PerformerRole { get; set; }

        [JsonProperty(PropertyName = "Actor")]
        public string PerformerActor { get; set; }
    }
    public class LaboratoryTestsImagingModel
    {
        [JsonProperty(PropertyName = "Study")]
        public string ImagingStudy { get; set; }

        [JsonProperty(PropertyName = "Comment")]
        public string ImageComment { get; set; }

        [JsonProperty(PropertyName = "Link")]
        public string ImageLink { get; set; }
    }
    //******************End of LaboratoryTests***********************
    
    public class CareTeamMembersModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public string Status { get; set; }
        public List<CodeableConceptModel> Category { get; set; }
        public string Name { get; set; }
        public string Subject { get; set; }
        public string Context { get; set; }
        public List<PeriodModel> Period { get; set; }
        public List<CareTeamMembersParticipantModel> Participant { get; set; }
        public List<CodeableConceptModel> ReasonCode { get; set; }
        public string ReasonReference { get; set; }
        public string ManagingOrganization { get; set; }
        public List<AnnotationModel> Note { get; set; }
    }
    public class CareTeamMembersParticipantModel
    {
        [JsonProperty(PropertyName = "Role")]
        public List<CodeableConceptModel> ParticipantRole { get; set; }

        [JsonProperty(PropertyName = "Member")]
        public string ParticipantMember { get; set; }

        [JsonProperty(PropertyName = "OnBehalfOf")]
        public string ParticipantOnBehalfOf { get; set; }

        [JsonProperty(PropertyName = "Period")]
        public List<ParticipantPeriodModel> ParticipantPeriod { get; set; }
    }

    public class ParticipantPeriodModel
    {
        [JsonProperty(PropertyName = "Start")]
        public DateTime? ParticipantPeriodStart { get; set; }     //"start" : "<dateTime>", // C? Starting time with inclusive boundary    

        [JsonProperty(PropertyName = "End")]
        public DateTime? ParticipantPeriodEnd { get; set; }       //"end" : "<dateTime>" // C? End time with inclusive boundary, if not ongoing
    }
    //******************End of CareTeamMembers***********************

    public class UDIModel
    {
        //public int ClientId { get; set; }
        public List<IdentifierModel> Identifier { get; set; }
        public List<UDIIdentifierModel> Udi { get; set; }
        public string Status { get; set; }
        public List<CodeableConceptModel> Type { get; set; }
        public string LotNumber { get; set; }
        public string Manufacturer { get; set; }
        public string ManufactureDate { get; set; }
        public string ExpirationDate { get; set; }
        public string Model { get; set; }
        public string Version { get; set; }
        public string Patient { get; set; }
        public string Owner { get; set; }
        public List<ContactPointModel> Contact { get; set; }
        public string Location { get; set; }
        public string Url { get; set; }
        public List<AnnotationModel> Note { get; set; }
        public List<CodeableConceptModel> Safety { get; set; }
    }
    public class UDIIdentifierModel
    {
        //[JsonProperty(PropertyName = "DeviceIdentifier")]
        public string UdiDeviceIdentifier { get; set; }

        //[JsonProperty(PropertyName = "Name")]
        public string UdiName { get; set; }

        //[JsonProperty(PropertyName = "Jurisdiction")]
        public string UdiJurisdiction { get; set; }

        //[JsonProperty(PropertyName = "CarrierHRF")]
        public string UdiCarrierHRF { get; set; }

        //[JsonProperty(PropertyName = "ArrierAIDC")]
        public string UdiArrierAIDC { get; set; }

        //[JsonProperty(PropertyName = "Issuer")]
        public string UdiIssuer { get; set; }

        //[JsonProperty(PropertyName = "EntryType")]
        public string UdiEntryType { get; set; }
    }
    //******************End of UDI***********************

    public class HealthConcernsModel
    {
        public List<CompHeathConcernsModel> component { get; set; }
    }
    public class CompHeathConcernsModel
    {
        public List<SectionModel> section { get; set; }
    }
    public class SectionModel
    {
        public List<TemplateIdModel> templateId { get; set; }
        public List<CodeModel> code { get; set; }
        public List<EntryModel> entry { get; set; }
    }

    public class TemplateIdModel
    {
        public string _root { get; set; }
        public string _extension { get; set; }
    }
    public class CodeModel
    {
        public string _code { get; set; }
        public string _displayName { get; set; }
        public string _codeSystem { get; set; }
        public string _codeSystemName { get; set; }
    }

    public class EntryModel
    {
        public List<ObservationModel> observation  { get; set; }

    }

    public class ObservationModel
    {
        public List<TemplateIdEntryModel> templateId { get; set; }
        public List<IdEntryModel> Id { get; set; }
        public List<CodeEntryModel> code { get; set; }
        public List<StatusCodeEntryModel> statusCode { get; set; }
        public string _classCode { get; set; }
        public string _moodCode { get; set; }
    }
    public class TemplateIdEntryModel
    {
        public string _root { get; set; }
        public string _extension { get; set; }
    }
    public class IdEntryModel
    {
        public string _root { get; set; }
    }
    public class CodeEntryModel
    {
        public string _code { get; set; }
        public string _codeSystem { get; set; }
        public string _codeSystemName { get; set; }
        public string _displayName { get; set; }
    }
    public class StatusCodeEntryModel
{
        public string _code { get; set; }
}

//########################### Common Models Start #########################################    
	public class IdentifierModel
    {
        public string Use { get; set; }      //"use" : "<code>", // usual | official | temp | secondary (If known)
        public string Type { get; set; }     //"type" : { CodeableConcept }, // Description of identifier
        public string System { get; set; }   //"system" : "<uri>", // The namespace for the identifier value
        public string Value { get; set; }    //"value" : "<string>", // The value that is unique
        public List<PeriodModel> Period { get; set; }   //"period" : { Period}, // Time period when id is/was valid for use       
        public string Assigner { get; set; } //"assigner" : { Reference(Organization) } // Organization that issued id (may be just text)
    }
            
    public class HumanNameModel
    {
        //public string Patient_HumanName { get; set; }         //"resourceType" : "HumanName",  // from Element: extension
        public string Use { get; set; }       //"use" : "<code>", // usual | official | temp | nickname | anonymous | old | maiden
        public string Text { get; set; }      //"text" : "<string>", // Text representation of the full name
        public string Family { get; set; }    //"family" : "<string>", // Family name (often called 'Surname')
        public string Given { get; set; }     //"given" : ["<string>"], // Given names (not always 'first'). Includes middle names
        public string Prefix { get; set; }    //"prefix" : ["<string>"], // Parts that come before the name
        public string Suffix { get; set; }    //"suffix" : ["<string>"], // Parts that come after the name
        public List<PeriodModel> Period { get; set; }   // "period" : { Period } // Time period when name was/is in use
    }
        
    public class CodingModel
    {
        public string System { get; set; }       //"system" : "<uri>", // Identity of the terminology system
        public string Version { get; set; }      //"version" : "<string>", // Version of the system - if relevant
        public string Code { get; set; }         //"code" : "<code>", // Symbol in syntax defined by the system
        public string Display { get; set; }      //"display" : "<string>", // Representation defined by the system
        public bool UserSelected { get; set; }   //"userSelected" : <boolean> // If this coding was chosen directly by the user
    }

    public class CodeableConceptModel
    {
        public List<CodingModel> Coding { get; set; }  //"coding" : [{ Coding }], // Code defined by a terminology system
        public string Text { get; set; }    //"text" : "<string>" // Plain text representation of the concept
    }
    
    public class PeriodModel
    {
        public DateTime? Start { get; set; }     //"start" : "<dateTime>", // C? Starting time with inclusive boundary        
        public DateTime? End { get; set; }       //"end" : "<dateTime>" // C? End time with inclusive boundary, if not ongoing
    }

    public class ContactPointModel
    {
        public string System { get; set; } //"system" : "<code>", // C? phone | fax | email | pager | url | sms | other
        public string Value { get; set; }  //""value" : "<string>", // The actual contact point details
        public string Use { get; set; }    //"use" : "<code>", // home | work | temp | old | mobile - purpose of this contact point
        public int Rank { get; set; }   //"rank" : "<positiveInt>", // Specify preferred order of use (1 = highest)
        public List<PeriodModel> Period { get; set; }//"period" : { Period } // Time period when the contact point was/is in use
    }
    
    public class QuantityModel
    {
        public decimal? Value { get; set; }      //"value" : <decimal>, // Numerical value (with implicit precision)
        public string Comparator { get; set; } //"comparator" : "<code>", // < | <= | >= | > - how to understand the value
        public string Unit { get; set; }       //"unit" : "<string>", // Unit representation
        public string System { get; set; }     //"system" : "<uri>", // C? System that defines coded unit form
        public string Code { get; set; }       //"code" : "<code>" // Coded form of the unit
    }

    public class RangeModel
    {
        public List<QuantityModel> Low { get; set; }    //"low" : { Quantity(SimpleQuantity) }, // C? Low limit
        public List<QuantityModel> High { get; set; }   //"high" : { Quantity(SimpleQuantity) } // C? High limit
    }
    
    public class RatioModel
    {
        public List<QuantityModel> Numerator { get; set; }     //"numerator" : { Quantity }, // Numerator value
        public List<QuantityModel> Denominator { get; set; }   //"denominator" : { Quantity } // Denominator value
    }
        
    public class AnnotationModel
    {
        public string AuthorReference { get; set; } //{ Reference(Practitioner|Patient|RelatedPerson) },
        //public string AuthorString { get; set; }    //"denominator" : { Quantity } // Denominator value
        public DateTime? Time { get; set; }   // When the annotation was made
        public string Text { get; set; }     //R! The annotation  - text content
    }
    public class TimingModel
    {
        public DateTime? Event { get; set; }
        public string RepeatBoundsDuration { get; set; } // { Duration },// bounds[x]: Length/Range of lengths, or (Start and/or end) limits. One of these 3:
        //public string RepeatBoundsRange { get; set; }	 // { Range },
        //public string RepeatBoundsPeriod { get; set; }	 //{ Period },
        public int RepeatCount { get; set; }			 // <integer>, // Number of times to repeat
        public int RepeatCountMax { get; set; }		 // Maximum number of times to repeat
        public string RepeatDuration { get; set; }		 // How long when it happens
        public string RepeatDurationMax { get; set; }    // How long when it happens (Max)
        public string RepeatDurationUnit { get; set; }   // s | min | h | d | wk | mo | a - unit of time (UCUM)
        public int RepeatFrequency { get; set; }	     // Event occurs frequency times per period
        public int RepeatFrequencyMax { get; set; }   // Event occurs up to frequencyMax times per period
        public string RepeatPeriod { get; set; }	 	 // Event occurs frequency times per period
        public string RepeatPeriodMax { get; set; }  	 // Upper limit of period (3-4 hours)
        public string RepeatPeriodUnit { get; set; }	 // s | min | h | d | wk | mo | a - unit of time (UCUM)
        public string RepeatDayOfWeek { get; set; } 	 // mon | tue | wed | thu | fri | sat | sun
        public string RepeatTimeOfDay { get; set; } 	 // Time of day for action
        public string RepeatWhen { get; set; }	         // Regular life events the event is tied to
        public int RepeatOffset { get; set; } 	     // Minutes from event (before or after)
        public List<CodeableConceptModel> Code { get; set; }  	// BID | TID | QID | AM | PM | QD | QOD | Q4H | Q6H +
    }    

    public class AttachmentModel
    {
        public string ContentType { get; set; }   // Mime type of the content, with charset etc. 
        public string Language { get; set; }   // Human language of the content (BCP-47)
        public string Data { get; set; }   // Data inline, base64ed
        public string Url { get; set; }   // Uri where the data can be found
        public int Size { get; set; }  // Number of bytes of content (if url provided)
        public string Hash { get; set; }  // Hash of the data (sha-1, base64ed)
        public string Title { get; set; }   // Label to display in place of the data
        public DateTime? Creation { get; set; }   // Date attachment was first created
    }
    public class MetaDataModel
    {
        public string VersionId { get; set; }   // Version specific identifier
        public DateTime? LastUpdated { get; set; } // When the resource version last changed
        public string Profile { get; set; }     // Profiles this resource claims to conform to
        public List<CodingModel> Security { get; set; }    // Security Labels applied to this resource
        public List<CodingModel> Tag { get; set; }         // Tags applied to this resource
    }
    //****************** Common Models End ************************

    public class ClinicianModel
    {
        public int ClinicianId { get; set; }
        public string ClinicianName { get; set; }
    }

}
