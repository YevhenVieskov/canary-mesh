import boto3

def rollbackto_previous_canary(event, context):
    # Initialize boto3 clients for ECS
    ecs_client = boto3.client('ecs')
    
    # Retrieve information about the previous canary deployment
    # (This could be passed as part of the event payload or stored elsewhere)
    previous_canary_service_name = event['previous_canary_service_name']
    previous_canary_task_definition = event['previous_canary_task_definition']
    
    try:
        # Update ECS service to use the previous canary task definition
        response = ecs_client.update_service(
            cluster='your-cluster',
            service=previous_canary_service_name,
            taskDefinition=previous_canary_task_definition
        )
        
        # Check if the service update was successful
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            return {
                'statusCode': 200,
                'body': 'Rollback to previous canary task definition successful'
            }
        else:
            return {
                'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
                'body': 'Rollback failed'
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error occurred during rollback: {str(e)}'
        }