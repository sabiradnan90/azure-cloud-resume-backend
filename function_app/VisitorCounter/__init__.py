import azure.functions as func
import json
import os
from azure.cosmos import CosmosClient, exceptions

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        # Environment variables (set these in Function App settings)
        url = os.environ["COSMOS_DB_URL"]
        key = os.environ["COSMOS_DB_KEY"]
        db_name = os.environ.get("COSMOS_DB_NAME", "cloudresume")
        container_name = os.environ.get("COSMOS_CONTAINER_NAME", "visitorCounter")

        # Connect to Cosmos DB
        client = CosmosClient(url, credential=key)
        database = client.get_database_client(db_name)
        container = database.get_container_client(container_name)

        # Read or create visitor counter document
        item_id = "counter"
        try:
            item = container.read_item(item=item_id, partition_key=item_id)
            item["count"] += 1
            container.replace_item(item=item_id, body=item)
        except exceptions.CosmosResourceNotFoundError:
            item = {"id": item_id, "count": 1}
            container.create_item(body=item)

        return func.HttpResponse(
            json.dumps({"count": item["count"]}),
            mimetype="application/json"
        )

    except Exception as e:
        return func.HttpResponse(
            json.dumps({"error": str(e)}),
            status_code=500,
            mimetype="application/json"
        )
