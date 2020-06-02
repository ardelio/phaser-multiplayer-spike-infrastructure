import AWS from 'aws-sdk';

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

  return {
    statusCode: 200
  };
};
