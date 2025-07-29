import 'package:konstudy/controllers/auth/iauth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gotrue/src/types/user.dart';

class FakeAuthController extends StateNotifier<AsyncValue<User?>> implements IAuthController {
  FakeAuthController() : super(const AsyncData(null));

  @override
  // TODO: implement currentUser
  User? get currentUser => throw UnimplementedError();

  @override
  Future<void> handleVerificationCallBackAndRedirect(BuildContext context) {
    // TODO: implement handleVerificationCallBackAndRedirect
    throw UnimplementedError();
  }

  @override
  Future<void> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async{
    return;
  }

  @override
  Future<void> signUp(String email, String password, String name) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}