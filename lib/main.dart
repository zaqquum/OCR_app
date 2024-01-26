import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Status Calculator'),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'BMI & Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'OCR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Result',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    if (_currentIndex == 0) {
      return BMIStatusScreen();
    } else if (_currentIndex == 1) {
      return OCRScreen();
    } else {
      return ResultScreen(
        userName: '',
        todayCalories: 0,
        recommendedCalories: 0,
        carb_g: 0,
        protein_g: 0,
        fat_g: 0,
        bmi: 0,);
    }
  }
}
////
class BMIStatusScreen extends StatefulWidget {
  @override
  _BMIStatusScreenState createState() => _BMIStatusScreenState();
}

class _BMIStatusScreenState extends State<BMIStatusScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String gender = 'm';
  int paLevel = 0;
  TextEditingController carbRatioController = TextEditingController();
  TextEditingController proteinRatioController = TextEditingController();
  TextEditingController fatRatioController = TextEditingController();

  String bmiResult = '';
  String teeResult = '';
  String nutrientRatioResult = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: heightController,
                    decoration: InputDecoration(labelText: 'Height (cm)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    decoration: InputDecoration(labelText: 'Weight (kg)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Gender:'),
                Radio(
                  value: 'm',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value as String;
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'f',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value as String;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            Row(
              children: [
                Text('Activity Level'),
                Radio(
                  value: 0,
                  groupValue: paLevel,
                  onChanged: (value) {
                    setState(() {
                      paLevel = value as int;
                    });
                  },
                ),
                Text('0'),
                Radio(
                  value: 1,
                  groupValue: paLevel,
                  onChanged: (value) {
                    setState(() {
                      paLevel = value as int;
                    });
                  },
                ),
                Text('1'),
                Radio(
                  value: 2,
                  groupValue: paLevel,
                  onChanged: (value) {
                    setState(() {
                      paLevel = value as int;
                    });
                  },
                ),
                Text('2'),
                Radio(
                  value: 3,
                  groupValue: paLevel,
                  onChanged: (value) {
                    setState(() {
                      paLevel = value as int;
                    });
                  },
                ),
                Text('3'),
              ],
            ),
            TextField(
              controller: carbRatioController,
              decoration: InputDecoration(labelText: 'Carbohydrate Ratio (%)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: proteinRatioController,
              decoration: InputDecoration(labelText: 'Protein Ratio (%)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: fatRatioController,
              decoration: InputDecoration(labelText: 'Fat Ratio (%)'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                _calculateStatus();
              },
              child: Text('Calculate Status'),
            ),
            SizedBox(height: 20),
            Text('BMI Result: $bmiResult'),
            Text('TEE Result: $teeResult'),
            Text('Nutrient Ratio: $nutrientRatioResult'),
          ],
        ),
      ),
    );
  }

  void _calculateStatus() async {
    final String apiUrl = 'http://192.168.11.113:5000/calculate_status';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'age': ageController.text,
        'height': heightController.text,
        'weight': weightController.text,
        'gender': gender,
        'pa_level': paLevel.toString(),
        'carb_ratio': carbRatioController.text,
        'protein_ratio': proteinRatioController.text,
        'fat_ratio': fatRatioController.text,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      // Extracting values from the server response
      String userName = "User1"; // User Nickname
      double bmiValue = data['bmi']['bmi'].toDouble();


      double recommendedCalories = data['TEE']; //
      double todayCalories = 1300;
      double carb_g = data['nutrient_ratio']['Carbohydrate'];
      double protein_g = data['nutrient_ratio']['Protein'];
      double fat_g = data['nutrient_ratio']['Lipide'];

      setState(() {
        bmiResult =
        'BMI: ${data['bmi']['bmi']}, Result: ${data['bmi']['bmi_result']}';
        teeResult = 'TEE Result: ${data['TEE']} kcal';
        nutrientRatioResult =
        'Carbohydrate: ${data['nutrient_ratio']['Carbohydrate']}g,Protein: ${data['nutrient_ratio']['Protein']}g, Lipide: ${data['nutrient_ratio']['Lipide']}g';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(
                  userName: userName,
                  bmi: bmiValue,
                  todayCalories: todayCalories,
                  recommendedCalories: recommendedCalories,

                  carb_g: carb_g,
                  protein_g: protein_g,
                  fat_g: fat_g,
                ),
          ),
        );
      });
    } else {
      throw Exception('Failed to load status result');
    }
  }
}

