import AWS from 'aws-sdk';

import { ILambdaEvent } from '../../types';

const apiGatewayManagementApi = new AWS.ApiGatewayManagementApi({ endpoint: process.env.API_ENDPOINT });
const dynamoDbDocumentClient = new AWS.DynamoDB.DocumentClient();

export const handler = async (event: ILambdaEvent) => {
  const { connectionId: currentConnectionId } = event.requestContext;
  const { data } = JSON.parse(event.body) as IMovementMessage;
  const worldId = 1;

  const connectionIds = await getWorldConnectionIds(worldId)
  await updateOtherConnections(currentConnectionId, connectionIds, data);

  return {
      statusCode: 200,
  };
};

async function getWorldConnectionIds(worldId: number) : Promise<string[]> {
  const tableName = process.env.DYNAMO_DB_TABLE_NAME as string;

  const queryParams: AWS.DynamoDB.DocumentClient.QueryInput = {
    TableName: tableName,
    KeyConditionExpression: 'WorldId = :worldId',
    ExpressionAttributeValues: {
      ':worldId': worldId
    }
  }
  const response = await dynamoDbDocumentClient.query(queryParams).promise();

  return (response.Items || []).map(item => item.ConnectionId);
}

async function updateOtherConnections(currentConnectionId: string, connectionIds: string[], data: IMovementMessage['data']) : Promise<void> {
  const promises = connectionIds.map(async connectionId => {
    if (connectionId === currentConnectionId) {
      return
    }

    const params = {
      ConnectionId: connectionId,
      Data: JSON.stringify({ action: 'movement', data: { ...data, connectionId: currentConnectionId }}),
    };

    try {
      await apiGatewayManagementApi.postToConnection(params).promise();
    } catch (error) {
      console.error(error);
    }
  });

  await Promise.all(promises);
}

interface IMovementMessage {
  action: string;
  data: object;
}
