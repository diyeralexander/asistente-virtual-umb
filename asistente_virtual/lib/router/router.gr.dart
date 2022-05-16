// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppAutoRouter extends RootStackRouter {
  _$AppAutoRouter([GlobalKey<NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HomePage());
    },
    ManipulateNoteRoute.name: (routeData) {
      final args = routeData.argsAs<ManipulateNoteRouteArgs>(
          orElse: () => const ManipulateNoteRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ManipulateNotePage(key: args.key, note: args.note));
    },
    CommandRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const CommandPage());
    },
    NotesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NotesPage());
    },
    TodosRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const TodosPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(HomeRoute.name, path: '/', children: [
          RouteConfig(CommandRoute.name,
              path: 'command-page', parent: HomeRoute.name),
          RouteConfig(NotesRoute.name,
              path: 'notes-page', parent: HomeRoute.name),
          RouteConfig(TodosRoute.name,
              path: 'todos-page', parent: HomeRoute.name)
        ]),
        RouteConfig(ManipulateNoteRoute.name, path: '/manipulate-note-page')
      ];
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [ManipulateNotePage]
class ManipulateNoteRoute extends PageRouteInfo<ManipulateNoteRouteArgs> {
  ManipulateNoteRoute({Key? key, Note? note})
      : super(ManipulateNoteRoute.name,
            path: '/manipulate-note-page',
            args: ManipulateNoteRouteArgs(key: key, note: note));

  static const String name = 'ManipulateNoteRoute';
}

class ManipulateNoteRouteArgs {
  const ManipulateNoteRouteArgs({this.key, this.note});

  final Key? key;

  final Note? note;

  @override
  String toString() {
    return 'ManipulateNoteRouteArgs{key: $key, note: $note}';
  }
}

/// generated route for
/// [CommandPage]
class CommandRoute extends PageRouteInfo<void> {
  const CommandRoute() : super(CommandRoute.name, path: 'command-page');

  static const String name = 'CommandRoute';
}

/// generated route for
/// [NotesPage]
class NotesRoute extends PageRouteInfo<void> {
  const NotesRoute() : super(NotesRoute.name, path: 'notes-page');

  static const String name = 'NotesRoute';
}

/// generated route for
/// [TodosPage]
class TodosRoute extends PageRouteInfo<void> {
  const TodosRoute() : super(TodosRoute.name, path: 'todos-page');

  static const String name = 'TodosRoute';
}
