using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace taxiservice.Models
{
	public class Automovil
	{
		public int IDAutomovil { get; set; }
		public int IDMarca { get; set; }
		public int IDModelo { get; set}
		public string Placa { get; set; }
		public string Codigo { get; set; }
		public string Color { get; set; }
	}
}