import streamlit as st
import requests
from knowledge import load_documents, build_context
from prometheus_client import get_infra_snapshot

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL_NAME = "llama3.2:3b"

st.set_page_config(page_title="Silak Assistant", page_icon="🛰️")
st.title("🛰️ Silak Assistant")
st.caption("Assistant Intelligent de l'infrastructure Silak-IT")

if "documents" not in st.session_state:
    st.session_state.documents = load_documents()

if "messages" not in st.session_state:
    st.session_state.messages = []

INFRA_KEYWORDS = ["état", "infrastructure", "vm", "monitoring", "prometheus", "up", "down", "disponib"]

def is_infra_question(question):
    q = question.lower()
    return any(kw in q for kw in INFRA_KEYWORDS)

def call_ollama(prompt):
    response = requests.post(
        OLLAMA_URL,
        json={"model": MODEL_NAME, "prompt": prompt, "stream": False},
        timeout=60,
    )
    response.raise_for_status()
    return response.json()["response"]

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

if question := st.chat_input("Posez votre question sur l'infrastructure Silak-IT..."):
    st.session_state.messages.append({"role": "user", "content": question})
    with st.chat_message("user"):
        st.markdown(question)

    with st.chat_message("assistant"):
        with st.spinner("Silak Assistant réfléchit..."):
            extra_context = ""
            if is_infra_question(question):
                extra_context = f"\n\nÉtat actuel de l'infrastructure (Prometheus) :\n{get_infra_snapshot()}"

            doc_context = build_context(question, st.session_state.documents)

            prompt = f"""Tu es Silak Assistant, l'assistant intelligent de l'infrastructure Silak-IT.
Réponds de façon claire et concise en te basant sur le contexte fourni.

Contexte documentaire :
{doc_context}
{extra_context}

Question : {question}
Réponse :"""

            answer = call_ollama(prompt)
            st.markdown(answer)
            st.session_state.messages.append({"role": "assistant", "content": answer})
