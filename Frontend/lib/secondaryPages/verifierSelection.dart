import 'package:flutter/material.dart';

//Allows user to automatically select a verifier or pick one manually
class VerifierSelection extends StatefulWidget {
  final List<String> objectTypes;
  final bool withSendButton;
  const VerifierSelection({Key key, this.objectTypes, this.withSendButton})
      : super(key: key);

  @override
  _VerifierSelectionState createState() => _VerifierSelectionState();
}

class _VerifierSelectionState extends State<VerifierSelection> {
  bool _selected = true;
/**
  var objectTypes = [
    'Automatically',
    'Post Ident',
    'Verifier 2',
    'Verifier 3',
    'Verifier 4'
  ];
   */
  var _selectedObjectType = 'Automatically';

  @override
  Widget build(BuildContext context) {
    if (_selected == true) {
      return Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Checkbox(
              value: _selected,
              onChanged: (bool val) {
                setState(() {
                  _selected = val;
                });
              }),
          Text('Select Receiver automatically'),
        ]),
        widget.withSendButton == true
            ? RaisedButton(
                color: Colors.black,
                textColor: Colors.white,
                child: Text('Send'),
                onPressed: () {},
              )
            : Opacity(opacity: 1),
      ]);
    } else {
      return Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.white, //This will change the canvas background to white.
          //other styles
        ),
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Choose Receiver   '),
              DropdownButton<String>(
                  value: _selectedObjectType,
                  onChanged: (String newValue) {
                    setState(() {
                      // viewModel.classType = newValue;
                      _selectedObjectType = newValue;
                    });
                  },
                  items: widget.objectTypes.map((String objectType) {
                    return new DropdownMenuItem<String>(
                        value: objectType,
                        child: new Text(objectType.toString()));
                  }).toList()),
            ]),
            widget.withSendButton == true
                ? RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text('Send'),
                    onPressed: () {},
                  )
                : Opacity(opacity: 1),
          ],
        ),
      );
    }
  }
}
