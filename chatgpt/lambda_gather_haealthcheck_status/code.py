import requests

def gather_healthcheck_status(event, context):
    # Replace 'health_check_url' with the actual URL of your application's health check endpoint
    health_check_url = 'https://example.com/health'
    
    try:
        # Send a GET request to the health check endpoint
        response = requests.get(health_check_url)

        # Check if the response status code indicates success (2xx)
        if response.status_code >= 200 and response.status_code < 300:
            return {
                'statusCode': 200,
                'body': 'Application is healthy'
            }
        else:
            return {
                'statusCode': response.status_code,
                'body': 'Application health check failed'
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error occurred while checking health status: {str(e)}'
        }