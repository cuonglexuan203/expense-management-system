# GenAI-Driven Expense Management System 🚀

[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.19-blue?logo=flutter)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![GenAI-Driven Expense Management Banner](/Assets/Images/banner.jpeg)

An AI-powered expense management platform that combines financial tracking with smart automation using NLP and voice recognition.
## 👥 Team

| **Member**   | **Student ID** | **Responsibilities**                        |
|--------------|----------------|--------------------------------------------|
| **Le Xuan Cuong** | 21110758       |  |
| **Bui Quoc Thong** | 21110092       |   |

> Responsibilities: Backend Architecture, AI Integration, DevOps, Mobile Development, Frontend, UI/UX Design

**Project Supervisor:**  
Mr. Nguyen Minh Tien - Instructor, HCMC Univercity of Technology and Education

## 📑 Table of Contents
- [Team](#-team)
- [Project Overview](#-project-overview)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

## 🌟 Project Overview

**University of Information Technology (UIT)**  
**Capstone Project - Software Engineering Program**  
**Instructor: Mr. Nguyen Minh Tien**

A smart expense management solution that enables users to:
- Track expenses via text/voice input 📱
- Manage recurring payments 🔄
- Analyze spending patterns with AI insights 🧠
- Schedule financial events with calendar integration 📅
- Process receipt images for automated tracking 🖼️

## 🎯 Key Features

### 💸 Expense Management
- Natural Language Processing (NLP) transaction input
- Voice-based expense recording 🎤
- Recurring payment automation
- Multi-wallet support
- Receipt image analysis with OCR

### 📅 Smart Scheduling
- Calendar-event linked expenses
- Conflict detection and resolution
- Intelligent reminders and notifications
- Time management recommendations

### 📊 Analytics & Insights
- AI-generated spending reports
- Budget optimization suggestions
- Comparative period analysis
- Customizable financial goals

## 🛠️ Tech Stack

| Component          | Technology Stack                                                                 |
|--------------------|----------------------------------------------------------------------------------|
| **Mobile App**     | Flutter (Dart)                                                                   |
| **Backend**        | ASP.NET Core 8, Entity Framework Core, PostgreSQL                                |
| **AI Service**     | FastAPI, OpenAI GPT-4/Whisper, Tesseract OCR, Weaviate                           |
| **Admin Panel**    | Next.js 15 (TypeScript), Tailwind CSS                                            |
| **Infrastructure** | Docker, Cloudinary CDN, REST API                                                 |
| **Dev Tools**      | Serilog, FluentValidation, Swagger, GitHub Actions                               |

## 🚀 Getting Started

### Prerequisites
- .NET 8 SDK
- Flutter 3.19+
- Docker Desktop 24.0+
- Python 3.10+
- Node.js 18+

### Installation

1. **Clone Repository**
```bash
git clone https://github.com/[your-username]/genai-expense-management.git
cd genai-expense-management
```
2. **Backend Setup**
```cd backend
cp .env.example .env  # Update with actual values
docker-compose up --build
```
3. **Mobile App**
```cd mobile
flutter pub get
flutter run -d chrome  # For web development
```
4. **AI Service**
```cd ai-service
python -m venv venv
source venv/bin/activate  # Linux/Mac) / venv\Scripts\activate (Windows)
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```
5. **Admin Panel**
```cd admin-web
npm install
npm run dev
```
### Environment Variables
```
# backend/appsettings.json
ConnectionStrings__Default=Host=postgres;Port=5432;Database=expense_db;
Jwt__Key=your_secure_key_here
AI_SERVICE_URL=http://ai-service:8000
CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME
```
## 📂 Project Structure
```
genai-expense-management/
├── Backend/          # Backend microservices
│   ├── ApiGateways/         # API gateway configurations
│   ├── Infrastructure/ # Infrastructure setup
│   └── Services/          # Core services
|       ├── AI/       # FastAPI service
│       │    ├── app/          # API routers
│       │    └── ml_models/    # AI/ML components
│       └── Expense # ASP.NET expense microservice
│           ├── Expense.API/
│           ├── Expense.Infrastructure/
│           ├── Expense.Application/
│           └── Expense.Core/
├── Clients/          # Client applications
│   ├── mobile/           # Flutter application
│   │    ├── lib/          # Dart source code
│   │    └── assets/       # Media files
│   └── admin-web/        # Next.js admin panel
│       ├── components/   # React components
│       └── app/        # Next.js routes
│
├── Docs/             # Project documentation
└── Assets/             # Global assets (images, icons)
```

## 📄 License
This project is licensed under the MIT <a href="https://mit-license.org/" target="_blank">License</a> - see the LICENSE file for details.
## 🙏 Acknowledgments

- **[HCMC University of Technology and Education (HCMUTE)](https://en.hcmute.edu.vn/)** for academic guidance  
- **[OpenAI](https://openai.com/)** for GPT and Whisper APIs  
- **[Cloudinary](https://cloudinary.com/)** for media management services  
- **[.NET Foundation](https://dotnetfoundation.org/)** for excellent backend tools  
- **[Flutter Community](https://flutter.dev/)** for cross-platform development framework  

---

🏡 **HCMC University of Technology and Education**  
🎓 **Faculty of Internaltional Education**  
📅 **Capstone Project 2025**\
<a href="https://en.hcmute.edu.vn/" target="_blank">HCMUTE Website</a> |
<a href="https://fie.hcmute.edu.vn/" target="_blank">IE Faculty</a>

