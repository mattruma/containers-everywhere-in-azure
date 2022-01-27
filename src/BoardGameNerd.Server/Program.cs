using BoardGameNerd.Shared;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddHttpClient("bgg", client =>
{
    client.BaseAddress = new Uri("https://bgg-json.azurewebsites.net/");
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.MapGet("/games/hot", async (IHttpClientFactory _httpClientFactory) =>
{
    var httpClient = _httpClientFactory.CreateClient("bgg");

    return await httpClient.GetFromJsonAsync<List<Game>>("/hot");
})
.WithName("GameList");

app.MapGet("/games/{id}", async (IHttpClientFactory _httpClientFactory, int id) =>
{
    var httpClient = _httpClientFactory.CreateClient("bgg");

    return await httpClient.GetFromJsonAsync<Game>($"/thing/{id}");
})
.WithName("GameFetchById");

app.Run();