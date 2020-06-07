class ConnectionsTable {
  private db: AWS.DynamoDB.DocumentClient;
  private tableName: string;

  constructor(db: AWS.DynamoDB.DocumentClient) {
    this.db = db;
    this.tableName = process.env.DYNAMO_DB_TABLE_NAME as string;
  }

  async connected(worldId: number, connectionId: string) : Promise<void> {
    const params: AWS.DynamoDB.DocumentClient.PutItemInput = {
      TableName: this.tableName,
      Item: {
        ConnectionId: connectionId,
        WorldId: worldId
      }
    };
    await this.db.put(params).promise();
  }

  async disconnected(worldId: number, connectionId:string) : Promise<void> {
    const params: AWS.DynamoDB.DocumentClient.DeleteItemInput = {
      TableName: this.tableName,
      Key: {
        ConnectionId: connectionId,
        WorldId: worldId
      }
    };
    await this.db.delete(params).promise();
  }

  async getWorldConnectionIds(worldId: number) : Promise<string[]> {
    const params: AWS.DynamoDB.DocumentClient.QueryInput = {
      TableName: this.tableName,
      KeyConditionExpression: 'WorldId = :worldId',
      ExpressionAttributeValues: {
        ':worldId': worldId
      }
    }
    const response = await this.db.query(params).promise();

    return (response.Items || []).map(item => item.ConnectionId);
  }
}

export default ConnectionsTable;