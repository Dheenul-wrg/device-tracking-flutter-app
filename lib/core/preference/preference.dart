import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preference.g.dart';

@riverpod
Preference preference(Ref ref) {
  return PrefernceImpl();
}

abstract class Preference {
  Future<T?> getValue<T>(String key);

  Future<void> setValue<T>(String key, T value);
  Future<bool> clear<T>(String key);
  Future<void> clearAll();
}

class PrefernceImpl implements Preference {
  @override
  Future<T?> getValue<T>(String key) async {
    final preference = await SharedPreferences.getInstance();
    if (T == int) {
      return preference.getInt(key) as T?;
    }
    if (T == String) {
      return preference.getString(key) as T?;
    }
    if (T == double) {
      return preference.getDouble(key) as T?;
    }
    if (T == bool) {
      return preference.getBool(key) as T?;
    }
    if (T == List<String>) {
      return preference.getStringList(key) as T?;
    }
    return null;
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    final preference = await SharedPreferences.getInstance();

    if (value is int) {
      await preference.setInt(key, value as int);
    }
    if (value is String) {
      await preference.setString(key, value as String);
    }
    if (value is double) {
      await preference.setDouble(key, value as double);
    }
    if (value is bool) {
      await preference.setBool(key, value as bool);
    }
    if (value is List<String>) {
      await preference.setStringList(key, value as List<String>);
    }
  }

  @override
  Future<bool> clear<T>(String key) async {
    final preference = await SharedPreferences.getInstance();
    return preference.remove(key);
  }

  @override
  Future<void> clearAll() async {
    final preference = await SharedPreferences.getInstance();
    await preference.clear();
  }
}
