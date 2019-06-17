using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace Streamline.UserBusinessServices
{
  public  class HealthMaintenanceTemplate: IDisposable
    {
        public void Dispose()
        {
            
        }

        
        /// <summary>
        /// <Description>This function will return Dataset bind List Page Grid For Health Data Template List Page</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>10-Aug-2012</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenanceTriggeringList(int pageNumber, int pageSize, string sortExpression, string searchCriteria, string ActionValue)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataSTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataSTemplates.GetHealthMaintenanceTriggeringList(pageNumber, pageSize, sortExpression, searchCriteria, ActionValue);
            }
        }
      /// <summary>
        /// <Author>Veena S Mani</Author>
        /// <CreatedOn>18-July-2014</CreatedOn>
      /// </summary>
      /// <param name="pageNumber"></param>
      /// <param name="pageSize"></param>
      /// <param name="sortExpression"></param>
      /// <param name="HealthMaintenanceTriggeringFactorGroupId"></param>
      /// <param name="OtherFilter"></param>
      /// <returns></returns>
        public DataSet GetHealthMaintenanceTriggeringFactorList(int pageNumber, int pageSize, string sortExpression, string FactorName, int OtherFilter)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectGetHealthMaintenanceTriggeringFactorList = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectGetHealthMaintenanceTriggeringFactorList.GetHealthMaintenanceTriggeringFactorList(pageNumber, pageSize, sortExpression, FactorName, OtherFilter);
            }
        }
        /// <summary>
        /// <Description>This function will return Dataset bind List Page Grid For Client Health Data Template List Page</Description>
        /// <Author>Rakesh Garg</Author>
        /// <CreatedOn>27-Aug-2012</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetClientHealthMaintenaceListPageData(int pageNumber, int pageSize, string sortExpression, string status, string FromDate, string Todate,int ClientID, int otherFilter)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataSTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataSTemplates.GetClientHealthMaintenaceListPageData(pageNumber, pageSize, sortExpression, status, FromDate, Todate,ClientID, otherFilter);
            }
        }

        /// <summary>
        /// <Description>This function will return Dataset for binding List Page Grid For Health Maintenance Template List Page</Description>
        /// <Author>Swapan Mohan</Author>
        /// <CreatedOn>27-Aug-2012</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenanceTemplate(int pageNumber, int pageSize, string sortExpression, int otherFilter, string templateName, string status)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthMaintenance = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthMaintenance.GetHealthMaintenanceTemplate(pageNumber, pageSize, sortExpression, otherFilter, templateName, status);
            }
        }

        /// <summary>
        /// <Description>This function will return Dataset bind List Page Grid For Client Health Data Template List Page popup</Description>
        /// <Author>Davinder K</Author>
        /// <CreatedOn>27-Aug-2012</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenaceTemplateListPageData(Int32 ClientID,String SearchText)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataSTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataSTemplates.GetHealthMaintenaceTemplateListPageData(ClientID, SearchText);
            }
        }
      /// <summary>
      /// 
      /// </summary>
      /// <param name="OrderType"></param>
      /// <param name="SearchText"></param>
      /// <returns></returns>
        public DataSet GetHealthMaintenaceOrdersSelected(Int32 OrderType, String SearchText)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataSTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataSTemplates.GetHealthMaintenaceOrdersSelected(OrderType, SearchText);
            }
        }
       
        /// <summary>
        /// Gets the  Client HealthMaintenance Template.
        /// <Author>Author: Rahul An</Author>
        /// <CreatedDate>Date: 11-sep-2012</CreatedDate>
        /// </summary>
        /// <returns>Returns DataSet containing the Client HealthMaintenance</returns>
        public DataSet GetClientHealthMaintenaceTemplate(int pageNumber, int pageSize, string sortExpression, int otherFilter, string status, int TemplatedID)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.GetClientHealthMaintenaceTemplate(pageNumber, pageSize, sortExpression, otherFilter, status, TemplatedID);
            }

        }
      /// <summary>
        /// <Author>Author:Veena S Mani</Author>
        /// <CreatedDate>Date: 18 july 2014</CreatedDate>  
      /// </summary>
      /// <param name="ClientId"></param>
      /// <returns></returns>
        public DataSet GetHealthMaintenaceGroups()
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectGetHealthMaintenaceGroups = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectGetHealthMaintenaceGroups.GetHealthMaintenaceGroups();
            }
        }
        /// <summary>
        /// Gets the  Client HealthMaintenance Template Name.
        /// <Author>Author: Rahul An</Author>
        /// <CreatedDate>Date: 12-sep-2012</CreatedDate>
        /// </summary>
        /// <returns>Returns DataSet containing the TemplateName</returns>
        public DataSet GetClientHealthMaintenaceTemplateName(int ClientId)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.GetClientHealthMaintenaceTemplateName(ClientId);
            }
        }

        /// <summary>
        /// Gets the  PrimaryCare ProcedureCode.
        /// <Author>Author: Rahul An</Author>
        /// <CreatedDate>Date: 20-sep-2012</CreatedDate>
        /// </summary>
        /// <returns>Returns DataSet containing the ProcedureCode and Description</returns>
        public DataSet GetPrimaryCareProcedureCodes()
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.GetPrimaryCareProcedureCodes();
            }
        }
       /// <summary>
        /// Added By Mamta Gupta - To create Client Compliance - Primary Care - Summit Pointe Ref Task No. 15
       /// </summary>
       /// <param name="ClientId"></param>
       /// <param name="PrimaryCareHealthMaintenanceTemplateId"></param>
       /// <returns></returns>
        public DataSet GetClientHealthMaintenaceTemplateCompliance(Int32 ClientId, Int32 PrimaryCareHealthMaintenanceTemplateId)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.GetClientHealthMaintenaceTemplateCompliance(ClientId, PrimaryCareHealthMaintenanceTemplateId);
            }
        }

        /// <summary>
        /// <Description>To check for Health Maintenance Alerts, Ref : Meaningful Use -> Task No. 31.1</Description>
        /// <Author>Prasan</Author>
        /// <CreatedOn>30-July-2014</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet HealthMaintenanceAlertCheck(int clientID, int staffID)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.HealthMaintenanceAlertCheck(clientID, staffID);
            }
        }

        /// <summary>
        /// <Description>To Get Health Maintenance Alert Data, Ref : Meaningful Use -> Task No. 31.1</Description>
        /// <Author>Prasan</Author>
        /// <CreatedOn>1-AUG-2014</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenaceAlertData(int clientID, int staffID)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.GetHealthMaintenaceAlertData(clientID, staffID);
            }
        }

        /// <summary>
        /// <Description>To Save Health Maintenance Alert Data, Ref : Meaningful Use -> Task No. 31.1</Description>
        /// <Author>Prasan</Author>
        /// <CreatedOn>1-AUG-2014</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>

        public DataSet SaveHealthMaintenaceUserDecisions(string acceptedKeys, string rejectedKeys, int clientId)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.SaveHealthMaintenaceUserDecisions(acceptedKeys, rejectedKeys, clientId);
            }
        }
      
        /// <summary>
        /// <Description>To get initial Health Maintenance Alert data, Ref : Meaningful Use -> Task No. 31.1</Description>
        /// <Author>Prasan</Author>
        /// <CreatedOn>18-SEP-2014</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet InitHealthMaintenanceAlertCheck(int staffID)
        {
            using (Streamline.DataService.HealthMaintenanceTemplate objectHealthDataMaintTemplates = new Streamline.DataService.HealthMaintenanceTemplate())
            {
                return objectHealthDataMaintTemplates.InitHealthMaintenanceAlertCheck(staffID);
            }
        }
    }
}
