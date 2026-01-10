import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const AppBarAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppBarAction &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          label == other.label;

  @override
  int get hashCode => icon.hashCode ^ label.hashCode;
}

class AppBarConfig {
  final String title;
  final List<AppBarAction> actions;
  final bool centerTitle;
  final bool isSearchEnabled;
  final String? searchHint;

  const AppBarConfig({
    required this.title,
    this.actions = const [],
    this.centerTitle = true,
    this.isSearchEnabled = false,
    this.searchHint,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppBarConfig &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          listEquals(actions, other.actions) &&
          centerTitle == other.centerTitle &&
          isSearchEnabled == other.isSearchEnabled &&
          searchHint == other.searchHint;

  @override
  int get hashCode => Object.hash(
    title,
    Object.hashAll(actions),
    centerTitle,
    isSearchEnabled,
    searchHint,
  );
}

class AppBarConfigNotifier extends StateNotifier<AppBarConfig> {
  AppBarConfigNotifier()
    : super(const AppBarConfig(title: 'RightLogistics', actions: []));

  void setConfig(AppBarConfig config) {
    if (state != config) {
      state = config;
    }
  }

  void reset() {
    state = const AppBarConfig(title: 'RightLogistics', actions: []);
  }
}

// Keyed by route to ensure consistency across navigation
final appBarConfigProvider =
    StateNotifierProvider.family<AppBarConfigNotifier, AppBarConfig, String>((
      ref,
      route,
    ) {
      return AppBarConfigNotifier();
    });

final isSearchingProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');
