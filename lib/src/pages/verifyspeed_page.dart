import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_verifyspeed/src/models/models.dart';
import 'package:flutter_verifyspeed/src/utils/verifyspeed_method_type_extension.dart';
import 'package:flutter_verifyspeed_plugin/flutter_verifyspeed_plugin.dart';

class VerifySpeedPage extends StatefulWidget {
  const VerifySpeedPage({
    super.key,
    required this.onSuccess,
    required this.onFailure,
  });

  final void Function(String) onSuccess;
  final void Function(VerifySpeedError) onFailure;

  @override
  State<VerifySpeedPage> createState() => _VerifySpeedPageState();
}

class _VerifySpeedPageState extends State<VerifySpeedPage>
    with WidgetsBindingObserver {
  late VerifySpeedModel verifyspeedModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await VerifySpeedPlugin.instance.notifyOnResumed();
    }
  }

  Future<void> getUiFromApi() async {
    final response = await VerifySpeedPlugin.instance.getUiFromApi();

    if (response == null) {
      throw Exception('Failed to get ui from api');
    }

    verifyspeedModel = VerifySpeedModel.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('VerifySpeed'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder(
          future: getUiFromApi(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('An error occurred ${snapshot.error}'));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final verifyspeed in verifyspeedModel.availableMethods ??
                      <MethodModel>[]) ...{
                    if (verifyspeed.methodName == null) ...{
                      Builder(
                        builder: (context) {
                          log('verify method is null!');
                          return const SizedBox();
                        },
                      )
                    } else
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                            backgroundColor:
                                verifyspeed.methodName!.backgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            minimumSize: Size(
                              width * 0.8,
                              height * 0.08,
                            )),
                        icon: Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            verifyspeed.methodName!.icon,
                            package: 'flutter_verifyspeed',
                            width: width * 0.08,
                            height: height * 0.08,
                          ),
                        ),
                        label: Center(
                          child: Text(
                            verifyspeed.methodName!.name,
                            style: TextStyle(
                              fontSize: width * 0.04,
                            ),
                          ),
                        ),
                        onPressed: () =>
                            VerifySpeedPlugin.instance.startVerification(
                          onSuccess: widget.onSuccess,
                          onFailure: widget.onFailure,
                          type: verifyspeed.methodName!,
                        ),
                      ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                  },
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
