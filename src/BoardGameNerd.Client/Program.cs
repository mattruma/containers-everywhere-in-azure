var builder = WebApplication.CreateBuilder(args);

builder.Services.AddRazorPages();
builder.Services.AddApplicationInsightsTelemetry();

builder.Configuration.AddEnvironmentVariables();

builder.Services.AddHttpClient("bgn", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["BGN_API_ENDPOINT"]??"");
});

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
