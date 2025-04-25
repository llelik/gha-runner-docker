# gha-runner-docker
GH Actions docker container with NetApp Ansible libs and collections

## Requirements  
### you need to set in .env file:  
- REPO= repository name
- REG_TOKEN= token obtained either via GH API or on Add Runner page. Configure.sh link is generated on container startup.
- REPO_OWNER= repository owner
- RUNNER_LABELS= labels for you runner to select in the workflow. Set here or on your GH page in Runners settings section

### Runner registers itself on first start (but need REG_TOKEN to provide in .env)  

## Python libraries included:  
- netapp.ontap (latest)

## Python  
- ver 3.12

## Ansible  
- Latest available for Python 3.12
- installed with pip3.12