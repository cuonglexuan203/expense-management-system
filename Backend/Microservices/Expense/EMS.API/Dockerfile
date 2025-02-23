# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 80
EXPOSE 443


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Microservices/Expense/EMS.API/EMS.API.csproj", "Microservices/Expense/EMS.API/"]
COPY ["Microservices/Expense/EMS.Infrastructure/EMS.Infrastructure.csproj", "Microservices/Expense/EMS.Infrastructure/"]
COPY ["Microservices/Expense/EMS.Application/EMS.Application.csproj", "Microservices/Expense/EMS.Application/"]
COPY ["Microservices/Expense/EMS.Core/EMS.Core.csproj", "Microservices/Expense/EMS.Core/"]
RUN dotnet restore "./Microservices/Expense/EMS.API/EMS.API.csproj"
COPY . .
WORKDIR "/src/Microservices/Expense/EMS.API"
RUN dotnet build "./EMS.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./EMS.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EMS.API.dll"]