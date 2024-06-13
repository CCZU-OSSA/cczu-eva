import 'package:arche/arche.dart';
import 'package:cczu_eva/client.dart';
import 'package:cczu_eva/pages/login.dart';
import 'package:cczu_eva/type.dart';
import 'package:cczu_eva/widgets.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApplication());
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: "CCZU EVA",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightDynamic,
          brightness: Brightness.light,
          fontFamily: "Default",
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkDynamic,
          brightness: Brightness.dark,
          fontFamily: "Default",
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool logined = false;
  late EVAClient client;
  List<EvaluationEntry> data = [];
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: Visibility(
        visible: logined,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text("一键评价"),
                  ),
                  body: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: EvaluationPanl(
                          onSave: (rating, parts, comment) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => ValueStateBuilder(
                                builder: (context, state) => Dialog(
                                    child: SizedBox.expand(
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: state.value / data.length,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text("${state.value} / ${data.length}"),
                                    ],
                                  )),
                                )),
                                init: 1,
                                onInit: (context, state) {
                                  for (var e in data) {
                                    client
                                        .getEvaluationUrl(e.order)
                                        .then((url) {
                                      if (url != null) {
                                        client
                                            .evaluate(
                                          url,
                                          rating,
                                          comment,
                                          parts,
                                        )
                                            .then((_) {
                                          state.update(state.value + 1);
                                          if (state.value + 1 == data.length) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text("已完成！请稍后自行查询是否有遗漏"),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                          }
                                        });
                                      }
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.edit),
        ),
      ),
      appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceContainerLow,
          title: const Text("CCZU EVA"),
          notificationPredicate: (_) => false),
      body: Container(
        color: theme.colorScheme.surfaceContainerLow,
        child: Card(
          color: theme.colorScheme.surface,
          margin: const EdgeInsets.all(0),
          child: SizedBox.expand(
            child: AnimatedSwitcher(
              duration: Durations.medium4,
              child: logined
                  ? FutureBuilder(
                      future: client.listTiles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          this.data = data;
                          return ListView(
                            children: data
                                .map(
                                  (e) => Card(
                                    child: ExpansionTile(
                                      title: Text(e.name),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      collapsedShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: EvaluationPanl(
                                            onSave: (rating, parts, comment) {
                                              client
                                                  .getEvaluationUrl(e.order)
                                                  .then((url) {
                                                if (url != null) {
                                                  client.evaluate(
                                                      url,
                                                      rating,
                                                      comment,
                                                      parts, (response) {
                                                    var text = alertPattern
                                                        .stringMatch(response
                                                            .data
                                                            .toString());
                                                    if (text != null) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(text),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ));
                                                    }
                                                  });
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text("查询评价地址失败"),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ));
                                                }
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  : LoginPage(
                      onSuccess: (client) => setState(
                        () {
                          this.client = client;
                          logined = true;
                        },
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
