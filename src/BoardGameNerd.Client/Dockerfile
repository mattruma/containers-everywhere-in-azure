FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["BoardGameNerd.Client/BoardGameNerd.Client.csproj", "BoardGameNerd.Client/"]
RUN dotnet restore "BoardGameNerd.Client/BoardGameNerd.Client.csproj"
COPY . .
WORKDIR "/src/BoardGameNerd.Client"
RUN dotnet build "BoardGameNerd.Client.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BoardGameNerd.Client.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BoardGameNerd.Client.dll"]