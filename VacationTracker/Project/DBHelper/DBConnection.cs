using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MySql.Data.MySqlClient;
using System.Data;

namespace DBHelper
{
    public class DBConnection
    {
        MySqlConnection _MyCon;
        MySqlDataAdapter _MyAdaptor;

        DataSet dsResult;
        DataTable dtResult;
        DataView dvResult;
        bool blnAppendDataset;

        string strConString;
        string strDataTableName;

        public DBConnection()
        {
            strConString = StaticMembers._CONNECTION_STRING;
        }

        public DBConnection(string ConnectionString)
        {
            strConString = ConnectionString;
        }

        public MySqlConnection createConnection()
        {
            try
            {
              
               _MyCon = new MySqlConnection(strConString);
                _MyCon.Open();
            }
            catch (Exception ex)
            {
                //StaticMembers.WriteLogFile(ex.InnerException.ToString(), "DBConnection", "createConnection");
            }
            finally
            {
                if (_MyCon.State != ConnectionState.Open)
                    createConnection();
            }
            return _MyCon;
        }

        public void disposeConnection(MySqlConnection MyCon)
        {
            if (MyCon.State == ConnectionState.Open)
            {
                MyCon.Close();
            }
            MyCon.Dispose();
            MyCon = null;
        }

        /// <summary>
        /// Creates and Returns a Dataset with respect to the Given Query
        /// </summary>
        /// <param name="Query">SQL Query to get a dataset</param>
        /// <returns>Returns Dataset</returns>
        public DataSet generateDataSet(string Query)
        {
            if (!blnAppendDataset)
            {
                dsResult = new DataSet();
            }
            try
            {
                createConnection();
                _MyAdaptor = new MySqlDataAdapter(Query, _MyCon);
                if (strDataTableName == "" || strDataTableName == null)
                {
                    _MyAdaptor.Fill(dsResult);
                }
                else
                {
                    _MyAdaptor.Fill(dsResult, strDataTableName);
                }
                disposeConnection(_MyCon);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
                StaticMembers.WriteLogFile(ex.Message, "DBAccess", "generateDataSet-Single String Param");
            }
            return dsResult;
        }

        
        public DataTable GenerateDataTable(string Query)
        {
            try
            {
                createConnection();
                _MyAdaptor = new MySqlDataAdapter(Query, _MyCon);
                dtResult = new DataTable();
                _MyAdaptor.Fill(dtResult);
                 disposeConnection(_MyCon);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
                StaticMembers.WriteLogFile(ex.Message, "DBAccess", "generateDataTable-Single String Param");
            }
            return dtResult;
        }
        public DataSet GenerateDataSet(string Query, string DataTableName)
        {
            try
            {
                strDataTableName = DataTableName;
                blnAppendDataset = false;
                generateDataSet(Query);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
            }
            return dsResult;
        }

        public DataSet generateDataSet(string Fields, string Tables, string Condition)
        {
            try
            {
                string strQuery;
                blnAppendDataset = false;
                strQuery = "SELECT " + Fields + " FROM " + Tables;

                if (Condition != "")
                {
                    strQuery += Condition;
                }

                generateDataSet(strQuery);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
            }
            return dsResult;
        }

        public DataSet generateDataSet(string Fields, string Tables, string Condition, string DataTableName)
        {
            try
            {
                string strQuery;

                strQuery = "SELECT " + Fields + " FROM " + Tables;
                blnAppendDataset = false;
                if (Condition != "")
                {
                    strQuery += Condition;
                }

                generateDataSet(strQuery);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
            }
            return dsResult;
        }

        public DataSet generateDataSet(string Query, DataSet thisDS, string DataTableName)
        {
            try
            {
                strDataTableName = DataTableName;
                blnAppendDataset = true;
                dsResult = thisDS;
                dsResult = generateDataSet(Query);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
            }
            return thisDS;
        }

        public bool updateDataset(DataSet thisDS, string DataTableName)
        {
            bool blnResult = true;
            try
            {
                createConnection();
                if (strDataTableName == "" || strDataTableName == null)
                {
                    MySqlHelper.UpdateDataset(thisDS, _MyCon.ConnectionString);
                }
                disposeConnection(_MyCon);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
                blnResult = false;
            }
            return blnResult;
        }

        /// <summary>
        /// This method updates all the datatables placed within a dataset.
        /// </summary>
        /// <param name="thisDS">Dataset which is to be saved. This may contain many tables with relationships</param>
        /// <returns>Returns true/false based on the update.</returns>
        public bool updateDataset(DataSet thisDS)
        {
            bool blnResult = true;
            try
            {
                createConnection();
                MySqlHelper.UpdateDataset(thisDS, _MyCon.ConnectionString);
                disposeConnection(_MyCon);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
                blnResult = false;
                throw;
            }
            return blnResult;
        }

        /// <summary>
        /// This method deletes all the datatables placed within a dataset.
        /// </summary>
        /// <param name="thisDS">Dataset which is to be deleted. This may contain many tables with relationships and rows state must be in Deleted.</param>
        /// <returns>Returns true/false based on the update.</returns>
        public bool deleteDataset(DataSet thisDS)
        {
            bool blnResult = true;
            try
            {
                createConnection();
                MySqlHelper.UpdateDataset(thisDS, _MyCon.ConnectionString);
                disposeConnection(_MyCon);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
                blnResult = false;
                throw;
            }
            return blnResult;
        }


        //Added by Maha for returning dataset with pkey for ETL import

        public DataSet UpdateDataset_WithDataset(DataSet thisDS)
        {
            DataSet dsResultNew = new DataSet();
            try
            {
                createConnection();
                if (strDataTableName == "" || strDataTableName == null)
                {
                    dsResultNew = MySqlHelper.UpdateDataset_WithDataset(thisDS, _MyCon.ConnectionString);
                }
                disposeConnection(_MyCon);
            }
            catch (Exception ex)
            {
                disposeConnection(_MyCon);
                
            }
            return dsResultNew;
        }


        public string retrieveScalar(string Query)
        {
            string strResult;
            DataTable dtTemp = generateDataSet(Query).Tables[0];
            if (dtTemp.Rows.Count > 0)
            {
                strResult = Convert.ToString(dtTemp.Rows[0][0]);
            }
            else
            {
                strResult = "";
            }
            return strResult;
        }

        public bool executeNonQuery(string[] Query)
        {
            bool blnResult = true;
            try
            {
                MySqlHelper.ExecuteTransNonQuery(strConString, Query);
            }
            catch (Exception ex)
            {
                blnResult = false;
                throw;
            }
            return blnResult;
        }

        public int[] executeNonQueryWithIDReturn(string[] Query)
        {
            int[] intResult;
            try
            {
               intResult= MySqlHelper.ExecuteTransNonQueryWithIDReturn(strConString, Query);
            }
            catch (Exception ex)
            {
                throw;
            }
            return intResult;
        }

        public DataSet XMLDBConnection(string strxmlPath)
        {
            DataSet dsProjectDetails = new DataSet();
            dsProjectDetails.ReadXml(strxmlPath);
            return dsProjectDetails;
        }
    }
}