import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

mixin Config {
  static ValueNotifier<GraphQLClient> initializeClient(String _token) {
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        // MUST-CONFIG
        // Your link web socket hasura
        link: WebSocketLink(
          'wss://monseytest.herokuapp.com/v1/graphql',
          config: SocketClientConfig(
              autoReconnect: true,
              inactivityTimeout: const Duration(seconds: 60),
              initialPayload: <String, dynamic>{
                'headers': {
                  'Authorization': 'Bearer $_token',
                  'content-type': 'application/json',
                }
              }),
        ),
      ),
    );
    return client;
  }
}