class OCRScreen extends StatefulWidget {
  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  TextEditingController ocrResultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final String apiUrl = 'http://192.168.11.113:5000/perform_ocr';

              final XFile? pickedImage = await ImagePicker().pickImage(
                  source: ImageSource.gallery);

              if (pickedImage != null) {
                final bytes = await pickedImage.readAsBytes();
                final String base64Image = base64Encode(bytes);

                final response = await http.post(
                  Uri.parse(apiUrl),
                  body: {
                    'image': base64Image,
                  },
                );

                if (response.statusCode == 200) {
                  Map<String, dynamic> data = json.decode(response.body);
                  setState(() {
                    ocrResultController.text = data['ocr_result'];
                  });
                } else {
                  throw Exception('Failed to perform OCR');
                }
              }
            },
            child: Text('Perform OCR'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: ocrResultController,
            decoration: InputDecoration(labelText: 'OCR Result'),
            maxLines: null,
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final String userName;
  final double todayCalories;
  final double recommendedCalories;


  final double carb_g;
  final double protein_g;
  final double fat_g;
  final double bmi;


  ResultScreen({
    required this.userName,
    required this.todayCalories,
    required this.recommendedCalories,

    required this.carb_g,
    required this.protein_g,
    required this.fat_g,
    required this.bmi,
  });


  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String userName;
  late double todayCalories;
  late double recommendedCalories;
  late double carb_g;
  late double protein_g;
  late double fat_g;
  late double bmi;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    todayCalories = widget.todayCalories;
    recommendedCalories = widget.recommendedCalories;
    carb_g = widget.carb_g;
    protein_g = widget.protein_g;
    fat_g = widget.fat_g;
    bmi = widget.bmi;
  }

  @override
  Widget build(BuildContext context) {
    double leftCalories = recommendedCalories - todayCalories;
    double caloriesRatio = (todayCalories / recommendedCalories) * 360;
    double eatenCarb = 120;
    double eatenFat = 45;
    double eatenProtein = 40;


    List<BMIResult> results = [
      calculateBMIResult(0),
      calculateBMIResult(18.5),
      calculateBMIResult(23),
      calculateBMIResult(25),
      calculateBMIResult(30),
    ];


    // Result UI
    return Scaffold(
      appBar: AppBar(
        title: Text('결과'),
      ),
      body:SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 칼로리 파트
              Text(
                'Calories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, bottom: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Recommended:',
                          style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF213333).withOpacity(0.8),
                          ),
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 10),
                              Text(
                                '$recommendedCalories',
                                style: TextStyle(fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2633C5).withOpacity(0.8),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'kcal',
                                style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF213333).withOpacity(0.5),
                                ),
                              ),
                            ]
                        ), // padding , center

                        Text(
                          'Today:',
                          style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF213333).withOpacity(0.8),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 10),
                              Text(
                                '$todayCalories',
                                style: TextStyle(fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2633C5).withOpacity(0.8),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'kcal',
                                style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF213333).withOpacity(0.5),
                                ),
                              ),
                            ]
                        ), // padding , center


                      ],
                    ),
                  ),

                  //원형 그래프 & 잔여 칼로리

                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100.0),
                                ),
                                border: new Border.all(
                                    width: 4,
                                    color: Color(0xFF2633C5)
                                        .withOpacity(0.2)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '$leftCalories',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(

                                      fontWeight: FontWeight.normal,
                                      fontSize: 24,
                                      letterSpacing: 0.0,
                                      color: Color(0xFF2633C5),
                                    ),
                                  ),
                                  Text(
                                    'Kcal left',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      color: Color(0xFF3A5160)
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CustomPaint(
                              painter: CurvePainter(
                                  colors: [
                                    Color(0xFF2633C5),
                                    HexColor("#8A98E8"),
                                    HexColor("#8A98E8")
                                  ],
                                  angle: caloriesRatio),
                              child: SizedBox(
                                width: 108,
                                height: 108,
                              ),
                            ),

                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              // 영양소 파트
              Text(
                'Nutrients',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildNutrientBar('Carbohydrate', '#87A0E5', carb_g, eatenCarb),
              _buildNutrientBar('Protein', '#F56E98', protein_g, eatenProtein),
              _buildNutrientBar('Fat', '#F1B440', fat_g, eatenFat),
              SizedBox(height: 20),

              // BMI 파트
              Text(
                'BMI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, bottom: 3),
                // child: Text(
                //     'BMI: ${widget.bmi}',
                //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:Color(0xFF213333).withOpacity(0.8)),
                // ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                        Row(
                          children: [
                            Text('BMI 결과: ${widget.bmi}',
                              style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF213333).withOpacity(0.8),
                              fontWeight: FontWeight.bold),),
                            SizedBox(width: 15),
                            Text(
                            '${calculateBMIResult(widget.bmi).result}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: calculateBMIResult(widget.bmi).color),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      Row(
                        children: results.map((result) {
                          return _buildBar(result);
                        }).toList(),
                      ),

                    ], //children
                  ),
                ),
              ),
            ],
          ),
        ),



      )

    );
  }


  //영양성분
  Widget _buildNutrientBar(String nutrient, String color, double total,
      double current) {
    double ratio = (current / total) * 100;
    if (current == 0) {
      ratio = 0;
    }

    return Column(
      children: [
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    left: 10, bottom: 3)),
            Container(
              width: 100,
              height: 20,
              child: Text('$nutrient',
                style: TextStyle(
                    color: HexColor(color),
                    fontSize: 16,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.w500
                ),
              ),

            ),


            SizedBox(width: 10),

            Positioned(
                left: 100,
                child: Container( // bar background
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor('#7D7D7DFF').withOpacity(0.2),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 1.5 * ratio,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            HexColor(color).withOpacity(0.4), HexColor(color),
                          ]),
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor(color),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        child: Text(
                            '$current g / $total g',
                            style: TextStyle(color: Color(0xFF3A5160)
                                .withOpacity(0.5),
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            )),
                      ),
                    ],
                  ),
                ))


          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBar(BMIResult result) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 60,
            width: 200,

            child: Stack(
              children: [
                Positioned(
                  left:5,
                  child: Text(
                      result.limit,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)
                  ),
                ),
                Positioned(
                  top: 20,
                  child:
                Container(
                  height: 10,
                  width: 200 * (bmi / 35), // 최대 BMI를 기준으로 계산
                  color: result.color,
                ),),

                Positioned(

                  bottom:5,

                  child: Text(
                    result.result,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),



              ],
            ),
          ),
        ],
      ),
    );
  }

}


// 원형 그래프
class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}

// BMI
class BMIResult {
  final String result;
  final Color color;
  final String limit;

  BMIResult({required this.result, required this.color, required this.limit});
}

BMIResult calculateBMIResult(double bmi) {
  if (bmi >= 30) {
    return BMIResult(
        result: "고도비만", color: HexColor("b81414"), limit: "30");
  } else if (bmi >= 25) {
    return BMIResult(
        result: "비만", color: Colors.deepOrange, limit: "20");
  } else if (bmi >= 23) {
    return BMIResult(result: "과체중", color: Colors.orange, limit: "23");
  } else if (bmi >= 18.5) {
    return BMIResult(result: "정상", color: Colors.green, limit: "18.5");
  } else {
    return BMIResult(
        result: "저체중", color: Colors.lightBlue, limit: "0");
  }
}