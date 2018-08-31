include settings.cfg

.PHONY: build sandbox deploy clean

# installs all dependencies to vendored folder
build:
	rm -rf vendored ;
	mkdir -p vendored ;
	docker run -v $(shell pwd):/wd python /bin/bash -c "pip install --quiet -r /wd/requirements.txt -t /wd/vendored/"

# install the stack for sandbox purposes
sandbox:
	sam package --template-file template.yaml --s3-bucket $(S3_BUCKET) --output-template-file packaged.yaml ;
	aws cloudformation deploy --stack-name $(SANDBOX_NAME) --template-file packaged.yaml --capabilities CAPABILITY_IAM

# run the api gateway locally with access to sandbox resources
local:
	S3_BUCKET=$(shell aws cloudformation describe-stack-resources --stack-name $(SANDBOX_NAME) --logical-resource-id MyBucket --query "StackResources[0].PhysicalResourceId" --output text) \
	DDB_TABLE=$(shell aws cloudformation describe-stack-resources --stack-name $(SANDBOX_NAME) --logical-resource-id MyTable --query "StackResources[0].PhysicalResourceId" --output text) \
	sam local start-api --profile $(AWS_PROFILE)

# deploy the production platform
deploy:
	sam package --template-file template.yaml --s3-bucket $(S3_BUCKET) --output-template-file packaged.yaml ;
	aws cloudformation deploy --stack-name $(LIVE_NAME) --template-file packaged.yaml --capabilities CAPABILITY_IAM

# clean up everything
clean:
	rm -rf vendored ;
	aws cloudformation delete-stack --stack-name $(SANDBOX_NAME)
	aws cloudformation delete-stack --stack-name $(LIVE_NAME)