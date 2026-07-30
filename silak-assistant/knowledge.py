import os
import glob

DOC_SOURCES = [
    "/opt/silak-it/docs/**/*.md",
    "/opt/silak-it/ansible/roles/*/README.md",
    "/opt/silak-it/README.md",
]

def load_documents():
    """Charge tous les documents Markdown en mémoire (nom, contenu)."""
    documents = []
    for pattern in DOC_SOURCES:
        for path in glob.glob(pattern, recursive=True):
            if os.path.isfile(path):
                with open(path, "r", encoding="utf-8") as f:
                    documents.append({"path": path, "content": f.read()})
    return documents

def search_documents(query, documents, max_results=3):
    """Recherche simple par mots-clés : score = nb de mots de la question présents dans le doc."""
    keywords = [w.lower() for w in query.split() if len(w) > 2]
    scored = []
    for doc in documents:
        content_lower = doc["content"].lower()
        score = sum(content_lower.count(kw) for kw in keywords)
        if score > 0:
            scored.append((score, doc))
    scored.sort(key=lambda x: x[0], reverse=True)
    return [doc for _, doc in scored[:max_results]]

def build_context(query, documents):
    relevant = search_documents(query, documents)
    if not relevant:
        return ""
    context = "\n\n".join(
        f"### Source: {doc['path']}\n{doc['content']}" for doc in relevant
    )
    return context
