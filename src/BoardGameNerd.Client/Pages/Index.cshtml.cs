using BoardGameNerd.Shared;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace BoardGameNerd.Client.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly IHttpClientFactory _httpClientFactory;

        public IndexModel(ILogger<IndexModel> logger,
            IHttpClientFactory httpClientFactory)
        {
            _logger = logger;
            _httpClientFactory = httpClientFactory;
        }

        public List<Game>? Games { get; private set; }

        public async Task OnGet()
        {
            var httpClient = _httpClientFactory.CreateClient("bgn");

            this.Games = await httpClient.GetFromJsonAsync<List<Game>>("/games/hot");
        }
    }
}