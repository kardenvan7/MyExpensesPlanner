// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../../domain/models/transaction.dart' as _i9;
import '../../domain/models/transaction_category.dart' as _i10;
import '../ui/core/widgets/color_picker_screen.dart' as _i5;
import '../ui/edit_category/edit_category_screen.dart' as _i3;
import '../ui/edit_transaction/edit_transaction_screen.dart' as _i2;
import '../ui/main/main_screen.dart' as _i1;
import '../ui/period_statistics/period_statistics_screen.dart' as _i6;
import '../ui/settings/settings_screen.dart' as _i4;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.MainScreen());
    },
    EditTransactionRoute.name: (routeData) {
      final args = routeData.argsAs<EditTransactionRouteArgs>(
          orElse: () => const EditTransactionRouteArgs());
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.EditTransactionScreen(
              transaction: args.transaction, key: args.key));
    },
    EditCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<EditCategoryRouteArgs>(
          orElse: () => const EditCategoryRouteArgs());
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.EditCategoryScreen(
              onEditFinish: args.onEditFinish,
              category: args.category,
              key: args.key));
    },
    SettingsRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SettingsScreen());
    },
    ColorPickerRoute.name: (routeData) {
      final args = routeData.argsAs<ColorPickerRouteArgs>(
          orElse: () => const ColorPickerRouteArgs());
      return _i7.MaterialPageX<_i8.Color?>(
          routeData: routeData,
          child: _i5.ColorPickerScreen(
              initialColor: args.initialColor, key: args.key));
    },
    PeriodStatisticsRoute.name: (routeData) {
      final args = routeData.argsAs<PeriodStatisticsRouteArgs>(
          orElse: () => const PeriodStatisticsRouteArgs());
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.PeriodStatisticsScreen(
              dateTimeRange: args.dateTimeRange, key: args.key));
    }
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig('/#redirect',
            path: '/', redirectTo: '/main', fullMatch: true),
        _i7.RouteConfig(MainRoute.name, path: '/main'),
        _i7.RouteConfig(EditTransactionRoute.name, path: '/edit_transaction'),
        _i7.RouteConfig(EditCategoryRoute.name, path: '/edit_category'),
        _i7.RouteConfig(SettingsRoute.name, path: '/settings'),
        _i7.RouteConfig(ColorPickerRoute.name, path: '/color_picker'),
        _i7.RouteConfig(PeriodStatisticsRoute.name, path: '/period_statistics')
      ];
}

/// generated route for
/// [_i1.MainScreen]
class MainRoute extends _i7.PageRouteInfo<void> {
  const MainRoute() : super(MainRoute.name, path: '/main');

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.EditTransactionScreen]
class EditTransactionRoute extends _i7.PageRouteInfo<EditTransactionRouteArgs> {
  EditTransactionRoute({_i9.Transaction? transaction, _i8.Key? key})
      : super(EditTransactionRoute.name,
            path: '/edit_transaction',
            args: EditTransactionRouteArgs(transaction: transaction, key: key));

  static const String name = 'EditTransactionRoute';
}

class EditTransactionRouteArgs {
  const EditTransactionRouteArgs({this.transaction, this.key});

  final _i9.Transaction? transaction;

  final _i8.Key? key;

  @override
  String toString() {
    return 'EditTransactionRouteArgs{transaction: $transaction, key: $key}';
  }
}

/// generated route for
/// [_i3.EditCategoryScreen]
class EditCategoryRoute extends _i7.PageRouteInfo<EditCategoryRouteArgs> {
  EditCategoryRoute(
      {void Function(String?)? onEditFinish,
      _i10.TransactionCategory? category,
      _i8.Key? key})
      : super(EditCategoryRoute.name,
            path: '/edit_category',
            args: EditCategoryRouteArgs(
                onEditFinish: onEditFinish, category: category, key: key));

  static const String name = 'EditCategoryRoute';
}

class EditCategoryRouteArgs {
  const EditCategoryRouteArgs({this.onEditFinish, this.category, this.key});

  final void Function(String?)? onEditFinish;

  final _i10.TransactionCategory? category;

  final _i8.Key? key;

  @override
  String toString() {
    return 'EditCategoryRouteArgs{onEditFinish: $onEditFinish, category: $category, key: $key}';
  }
}

/// generated route for
/// [_i4.SettingsScreen]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: '/settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i5.ColorPickerScreen]
class ColorPickerRoute extends _i7.PageRouteInfo<ColorPickerRouteArgs> {
  ColorPickerRoute({_i8.Color? initialColor, _i8.Key? key})
      : super(ColorPickerRoute.name,
            path: '/color_picker',
            args: ColorPickerRouteArgs(initialColor: initialColor, key: key));

  static const String name = 'ColorPickerRoute';
}

class ColorPickerRouteArgs {
  const ColorPickerRouteArgs({this.initialColor, this.key});

  final _i8.Color? initialColor;

  final _i8.Key? key;

  @override
  String toString() {
    return 'ColorPickerRouteArgs{initialColor: $initialColor, key: $key}';
  }
}

/// generated route for
/// [_i6.PeriodStatisticsScreen]
class PeriodStatisticsRoute
    extends _i7.PageRouteInfo<PeriodStatisticsRouteArgs> {
  PeriodStatisticsRoute({_i8.DateTimeRange? dateTimeRange, _i8.Key? key})
      : super(PeriodStatisticsRoute.name,
            path: '/period_statistics',
            args: PeriodStatisticsRouteArgs(
                dateTimeRange: dateTimeRange, key: key));

  static const String name = 'PeriodStatisticsRoute';
}

class PeriodStatisticsRouteArgs {
  const PeriodStatisticsRouteArgs({this.dateTimeRange, this.key});

  final _i8.DateTimeRange? dateTimeRange;

  final _i8.Key? key;

  @override
  String toString() {
    return 'PeriodStatisticsRouteArgs{dateTimeRange: $dateTimeRange, key: $key}';
  }
}
