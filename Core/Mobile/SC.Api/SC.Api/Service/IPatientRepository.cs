using SC.Api.Models;
using SC.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace SC.Api
{
    public interface IPatientRepository
    {
        string GetClientId(string SSN, string FirstName, string LastName, DateTime? DOB);
        PatientDetailsModel GetPatientInformation(int clientId, string Type, DateTime fromDate, DateTime toDate);
        string GetSummaryOfCareCCDXML(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<PatientDemographicDetailsModel> GetDemographicDetails(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<AllergiesModel> GetAllergies(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<CurrentMedicationsModel> GetCurrentMedications(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<ActiveProblemsModel> GetActiveProblems(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<MostRecentEncountersModel> GetMostRecentEncounters(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<ImmunizationsModel> GetImmunizations(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<SocialHistoryModel> GetSocialHistory(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<VitalSignsModel> GetVitalSigns(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<PlanOfTreatmentModel> GetPlanOfTreatment(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<GoalsModel> GetGoals(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<UDIModel> GetUDI(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<HistoryOfProceduresModel> GetHistoryOfProcedures(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<StudiesSummaryModel> GetStudiesSummary(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<LaboratoryTestsModel> GetLaboratoryTests(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<CareTeamMembersModel> GetCareTeamMembers(int clientId, string Type, DateTime fromDate, DateTime toDate);
        List<HealthConcernsModel> GetHealthConcerns(int clientId, string Type, DateTime fromDate, DateTime toDate);
        ClinicianModel GetPrimaryClinician(int clientId);
        List<ClinicianModel> GetProgramClinicians(int clientId);
        List<AppointmentResponseModel> GetAvailableAppointmentsSlots(AppointmentRequestModel appRequest);
        AppointmentModel GetAppointment(int AppointmentId);
        //Models.AppointmentModel ScheduleAppointment(Models.AppointmentModel appointment, int loggedInUser);
        Client GetClientBalance(int clientId);
        int UpdatePayment(ClientPaymentModel cp);
        List<int> GetAppointmentIds(AppointmentSearchModel sm);
        ClientDocumentsModel GetDocument(int DocumentVersionId);
        List<DocumentListResponseModel> GetDocumentList(DocumentListRequestModel docRequest);
        bool IsNonStaffUser(int ClientId);
        ServiceDropdownConfigurationsResponseModel GetServiceDropdownData(ServiceDropdownConfigurationsRequestModel serRequest);
        AppointmentModel CreateService(APIServiceModel serModel);
        
    }
}
