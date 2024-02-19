import os

def check_deployment_version(event, context):
    # Retrieve the deployment version from environment variables
    deployment_version = os.environ.get('DEPLOYMENT_VERSION')

    if deployment_version:
        return {
            'statusCode': 200,
            'body': f'Deployment version: {deployment_version}'
        }
    else:
        return {
            'statusCode': 404,
            'body': 'Deployment version not found'
        }