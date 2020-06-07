interface ILambdaEvent {
  requestContext: {
    connectionId: string;
  };
  body: string;
};