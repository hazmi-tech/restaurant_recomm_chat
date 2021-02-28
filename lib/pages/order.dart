import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/dropdown_formfield.dart';


class Order extends StatefulWidget {
  @override
  OrderState createState() {
    return OrderState();
  }
}

class OrderState extends State<Order>
    with SingleTickerProviderStateMixin {
  String _myActivity;
  String _myActivityResult;
  String _myActivity2;
  String _myActivityResult2;
  String _myActivity3;
  String _myActivityResult3;
  final formKey = new GlobalKey<FormState>();
  final formKey2 = new GlobalKey<FormState>();
  final formKey3 = new GlobalKey<FormState>();
  double _animatedHeight = 10.0;
  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
    _myActivity2 = '';
    _myActivityResult2 = '';
    _myActivity3 = '';
    _myActivityResult3 = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    var form2 = formKey2.currentState;
    var form3 = formKey2.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = _myActivity;
      });
    }
    if (form2.validate()) {
      form2.save();
      setState(() {
        _myActivityResult2 = _myActivity2;
      });
    }
    if (form3.validate()) {
      form3.save();
      setState(() {
        _myActivityResult3 = _myActivity3;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'طلب استشارة',
                  style: TextStyle(color: Colors.black),
                ),

              ],
            ),

          ],
        ),
      ),
      body: Center(
    child: SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    Flexible(
            //width: 200,
           // height: 100,
             // padding: const EdgeInsets.only(top: 16),

      child: Text(
        'وصف الطلب',
        style: TextStyle(color: Colors.black),
      ),
    ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: TextField(
                style: TextStyle(color: Colors.black, height: 0.5),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)))),
              ),
            ),
        Container(
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: DropDownFormField(
                titleText: 'موقع الطلب',
                hintText: 'اختر موقعك',
                value: _myActivity,
                onSaved: (value) {
                  setState(() {
                    _myActivity = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _myActivity = value;
                  });
                },
                dataSource: [
                  {
                    "display": "الشاطئ",
                    "value": "الشاطئ",
                  },
                  {
                    "display": "أبحر الجنوبية",
                    "value": "أبحر الجنوبية",
                  },
                  {
                    "display": "أبحر الشمالية",
                    "value": "أبحر الشمالية",
                  },
                  {
                    "display": "المحمدية",
                    "value": "المحمدية",
                  },
                  {
                    "display": "المرجان",
                    "value": "المرجان",
                  },
                  {
                    "display": "البساتين",
                    "value": "البساتين",
                  },
                  {
                    "display": "النزهة",
                    "value": "النزهة",
                  },
                  {
                    "display": "الحمرا",
                    "value": "الحمرا",
                  },
                  {
                    "display": "النعيم",
                    "value": "النعيم",
                  },
                  {
                    "display": "البوادي",
                    "value": "البوادي",
                  },
                  {
                    "display": "الخالدية",
                    "value": "الخالدية",
                  },
                  {
                    "display": "الفيصلية",
                    "value": "الفيصلية",
                  },
                  {
                    "display": "السامر",
                    "value": "السامر",
                  },
                  {
                    "display": "الحمدانية",
                    "value": "الحمدانية",
                  },
                  {
                    "display": "الربوة",
                    "value": "الربوة",
                  },
                  {
                    "display": "المروة",
                    "value": "المروة",
                  },
                  {
                    "display": "السلامة",
                    "value": "السلامة",
                  },
                  {
                    "display": "الأندلس",
                    "value": "الأندلس",
                  },
                  {
                    "display": "الروضة",
                    "value": "الروضة",
                  },
                  {
                    "display": "الزهراء",
                    "value": "الزهراء",
                  },
                  {
                    "display": "الكورنيش",
                    "value": "الكورنيش",
                  },
                  {
                    "display": "بريمان",
                    "value": "بريمان",
                  },
                  {
                    "display": "الصفا",
                    "value": "Running",
                  },
                  {
                    "display": "النهضة",
                    "value": "النهضة",
                  },
                  {
                    "display": "البغدادية",
                    "value": "البغدادية",
                  },
                  {
                    "display": "الرويس",
                    "value": "الرويس",
                  },
                  {
                    "display": "العزيزية",
                    "value": "العزيزية",
                  },
                  {
                    "display": "العمارية",
                    "value": "العمارية",
                  },
                  {
                    "display": "النسيم",
                    "value": "النسيم",
                  },
                  {
                    "display": "العين",
                    "value": "العين",
                  },
                  {
                    "display": "الكندرة",
                    "value": "الكندرة",
                  },
                  {
                    "display": "الصحيفة",
                    "value": "الصحيفة",
                  },
                  {
                    "display": "المطار القديم",
                    "value": "المطار القديم",
                  },
                  {
                    "display": "بني مالك",
                    "value": "بني مالك",
                  },
                  {
                    "display": "الشرفية",
                    "value": "الشرفية",
                  },
                  {
                    "display": "البلد",
                    "value": "البلد",
                  },
                  {
                    "display": "السبيل",
                    "value": "السبيل",
                  },
                  {
                    "display": "الهنداوية",
                    "value": "الهنداوية",
                  },
                  {
                    "display": "غليل",
                    "value": "غليل",
                  },
                  {
                    "display": "التوفيق",
                    "value": "التوفيق",
                  },
                  {
                    "display": "الثعالبة",
                    "value": "الثعالبة",
                  },
                  {
                    "display": "الجامعة",
                    "value": "الجامعة",
                  },
                  {
                    "display": "الروابي",
                    "value": "الروابي",
                  },
                  {
                    "display": "المحجر",
                    "value": "المحجر",
                  },
                  {
                    "display": "مدائن الفهد",
                    "value": "مدائن الفهد",
                  },
                  {
                    "display": "الاسكان",
                    "value": "الاسكان",
                  },
                  {
                    "display": "القريات",
                    "value": "القريات",
                  },
                  {
                    "display": "الثغر",
                    "value": "الثغر",
                  },
                  {
                    "display": "السالمية",
                    "value": "السالمية",
                  },
                  {
                    "display": "النزلة",
                    "value": "النزلة",
                  },
                  {
                    "display": "بترومين",
                    "value": "بترومين",
                  },
                  {
                    "display": "المنتزهات",
                    "value": "المنتزهات",
                  },
                  {
                    "display": "قويزة",
                    "value": "قويزة",
                  },
                  {
                    "display": "عبيد",
                    "value": "عبيد",
                  },
                  {
                    "display": "حارة المظلوم",
                    "value": "حارة المظلوم",
                  },
                  {
                    "display": "حارة الشام",
                    "value": "حارة الشام",
                  },
                  {
                    "display": "حارة اليمن",
                    "value": "حارة اليمن",
                  },
                  {
                    "display": "حارة البحر",
                    "value": "حارة البحر",
                  },
                ],
                textField: 'display',
                valueField: 'value',
              ),
            ),
        ],
    ),
            ),
        ),
    Container(
    child: Form(
    key: formKey2,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    child: DropDownFormField(
    titleText: 'نوع الطعام',
    hintText: 'ايش تشتهي؟',
    value: _myActivity2,
    onSaved: (value) {
    setState(() {
    _myActivity2 = value;
    });
    },
    onChanged: (value) {
    setState(() {
    _myActivity2 = value;
    });
    },
    dataSource: [
    {
    "display": "هندي",
    "value": "هندي",
    },
      {
        "display": "سعودي",
        "value": "سعودي",
      },
      {
        "display": "إيطالي",
        "value": "إيطالي",
      },
      {
        "display": "ساندوتشات",
        "value": "ساندوتشات",
      },
      {
        "display": "مصري",
        "value": "مصري",
      },
      {
        "display": "جاوي",
        "value": "جاوي",
      },
      {
        "display": "امريكي",
        "value": "امريكي",
      },
      {
        "display": "صيني",
        "value": "صيني",
      },
      {
        "display": "ياباني",
        "value": "ياباني",
      },
      {
        "display": "صحي",
        "value": "صحي",
      },
      {
        "display": "حلى",
        "value": "حلى",
      },
      {
        "display": "أرجنتيني",
        "value": "أرجنتيني",
      },
      {
        "display": "مكسيكي",
        "value": "مكسيكي",
      },
      {
        "display": "شامي",
        "value": "شامي",
      },
      {
        "display": "يمني",
        "value": "يمني",
      },
      {
        "display": "مغربي",
        "value": "مغربي",
      },
      {
        "display": "أخرى",
        "value": "أخرى",
      },
      {
        "display": "ما أعرف",
        "value": "ما أعرف",
      },
    ],
      textField: 'display',
      valueField: 'value',
    ),
    ),
    ],
    ),
    ),
    ),
      Text(
        'عدد الأشخاص',
        style: TextStyle(color: Colors.black),
      ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: TextField(
                style: TextStyle(color: Colors.black, height: 0.5),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)))),
              ),
        ),
      Text(
        'الميزانية',
        style: TextStyle(color: Colors.black),
      ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextField(
              style: TextStyle(color: Colors.black, height: 0.5),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
            ),
    ),

          new GestureDetector(
            onTap: ()=>setState((){
              _animatedHeight!=0.0?_animatedHeight=0.0:_animatedHeight=260.0;}
              ),
            child:  new Container(
              child: new Text("*خيارات إضافية*",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              //color: Colors.white,
              height: 25.0,
             // width: 100.0,
            ),
          ),


        SingleChildScrollView(
          child: new AnimatedContainer(duration: const Duration(milliseconds: 120),
            height: _animatedHeight,
            //color: Colors.tealAccent,
           // width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: Text(
                    'المناسبة',
                    style: TextStyle(color: Colors.black),
                  ),
          ),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: TextField(
                      style: TextStyle(color: Colors.black, height: 0.5),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32)))),
                    ),
                  ),
    Container(
    child: Form(
    key: formKey3,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    child: DropDownFormField(
    titleText: 'طريقة الاستلام',
    hintText: 'ايش يناسبك',
    value: _myActivity3,
    onSaved: (value) {
    setState(() {
    _myActivity3 = value;
    });
    },
    onChanged: (value) {
    setState(() {
    _myActivity3 = value;
    });
    },
    dataSource: [
    {
    "display": "محلي",
    "value": "محلي",
    },
    {
    "display": "طلب خارجي",
    "value": "طلب خارجي",
    },
    {
    "display": "توصيل",
    "value": "توصيل",
    },
    ],
      textField: 'display',
      valueField: 'value',
    ),
    ),
    ],
    ),
    ),
    ),
                ],
                ),
          ),
        ),

          Container(
            width: 200,
            height: 40,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color:Color(0xffff8046),
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: Center(
              child: Text(
                'ارسال',
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ) ,
   ],
    ),

    ),
      ),
    );
  }
}

