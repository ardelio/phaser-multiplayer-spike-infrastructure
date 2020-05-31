export const handler = async (event: any) => {
  const { connectionId } = event.requestContext;
  return {
    statusCode: 200,
    body: JSON.stringify({ action: 'connection_id', data: connectionId }),
  };
};
