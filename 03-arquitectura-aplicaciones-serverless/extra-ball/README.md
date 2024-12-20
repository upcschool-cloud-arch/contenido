# Extra ball

## Additional learning resources

* Serverless is a fuzzy concept, but if you require a MySQL / Postgres compatible database that scales vertically in milliseconds (O_O!) check [Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html).
* Implementing a lambda-based application with an RDS backend comes with its own challenges. Do some research (for example, read [this post about connection issues](https://faiqahsan.medium.com/how-to-solve-lambda-and-rds-database-connection-issues-for-nodejs-application-7c9a22362160)) before taking this path.
* Many AI-related services can be considered serverless. For example, [Transcribe](https://aws.amazon.com/transcribe) can help for transforming audio into text, or [Polly](https://aws.amazon.com/polly) can do the opposite. Others are focused on computer vision, like [Textract](https://aws.amazon.com/textract) for extracting textual data from images (including particular cases, like invoices).
* The most popular choices for developing lambda-based applications are [AWS SAM](./AWS-SAM.md), [Serverless Framework](https://www.serverless.com) and [AWS CDK](https://youtu.be/zOwYSX6ExSY?si=peJtI6O3oJe0Wu2C). Check them to choose your own favorite.
* A very nice post comparing the serverless compute offer of the three vendors: [serverless showdown](https://www.pluralsight.com/resources/blog/cloud/serverless-showdown-aws-lambda-vs-azure-functions-vs-google-cloud-functions).

## Additional labs

* We have added an especial lab: the description of a simple Minimum Viable Product intended to provide [support for expense management](../labs/80-arch-problem/). Feel free to draw the design of a serverless architecture that allows the company to run at any scale that product, while minimizing the operation load.
* AWS has a very complete [serverless application workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/b34eab03-4ebe-46c1-bc63-cd2d975d8ad4/en-US). It provides good insights on many different interesting projects, so if you have some time (it is quite long) don't hesitate to try it. *Personal note from Javi: Cognito deserves more attention from AWS, but it is still an option if other more expensive services like Okta are not available*.
