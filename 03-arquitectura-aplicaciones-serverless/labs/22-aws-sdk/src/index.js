const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocument } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocument.from(client);

exports.handler = async function (event, context) {
	console.log('EVENT\n' + JSON.stringify(event, null, 2));

	const params = {
		Key: {
			PK: 'item1',
		},
		TableName: 'mi-tabla-cli',
	};

	console.log(params);

	try {
		const response = await ddbDocClient.get(params);
		console.log('Success :', response.Item);
	} catch (err) {
		console.log('Error', err);
	}
};
