import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ErrorWidgetBuilder =
    Widget Function(Object error, StackTrace stackTrace);
typedef LoadingWidgetBuilder = Widget Function();

class AsyncValueWidget<T> extends ConsumerWidget {
  const AsyncValueWidget({
    required this.asyncValue,
    required this.data,
    super.key,
    this.error,
    this.loading,
  });
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) data;
  final ErrorWidgetBuilder? error;
  final LoadingWidgetBuilder? loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncValue.when(
      data: data,
      error: error ?? _defaultErrorWidgetBuilder,
      loading: loading ?? _defaultProgressWidgetBuilder,
    );
  }

  Widget _defaultProgressWidgetBuilder() => const _ProgressWidget();

  Widget _defaultErrorWidgetBuilder(error, stackTrace) =>
      _ErrorWidget(error, stackTrace);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<AsyncValue<T>>('asyncValue', asyncValue),
    );
    properties.add(
      ObjectFlagProperty<Widget Function(T data)>.has('data', data),
    );
    properties.add(ObjectFlagProperty<ErrorWidgetBuilder?>.has('error', error));
    properties.add(
      ObjectFlagProperty<LoadingWidgetBuilder?>.has('loading', loading),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget(this.error, this.stackTrace);
  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('error'));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object?>('error', error));
    properties.add(DiagnosticsProperty<StackTrace?>('stackTrace', stackTrace));
  }
}

class _ProgressWidget extends StatelessWidget {
  const _ProgressWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
