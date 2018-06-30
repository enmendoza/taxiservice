using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace taxiservice.Models
{
	 public class Conductor
	 {
			public int Id { get; set; }
			public string TDocumento { get; set; }
			public string NDocumento { get; set; }
			public string NLicencia { get; set; }
			public string Nombre { get; set; }
			public string Direccion { get; set; }
			public string Telefono { get; set; }
	 }
}