class GameCommunications {
  private apiGatewayManagementApi: AWS.ApiGatewayManagementApi;

  constructor(apiGatewayManagementApi: AWS.ApiGatewayManagementApi) {
    this.apiGatewayManagementApi = apiGatewayManagementApi;
  }

  async postMessageToAll(connectionIds: string[], gameMessage: IGameMessage) : Promise<void[]> {
    const promises = connectionIds.map(async connectionId => {
      const params = {
        ConnectionId: connectionId,
        Data: JSON.stringify(gameMessage),
      };

      try {
        await this.apiGatewayManagementApi.postToConnection(params).promise();
        console.debug(`* Sent message: ${JSON.stringify(gameMessage)}`);
      } catch (error) {
        console.error(error);
      }
    });

    return Promise.all(promises);
  }
}

export default GameCommunications;