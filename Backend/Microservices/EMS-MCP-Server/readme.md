# EMS AI MCP Integration

This module is part of the **LLM-based Expense Management System (EMS)**.  
It enables the AI Financial Assistant to **retrieve and modify expenses/events dynamically** through a custom **MCP (Message Communication Protocol)** server and client setup.

---

## 📋 Description

- **EMS MCP Server**: A standalone server that listens for MCP connections from clients.
- **MCP Client**: Implemented inside the **AI microservice**, connects to EMS MCP Server.
- **Tools**: Functions (e.g., `CreateTransaction`, `GetTransactions`, `AddEvent`) for the AI Agent to interact with backend APIs via MCP.
- **AI Agent**: Developed using **LangChain** with **Memory** support to manage conversation history and context.

The EMS MCP Server communicates with the **ASP.NET Core** Backend's **RESTful APIs** to perform CRUD operations on transactions and events.

---

## 🎯 Goal

- Enable the AI agent to retrieve/modify expense and event data through MCP communication.
- Equip the AI agent with memory to maintain conversation context.
- Provide tools that allow seamless interaction between the AI agent and the backend.

---

## ✅ Acceptance Criteria

- [x] EMS MCP Server is implemented and listens for MCP client requests.
- [x] MCP Client is integrated into the AI microservice and connects to the EMS MCP Server.
- [x] EMS MCP Server forwards requests to the Backend REST APIs and returns responses.
- [x] Tools like `CreateTransaction`, `GetTransactions`, and `AddEvent` are developed and exposed to the AI agent.
- [x] AI Agent is developed with LangChain and supports Memory (conversation history and context management).
- [x] AI Agent successfully uses tools via MCP to perform CRUD operations.
- [x] Error handling and basic logging are implemented for MCP communication.

---

## 🚀 How to Run

1. **Activate the virtual environment:**
   ```bash
   .\venv\Scripts\Activate.ps1
   ```

2. **Install required packages:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the FastAPI server:**
   ```bash
   python main.py
   ```

4. **Run the MCP Inspector:**
   ```bash
   mcp dev .\app\mcp\ems_server.py
   ```
   > 📌 *Note: This connects through SSE (Server-Sent Events) transport.*

---

## 🛠 Tech Stack

- **Python** (FastAPI, LangChain)
- **MCP Protocol**
- **ASP.NET Core 8** (Backend APIs)
- **PostgreSQL** (Database)
- **Docker** (Optional for containerization)

---

## 🧠 Notes

- EMS MCP Server acts as a bridge between the AI microservice and the ASP.NET backend.
- LangChain Memory is used to ensure that the AI agent remembers the ongoing conversation and context.
- Ensure backend APIs are up and running before starting MCP server and client.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.