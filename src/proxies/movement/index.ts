import AWS from 'aws-sdk';

const apiGatewayManagementApi = new AWS.ApiGatewayManagementApi({ endpoint: process.env.API_ENDPOINT });
const dynamoDbDocumentClient = new AWS.DynamoDB.DocumentClient();

export const handler = async (event: any) => {
  const { connectionId: movingConnectionId } = event.requestContext;
  const { data } = JSON.parse(event.body);
  const tableName = process.env.DYNAMOD_DB_TABLE_NAME as string;

  const queryParams: AWS.DynamoDB.DocumentClient.QueryInput = {
    TableName: tableName,
    KeyConditionExpression: 'WorldId = :worldId',
    ExpressionAttributeValues: {
      ':worldId': 1
    }
  }
  const queryResponse = await dynamoDbDocumentClient.query(queryParams).promise();

  const connectionIds = (queryResponse.Items || []).map(item => item.ConnectionId);

  const promises = connectionIds.map(async connectionId => {
    if (connectionId === movingConnectionId) {
      return
    }

    const params = {
      ConnectionId: connectionId,
      Data: JSON.stringify({ action: 'movement', data: { ...data, connectionId: movingConnectionId }}),
    };
    console.log('Sending postition to: ', connectionId);
    let postToConnectionResponse;
    try {
      postToConnectionResponse = await apiGatewayManagementApi.postToConnection(params).promise();
    } catch (error) {
      console.error(error);
    }

    return postToConnectionResponse;
  });

  await Promise.all(promises);


  const response = {
      statusCode: 200,
  };
  return response;
};
