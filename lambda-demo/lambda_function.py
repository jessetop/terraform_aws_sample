import json
import os

def lambda_handler(event, context):
    """
    Demo Lambda function that returns a simple response
    """
    
    # Get environment variable
    environment = os.environ.get('ENVIRONMENT', 'unknown')
    
    # Log the incoming event
    print(f"Received event: {json.dumps(event)}")
    
    # Create response
    response_body = {
        'message': 'Hello from Lambda!',
        'environment': environment,
        'event_source': event.get('source', 'direct-invoke'),
        'timestamp': context.aws_request_id if context else 'local-test'
    }
    
    # Handle API Gateway events
    if 'httpMethod' in event:
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(response_body)
        }
    
    # Handle direct invocation
    return response_body