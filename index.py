import json
import boto3

glue_client = boto3.client('glue')

def lambda_handler(event, context):
    """
    Triggered by S3 event when a file is uploaded to employee_data/input/ prefix.
    Invokes the Glue job to process the uploaded file.
    """
    try:
        # Extract bucket and key from S3 event
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        
        print(f"File uploaded: s3://{bucket}/{key}")
        
        # Trigger Glue job
        response = glue_client.start_job_run(
            JobName='salary-filter-job'
        )
        
        print(f"Started Glue job run: {response['JobRunId']}")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Glue job triggered successfully',
                'jobRunId': response['JobRunId']
            })
        }
    except Exception as e:
        print(f"Error triggering Glue job: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
