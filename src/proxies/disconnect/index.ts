import AWS from 'aws-sdk';
import { ILambdaEvent } from '../../types';

const dynamoDbDocumentClient = new AWS.DynamoDB.DocumentClient();

export const handler = async (event: ILambdaEvent) => {
  const { connectionId } = event.requestContext;
  const { DYNAMO_DB_TABLE_NAME: tableName } = process.env;

  if (typeof tableName === 'undefined') {
    throw new Error('DYNAMO_DB_TABLE_NAME is not defined in the environment');
  }

  const params: AWS.DynamoDB.DocumentClient.DeleteItemInput = {
    TableName: tableName,
    Key: {
      ConnectionId: connectionId,
      WorldId: 1
    }
  };
  await dynamoDbDocumentClient.delete(params).promise();

  return {
    statusCode: 200
  };
};
