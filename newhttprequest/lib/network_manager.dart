import 'dart:convert';

import 'inetwork_model.dart';
import 'package:http/http.dart' as http;

enum RequestTypes { GET, POST }

class NetworkManager {
  static NetworkManager? _networkManager;

  factory NetworkManager() {
    if (_networkManager == null) {
      _networkManager = NetworkManager._internal();
      return _networkManager!;
    } else {
      return _networkManager!;
    }
  }

  NetworkManager._internal();

  static const END_POINT = "https://jsonplaceholder.typicode.com/";

  /// You can create a request with `GET` and `POST` methods.
  ///
  /// `R` should be your response model or your response model list, like as `MyModel` or `List<MyModel>`
  ///
  /// `T` should be your response model, like as `MyModel`
  ///
  /// [path] is your request directory. You don't need to add `/` when adding [path].
  ///
  /// [method] should be `RequestTypes.GET` or `RequestTypes.POST`
  ///
  /// [parseModel] should be an instance from your model which in your response, like as `MyModel()`
  ///
  /// [queryParameters] should be an `Object` and contains your parameters, like as `{"id": 26}`
  ///
  /// [headers] You can add http request headers here. It has default `json` content-type
  ///
  /// It returns `MyModel` or `List<MyModel>` or `null`
  ///
  /// GET Method example:
  /// ```dart
  /// var myUser = await request<List<MyModel>, MyModel>(
  /// path: "todos",
  /// method: RequestTypes.GET,
  /// parseModel: MyModel(),
  /// );
  /// ```
  ///
  /// POST Method example:
  /// ```dart
  /// var myUser = await request<MyModel, MyModel>(
  /// path: 'posts',
  /// method: RequestTypes.POST,
  /// parseModel: MyModel(),
  /// queryParameters: {"title": "foo", "body": "bar", "userId": 1},
  /// );
  /// ```
  Future<R?> request<R, T extends INetworkModel>(
      {required String path,
      required RequestTypes method,
      required T parseModel,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    if (headers == null) {
      headers = {'Content-Type': 'application/json; charset=UTF-8'};
    }

    if (headers["Content-Type"] == null) {
      headers["Content-Type"] = 'application/json; charset=UTF-8';
    }

    http.Response? response;
    var endUri = Uri.parse(END_POINT + path);

    if (method == RequestTypes.GET) {
      try {
        response = await http.get(endUri, headers: headers);
      } catch (e) {
        print(e.toString());
        return null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _parser<R, T>(parseModel, jsonDecode(response.body));
      }
      return null;
    } else {
      try {
        response = await http.post(endUri,
            body: jsonEncode(queryParameters), headers: headers);
      } catch (e) {
        print(e.toString());
        return null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {}
      return _parser<R, T>(parseModel, jsonDecode(response.body));
    }
  }
}

R? _parser<R, T>(INetworkModel model, dynamic data) {
  if (data is List) {
    return data.map((e) => model.fromJson(e)).toList().cast<T>() as R?;
  } else if (data is Map) {
    return model.fromJson(data as Map<String, dynamic>) as R?;
  }
  return data as R?;
}
