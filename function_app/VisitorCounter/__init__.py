import logging
import os
import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity

# Get Cosmos DB details from environment variables
TABLE_NAME = os.environ["COSMOS_TABLE_NAME"]
CONN_STR = os.environ["COSMOS_CONN_STRING"]

# Connect to Cosmos Table
table_service = TableService(connection_string=CONN_STR)

# Ensure the table exists
table_service.create_table(TABLE_NAME, fail_on_exist=False)

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('VisitorCounter function processed a request.')

    try:
        # Use a single row with PartitionKey/RowKey as "Visitor" to store the count
        visitor_entity = table_service.get_entity(TABLE_NAME, partition_key="Visitor", row_key="Counter")
    except:
        # If it doesn’t exist, create it
        visitor_entity = Entity()
        visitor_entity.PartitionKey = "Visitor"
        visitor_entity.RowKey = "Counter"
        visitor_entity.count = 0
        table_service.insert_entity(TABLE_NAME, visitor_entity)

    # Increment the visitor count
    visitor_entity.count += 1
    table_service.update_entity(TABLE_NAME, visitor_entity)

    return func.HttpResponse(
        f"Visitor count: {visitor_entity.count}",
        status_code=200
    )
