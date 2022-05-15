// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../../domain/models/transactions/transaction.dart' as _i8;
import '../../domain/models/categories/transaction_category.dart' as _i9;
import '../ui/core/widgets/color_picker_screen.dart' as _i5;
import '../ui/edit_category/edit_category_screen.dart' as _i3;
import '../ui/edit_transaction/edit_transaction_screen.dart' as _i2;
import '../ui/main/main_screen.dart' as _i1;
import '../ui/settings/settings_screen.dart' as _i4;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.MainScreen());
    },
    EditTransactionRoute.name: (routeData) {
      final args = routeData.argsAs<EditTransactionRouteArgs>(
          orElse: () => const EditTransactionRouteArgs());
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.EditTransactionScreen(
              transaction: args.transaction, key: args.key));
    },
    EditCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<EditCategoryRouteArgs>(
          orElse: () => const EditCategoryRouteArgs());
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.EditCategoryScreen(
              onEditFinish: args.onEditFinish,
              category: args.category,
              key: args.key));
    },
    SettingsRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SettingsScreen());
    },
    ColorPickerRoute.name: (routeData) {
      final args = routeData.argsAs<ColorPickerRouteArgs>(
          orElse: () => const ColorPickerRouteArgs());
      return _i6.MaterialPageX<_i7.Color?>(
          routeData: routeData,
          child: _i5.ColorPickerScreen(
              initialColor: args.initialColor, key: args.key));
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig('/#redirect',
            path: '/', redirectTo: '/main', fullMatch: true),
        _i6.RouteConfig(MainRoute.name, path: '/main'),
        _i6.RouteConfig(EditTransactionRoute.name, path: '/edit_transaction'),
        _i6.RouteConfig(EditCategoryRoute.name, path: '/edit_category'),
        _i6.RouteConfig(SettingsRoute.name, path: '/settings'),
        _i6.RouteConfig(ColorPickerRoute.name, path: '/color_picker')
      ];
}

/// generated route for
/// [_i1.MainScreen]
class MainRoute extends _i6.PageRouteInfo<void> {
  const MainRoute() : super(MainRoute.name, path: '/main');

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.EditTransactionScreen]
class EditTransactionRoute extends _i6.PageRouteInfo<EditTransactionRouteArgs> {
  EditTransactionRoute({_i8.Transaction? transaction, _i7.Key? key})
      : super(EditTransactionRoute.name,
            path: '/edit_transaction',
            args: EditTransactionRouteArgs(transaction: transaction, key: key));

  static const String name = 'EditTransactionRoute';
}

class EditTransactionRouteArgs {
  const EditTransactionRouteArgs({this.transaction, this.key});

  final _i8.Transaction? transaction;

  final _i7.Key? key;

  @override
  String toString() {
    return 'EditTransactionRouteArgs{transaction: $transaction, key: $key}';
  }
}

/// generated route for
/// [_i3.EditCategoryScreen]
class EditCategoryRoute extends _i6.PageRouteInfo<EditCategoryRouteArgs> {
  EditCategoryRoute(
      {void Function(String?)? onEditFinish,
      _i9.TransactionCategory? category,
      _i7.Key? key})
      : super(EditCategoryRoute.name,
            path: '/edit_category',
            args: EditCategoryRouteArgs(
                onEditFinish: onEditFinish, category: category, key: key));

  static const String name = 'EditCategoryRoute';
}

class EditCategoryRouteArgs {
  const EditCategoryRouteArgs({this.onEditFinish, this.category, this.key});

  final void Function(String?)? onEditFinish;

  final _i9.TransactionCategory? category;

  final _i7.Key? key;

  @override
  String toString() {
    return 'EditCategoryRouteArgs{onEditFinish: $onEditFinish, category: $category, key: $key}';
  }
}

/// generated route for
/// [_i4.SettingsScreen]
class SettingsRoute extends _i6.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: '/settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i5.ColorPickerScreen]
class ColorPickerRoute extends _i6.PageRouteInfo<ColorPickerRouteArgs> {
  ColorPickerRoute({_i7.Color? initialColor, _i7.Key? key})
      : super(ColorPickerRoute.name,
            path: '/color_picker',
            args: ColorPickerRouteArgs(initialColor: initialColor, key: key));

  static const String name = 'ColorPickerRoute';
}

class ColorPickerRouteArgs {
  const ColorPickerRouteArgs({this.initialColor, this.key});

  final _i7.Color? initialColor;

  final _i7.Key? key;

  @override
  String toString() {
    return 'ColorPickerRouteArgs{initialColor: $initialColor, key: $key}';
  }
}
