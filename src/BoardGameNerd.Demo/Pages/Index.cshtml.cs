using Microsoft.AspNetCore.Mvc.RazorPages;

namespace BoardGameNerd.Demo.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        public readonly IConfiguration Configuration;

        public IndexModel(IConfiguration configuration,
            ILogger<IndexModel> logger)
{
            _logger = logger;
            this.Configuration = configuration;
        }

        public void OnGet()
        {

        }
    }
}