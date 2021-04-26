AWS_DEFAULT_REGION ?=us-west-2
AWS_PROFILE ?=PECN_DEV-DevOps

.PHONY: run
run:
	@docker run -it \
	-e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
	-e AWS_ACCESS_KEY_ID=$(shell anvil aws login --idp-realm solar --profile ${AWS_PROFILE} | jq .AccessKeyId -r) \
	-e AWS_SECRET_ACCESS_KEY=$(shell anvil aws login --idp-realm solar --profile ${AWS_PROFILE} | jq .SecretAccessKey -r) \
	-e AWS_SESSION_TOKEN=$(shell anvil aws login --idp-realm solar --profile ${AWS_PROFILE} | jq .SessionToken -r) \
  	-v $(PWD)/output:/home/custodian/output \
  	-v $(PWD)/policy.yaml:/home/custodian/policy.yaml \
     cloudcustodian/c7n run -v -s /home/custodian/output /home/custodian/policy.yaml

.PHONY: schema
schema:
	docker run --rm -it cloudcustodian/c7n schema

.PHONY: validate
validate:
	docker run -it \
  	-v $(PWD)/policy.yaml:/home/custodian/policy.yaml \
	cloudcustodian/c7n validate /home/custodian/policy.yaml

.PHONY: dry-run
dry-run:
	docker run -it \
	-e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
	-e AWS_ACCESS_KEY_ID=$(shell anvil aws login --idp-realm solar --profile ${AWS_PROFILE} | jq .AccessKeyId -r) \
	-e AWS_SECRET_ACCESS_KEY=$(shell anvil aws login --idp-realm solar --profile ${AWS_PROFILE} | jq .SecretAccessKey -r) \
	-e AWS_SESSION_TOKEN=$(shell anvil aws login --idp-realm solar --profile ${AWS_PROFILE} | jq .SessionToken -r) \
  	-v $(PWD)/output:/home/custodian/output \
  	-v $(PWD)/policy.yaml:/home/custodian/policy.yaml \
	cloudcustodian/c7n run --dryrun -s . /home/custodian/policy.yaml

.PHONY: schema-json
schema-json:
	docker run -it \
	cloudcustodian/c7n schema --json > schema.json
