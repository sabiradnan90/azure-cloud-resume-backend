import os
import json
from azure.cosmos import CosmosClient, exceptions

def main(req):
    connection_string = os.environ["COSMOS_CONNECTION_STRING"]
    db_name = os.environ["COSMOS_DB_NAME"]
    container_name = os.environ["COSMOS_CONTAINER_NAME"]

    client = CosmosClient.from_connection_string(connection_string)
    database = client.get_database_client(db_name)
    container = database.get_container_client(container_name)

    try:
        # Try to read existing counter item
        item = container.read_item(item="counter", partition_key="counter")
        item["count"] += 1
        container.replace_item(item="counter", body=item)
    except exceptions.CosmosResourceNotFoundError:
        # If not found, create the first counter
        item = {"id": "counter", "count": 1}
        container.create_item(body=item)

    return {
        "status": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"visitor_count": item["count"]})
    }
