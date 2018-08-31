# SAM Boilerplate

This boilerplate is developed to kick start your Serverless Application Model (SAM) API Gateway Project. You have your API running in just a few minutes.

The project consists of the following files:

```
.
├── Makefile
├── readme.md
├── requirements.txt
├── simple.py
├── settings.example.cfg
├── template.yaml
└── vendored
    └── dependencies.txt
```

# Usage

## Prepare

Ensure you have Docker installed on your machine.

Install/update the following tools:

```
pip install --user --upgrade awscli aws-sam-cli httpie
```

Now create your own settings.cfg and update the variables.

```
cp settings.example.cfg settings.cfg
```

## Download Dependencies

Use the following command to download all dependencies from requirements.txt to a sub folder `/vendored/`. Often the default lambda boto3 is outdated, and with this solution you download the most recent boto3 version which contains all current features.

```
make build
```

Use the next script at the top of your lambda script to ensure the vendored libraries are loaded.

```python
import sys
sys.path.insert(0,"vendored")
```

## Deploy Sandbox

Use the following command to deploy the sandbox. When you are using S3 or DynamoDB to store data, this is already working as an example. The API Gateway and Lambda functions are also deployed, but simply not used. The beautiful thing of sam package, is that it will package the whole directory and upload it to the s3 location. In the packaged.yaml the S3 location is added automatically. 

```
make sandbox
```

## Local Test

To start a local test use the following command. It will show some output with in the end an local endpoint. When changing the template.yaml, a restart is required. When changing just some parts of the code, it's immediatly updated.

```
$ make local
...
2018-08-31 21:05:38  * Running on http://127.0.0.1:3000/ (Press CTRL+C to quit)
```

When it's running, httpie helps with quickly testing your API. Httpie makes it really easy to make GET, PUT, POST requests etc. Check out the docs: https://httpie.org/doc.

```
$ http http://127.0.0.1:3000/SimpleApi
HTTP/1.0 200 OK
Content-Length: 67
Content-Type: application/json
Date: Fri, 31 Aug 2018 18:58:05 GMT
Server: Werkzeug/0.14.1 Python/3.7.0

{
    "result": {
        "vendored-boto3-version": "1.8.5"
    }
}
```

Need more lambda functions? Just copy the `simple.py` and update the code, and add another `AWS::Serverless::Function` resource.

Because it's cloudformation, you can easily add other resources. Makes sure the permissions are updated accordingly. If you're going to use this boilerplate in production, please review the current policies as well. They are way too open.

## Deploy Prod

You can use this if you have a small experiment or personal project, and should be used as an starter for your bigger production deployments.

```
make deploy
```

## Clean

With the following command the vendored folder and stacks are cleaned up.

```
make clean
```

## Next Steps

I want to add a working example with some best practices on how to separate the lambda invoke, a controller and the logic. Also I want to add some tests.

## Debugging

Using Visual Studio Code? Here some docs on how to use debugging.

https://github.com/awslabs/aws-sam-cli/blob/develop/docs/usage.rst