import 'package:flutter/material.dart';

abstract class SecureStorage {
  Future<void> saveAppLanguage(Locale locale);

  Future<Locale> getAppLanguage();
}
