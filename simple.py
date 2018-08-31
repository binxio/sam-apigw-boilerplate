import sys
# first look in the vendored folder for dependencies
sys.path.insert(0,"vendored")
import boto3
import requests
import json
import os
import logging
from mylib import MyClass

logger = logging.getLogger()
logger.setLevel(logging.INFO)

S3_BUCKET = os.environ['S3_BUCKET']
DDB_TABLE = os.environ['DDB_TABLE']

def lambda_handler(event, context):

    mc = MyClass()
    a = mc.test()
    
    result = {
        "vendored-boto3-version": boto3.__version__
    }

    return {'statusCode': 200,
            'body': json.dumps({"result": result}, indent=4),
            'headers': {'Content-Type': 'application/json'}}

if __name__ == "__main__":
    result = lambda_handler({}, {})
    print(result)
