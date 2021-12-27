import 'package:dartz/dartz.dart';

import '/domain/auth/value_objects.dart';
import '/domain/auth/auth_failure.dart';

// [i for] is an Interface between Application layer and Infrastructure layer.
// facade is a design pattern to abstract weird implementations into clear defintions
// any class starting with "I" is OUR convention for interface class and
// they will be abstract classes
// facade is like repositories but more

// Unit inside right of Either is to return nothing(as a dud replacement)...we can't return void, as its not a class/type

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}
