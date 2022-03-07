import 'package:assignment/bike_service.dart';
import 'package:assignment/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

const primaryColors = Color.fromRGBO(240, 136, 51, 1);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          iconTheme: IconThemeData(color: primaryColors)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _slideOut = false;

  @override
  Widget build(BuildContext context) {
    //TODO use notification widget listen , scale widgets out when started,
    // bring widgets back when list view is back in it's original place
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 300,
            top: 300,
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                switch (notification.direction) {
                  case ScrollDirection.idle:
                    // TODO: Handle this case.
                    if (notification.metrics.atEdge &&
                        notification.metrics.extentAfter != 0) {
                      setState(() {
                        _slideOut = false;
                      });
                    }
                    break;
                  case ScrollDirection.forward:
                    break;
                  case ScrollDirection.reverse:
                    //TODO have a little extent first
                    if (!_slideOut) {
                      setState(() {
                        _slideOut = true;
                      });
                    }
                    break;
                }
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 42,
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: 24,
                          left: 0,
                          right: 0,
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              CustomIcons.arrow_down_icon,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color!
                                  .withOpacity(0.4),
                              size: 124,
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            CustomIcons.bike,
                            size: 300,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    FutureBuilder<BikeModel>(
                        future: BikeApi().getBikeModel(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            //TODO build bike information
                            final data = snapshot.data!.bikeInfo();
                            //Create a sectioned list widget maybe
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                if (item is BikeInfoHeader) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: ListTile(
                                      title: Text(
                                        item.header,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                } else if (item is BikeInfo) {
                                  //TODO format item info
                                  return ListTile(
                                    title: Text(item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    trailing: Text(
                                      item.info,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: Colors.grey),
                                    ),
                                  );
                                } else {
                                  throw Exception(
                                      'no support for bike info of type ${item.runtimeType}');
                                }
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                final nextItem = index < data.length - 1
                                    ? data[index + 1]
                                    : null;
                                if (nextItem is BikeInfo) {
                                  return Divider();
                                } else
                                  return SizedBox();
                              },
                            );
                          } else if (snapshot.hasError) {
                            //TODO show proper error with retry
                            return Container(
                              color: Colors.red,
                            );
                          } else {
                            //TODO show progress for the whole page
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          AnimatedScale(
            duration: Duration(milliseconds: 600),
            scale: _slideOut ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: const Icon(
                    CustomIcons.user_icon,
                    size: 46,
                  ),
                ),
                Center(
                    child: Text(
                  'Good afternoon,',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.black),
                )),
                SizedBox(
                  height: 24,
                ),
                Center(
                    child: Text(
                  'Your bike is looking perfect to ride, watch out for the rain',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.grey),
                )),
                SizedBox(
                  height: 36,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    width: 150,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CustomIcons.update_icon,
                          size: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Updates',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            bottom: _slideOut ? -100 : 100,
            left: 0,
            right: 0,
            duration: Duration(milliseconds: 300),
            child: Text(
              'Ride',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
