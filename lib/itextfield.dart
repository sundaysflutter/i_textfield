import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///自带删除的ITextField
typedef void ITextFieldCallBack(String content);
typedef void IEyeCallBack(ITextInputType inputType, bool isopen);

enum ITextInputType {
  phone,
  emailAddress,
  text,
  multiline,
  number,
  datetime,
  url,
  password
}

class ITextField extends StatefulWidget {
  final ITextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final String hintText;
  final TextStyle hintStyle;
  final ITextFieldCallBack fieldCallBack;
  final Alignment rightIconsAligment;
  final double rightIconsSpace;
  final Widget deleteIcon;
  final Widget pwdEyeIcon;
  final Widget pwdEyeCloseIcon;
  final IEyeCallBack eyeCallBack;
  final Widget otherWidget;
  final bool isOtherFloorDel;
  final InputBorder inputBorder;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final FormFieldValidator<String> validator;

  ITextField(
      {Key key,
      ITextInputType keyboardType: ITextInputType.text,
      this.maxLines = 1,
      this.maxLength,
      this.hintText,
      this.hintStyle,
      this.fieldCallBack,
      this.rightIconsAligment = Alignment.centerRight,
      this.rightIconsSpace = 4,
      this.deleteIcon,
      this.pwdEyeIcon,
      this.pwdEyeCloseIcon,
      this.eyeCallBack,
      this.otherWidget,
      this.isOtherFloorDel = false,
      this.inputBorder,
      this.prefixIcon,
      this.textStyle,
      this.validator})
      : assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);

  @override
  State<StatefulWidget> createState() => ITextFieldState();
}

class ITextFieldState extends State<ITextField> {
  String _inputText = "";
  bool _hasdeleteIcon = false;
  bool _isNumber = false;
  bool _isPassword = false;
  bool showPwd = true;

  ///输入类型
  TextInputType _getTextInputType() {
    TextInputType textType = TextInputType.text;
    switch (widget.keyboardType) {
      case ITextInputType.text:
        textType = TextInputType.text;
        break;
      case ITextInputType.multiline:
        textType = TextInputType.multiline;
        break;
      case ITextInputType.number:
        _isNumber = true;
        textType = TextInputType.number;
        break;
      case ITextInputType.phone:
        _isNumber = true;
        textType = TextInputType.phone;
        break;
      case ITextInputType.datetime:
        textType = TextInputType.datetime;
        break;
      case ITextInputType.emailAddress:
        textType = TextInputType.emailAddress;
        break;
      case ITextInputType.url:
        textType = TextInputType.url;
        break;
      case ITextInputType.password:
        _isPassword = true;
        textType = TextInputType.text;
        break;
      default:
    }
    return textType;
  }

  TextEditingController mControll3 = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  ///输入范围
  List<TextInputFormatter> _getTextInputFormatter() {
    return _isNumber
        ? <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ]
        : null;
  }

  @override
  void dispose() {
    mControll3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextField textField = new TextField(
      controller: mControll3,
      decoration: InputDecoration(
          hintStyle: widget.hintStyle,
          counterStyle: TextStyle(color: Colors.white),
          hintText: widget.hintText,
          border: widget.inputBorder != null
              ? widget.inputBorder
              : UnderlineInputBorder(),
          fillColor: Colors.transparent,
          filled: true,
          prefixIcon: widget.prefixIcon,
          focusColor: Colors.white.withOpacity(0.5),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          )),
      onChanged: (str) {
        _inputText = str;
        _hasdeleteIcon = _inputText.isNotEmpty;
        if (widget.fieldCallBack != null) {
          widget.fieldCallBack(_inputText);
        }
        setState(() {});
      },
      keyboardType: _getTextInputType(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: _isPassword,
    );

    List<Widget> floorChilden() {
      List<Widget> arr = [];
      if (widget.isOtherFloorDel) {
        if (_hasdeleteIcon) {
          if (widget.otherWidget != null) {
            arr.add(widget.otherWidget);
            arr.add(SizedBox(
              width: widget.rightIconsSpace,
            ));
          }
        }
      } else {
        if (widget.otherWidget != null) {
          arr.add(widget.otherWidget);
          arr.add(SizedBox(
            width: widget.rightIconsSpace,
          ));
        }
      }
      return arr;
    }

    return Container(
        width: double.maxFinite,
        child: Stack(
          alignment: widget.rightIconsAligment,
          children: [
            Align(alignment: Alignment.center, child: textField),
            Align(
                // alignment: Alignment(1, 1),
                child: Container(
                    child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _hasdeleteIcon
                    ? GestureDetector(
                        child: widget.deleteIcon ?? Container(),
                        onTap: () {
                          _inputText = '';
                          mControll3.clear();
                        },
                      )
                    : Container(),
                widget.deleteIcon != null
                    ? SizedBox(
                        width: widget.rightIconsSpace,
                      )
                    : Container(),
                _hasdeleteIcon
                    ? GestureDetector(
                        child: _isPassword == true
                            ? widget.pwdEyeCloseIcon
                            : widget.pwdEyeIcon,
                        onTap: () {
                          _isPassword = !_isPassword;

                          ITextInputType callType = _isPassword == true
                              ? ITextInputType.password
                              : ITextInputType.text;
                          if (widget.eyeCallBack != null) {
                            widget.eyeCallBack(callType, _isPassword);
                          }
                          setState(() {});
                        },
                      )
                    : Container(),
                (widget.pwdEyeCloseIcon != null || widget.pwdEyeIcon != null)
                    ? SizedBox(
                        width: widget.rightIconsSpace,
                      )
                    : Container(),
                ...floorChilden(),
                SizedBox(
                  width: widget.rightIconsSpace,
                  // height: 50,
                ),
              ],
            )))
          ],
        ));
  }
}

