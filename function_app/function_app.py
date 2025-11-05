import logging
import azure.functions as func
from azure.cosmos import CosmosClient
from azure.identity import DefaultAzureCredential
import os

COSMOS_ACCOUNT = os.environ['COSMOS_DB_ACCOUNT']
DATABASE_NAME = os.environ['COSMOS_DB_DATABASE']
CONTAINER_NAME = os.environ['COSMOS_DB_CONTAINER']

endpoint = f"https://{COSMOS_ACCOUNT}.documents.azure.com:443/"
credential = DefaultAzureCredential()  # Uses system-assigned identity
client = CosmosClient(endpoint, credential=credential)

db = client.get_database_client(DATABASE_NAME)
container = db.get_container_client(CONTAINER_NAME)

def main(req: func.HttpRequest) -> func.HttpResponse:
    visitor_id = 'counter'
    try:
        item = container.read_item(item=visitor_id, partition_key=visitor_id)
        item['visits'] += 1
        container.upsert_item(item)
    except Exception:
        item = {'id': visitor_id, 'visits': 1}
        container.create_item(item)
    return func.HttpResponse(f"{{'visits': {item['visits']}}}", mimetype='application/json')
