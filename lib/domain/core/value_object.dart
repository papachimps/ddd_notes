import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '/domain/core/errors.dart';
import '/domain/core/failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();

  ///Throws [UnExpectedValueError] containing [ValueFailure]
  T getOrCrash() {
    // id = identity; same as (right) => right
    return value.fold((f) =>  throw UnexpectedValueError(f), id);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "Value:$value";
}
