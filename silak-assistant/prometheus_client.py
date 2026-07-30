import requests

PROMETHEUS_URL = "http://192.168.40.10:9090"

def query_prometheus(promql_query):
    """Exécute une requête PromQL et retourne le résultat brut."""
    try:
        response = requests.get(
            f"{PROMETHEUS_URL}/api/v1/query",
            params={"query": promql_query},
            timeout=5,
        )
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        return {"status": "error", "error": str(e)}

def get_infra_snapshot():
    """Récupère un aperçu simple de l'état des VM surveillées (up/down)."""
    result = query_prometheus("up")
    if result.get("status") != "success":
        return "Impossible de contacter Prometheus."
    lines = []
    for item in result["data"]["result"]:
        instance = item["metric"].get("instance", "inconnu")
        value = item["value"][1]
        etat = "UP" if value == "1" else "DOWN"
        lines.append(f"- {instance} : {etat}")
    return "\n".join(lines) if lines else "Aucune cible trouvée."
