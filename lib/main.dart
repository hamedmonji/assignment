import 'package:assignment/bike_service.dart';
import 'package:assignment/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

const primaryColors = Color(0xFFFF8200);

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
          buildWelcomeAndUpdate(context),
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              switch (notification.direction) {
                case ScrollDirection.idle:
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
                  if (!_slideOut &&
                      (notification.metrics.extentAfter <
                          notification.metrics.maxScrollExtent - 140)) {
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
                  Opacity(
                    opacity: 0,
                    child: buildPlaceholderInfo(),
                  ),
                  buildBike(context),
                  SizedBox(
                    height: 24,
                  ),
                  buildList(),
                ],
              ),
            ),
          ),
          buildRide(context),
        ],
      ),
    );
  }

  AnimatedPositioned buildRide(BuildContext context) {
    return AnimatedPositioned(
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
    );
  }

  Column buildWelcomeAndUpdate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedScale(
            duration: Duration(milliseconds: 400),
            alignment: Alignment.topLeft,
            scale: _slideOut ? 0 : 1,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _slideOut ? 0 : 1,
              child: const Icon(
                CustomIcons.user_icon,
                size: 46,
              ),
            ),
          ),
        ),
        AnimatedScale(
          duration: Duration(milliseconds: 300),
          alignment: Alignment(0, -0.5),
          scale: _slideOut ? 0 : 1,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _slideOut ? 0 : 1,
            child: Column(
              children: [
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
        )
      ],
    );
  }

  FutureBuilder<BikeModel> buildList() {
    return FutureBuilder<BikeModel>(
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
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else if (item is BikeInfo) {
                  //TODO format item info
                  return ListTile(
                    title: Text(item.title,
                        style: Theme.of(context).textTheme.titleLarge),
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
              separatorBuilder: (BuildContext context, int index) {
                final nextItem =
                    index < data.length - 1 ? data[index + 1] : null;
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
        });
  }

  Widget buildBike(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            Positioned(
              top: 42,
              left: 0,
              right: 0,
              child: RotatedBox(
                quarterTurns: 2,
                child: Container(
                  height: 124,
                  width: 124,
                  child: Icon(
                    CustomIcons.arrow_down_icon,
                    size: 124,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            Center(
              child: SvgPicture.asset(
                "assets/images/bike.svg",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceholderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: const SizedBox(
            width: 46,
            height: 46,
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
          padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            width: 150,
            height: 150,
            child: null,
          ),
        ),
      ],
    );
  }
}
