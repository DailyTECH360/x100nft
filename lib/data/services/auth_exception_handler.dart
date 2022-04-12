import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils.dart';
import 'auth_result_status.dart';

class AuthExceptionHandler {
  static handleException(e) {
    // debugPrint(e.code);
    Get.defaultDialog(
      middleText: '$singinFail!\n${e.code}',
      textConfirm: ok,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
    AuthResultStatus status;
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        status = AuthResultStatus.invalidEmail;
        break;
      case 'ERROR_WRONG_PASSWORD':
        status = AuthResultStatus.wrongPassword;
        break;
      case 'ERROR_USER_NOT_FOUND':
        status = AuthResultStatus.userNotFound;
        break;
      case 'ERROR_USER_DISABLED':
        status = AuthResultStatus.userDisabled;
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        status = AuthResultStatus.tooManyRequests;
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        status = AuthResultStatus.operationNotAllowed;
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = emailNotFormat;
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = passWrong;
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = emailNotExist;
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = emailDisabled;
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = manyReq;
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = emailNotEnabled;
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = emailAlreadyReg;
        break;
      default:
        errorMessage = undefinedError;
    }

    return errorMessage;
  }
}
