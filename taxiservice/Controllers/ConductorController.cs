using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using taxiservice.Services;
using taxiservice.Models;

namespace taxiservice.Controllers
{
	 public class ConductorController: Controller
	 {
			private Conductores m_regs;

			public ConductorController()
			{
				 m_regs = new Conductores();
			}

			public ActionResult Agregar()
			{
				 return View();
			}

			public ActionResult Eliminar()
			{
				 return View();
			}

			public ActionResult Actualizar()
			{
				 ViewBag.Message = "Editando Conductor...";
				 return View();
			}

			public ActionResult Buscar()
			{
				 return View();
			}

			public ActionResult VerDatos()
			{
				 ViewBag.Message = "Lista de Conductores";
				 m_regs.buscar("*", "");
				 var model = m_regs.getData();
				 return View(model);
			}
	 }
}