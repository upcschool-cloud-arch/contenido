const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocument } = require('@aws-sdk/lib-dynamodb');

const { PublishCommand } = require('@aws-sdk/client-sns');
const { SNSClient } = require('@aws-sdk/client-sns');

const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocument.from(client);

const snsClient = new SNSClient();

exports.handler = async function (event, context) {
	console.log('EVENT\n' + JSON.stringify(event, null, 2));

	const key = event.Records[0].s3.object.key;
	const date = event.Records[0].eventTime;

	const params = {
		TableName: 'mi-tabla-cli',
		Item: {
			PK: key,
			Fecha: date,
		},
	};

	console.log(params);

	try {
		const response = await ddbDocClient.put(params);
		console.log('Success :', response.Item);

		const snsParams = {
			Message: `Se subio un nuevo archivo ${key}`,
			TopicArn: 'arn:aws:sns:us-east-1:XXXX:mi-topico',
		};

		await await snsClient.send(new PublishCommand(snsParams));
	} catch (err) {
		console.log('Error', err);
	}
};
