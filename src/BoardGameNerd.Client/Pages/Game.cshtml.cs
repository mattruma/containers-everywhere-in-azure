using BoardGameNerd.Shared;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace BoardGameNerd.Client.Pages
{
    public class GameModel : PageModel
    {
        [Parameter]
        public int Id { get; set; }

        private readonly ILogger<IndexModel> _logger;
        private readonly IHttpClientFactory _httpClientFactory;

        public GameModel(
            ILogger<IndexModel> logger,
            IHttpClientFactory httpClientFactory)
        {
            _logger = logger;
            _httpClientFactory = httpClientFactory;
        }
        public Game? Game { get; private set; }

        public async Task OnGet(
            int id)
        {
            var httpClient = _httpClientFactory.CreateClient("bgn");

            this.Game = await httpClient.GetFromJsonAsync<Game>($"/games/{id}");
        }
    }
}
