using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace taxiservice.Models
{
	public class Cliente
	{
		public int IDCliente { get; set; }
		public string TDoc { get; set; }
		public string NDoc { get; set; }
		public string Nombre { get; set; }
		public string Correo { get; set; }
		public string Telefono { get; set; }
	}
}