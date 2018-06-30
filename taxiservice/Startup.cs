using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(taxiservice.Startup))]
namespace taxiservice
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            //ConfigureAuth(app);
        }
    }
}
