import logging
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("VisitorCounter function processed a request.")

    name = req.params.get("name")
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            req_body = {}
        name = req_body.get("name")

    if name:
        return func.HttpResponse(f"Hello, {name}! Your visit is counted.")
    else:
        return func.HttpResponse(
            "Hello! Your visit is counted.",
            status_code=200
        )
