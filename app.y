import streamlit as st
import pandas as pd
import time
import random
import plotly.express as px
from datetime import datetime

# --- CONFIGURATION & MOCK DATA ---
MODELS = ["GPT-4o", "Claude 3.5 Sonnet", "Llama 3.1 (70B)"]
METRICS = ["Latency (s)", "Cost ($)", "Pass Rate (%)", "Hallucination Rate (%)"]

st.set_page_config(page_title="LLM Eval Harness", layout="wide")

# --- AGENT LOGIC (SIMULATED) ---
class EvalHarness:
    def __init__(self):
        if 'history' not in st.session_state:
            st.session_state.history = []

    def run_test_suite(self, task_name, num_runs):
        with st.status(f"Running Eval: {task_name}...", expanded=True) as status:
            st.write("🤖 **TestGenerator:** Creating edge-case prompts...")
            time.sleep(1)
            
            st.write("🏃 **Runner:** Executing prompts across models...")
            new_results = []
            for model in MODELS:
                for _ in range(num_runs):
                    result = {
                        "timestamp": datetime.now().strftime("%H:%M:%S"),
                        "task": task_name,
                        "model": model,
                        "latency": round(random.uniform(0.5, 4.0), 2),
                        "cost": round(random.uniform(0.001, 0.05), 4),
                        # Judge Agent Logic
                        "score": random.choice([0, 1]), 
                        "hallucination": random.choice([0, 0, 0, 1]) # 25% chance
                    }
                    new_results.append(result)
            
            st.session_state.history.extend(new_results)
            status.update(label="Eval Complete!", state="complete", expanded=False)

# --- UI LAYOUT ---
st.title("🛠️ LLM Test & Monitoring Harness")
st.markdown("### *Mini Eval Platform for MLOps*")

eval_engine = EvalHarness()

# Sidebar: Controls
with st.sidebar:
    st.header("Test Configuration")
    task_input = st.text_input("Define Task", value="Summarize Legal Docs")
    num_iterations = st.slider("Iterations per model", 1, 10, 5)
    
    if st.button("🚀 Run Evaluation Suite", use_container_width=True):
        eval_engine.run_test_suite(task_input, num_iterations)

# Main Dashboard
if st.session_state.history:
    df = pd.DataFrame(st.session_state.history)

    # Row 1: Key Metrics
    col1, col2, col3, col4 = st.columns(4)
    avg_latency = df['latency'].mean()
    total_cost = df['cost'].sum()
    pass_rate = (df['score'].mean() * 100)
    
    col1.metric("Avg Latency", f"{avg_latency:.2f}s")
    col2.metric("Total Cost", f"${total_cost:.4f}")
    col3.metric("Avg Pass Rate", f"{pass_rate:.1f}%")
    col4.metric("Regression Risk", "Low" if pass_rate > 70 else "High", delta_color="inverse")

    st.divider()

    # Row 2: Visualizations
    c1, c2 = st.columns(2)
    
    with c1:
        st.subheader("Performance by Model")
        fig_perf = px.bar(df.groupby("model")["score"].mean().reset_index(), 
                          x="model", y="score", color="model", title="Win Rate per Model")
        st.plotly_chart(fig_perf, use_container_width=True)

    with c2:
        st.subheader("Latency vs Cost")
        fig_scatter = px.scatter(df, x="latency", y="cost", color="model", 
                                 hover_data=["task"], title="Efficiency Frontier")
        st.plotly_chart(fig_scatter, use_container_width=True)

    # Row 3: Raw Data & Regression Detector
    st.subheader("🕵️ Regression Detector (Latest Logs)")
    st.dataframe(df.tail(10), use_container_width=True)
    
    if st.button("Clear History"):
        st.session_state.history = []
        st.rerun()
else:
    st.info("👈 Configure your task and click 'Run Evaluation Suite' to begin testing.")
