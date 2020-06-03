import { ILambdaEvent } from "../../types";

export const handler = async (event: ILambdaEvent) => {
  const { connectionId } = event.requestContext;
  const connectonIdMessage: IConnectionIdMessage = {
    action: 'connection_id',
    data: connectionId
  };
  return {
    statusCode: 200,
    body: JSON.stringify(connectonIdMessage),
  };
};

interface IConnectionIdMessage {
  action: string;
  data: string;
}
