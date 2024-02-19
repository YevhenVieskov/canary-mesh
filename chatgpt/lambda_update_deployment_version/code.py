import os

def update_deployment_version(event, context):
    # Retrieve the new deployment version from the event payload
    new_deployment_version = event['new_deployment_version']

    try:
        # Update the deployment version in the environment variable
        os.environ['DEPLOYMENT_VERSION'] = new_deployment_version

        return {
            'statusCode': 200,
            'body': f'Deployment version updated to: {new_deployment_version}'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error occurred while updating deployment version: {str(e)}'
        }
