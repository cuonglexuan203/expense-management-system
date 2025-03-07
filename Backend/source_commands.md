# AI Microservice

## Commands to Run

```sh
# Create virtual env
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
# Run app
uvicorn main:app --reload
```

---

# Expense Microservice

## Migration Commands

**Note:** Before running migrations, ensure that the migration tool is installed:

```sh
dotnet tool install --global dotnet-ef
```

### Terminal Path
Navigate to the following directory before executing migration commands:

```
Backend/Microservices/Expense
```

### Add Migration

```sh
dotnet ef migrations add MigrationName -c ApplicationDbContext -s ./EMS.API/EMS.API.csproj -p ./EMS.Infrastructure/EMS.Infrastructure.csproj -o ./Persistence/Migrations
```

### Run Migration

```sh
dotnet ef database update -c ApplicationDbContext -s ./EMS.API/EMS.API.csproj -p ./EMS.Infrastructure/EMS.Infrastructure.csproj
```