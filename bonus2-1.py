import json
import boto3

def lambda_handler(event, context):
    lb = boto3.client('elbv2')
    ec2 = boto3.client('ec2', region_name=ap-south-1)
    lb1 = lb.describe_target_health(TargetGroupArn='')
    idlist = []
    for bals in lb1['TargetHealthDescriptions']:
      idlist.append(bals['Target']['Id'])
    print(idlist)
    client.stop_instances(InstanceIds=[idlist])
    waiter=client.get_waiter('instance_stopped')
    waiter.wait(InstanceIds=[idlist])
    client.modify_instance_attribute(InstanceId=idlist, Attribute='instanceType', Value='m3.xlarge')
    client.start_instances(InstanceIds=[idlist])
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
