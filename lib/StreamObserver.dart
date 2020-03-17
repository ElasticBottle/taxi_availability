import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StreamObserver<T> extends StatelessWidget {
  @required
  final Stream<T> stream;
  @required
  final Function onSuccess;
  final Function onError;
  final Function onWaiting;
  final T initialData;
  const StreamObserver({
    this.stream,
    this.onSuccess,
    this.onError,
    this.onWaiting,
    this.initialData,
  });

  Function get _defaultOnWaiting => (BuildContext context) => Center(
        child: CircularProgressIndicator(),
      );

  Function get _defualtOnError =>
      (BuildContext context, String error) => Text(error);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return (onError != null)
              ? onError(context, snapshot.error.toString())
              : _defualtOnError(context, snapshot.error.toString());
        }
        if (snapshot.hasData) {
          T data = snapshot.data;
          return onSuccess(context, data);
        } else {
          return (onWaiting != null)
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
