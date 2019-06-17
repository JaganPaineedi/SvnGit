using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Streamline.BaseLayer
{
    public class Client
    {
        private int _ClientId;
        private string _ClientRowIdentifier;
        private string _FirstName;
        private string _LastName;
        private Int32 _ClientOrderDetailsMedicationId;
        private Int32 _ClientOrderDetailsMedicationScriptId;
        //Added By Anuj
        private string _ClientDateOfBirth;
        public string ClientDateOfBirth
        {
            get { return _ClientDateOfBirth; }
            set { _ClientDateOfBirth = value; }
        }


        public int ClientId
        {
            get { return _ClientId; }
            set { _ClientId = value; }
        }

        public string ClientRowIdentifier
        {
            get { return _ClientRowIdentifier; }
            set { _ClientRowIdentifier = value; }
        }

        public string FirstName
        {
            get { return _FirstName; }
            set { _FirstName = value; }
        }

        public string LastName
        {
            get { return _LastName; }
            set { _LastName = value; }
        }

        public Int32 ClientOrderDetailsMedicationId
        {
            get { return _ClientOrderDetailsMedicationId; }
            set { _ClientOrderDetailsMedicationId = value; }

        }

        public Int32 ClientOrderDetailsMedicationScriptId
        {
            get { return _ClientOrderDetailsMedicationScriptId; }
            set { _ClientOrderDetailsMedicationScriptId = value; }

        }

        public Client(DataSet ClientData)
        {

            try
            {
                if (ClientData.Tables["ClientInformation"].Rows.Count > 0)
                {
                    _ClientId = Convert.ToInt32(ClientData.Tables["ClientInformation"].Rows[0]["ClientId"].ToString());
                    _ClientRowIdentifier = ClientData.Tables["ClientInformation"].Rows[0]["RowIdentifier"].ToString();
                    _FirstName = ClientData.Tables["ClientInformation"].Rows[0]["FirstName"].ToString();
                    _LastName = ClientData.Tables["ClientInformation"].Rows[0]["LastName"].ToString();
                    //_FirstName = ClientRow["FirstName"].ToString();
                    //_LastName = ClientRow["LastName"].ToString();
                    //Added by Anuj for task ref 2954 on 19March,2010
                    _ClientDateOfBirth = ClientData.Tables["ClientInformation"].Rows[0]["DOB"].ToString();
                }

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }


        }

    }
}
