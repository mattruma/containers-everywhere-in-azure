using BoardGameNerd.Shared;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddApplicationInsightsTelemetry();

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