import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController controller = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
//      width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.grey[100], image: const DecorationImage(image: AssetImage('assets/background.png'))),
        child: Stack(
          children: <Widget>[
            PageView(
              onPageChanged: (value) => setState(() => pageIndex = value),
              controller: controller,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Image.asset('assets/firstScreen.png', height: 200, width: 200),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Get Any Thing Online',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16.0),
                      child: Text(
                        'You can buy anything ranging from digital products to hardware within few clicks.',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Image.asset('assets/secondScreen.png', height: 200, width: 200),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Shipping to anywhere ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16.0),
                      child: Text(
                        'We will ship to anywhere in the world, With 30 day 100% money back policy.',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Image.asset('assets/thirdScreen.png', height: 200, width: 200),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text('On-time delivery', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16.0),
                      child: Text(
                        'You can track your product with our powerful tracking service.',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 16.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                            color: pageIndex == 0 ? Colors.yellow : Colors.white,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                            color: pageIndex == 1 ? Colors.yellow : Colors.white,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                            color: pageIndex == 2 ? Colors.yellow : Colors.white,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Opacity(
                          opacity: pageIndex != 2 ? 1.0 : 0.0,
                          child: ElevatedButton(
                            child: const Text('SKIP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            onPressed: () => Get.toNamed('/join'),
                          ),
                        ),
                        pageIndex != 2
                            ? ElevatedButton(
                                child: const Text('NEXT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                onPressed: () {
                                  if (!(controller.page == 2.0)) controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
                                },
                              )
                            : ElevatedButton(
                                child: const Text('FINISH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                onPressed: () => Get.toNamed('/join'),
                              )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}