using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using Npgsql;
using System.Data;

namespace taxiservice.Services
{
	 public class Conexion
	 {
			private NpgsqlConnection _con;

			public Conexion()
			{
				 _con = new NpgsqlConnection();
			}

			public int NumError { get; set; }
			public string DesError { get; set; }

			private string getCadenaConexion()
			{
				 return ConfigurationManager.ConnectionStrings["taxiservice"].ConnectionString;
			}
			public bool abrir(string pConn)
			{
				 bool lRet = false;
				 try
				 {
						if (string.IsNullOrEmpty(pConn))
							 _con = new NpgsqlConnection(getCadenaConexion());
						else
							 _con = new NpgsqlConnection(pConn);

						_con.Open();
						lRet = true;
				 }
				 catch (Exception ex)
				 {
						DesError = ex.Message;
						_con.Close();
				 }
				 return lRet;
			}
			public void cerrar()
			{
				 if (_con.State == System.Data.ConnectionState.Open)
				 {
						_con.Close();
						//_con.Dispose();
				 }
			}
			public bool activo()
			{
				 return (this._con.State == System.Data.ConnectionState.Open);
			}
			public NpgsqlConnection getConexion()
			{
				 return this._con;
			}
			public string getError()
			{
				 return DesError;
			}
	 }
}