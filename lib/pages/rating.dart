import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rect_getter/rect_getter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'poppins',
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Duration animationDuration = Duration(milliseconds: 800);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;
  double animatedHeight = 0;
  List<bool> isSelected;
  bool showImproveTags = false;
  List<String> improvesTagsValue = [
    "متجاوب",
    "دقيق",
    "نص ونص",
    "لم احصل على المطلوب",
    "فنااان",
    "انخميت"
  ];

  void _onTap() async {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
      rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      Future.delayed(animationDuration, _goToNextPage);
    });
  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: NextPage()))
        .then((_) => setState(() => rect = null));
  }

  @override
  void initState() {
    setState(() {
      isSelected = improvesTagsValue.map((e) => false).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotationAnimatedWidget.tween(
                      enabled: showImproveTags,
                      rotationDisabled: Rotation.deg(z: 15),
                      rotationEnabled: Rotation.deg(z: 125.0),
                      duration: Duration(milliseconds: 600),
                      child: Container(
                        width: 200,
                        height: 200,
                        child: ClipPath(
                          clipper: StarClipper(
                            5,
                          ),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 600),
                            color: showImproveTags
                                ? Colors.amber[600]
                                : Colors.grey[350],
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 35,
                                  left: 40,
                                  child: CircleAvatar(
                                    maxRadius: 120,
                                    backgroundColor: Colors.white24,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "قيّم تجربتك مع استشارة الخبير",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 50, left: 50, top: 3, bottom: 8),
                      child: Text(
                        "ساعدنا على تطوير تطبيقنا بتقييمنا",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    RatingBar.builder(

                      itemSize: 30,
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          showImproveTags = true;
                          animatedHeight = 260;
                        });
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[200],
                      height: animatedHeight,
                      child: TranslationAnimatedWidget.tween(
                        enabled: showImproveTags,
                        duration: Duration(milliseconds: 500),
                        translationDisabled: Offset(0, 100),
                        translationEnabled: Offset(0, 0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "كيف كان الخبير؟",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: GridView.builder(
                                  itemCount: improvesTagsValue.length,
                                  physics: ScrollPhysics(),
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 7 / 1.5,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 8),
                                  itemBuilder: (BuildContext context, int index) {
                                    return improveWidget(index);
                                  },
                                ),
                                  ),
                            ),

                          Container(
                                padding: EdgeInsets.only(
                                    left: 35,
                                    right: 35,
                                    top: 0,
                                    bottom: 0
                                ),
                                child:
                                TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.black, height: 0.1, ),
                                  decoration: InputDecoration(
                                      hintText: '.. رأي آخر',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                                ),
                              ),
                            SizedBox(
                              height: 12,
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RectGetter(
                key: rectGetterKey,
                child:showImproveTags ?  OpacityAnimatedWidget.tween(
                  enabled: showImproveTags,
                  opacityDisabled: 0,
                  duration: Duration(milliseconds: 1000),
                  opacityEnabled: 1,
                  child:ButtonTheme(
                      buttonColor: Colors.amber[700],
                      height: 48,
                      child: RaisedButton(
                          onPressed: _onTap,
                          child: Text(
                            "إرسال",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ))),
                ) : Container(),
              )),
          _ripple(),
        ],
      ),
    );
  }

  Widget improveWidget(index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected[index] = !isSelected[index];
        });
      },
      child: new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: isSelected[index] ? Colors.amber[600] : Colors.grey[300],
              width: 2),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            improvesTagsValue[index],
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber[700],
        ),
      ),
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
    pageBuilder: (context, animation1, animation2) => page,
    transitionsBuilder: (context, animation1, animation2, child) {
      return FadeTransition(opacity: animation1, child: child);
    },
  );
}

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  bool _feedback = false;
  bool _thank = false;
  bool _btn = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber[700],
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleAnimatedWidget.tween(
                enabled: true,
                duration: Duration(milliseconds: 600),
                animationFinished: (value) {
                  setState(() {
                    _feedback = true;
                  });
                },
                scaleDisabled: 0.5,
                scaleEnabled: 1,
                child: Icon(
                  LineAwesomeIcons.check_circle_o,
                  size: 100,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TranslationAnimatedWidget.tween(
                enabled: _feedback,
                translationDisabled: Offset(0, -12),
                translationEnabled: Offset(0, 0),
                child: OpacityAnimatedWidget.tween(
                  enabled: _feedback,
                  opacityDisabled: 0,
                  animationFinished: (value) {
                    setState(() {
                      _thank = true;
                    });
                  },
                  duration: Duration(milliseconds: 800),
                  opacityEnabled: 1,
                  child: Text(
                    "تم ارسال التقييم بنجاح",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              OpacityAnimatedWidget.tween(
                enabled: _thank,
                opacityDisabled: 0,
                animationFinished: (value) {
                  setState(() {
                    _btn = true;
                  });
                },
                duration: Duration(milliseconds: 500),
                opacityEnabled: 1,
                child: Text(
                  "شكراً لك، نتمنى لك تجربة قادمة سعيدة، وبالعاافية",
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              OpacityAnimatedWidget.tween(
                enabled: _btn,
                opacityDisabled: 0,
                duration: Duration(milliseconds: 500),
                opacityEnabled: 1,
                child: ButtonTheme(
                    minWidth: 150,
                    buttonColor: Colors.white,
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        "الصفحة الرئيسية",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
