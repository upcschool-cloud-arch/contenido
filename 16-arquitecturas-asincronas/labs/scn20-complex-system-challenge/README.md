# Complex system challenge

Design and build a solution that simulates the generation of reports in our company. The components involved in it would be:

## Phase 1

* A VPC with all the required subnets, routes, security groups, etc.
* A front-end component with an ALB + ASG + RDS (the last one is optional). Proper configuration of the security group chain should be in place. The ASG may run a simple nginx without a real application, or perhaps any of the Real World implementations if you feel brave enough. This alternative implementation uses MySQL, in case you want to run RDS.

## Phase 2

* Create an SQS queue for dropping messages that request report creation. Configure it with FIFO and Dead Letter Queues (optional).
* Update the front-end ASG with a role that allows instances to write to that queue. Update the ASG user-data to execute a simple script every 20 seconds that puts a message in the queue.
* Create a report bucket on S3.
* Create another ASG that reads from the queue and uploads a sample file with a random id to the S3 bucket, emulating the creation of the report. Delete the message from the queue once the process is completed. The instances in this ASG will need permissions to access both SQS and S3.
