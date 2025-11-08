import os
import json
from azure.cosmos import CosmosClient, exceptions

COSMOS_CONNECTION_STRING = os.environ["COSMOS_CONNECTION_STRING"]
COSMOS_DB_NAME = os.environ["COSMOS_DB_NAME"]
COSMOS_CONTAINER_NAME = os.environ["COSMOS_CONTAINER_NAME"]

client = CosmosClient.from_connection_string(COSMOS_CONNECTION_STRING)
database = client.get_database_client(COSMOS_DB_NAME)
container = database.get_container_client(COSMOS_CONTAINER_NAME)

def main(req):
    try:
        item = container.read_item(item="counter", partition_key="counter")
        item["count"] += 1
        container.replace_item(item="counter", body=item)
    except exceptions.CosmosResourceNotFoundError:
        item = {"id": "counter", "count": 1}
        container.create_item(body=item)
    
    return json.dumps({"visitor_count": item["count"]})
