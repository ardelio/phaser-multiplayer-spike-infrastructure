import AWS from 'aws-sdk';

import ConnectionsTable from '../../ConnectionsTable';

const connectionsTable = new ConnectionsTable(new AWS.DynamoDB.DocumentClient());

export const handler = async (event: ILambdaEvent) => {
  const { connectionId: currentConnectionId } = event.requestContext;
  const worldId = 1;
  const connectionIds = await connectionsTable.getWorldConnectionIds(worldId);
  const connectionIdsToMessage = connectionIds.filter(connectionId => connectionId !== currentConnectionId);
  const currentConnectionsMessage: IGameCurrentConnectionsMessage = {
    action: 'current_connections',
    data: connectionIdsToMessage,
  };

  return {
      statusCode: 200,
      body: JSON.stringify(currentConnectionsMessage),
  };
};
