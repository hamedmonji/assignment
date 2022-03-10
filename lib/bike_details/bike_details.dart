import 'package:assignment/bike_viewmodel.dart';
import 'package:assignment/common/extensions.dart';
import 'package:assignment/common/widgets.dart';
import 'package:assignment/custom_icons.dart';
import 'package:assignment/formate_bike_info_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BikeDetails extends StatefulWidget {
  @override
  State<BikeDetails> createState() => _BikeDetailsState();
}

class _BikeDetailsState extends State<BikeDetails>
    with SingleTickerProviderStateMixin {
  bool _slideOut = false;
  final GlobalKey _messageAndUpdateOffstageKey = GlobalKey();
  late AnimationController animationController;
  late double _welcomeAndMessageHeight;
  late Future<List<BaseBikeInfo>> fetchBikeInfoFuture;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<BikeViewModel>();
    fetchBikeInfoFuture = viewModel.getBikeData();
    animationController = AnimationController(
        vsync: this, upperBound: 600, duration: Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder<List<BaseBikeInfo>>(
          future: fetchBikeInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildPageContent(snapshot.data!);
            } else if (snapshot.hasError) {
              //TODO show proper error with retry
              return _buildRetryError(snapshot);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }

  Center _buildRetryError(AsyncSnapshot<List<BaseBikeInfo>> snapshot) {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            fetchBikeInfoFuture = context.read<BikeViewModel>().getBikeData();
          });
        },
        child: Text('${snapshot.error} \n click to retry'),
      ),
    );
  }

  Widget _buildPageContent(List<BaseBikeInfo> data) {
    return Stack(
      children: [
        _buildWelcomeAndUpdate(),
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            print(notification.runtimeType);
            if (notification is ScrollUpdateNotification) {
              if (!_slideOut && ((_isPassedScrollThreshold(notification)))) {
                setState(() {
                  _slideOut = true;
                  animationController.forward();
                });
              } else if (_isAtStartEdge(notification)) {
                setState(() {
                  _slideOut = false;
                  animationController.reverse();
                });
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            child: LayoutBuilder(builder: (_, __) {
              _welcomeAndMessageHeight = _getWelcomeAndUpdateHeight();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _welcomeAndMessageHeight,
                  ),
                  buildBike(context),
                  buildRide(context),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: _buildBikeInfoList(data),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  bool _isPassedScrollThreshold(ScrollUpdateNotification notification) {
    print(notification.metrics.pixels);
    return notification.metrics.pixels > 40;
  }

  bool _isAtStartEdge(ScrollUpdateNotification notification) {
    // for some reason on android pixels doesn't reach zero,so we put the
    // threshold to 5 just to be safe.
    return (notification.metrics.pixels - notification.metrics.minScrollExtent)
            .abs() <
        5;
  }

  Widget buildRide(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _slideOut ? 0 : 1,
          child: Container(
            child: Center(
              child: Text(
                'Ride',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
            ),
            transform:
                Matrix4.translationValues(0, animationController.value, 0),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeAndUpdate() {
    return Wrap(
      key: _messageAndUpdateOffstageKey,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileIcon(),
            AnimatedScaleFade(
              slideOut: _slideOut,
              alignment: Alignment(0, -0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42.0),
                    child: Center(
                        child: Text(
                      'Your bike is looking perfect to ride, watch out for the rain',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.grey),
                    )),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: _buildUpdates(),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Padding _buildProfileIcon() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AnimatedScaleFade(
        slideOut: _slideOut,
        alignment: Alignment.topLeft,
        child: const Icon(
          CustomIcons.user_icon,
          size: 46,
        ),
      ),
    );
  }

  Container _buildUpdates() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
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
    );
  }

  Widget _buildBikeInfoList(List<BaseBikeInfo> data) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        if (item is BikeInfoHeader) {
          return PaddedHeader(
            heading: item.header,
          );
        } else if (item is BikeInfo) {
          //TODO format item info
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleLarge),
                Spacer(),
                Text(
                  item.info,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          throw Exception(
              'no support for bike info of type ${item.runtimeType}');
        }
      },
      separatorBuilder: (_, int index) {
        final nextItem = data.elementAfterOrNull(index);
        if (nextItem is BikeInfo) {
          return Divider();
        } else
          return SizedBox();
      },
    );
  }

  Widget buildBike(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: _UpArrow(),
        ),
        Center(
          child: Container(
            height: 300,
            child: SvgPicture.asset(
              "assets/images/bike.svg",
            ),
          ),
        ),
      ],
    );
  }

  double _getWelcomeAndUpdateHeight() {
    final RenderBox render = _messageAndUpdateOffstageKey.currentContext!
        .findRenderObject()! as RenderBox;
    return render.size.height;
  }
}

class PaddedHeader extends StatelessWidget {
  final EdgeInsets padding;

  const PaddedHeader({
    Key? key,
    required this.heading,
    this.padding = const EdgeInsets.only(top: 24.0),
  }) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          heading,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _UpArrow extends StatelessWidget {
  final double size;

  const _UpArrow({Key? key, this.size = 124}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 2,
      child: Container(
        height: size,
        width: size,
        child: Icon(
          CustomIcons.arrow_down_icon,
          size: size,
          color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
        ),
      ),
    );
  }
}
