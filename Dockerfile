# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["Portfolio.csproj", "./"]
RUN dotnet restore "Portfolio.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "Portfolio.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "Portfolio.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Portfolio.dll"]
