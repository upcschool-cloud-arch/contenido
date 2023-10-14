[](.title.coverbg)

# Static websites

[](.illustration)

## The problem

![A typewriter machine with a sheet of paper showing the word WordPress, by Markus Winkler, https://www.pexels.com/photo/white-printer-paper-on-a-vintage-typewriter-4152505/](https://images.pexels.com/photos/4152505/pexels-photo-4152505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2)

Our company runs **dozens of websites** for many different purposes, historically
using WordPress as the main CMS

We have learned there is a new trend for architecting websites called
[JamStack](https://jamstack.org/), that requires no traditional server

We want to take advantage of this **serverless** approach for reducing
the overhead on our operations team

[](.illustration.dense.partial)

## The solution

![S3 icon](images/Arch_Amazon-Simple-Storage-Service_64.svg)

* S3 is an **object-based storage** service that promotes
a **write-once read-many** access pattern

* It was the second service published by AWS
([release note, 2006](https://aws.amazon.com/es/blogs/aws/amazon_s3/))

* At its core, S3 is a **key/value database** for binary data

* The main interface for accessing S3 objects is **HTTPs** with optional
browser full compatibility

* Like any other AWS service, S3 is tightly **integrated with IAM**

[](.illustration.dense.partial)

## Basic concepts

![Sheets of color paper, by pixebay, https://www.pexels.com/photo/multi-colored-folders-piled-up-159519/](https://images.pexels.com/photos/159519/back-to-school-paper-colored-paper-stationery-159519.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2)

* Objects in an account are divided in namespaces called **buckets**,
intended to group related files

* Bucket names are global because they appear as a part of the
object URL, but **objects are regional**

* Objects can store **metadata** and also can be **tagged** for further classification

* Basic list API useful only if the object key **prefix is known**

* Object operations can **trigger events**, attached to SNS, SQS and Lambda

[](#pyramid,.coverbg)

![Crystal pyramid, by Michael Dziedzic, https://unsplash.com/photos/ir5gC4hlqT0](https://images.unsplash.com/photo-1597008641621-cefdcf718025?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1039&q=80)

S3 will become the backbone of the information
architecture in most large systems.

[](.illustration.partial)

## Processing objects (I)

![Robotic facility, by Simon Kadula, https://unsplash.com/photos/8gr6bObQLOI](https://images.unsplash.com/photo-1647427060118-4911c9821b82?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80)

* **Reports** with selected objects can be generated using
[S3 Inventory](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-inventory.html)

* [Batch operations](https://aws.amazon.com/s3/features/batch-operations/) provides a way
to execute a sophisticated **queries and process** each selected object with Lambda

* To **transform content** in real time, [Object lambda](https://aws.amazon.com/s3/features/object-lambda/)
can process files while they are being downloaded

* For analyzing organization-wide **storage and access usage**,
[Storage lense](https://aws.amazon.com/s3/storage-analytics-insights/)
allows data aggregation and exploration

[](.illustration.partial)

## Processing objects (II)

![Automatic facility, from Getty+Unsplash, https://unsplash.com/photos/DVagg4RgTms](https://plus.unsplash.com/premium_photo-1661878008007-7a13bf31c14b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80)

* New objects can be **automatically copied** in the same or in other region using
[Replication](https://aws.amazon.com/s3/features/replication/). Existing ones
can be copied using [Batch replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-batch-replication-batch.html)

* To **reduce access latency** S3 can be integrated with [CloudFront](https://aws.amazon.com/cloudfront/) or
with [Multiregion access points](https://aws.amazon.com/s3/features/multi-region-access-points/)

::: Notes

Access Points also supports [failover controls](https://aws.amazon.com/blogs/aws/new-failover-controls-for-amazon-s3-multi-region-access-points/) for automatically redirect
to a healthy copy of the replicated data.

:::

[](.illustration.dense)

## Costs and pricing

![Squirrel in a tree, by Külli Kittus, https://unsplash.com/photos/qyt0cPByJjs](https://images.unsplash.com/photo-1518770352423-dce09a3d3307?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80)

User pays for the storage used, each API call made
and the traffic outside the object region

Cost may be optimized by using [different tiers](https://aws.amazon.com/s3/storage-classes):

* Standard
* Standard-Infrequent Access
* One Zone-Infrequent Access
* Glacier Instant Retrieval
* Glacier Flexible Retrieval
* Glacier Deep Archive

Choosing **Intelligent-Tiering usually provides the best results**, although it
doesn't manage small files (under 256KB)

[Lifecycle policies](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)
may be used for **more sophisticated** strategies

[](.illustration.dense)

## Security

![A lock with a heart in it, by Snapwire, https://www.pexels.com/photo/fence-love-padlock-lock-padlock-38866/](https://images.pexels.com/photos/38866/pexels-photo-38866.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2)

Use [Block public access](https://aws.amazon.com/s3/features/block-public-access/) and
[S3 Object Ownership](https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html) to **deactivate historical access** mechanisms

[IAM access analyzer](https://aws.amazon.com/iam/features/analyze-access/) provides
**compliance reports** regarding object access permissions

By default, all content is **encrypted at rest**. Also, it is possible to **enforce
HTTPs** access

Several encryption options are available:

* **Amazon managed** keys (SSE-S3)
* **KMS** keys (SSE-KMS)
* **customer-provided** keys (SSE-C)
* Client side encryption

::: Notes

Server-side encryption with KMS keys by default uses a different key for each
object and can suppose a significant cost if

:::

[](.illustration)

## Analytics

![Pencils and rules classified in buckets, by Pixebay, https://www.pexels.com/photo/pencils-in-stainless-steel-bucket-159644/](https://images.pexels.com/photos/159644/art-supplies-brushes-rulers-scissors-159644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2)

Directly executing **queries against objects** stored on S3 can suppose a revolution
in the way data is used in the company.

With [Select](https://docs.aws.amazon.com/AmazonS3/latest/dev/selecting-content-from-objects.html),
a single file can be **consulted using SQL-like** language

For **more sophisticated** queries among multiple files and with join operations,
[Athena](https://aws.amazon.com/athena/) is the most appropriate option.

To extend **data warehousing** to S3,
[Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-getting-started-using-spectrum.html)
provides direct integration with [Redshift](https://aws.amazon.com/redshift/)

::: Notes

In most cases, it is critical to partition the data in relatively small
blocks using the most common filtering pattern (usually, dates).

Also, choosing the right data format can suppose a x10 factor in
performance and cost. The general recommendation is to use ORC columnar
format with Snappy compression.

:::

[](.coverbg)

## Lab time!

![Man tinkering with a glue gun, by Thirdman, https://www.pexels.com/photo/a-man-holding-a-glue-gun-7180746/](https://images.pexels.com/photos/7180746/pexels-photo-7180746.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2)

