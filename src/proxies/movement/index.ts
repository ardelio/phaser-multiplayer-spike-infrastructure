import AWS from 'aws-sdk';

import GameCommunications from '../../GameCommunications';
import ConnectionsTable from '../../ConnectionsTable';

const gameCommunications = new GameCommunications(new AWS.ApiGatewayManagementApi({ endpoint: process.env.API_ENDPOINT }));
const connectionsTable = new ConnectionsTable(new AWS.DynamoDB.DocumentClient());

export const handler = async (event: ILambdaEvent) => {
  const { connectionId: currentConnectionId } = event.requestContext;
  const { data } = JSON.parse(event.body);
  const worldId = 1;
  const connectionIds = await connectionsTable.getWorldConnectionIds(worldId);
  const connectionIdsToMessage = connectionIds.filter(connectionId => connectionId !== currentConnectionId);
  const movementMessage: IGameMovementMessage = {
    action: 'movement',
    data: {
      ...data,
      connectionId: currentConnectionId,
    },
  };
  await gameCommunications.postMessageToAll(connectionIdsToMessage, movementMessage);

  return {
      statusCode: 200,
  };
};