class IButtonTextField extends StatefulWidget {
  final ITextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final String hintText;
  final TextStyle hintStyle;
  final ITextFieldCallBack fieldCallBack;
  final Widget deleteIcon;
  final Alignment rightIconsAligment;
  final double rightIconsSpace;
  final Widget otherWidget;
  final InputBorder inputBorder;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final FormFieldValidator<String> validator;

  IButtonTextField(
      {Key key,
      ITextInputType keyboardType: ITextInputType.text,
      this.maxLines = 1,
      this.maxLength,
      this.hintText,
      this.hintStyle,
      this.fieldCallBack,
      this.deleteIcon,
      this.rightIconsAligment = Alignment.centerRight,
      this.rightIconsSpace = 4,
      this.otherWidget,
      this.inputBorder,
      this.prefixIcon,
      this.textStyle,
      this.validator})
      : assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);
  @override
  _IButtonTextFieldState createState() => _IButtonTextFieldState();
}

class _IButtonTextFieldState extends State<IButtonTextField> {
  String _inputText = "";
  bool _hasdeleteIcon = false;
  bool _isNumber = false;
  bool _isPassword = false;
  bool showPwd = true;

  ///输入类型
  TextInputType _getTextInputType() {
    TextInputType textType = TextInputType.text;
    switch (widget.keyboardType) {
      case ITextInputType.text:
        textType = TextInputType.text;
        break;
      case ITextInputType.multiline:
        textType = TextInputType.multiline;
        break;
      case ITextInputType.number:
        _isNumber = true;
        textType = TextInputType.number;
        break;
      case ITextInputType.phone:
        _isNumber = true;
        textType = TextInputType.phone;
        break;
      case ITextInputType.datetime:
        textType = TextInputType.datetime;
        break;
      case ITextInputType.emailAddress:
        textType = TextInputType.emailAddress;
        break;
      case ITextInputType.url:
        textType = TextInputType.url;
        break;
      case ITextInputType.password:
        _isPassword = true;
        textType = TextInputType.text;
        break;
      default:
    }
    return textType;
  }

  TextEditingController mControll3 = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  ///输入范围
  List<TextInputFormatter> _getTextInputFormatter() {
    return _isNumber
        ? <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ]
        : null;
  }

  @override
  void dispose() {
    mControll3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextField textField = new TextField(
      controller: mControll3,
      decoration: InputDecoration(
        hintStyle: widget.hintStyle,
        counterStyle: TextStyle(color: Colors.white),
        hintText: widget.hintText,
        border: widget.inputBorder != null
            ? widget.inputBorder
            : UnderlineInputBorder(),
        fillColor: Colors.transparent,
        filled: true,
        prefixIcon: widget.prefixIcon,
        focusColor: Colors.white.withOpacity(0.5),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      onChanged: (str) {
        _inputText = str;
        _hasdeleteIcon = (_inputText.isNotEmpty);
        if (widget.fieldCallBack != null) {
          widget.fieldCallBack(_inputText);
        }
        setState(
          () {},
        );
      },
      keyboardType: _getTextInputType(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: _isPassword,
    );
    return Container(
      // width: double.maxFinite,
      // alignment: AlignmentDirectional.centerEnd,

      child: Stack(alignment: widget.rightIconsAligment, children: <Widget>[
        Align(alignment: Alignment.center, child: textField),
        Align(
            // alignment: Alignment(1, 1),
            child: Container(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _hasdeleteIcon
                ? GestureDetector(
                    child: widget.deleteIcon ?? Container(),
                    onTap: () {
                      _inputText = '';
                      mControll3.clear();
                    },
                  )
                : Container(),
            widget.deleteIcon != null
                ? SizedBox(
                    width: widget.rightIconsSpace,
                  )
                : Container(),
            widget.otherWidget ?? Container(),
            SizedBox(
              width: widget.rightIconsSpace,
            ),
          ],
        )))
      ]),
    );
  }
}
