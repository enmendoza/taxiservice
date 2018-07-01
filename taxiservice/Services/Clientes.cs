using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using taxiservice.Models;
using Npgsql;
using NpgsqlTypes;
using System.Data;

namespace taxiservice.Services
{
	public class Clientes
	{
		private Conexion m_conn;
		private NpgsqlDataReader m_data;
		private List<Cliente> m_lista;

		public Clientes()
		{
			m_conn = new Conexion();
			m_data = null;
			m_lista = new List<Cliente>();
		}
		/// <summary>
		/// Crea un Objeto Cliente
		/// </summary>
		/// <param name="lData">Es un objeto NpgsqlDataReader que contiene datos para crear el objeto</param>
		/// <returns>Devuelve un Objeto de tipo Cliente</returns>
		private Cliente crearObjeto(NpgsqlDataReader lData)
		{
			Cliente lObjeto = null;
			if (lData != null)
			{
				lObjeto = new Cliente();
				lObjeto.Id = Convert.ToInt32(lData["idconductor"]);
				lObjeto.TDocumento = Convert.ToString(lData["tdoc"]);
				lObjeto.NDocumento = Convert.ToString(lData["ndoc"]);
				lObjeto.NLicencia = Convert.ToString(lData["nlicencia"]);
				lObjeto.Nombre = Convert.ToString(lData["nombre"]);
				lObjeto.Direccion = Convert.ToString(lData["direccion"]);
				lObjeto.Telefono = Convert.ToString(lData["telefono"]);
			}
			return lObjeto;
		}
		/// <summary>
		/// Devuelve un Objeto Cliente
		/// </summary>
		/// <param name="pID">Es el id que identifica a un registro en la tabla Cliente</param>
		/// <returns>Devuelve un Objeto de tipo Cliente</returns>
		public Cliente getConductor(int pID)
		{
			Cliente lObjeto = null;
			if (buscar("*", "where idconductor=" + pID))
			{
				lObjeto = crearObjeto(m_data);
			}
			return lObjeto;
		}
		/// <summary>
		/// Crea una lista de Conductores
		/// </summary>
		/// <returns>Devuelve una lista de conductores</returns>
		public List<Cliente> getData()
		{
			return m_lista;
		}
		/// <summary>
		/// Busca en la tabla Cliente segun los parametros especificados
		/// </summary>
		/// <param name="pCampos">Indica los campos a devolver cuando se ejecuta la búsqueda</param>
		/// <param name="pFiltro">Es el filtro que se aplicara al realizar la búsqueda</param>
		/// <returns></returns>
		public bool buscar(string pCampos, string pFiltro)
		{
			bool lRsp = false;

			try
			{
				if (m_conn.activo() == false) m_conn.abrir("");
				using (NpgsqlCommand lCmd = new NpgsqlCommand())
				{
					lCmd.CommandType = CommandType.Text;
					lCmd.CommandText = "select " + pCampos + " from vw_reg_conductor " + pFiltro;
					lCmd.Connection = m_conn.getConexion();
					m_data = lCmd.ExecuteReader();
					while (m_data.Read())
					{
						m_lista.Add(crearObjeto(m_data));
					}
					lRsp = (m_data != null);
				}
			}
			catch (Exception ex)
			{
				Console.Write(ex.Message);
				throw;
			}
			finally
			{
				if (m_conn.activo()) m_conn.cerrar();
			}
			return lRsp;
		}
		/// <summary>
		/// Guarda/Actualiza un registro de Cliente
		/// </summary>
		/// <param name="pObjeto">Objeto tipo Cliente</param>
		/// <param name="pOpc">Parametro que indica si se crear un nuevo registro (INS),
		/// o si se va a actualizar un registro (UPD)</param>
		/// <returns>Entero que es el Id en la tabla de conductores</returns>
		public int guardar(Cliente pObjeto, string pOpc)
		{
			int lNuevoId = 0;
			try
			{
				if (m_conn.activo() == false) m_conn.abrir("");
				using (NpgsqlCommand lCmd = new NpgsqlCommand())
				{
					lCmd.CommandType = CommandType.Text;
					lCmd.CommandText = "fn_conductor";
					lCmd.Parameters.Add(new NpgsqlParameter("idconductor", NpgsqlDbType.Integer));
					lCmd.Parameters.Add(new NpgsqlParameter("tdoc", NpgsqlDbType.Varchar));
					lCmd.Parameters.Add(new NpgsqlParameter("tnoc", NpgsqlDbType.Varchar));
					lCmd.Parameters.Add(new NpgsqlParameter("nlicencia", NpgsqlDbType.Varchar));
					lCmd.Parameters.Add(new NpgsqlParameter("nombre", NpgsqlDbType.Varchar));
					lCmd.Parameters.Add(new NpgsqlParameter("direccion", NpgsqlDbType.Varchar));
					lCmd.Parameters.Add(new NpgsqlParameter("telefono", NpgsqlDbType.Varchar));
					lCmd.Parameters.Add(new NpgsqlParameter("opc", NpgsqlDbType.Varchar));
					lCmd.Parameters[0].Value = pObjeto.Id;
					lCmd.Parameters[1].Value = pObjeto.TDocumento;
					lCmd.Parameters[2].Value = pObjeto.NDocumento;
					lCmd.Parameters[3].Value = pObjeto.NLicencia;
					lCmd.Parameters[4].Value = pObjeto.Nombre;
					lCmd.Parameters[5].Value = pObjeto.Direccion;
					lCmd.Parameters[6].Value = pObjeto.Telefono;
					lCmd.Parameters[7].Value = pOpc;
					using (NpgsqlDataReader lDrd = lCmd.ExecuteReader())
					{
						if (lDrd != null)
						{
							lDrd.Read();
							lNuevoId = Convert.ToInt32(lDrd[0]);
						}
					}
				}
			}
			catch (Exception ex)
			{
				Console.Write(ex.Message);
				throw;
			}
			finally
			{
				if (m_conn.activo()) m_conn.cerrar();
			}
			return lNuevoId;
		}
	}
}