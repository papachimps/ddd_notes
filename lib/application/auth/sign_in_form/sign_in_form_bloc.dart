import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/auth/value_objects.dart';
import '/domain/auth/auth_failure.dart';

import '/domain/auth/i_auth_facade.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>(
      (event, emit) => event.map(
        emailChanged: (e) {
          emit(
            state.copyWith(
              emailAddress: EmailAddress(e.emailString),
              authFailureOrSuccessOption:
                  none(), //updating email field should flush previous successORfailure status, so reset to none()
            ),
          );
        },
        passwordChanged: (e) {
          emit(
            state.copyWith(
              password: Password(e.passwordString),
              authFailureOrSuccessOption:
                  none(), //updating password field also should flush previous successORfailure status, so reset to none()
            ),
          );
        },
        signInWithEmailAndPasswordPressed: (e) async {
          await _performActionOnAuthFacadeWithEmailAndPassword(
            _authFacade.signInWithEmailAndPassword,
            emit,
          );
        },
        registerWithEmailAndPasswordPressed: (e) async {
          await _performActionOnAuthFacadeWithEmailAndPassword(
            _authFacade.registerWithEmailAndPassword,
            emit,
          );
        },
        signInWithGooglePressed: (e) async {
          emit(
            state.copyWith(
              isSubmitting: true,
              authFailureOrSuccessOption: none(),
            ),
          );
          final failureOrSuccess = await _authFacade.signInWithGoogle();
          emit(
            state.copyWith(
              isSubmitting: false,
              authFailureOrSuccessOption: some(failureOrSuccess),
            ),
          );
        },
      ),
    );
  }

  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit> failureOrSuccess;
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    emit(state.copyWith(
      showErrorMessages: true,
    ));
    
    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );
      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: optionOf(failureOrSuccess),
        ),
      );
    }
  }

  // ignore: unused_element
  Stream<SignInFormState> _performActionOnAuthFacadeWithEmailAndPasswordYielder(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwadedCall,
  ) async* {
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    if (isEmailValid && isPasswordValid) {
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      );
      final failureOrSuccess = await forwadedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
      yield state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      );
    }
  }
}
