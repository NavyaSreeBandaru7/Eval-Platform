# Eval-Platform
# 🛠️ LLM Test & Monitoring Harness (Mini-Eval Platform)

A specialized MLOps tool designed to evaluate, monitor, and compare Large Language Models (LLMs) across multiple performance dimensions including quality, cost, and latency.

## 🚀 Key Features
- **Multi-Model Comparison:** Benchmark models like GPT-4, Claude, and Llama side-by-side.
- **Agentic Workflow:**
  - **TestGenerator:** Automatically creates edge-case prompts.
  - **Runner:** Handles concurrent execution across different model providers.
  - **Judge:** Uses LLM-as-a-Judge logic to score responses for accuracy.
  - **Regression-Detector:** Flags performance drops compared to previous runs.
- **Interactive Dashboard:** Built with Streamlit and Plotly for real-time visualization of cost-efficiency frontiers.

## 🛠️ Tech Stack
- **Frontend/Dashboard:** Streamlit
- **Data Analysis:** Pandas, NumPy
- **Visualizations:** Plotly Express
- **Persistence:** SQLite (Session-based)

## 📦 Installation & Setup
1. Clone the repository:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/llm-eval-harness.git](https://github.com/YOUR_USERNAME/llm-eval-harness.git)
   cd llm-eval-harness
