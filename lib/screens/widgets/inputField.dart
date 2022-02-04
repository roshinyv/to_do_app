import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  final String? title;
  final String? hint;
  final Widget? widget;
  final TextEditingController? controller;
  const InputField(
      {Key? key, this.title, this.hint, this.controller, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 14),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor: Get.isDarkMode ? Colors.grey : Colors.white,
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: hint,
                      // hintStyle:
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: context.theme.backgroundColor,
                        width: 0,
                      )),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: context.theme.backgroundColor,
                        width: 0,
                      ))),
                )),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
