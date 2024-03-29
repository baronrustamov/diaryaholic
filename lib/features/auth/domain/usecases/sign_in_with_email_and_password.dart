import 'package:dairy_app/core/errors/validation_exceptions.dart';
import 'package:dairy_app/core/logger/logger.dart';
import 'package:dairy_app/core/usecase/usecase_template.dart';
import 'package:dairy_app/features/auth/core/failures/failures.dart';
import 'package:dairy_app/features/auth/core/validators/email_validator.dart';
import 'package:dairy_app/features/auth/domain/entities/logged_in_user.dart';
import 'package:dairy_app/features/auth/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

final log = printer("AuthSignInUseCase");

class SignInWithEmailAndPassword
    implements UseCase<LoggedInUser, SignInParams> {
  final EmailValidator emailValidator;
  final IAuthenticationRepository authenticationRepository;

  SignInWithEmailAndPassword(
      {required this.emailValidator, required this.authenticationRepository});

  /// Validates [email]  and continues sign in process by calling repository's
  /// signUpWithEmailAndPassword method
  @override
  Future<Either<SignInFailure, LoggedInUser>> call(SignInParams params) {
    log.i(params);

    try {
      emailValidator(params.email);
    } on InvalidEmailException {
      log.w("Validation for email failed");
      return Future.value(Left(SignInFailure.invalidEmail()));
    }
    log.d("Email valdation passed");

    return authenticationRepository.signInWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  String toString() {
    return "$email, $password";
  }

  @override
  List<Object?> get props => [email, password];
}
