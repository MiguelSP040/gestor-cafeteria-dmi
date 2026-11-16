import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/failure.dart';
import 'package:gestor_cafeteria/core/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  ApiClient client(int status, String body) => ApiClient(
        client: MockClient((_) async => http.Response(body, status)),
        baseUrl: 'http://prueba',
      );
  test('GET exitoso decodifica JSON', () async {
    expect(await client(200, '[{"id":1}]').get('/orders'), [{'id': 1}]);
  });
  test('404 conserva mensaje', () async {
    expect(client(404, '{"detail":"Order 9 not found"}').get('/orders/9'),
        throwsA(isA<NotFoundFailure>().having((f) => f.message, 'message', 'Order 9 not found')));
  });
  test('409 conserva mensaje', () async {
    expect(client(409, '{"detail":"Conflicto"}').get('/orders'),
        throwsA(isA<ConflictFailure>().having((f) => f.message, 'message', 'Conflicto')));
  });
  test('422 conserva errores por campo', () async {
    expect(client(422, '{"detail":[{"loc":["body","customer"],"msg":"Must be 1-50 characters"}]}').get('/orders'),
        throwsA(isA<ValidationFailure>().having((f) => f.fields, 'fields', {'customer': 'Must be 1-50 characters'})));
  });
  test('503 conserva código', () async {
    expect(client(503, '').get('/orders'), throwsA(isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 503)));
  });
  test('sin conexión produce NetworkFailure', () async {
    final api = ApiClient(client: MockClient((_) async => throw http.ClientException('sin red')), baseUrl: 'http://prueba');
    expect(api.get('/orders'), throwsA(isA<NetworkFailure>()));
  });
  test('300 no se considera exitoso', () async {
    expect(client(300, '').get('/orders'), throwsA(isA<UnexpectedFailure>().having((f) => f.statusCode, 'statusCode', 300)));
  });
}
