import AWS from 'aws-sdk';
import ConnectionsTable from '../../ConnectionsTable';
import GameCommunications from '../../GameCommunications';

const gameCommunications = new GameCommunications(new AWS.ApiGatewayManagementApi({ endpoint: process.env.API_ENDPOINT }));
const connectionsTable = new ConnectionsTable(new AWS.DynamoDB.DocumentClient());

export const handler = async (event: ILambdaEvent) => {
  const { connectionId } = event.requestContext;
  const worldId = 1;
  const connectedMessage: IGameConnectedMessage = {
    action: 'connected',
    data: connectionId,
  };

  const connectionIds = await connectionsTable.getWorldConnectionIds(worldId);
  await connectionsTable.connected(worldId, connectionId);
  await gameCommunications.postMessageToAll(connectionIds, connectedMessage);

  return {
    statusCode: 200
  };
};
