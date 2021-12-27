import 'package:dartz/dartz.dart';

import '/domain/core/value_object.dart';
import '/domain/core/failures.dart';
import '/domain/core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    // assert(input != null);
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  const EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    // assert(input != null);
    return Password._(
      validatePassword(input),
    );
  }

  const Password._(this.value);
}




/*
void showingEmailAddressOrFailure() {
  final emailAddress = EmailAddress('asjahgcja');

  String emailText = emailAddress.value.fold(
    (left) => 'Failure occured, more precisely: $left',
    (right) => right,
  );

  String emailText2 =
      emailAddress.value.getOrElse(() => 'Some Failure happened!');
}
*/