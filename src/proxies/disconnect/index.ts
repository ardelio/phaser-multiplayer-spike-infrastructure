import AWS from 'aws-sdk';

const dynamoDbDocumentClient = new AWS.DynamoDB.DocumentClient();

export const handler = async (event: any) => {
  const { connectionId } = event.requestContext;
  const tableName = process.env.DYNAMOD_DB_TABLE_NAME as string;

  const deleteParams: AWS.DynamoDB.DocumentClient.DeleteItemInput = {
    TableName: tableName,
    Key: {
      ConnectionId: connectionId,
      WorldId: 1
    }
  };
  await dynamoDbDocumentClient.delete(deleteParams).promise();

  return {
    statusCode: 200
  };
};
