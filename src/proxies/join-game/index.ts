import AWS from 'aws-sdk';

const apiGatewayManagementApi = new AWS.ApiGatewayManagementApi({ endpoint: process.env.API_ENDPOINT });
const dynamoDbDocumentClient = new AWS.DynamoDB.DocumentClient();

export const handler = async (event: any) => {
  const { connectionId } = event.requestContext;
  const tableName = process.env.DYNAMOD_DB_TABLE_NAME as string;

  const putParams: AWS.DynamoDB.DocumentClient.PutItemInput = {
    TableName: tableName,
    Item: {
      ConnectionId: connectionId,
      WorldId: 1
    }
  };
  await dynamoDbDocumentClient.put(putParams).promise();

  const queryParams: AWS.DynamoDB.DocumentClient.QueryInput = {
    TableName: tableName,
    KeyConditionExpression: 'WorldId = :worldId',
    ExpressionAttributeValues: {
      ':worldId': 1
    }
  }
  const response = await dynamoDbDocumentClient.query(queryParams).promise();

  const connectionIds = (response.Items || []).map(item => item.ConnectionId);

  const promises = connectionIds.map(async connectionId => {
    const params = {
      ConnectionId: connectionId,
      Data: JSON.stringify(connectionIds),
    };
    console.log('Sending current Connection IDS to: ', connectionId);
    let response;
    try {
      response = await apiGatewayManagementApi.postToConnection(params).promise();
    } catch (error) {
      console.error(error);
      const deleteParams: AWS.DynamoDB.DocumentClient.DeleteItemInput = {
        TableName: tableName,
        Key: {
          WorldId: 1,
          ConnectionId: connectionId
        }
      };
      await dynamoDbDocumentClient.delete(deleteParams).promise();
    }

    return response;
  });

  await Promise.all(promises);

  return {
    statusCode: 200
  };
};
