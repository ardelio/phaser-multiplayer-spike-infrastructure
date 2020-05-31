import AWS from 'aws-sdk';

let connectionIds: string[] = [];

export const handler = async (event: any) => {
  const { connectionId } = event.requestContext;
  const { API_ENDPOINT } = process.env;

  connectionIds.push(connectionId);

  const apiGatewayManagementApi = new AWS.ApiGatewayManagementApi({ endpoint: API_ENDPOINT });

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
      connectionIds = connectionIds.filter(id => id !== connectionId);
    }

    return response;
  });

  await Promise.all(promises);

  return {
    statusCode: 200
  };
};
