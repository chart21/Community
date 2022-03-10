import 'package:flutter/material.dart';

import 'myFilterCheckBox.dart';

//Shows the filter checkboxes when the user tabs on the filter button or swipes the filter in
class myCheckboxBar extends StatelessWidget {
  final List<IconData> icons;
  final Function(int, bool) notifyFilter;
  final List<bool> filterValues;
  const myCheckboxBar(
      {Key key, this.icons, this.notifyFilter, this.filterValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> iconContainers = new List();
    for (var i = 0; i < icons.length; i++) {
      MyFilterCheckBox iconContainer = MyFilterCheckBox(
          icon: icons[i],
          index: i,
          value: filterValues[i],
          notifyParent: _updateFilterValues);
      iconContainers.add(iconContainer);
    }

    return Container(
      width: (icons.length * 55).toDouble(),
      height: 50,
      child: Row(children: iconContainers),
    );
  }

  _updateFilterValues(int index, bool value) {
    notifyFilter(index, value);
  }
}
