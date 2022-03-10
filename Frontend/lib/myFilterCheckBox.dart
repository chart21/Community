import 'package:flutter/material.dart';

//single filtercheckbox to check or uncheck an option
class MyFilterCheckBox extends StatefulWidget {
  final IconData icon;
  final bool value;
  final int index;
  final Function(int, bool) notifyParent;
  MyFilterCheckBox(
      {Key key, this.icon, this.value, this.notifyParent, this.index})
      : super(key: key);

  _MyFilterCheckBoxState createState() => _MyFilterCheckBoxState();
}

class _MyFilterCheckBoxState extends State<MyFilterCheckBox> {
  bool _isChecked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isChecked = widget.value;
  }

  void onChanged(bool value) {
    setState(() {
      _isChecked = value;
    });
    print(_isChecked);
    widget.notifyParent(widget.index, _isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 55,
      color: Colors.white,
      alignment: Alignment.centerRight,
      child: Stack(
        children: <Widget>[
          IconButton(
              onPressed: () {
                if (_isChecked) {
                  setState(() {
                    _isChecked = false;
                  });
                } else {
                  setState(() {
                    _isChecked = true;
                  });
                }
              },
              iconSize: 30,
              icon: Icon(widget.icon)),
          Container(
            height: 25,
            alignment: Alignment.centerRight,
            child: Checkbox(
              value: _isChecked,
              onChanged: (bool value) {
                onChanged(value);
              },
            ),
          )
        ],
      ),
    );
  }
}
