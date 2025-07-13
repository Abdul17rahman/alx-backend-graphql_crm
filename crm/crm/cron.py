from datetime import datetime


def log_crm_heartbeat():
    now = datetime.now().strftime("%d/%m/%Y-%H:%M:%S")
    with open("/tmp/crm_heartbeat_log.txt", "a") as log_file:
        log_file.write(f"{now} CRM is alive\n")

    # OPTIONAL: GraphQL endpoint check
    try:
        import requests
        response = requests.post(
            "http://localhost:8000/graphql", json={"query": "{ hello }"})
        if response.ok:
            print("GraphQL hello response:", response.json())
        else:
            print("GraphQL hello query failed:", response.status_code)
    except Exception as e:
        print("Failed to query GraphQL hello:", e)
