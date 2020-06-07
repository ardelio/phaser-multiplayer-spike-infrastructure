import AWS from 'aws-sdk';
import ConnectionsTable from '../../ConnectionsTable';
import GameCommunications from '../../GameCommunications';

const connectionsTable = new ConnectionsTable(new AWS.DynamoDB.DocumentClient());
const gameCommunications = new GameCommunications(new AWS.ApiGatewayManagementApi({ endpoint: process.env.API_ENDPOINT }));

export const handler = async (event: ILambdaEvent) => {
  const { connectionId } = event.requestContext;
  const worldId = 1;
  const disconnectedMessage: IGameDisconnectedMessage = {
    action: 'disconnected',
    data: connectionId,
  }

  await connectionsTable.disconnected(worldId, connectionId);
  const connectionIds = await connectionsTable.getWorldConnectionIds(worldId);
  await gameCommunications.postMessageToAll(connectionIds, disconnectedMessage);

  return {
    statusCode: 200
  };
};
