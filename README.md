# clearscore

## Tooling
For this exercise I've decided to use terraform. The code is available in this repository and it's split up into different modules:
- vpc: creates the vpc, subnets, nat gateway, private and public subnets and the rest of the basic infrastructure
- data: creates an S3 bucket where the content of the website can be stored
- web: creates the webserver stack as an autoscaling group so that it can scale up/down as required

## Scaling
Scaling is based on Cloudwatch alarms. It simply uses CPU as a metric to keep things simple, but could be extended to use other metrics.
The thresholds and other parameters can be set using variables.

## Run it!
I'm assuming terraform and the awscli are installed.
*Before starting:*
- change the S3 bucket name in the test.tf environment file
- change the `min_instances` and `max_instances` for the webserver module accordingly

```
# install infrastructure
cd environments/test
terraform apply -auto-approve

# add content to s3 bucket
aws s3 cp ../extra/website_content s3://<bucket_name> --recursive

# restart ec2 instance if it was created before you could upload the content to S3
```

# Approach
For high availability purposes I wanted to use a subnet in each availability zone in the region. The subnets are controlled by a map in the vpc module (I've actually used 2 out of 3 to save costs during tests). I wanted to make sure the instances were in a private subnet, not accessible to the internet. I then created public subnets (one for each AZ I have private subnets in), to allow the load balancer to point to the instances even if they're private. I decided to use a NAT gateway inside an extra public subnet to let the private instances connect to the internet. The best option would be to put 3 NAT gateways - one for each AZ - but I've kept it simple.

Note that for simplicity, the fetch of the web content is performed when the instance is bootstrapped via the userdata script. Of course this isn't ideal, a better option could be EFS.
This means that the first time the first instance of the autoscaling group starts it won't be able to find any content in the bucket. To work this around the easiest option is just to recycle the instances after th content has been uploaded.

I decided to store the terraform state locally as I was the only person accessing the code, but the best option is to store the state in S3.
