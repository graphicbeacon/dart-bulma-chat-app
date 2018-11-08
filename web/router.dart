import './views/view.dart';

// Type definition to label a Function that returns a `View` type
typedef ViewInstantiateFn = View Function(Map data);

class Router {
  Router() : _routes = [];

  List<Map<String, ViewInstantiateFn>> _routes;

  register(String path, ViewInstantiateFn viewInstance) {
    // The key `path` is a computed property
    // It could also be written as {'$path': viewInstance}
    _routes.add({path: viewInstance});
  }

  go(String path, {Map params = null}) {
    // Find the matching `Map` object in _routes
    // and invoke it's `View` object instance
    _routes.firstWhere(
      (Map<String, ViewInstantiateFn> route) => route.containsKey(path),
      orElse: () => null,
    )[path](params ?? {});
  }
}

Router router = Router();
