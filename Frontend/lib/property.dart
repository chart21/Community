import 'package:flutter/material.dart';
import 'dart:async';

//links starrating of review page to state
class Property<T> {
  StreamController<T> _controller;
  T _value;
  T get value => _value;
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _controller.add(newValue);
    }
  }

  Stream<T> get stream => _controller.stream;
  Property(T initialValue) {
    _value = initialValue;
    _controller = StreamController.broadcast(
      sync: true,
      onListen: () => _controller.add(_value),
    );
  }
}

class PropertyBuilder<T> extends StreamBuilder<T> {
  PropertyBuilder({
    Key key,
    @required Property<T> property,
    @required Widget Function(BuildContext, T) builder,
  }) : super(
          key: key,
          stream: property.stream,
          initialData: property.value,
          builder: (context, snapshot) {
            assert(snapshot.hasData);
            assert(!snapshot.hasError);
            return builder(context, snapshot.data);
          },
        );
}
