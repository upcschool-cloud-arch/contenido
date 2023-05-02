import urllib3
import json
import boto3
http = urllib3.PoolManager()
ec2 = boto3.client('ec2')

webhook = "" # TODO! Set webhook url!!

# GET instance name and type
def get_ec2_info(instance_id):
    response = ec2.describe_instances(InstanceIds=[instance_id])
    instance_tags = response['Reservations'][0]['Instances'][0]['Tags']
    instance_type = response['Reservations'][0]['Instances'][0]['InstanceType']
    instance_name = [x["Value"] for x in instance_tags if x["Key"] == "Name"][0]
    return {'name': instance_name, 'type': instance_type}
    
def lambda_handler(event, context):
    url = webhook
    text = event['Records'][0]['Sns']['Message']
    record_json = json.loads(text)
    instance_id = record_json["detail"]["instance-id"]
    state = record_json["detail"]["state"]
    additional_data = get_ec2_info(instance_id)
    msg = {
        "text": f"Ojo! Una instancia ({instance_id} / {additional_data['name']} / {additional_data['type']}) ha cambiado a estado {state}"
    }
    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST',url, body=encoded_msg)
    print({
        "message_origin_sns": event['Records'][0]['Sns']['Message'], 
        "status_code": resp.status, 
        "response": resp.data
    })