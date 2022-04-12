import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils.dart';
import 'num_p.dart';

class NumPage extends StatefulWidget {
  final Function(BuildContext, String) getText;
  final String? title;
  final String? initText;
  final double? balance;

  const NumPage({Key? key, required this.getText, this.title, this.initText, this.balance}) : super(key: key);

  @override
  State<NumPage> createState() => _NumPageState();
}

class _NumPageState extends State<NumPage> {
  final TextEditingController _myController = TextEditingController();
  @override
  void initState() {
    _myController.text = widget.initText ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _chia = 10;
    double _stepAmount = 10;
    if (widget.initText != null) {
      // _myController.text = widget.initText!;
      _stepAmount = double.parse(widget.initText ?? '0') / _chia;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? enterNum)),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // display the entered numbers
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 70,
                  child: Center(
                      child: TextField(
                    controller: _myController,
                    showCursor: true,
                    keyboardType: TextInputType.none, // Disable the default soft keybaord
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const InputDecoration(filled: true, fillColor: Colors.white10),
                  )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: const Icon(Icons.cancel, color: Colors.grey, size: 30),
                    onTap: () => setState(() {
                      _myController.text = '';
                    }),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Icon(Icons.remove, color: Colors.white),
                    style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
                    onPressed: () {
                      setState(() {
                        double _num = double.parse(_myController.text == '' ? '0' : _myController.text);
                        if (_num >= ((_stepAmount * _chia) + _stepAmount)) {
                          _myController.text = (_num - _stepAmount).toString();
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Icon(Icons.add, color: Colors.white),
                    style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
                    onPressed: () {
                      setState(() {
                        double _num = double.parse(_myController.text == '' ? '0' : _myController.text);
                        _myController.text = (_num + _stepAmount).toString();
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        border: Border.all(color: AppColors.primaryDeep, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                      ),
                      child: const Text('MIN', style: TextStyle(color: Colors.white)),
                    ),
                    onTap: () {
                      setState(() {
                        _myController.text = widget.initText ?? '0';
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        border: Border.all(color: AppColors.primaryDeep, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                      ),
                      child: const Text('MAX', style: TextStyle(color: Colors.white)),
                    ),
                    onTap: () {
                      setState(() {
                        _myController.text = (widget.balance ?? 0).floorToDouble().toString();
                      });
                    },
                  ),
                ],
              ),
              // implement the custom NumPad
              NumPad(
                buttonSize: 75,
                buttonColor: Colors.white12,
                iconColor: Colors.deepOrange,
                controller: _myController,
                delete: () => _myController.text = _myController.text.substring(0, _myController.text.length - 1),
                onSubmit: () {
                  widget.getText(context, _myController.text);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
