import boto3

def remove_previous_canary_components(event, context):
    # Initialize boto3 clients for ECS, ELB, etc.
    ecs_client = boto3.client('ecs')
    elbv2_client = boto3.client('elbv2')
    # Other clients as needed

    # Retrieve information about previous canary deployment
    # (This could be passed as part of the event payload or stored elsewhere)
    previous_canary_service_name = event['previous_canary_service_name']
    previous_canary_task_definition = event['previous_canary_task_definition']
    # Retrieve other relevant information

    try:
        # Update ECS service to desired task definition
        ecs_client.update_service(
            cluster='your-cluster',
            service=previous_canary_service_name,
            taskDefinition=previous_canary_task_definition,
            desiredCount=0  # Set desired count to 0 to stop the service
        )

        # Deregister targets from load balancer (if applicable)
        elbv2_client.deregister_targets(
            TargetGroupArn='your-target-group-arn',
            Targets=[
                {
                    'Id': 'instance-id',  # Replace with actual instance id
                    'Port': 80             # Replace with actual port
                },
                # Additional targets as needed
            ]
        )

        # Add any other cleanup steps here

        return {
            'statusCode': 200,
            'body': 'Previous canary components removed successfully.'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error occurred: {str(e)}'
        }
