import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const productgraphQL = """query GetConnections{
                            continents{
                              name
                                 }
                              }
                              """;
// **Note**   UseFul links to learn graphQL
// **Note**   https://blog.waldo.io/graphql-in-flutter/
// **Note**   https://blog.logrocket.com/using-graphql-with-flutter-a-tutorial-with-examples/
// **Note**   https://hasura.io/learn/graphql/flutter-graphql/introduction/
// **Note**   https://www.youtube.com/watch?v=Re7FPa3wzN0&t=404s
void main() {
  runApp(
    const MaterialApp(
      title: "GQL App",
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //url
    final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');
//
    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      //To connect to a GraphQL Server, we first need to create a GraphQLClient.
      // A GraphQLClient requires both a cache and a link to be initialized.
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(
          store: InMemoryStore(),
        ),
      ),
    );
    return GraphQLProvider(
      child: const HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphQL Client'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(productgraphQL),
          pollInterval: const Duration(seconds: 10),
        ),
        builder: (QueryResult? result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result!.data == null) {
            return const Text('No Data Found !');
          }
          print(result.data!['continents']);
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(result.data!['continents'][index]['name']));
            },
            itemCount: result.data!['continents'].length,
          );
        },
      ),
    );
  }
}
