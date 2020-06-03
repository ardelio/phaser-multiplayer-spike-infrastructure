export default interface ILambdaEvent {
  requestContext: {
    connectionId: string;
  };
  body: string;
};