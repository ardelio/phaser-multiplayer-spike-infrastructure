export const handler = async (event: ILambdaEvent) => {
  const { connectionId } = event.requestContext;
  const connectonIdMessage: IGameConnectionIdMessage = {
    action: 'connection_id',
    data: connectionId
  };
  return {
    statusCode: 200,
    body: JSON.stringify(connectonIdMessage),
  };
};
