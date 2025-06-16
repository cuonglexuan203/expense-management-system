# MOSA: GenAI-Powered Expense Management System

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![.NET Core](https://img.shields.io/badge/.NET-8.0-purple.svg?logo=.net)](https://dotnet.microsoft.com/)
[![Python](https://img.shields.io/badge/Python-FastAPI-blue.svg?logo=python)](https://fastapi.tiangolo.com/)
[![Go](https://img.shields.io/badge/Go-1.23.4-blue?logo=go)](https://golang.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.29.2-blue.svg?logo=flutter)](https://flutter.dev)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17.4-blue.svg?logo=postgresql)](https://www.postgresql.org/)

<div align="center">
  <img src="/Assets/Images/banner.jpeg" alt="App Screenshot">
</div>

## 🚀 Overview
MOSA is an intelligent expense management system that leverages Generative AI to transform personal finance tracking through conversational interfaces and smart automation. The system enables users to manage expenses using natural language, images, or voice commands.

**Key Innovations**:
- Multi-modal AI transaction processing
- Human-in-the-loop confirmation workflow
- Notification-based transaction detection
- Financial insights through conversational AI

## ✨ Features
| Module | Capabilities |
|--------|--------------|
| **AI Assistant** | Chat-based expense logging, financial advice, event scheduling |
| **Multi-Modal Input** | Process expenses via text, images, and voice |
| **Smart Automation** | AI-powered transaction extraction and categorization |
| **Notification Detection** | Detect expenses from device notifications (e.g. chat, banking,... apps) |
| **Financial Insights** | Personalized spending analysis and visualization |
| **Admin Dashboard** | User management, transaction monitoring, analytics |

## 🧠 AI Architecture
<div align="center">
  <img src="/Assets/Images/ai-orchestration.png" alt="AI Orchestration">
</div>

## ⚙️ Tech Stack
### System Architecture
<div align="center">
  <img src="/Assets/Images/system-architecture.png" alt="System Architecture">
</div>

### Component Breakdown
| Component | Technologies | Key Features |
|-----------|--------------|--------------|
| **Mobile App** | Flutter 3.29.2, Dart | Cross-platform UI, Chat interface, Notification handling |
| **Backend API** | ASP.NET Core 8, C#, Entity Framework | RESTful API, CQRS, Clean Architecture, JWT Auth |
| **AI Service** | FastAPI, Python, LangChain, LangGraph | Multi-agent architecture, Transaction extraction |
| **Dispatcher** | Golang, Gin, GORM | Asynchronous tasks, FCM notifications |
| **Database** | PostgreSQL 17.4 | Relational data storage |
| **Caching/Queue** | Redis 7.4 | Message brokering, Caching |
| **Admin Panel** | Next.js 15, TypeScript | User management, Analytics dashboard |
## 🛠️ Installation
### Prerequisites
*   Docker & Docker Compose
*   .NET 8 SDK
*   Node.js (v18.20.8) and npm/yarn
*   Python (and pip)
*   Golang
*   Flutter SDK (v3.29.2)
*   Access to OpenAI and Google Gemini APIs (API keys)
*   Firebase Project setup for FCM
*   Cloudinary account for media storage
### Running with Docker
```bash
# Clone repository
git clone https://github.com/cuonglexuan203/expense-management-system.git

# Start services
docker-compose up -d
```

**Services**:
1. `backend-api` (ASP.NET Core)
2. `ai-service` (FastAPI/Python)
3. `go-dispatcher` (Gin/Golang)
4. `postgres-db` (PostgreSQL)
5. `redis-cache` (Redis)

## 📱 User Flows
1. **Expense Logging**:
   - Chat: "Spent $15 at Starbucks yesterday"
   - Image: Receipt photo upload
   - Voice: "Record salary deposit of $2000"

2. **Event Management**:
   - "Remind me to pay rent every 1st"
   - "Schedule electricity bill on 15th monthly"

3. **Financial Insights**:
   - "Show my food spending this month"
   - "How can I reduce expenses?"

## 📂 Project Structure
```
expense-management-system/
├── Backend/                # Core backend services
│   ├── ApiGateways/
│   ├── deployment/         # Deployment scripts and configurations
│   ├── Infrastructure/
│   └── Microservices/
│       ├── AI/             # AI Service (Python/FastAPI/LangChain)
│       ├── Dispatcher/     # Dispatcher Service (Go/Gin)
│       ├── EMS-MCP-Server/
│       └── Expense/        # Expense Service (.NET Core)
├── Clients/                # Frontend clients
│   ├── admin/              # Admin dashboard (Next.js)
│   └── mobile/             # Mobile application (Flutter)
└── Docs/                   # Documentation assets
```

## 👥 Contributors
- [Lê Xuân Cường](https://github.com/cuonglexuan203) (Backend/AI Integration/Architecture Lead)
- [Bùi Quốc Thông](https://github.com/) (Frontend)

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
> **Ho Chi Minh City University of Technology and Education**  
> Faculty of International Education - Software Engineering Graduation Project  
> Advisor: Mr. Nguyễn Đăng Quang  
> Co-advisor: Lê Minh Tiến  
> May 2025