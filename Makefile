
.PHONY: run
run:
	docker run -it \
	-e AWS_ACCESS_KEY_ID=$(anvil aws login --idp-realm solar --profile davinci_dev-developer | jq .AccessKeyId -r) \
	-e AWS_SECRET_ACCESS_KEY=$(anvil aws login --idp-realm solar --profile davinci_dev-developer | jq .SecretAccessKey -r) \
	-e AWS_SESSION_TOKEN=$(anvil aws login --idp-realm solar --profile davinci_dev-developer | jq .SessionToken -r) \
  	-v $(pwd)/output:/home/custodian/output \
  	-v $(pwd)/policy.yml:/home/custodian/policy.yml \
     cloudcustodian/c7n run -v -s /home/custodian/output /home/custodian/policy.yml

.PHONY: schema
schema:
	docker run --rm -it cloudcustodian/c7n schema

.PHONY: validate
validate:
	docker run -it \
  	-v $(pwd)/output:/home/custodian/output \
  	-v $(pwd)/policy.yml:/home/custodian/policy.yml \
	cloudcustodian/c7n validate /home/custodian/policy.yml

.PHONY: dry-run
dry-run:
	docker run -it \
  	-v $(pwd)/output:/home/custodian/output \
  	-v $(pwd)/policy.yml:/home/custodian/policy.yml \
	cloudcustodian/c7n run --dryrun -s . /home/custodian/policy.yml

.PHONY: schema-json
schema-json:
	docker run -it \
	cloudcustodian/c7n schema --json > schema.json
