import 'package:elara/features/auth/data/models/auth_model.dart';
import 'package:elara/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequest request);
  Future<RegisteredUserData> register(RegisterRequest request);
  Future<void> verifyEmail(VerifyEmailRequest request);
}
