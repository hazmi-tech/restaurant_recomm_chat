import 'package:google_fonts/google_fonts.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class Introduction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IntroductionState();
  }
}

class IntroductionState extends State<Introduction> {
  List<Slide> slides = List();
  bool _isLoggedIn = false;
  Function goToTab;

  @override
  void initState() {
    super.initState();
    addScreens();
  }

  void addScreens() {
    slides.add(
      Slide(
        title: 'اكتشف أحلى \n المطاعم من حولك',
        description: 'نساعدك على اكتشاف الذ \n وجبات المطاعم من حولك',
        backgroundColor: Colors.white,
        pathImage: 'assets/images/screen-one.png',
        styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
        styleDescription: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    slides.add(
      Slide(
        title: 'شبكة اجتماعية \n لخبراء المطاعم',
        description: 'أفضل مكان لمشاركة الآراء وأذواق المطاعم والوجبات ',
        backgroundColor: new Color(0xFFF48858),
        pathImage: 'assets/images/screen-two.png',
        styleTitle: 
        TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
        styleDescription: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    slides.add(
      Slide(
        title: '!ودع الحيرة',
        description: 'لا تضيع وقت تدور وتقرأ تقييمات! \n تواصل مباشرة مع خبراء المطاعم حولك\n واحصل على اقتراحات مضبوطة لك وحدك.',
        pathImage: 'assets/images/screen-three.png',
        styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
        styleDescription: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  void onDonePress() {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>AuthenticatePage()),
  );
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Container( ),
                            Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(bottom: 30.0,top: 70.0),
              ),
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 250.0,
                height: 250.0,
                fit: BoxFit.contain,
              )),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33ffcc5c),
      highlightColorSkipBtn: Color(0xffffcc5c),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33ffcc5c),
      highlightColorDoneBtn: Color(0xffffcc5c),

      // Dot indicator
      colorDot: Color(0xffffcc5c),
      sizeDot: 13.0,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: new Color(0xFFF48858),
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );


    
  }
  
}


class CustomAppBar extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}