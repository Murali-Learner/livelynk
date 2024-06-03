import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

class HttpService {
  // Private constructor
  HttpService._init();

  static final HttpService _instance = HttpService._init();

  factory HttpService() {
    return _instance;
  }

  // SendPort to communicate with the isolate
  static SendPort? _httpRequestHandlerSendPort;

  // Isolate entry point
  static void httpRequestHandler(SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      final SendPort replyPort = message[0];
      final String method = message[1];
      final String url = message[2];
      final dynamic body = message[3];

      HttpClient client = HttpClient();
      HttpClientRequest request;

      try {
        switch (method) {
          case 'GET':
            request = await client.getUrl(Uri.parse(url));
            break;
          case 'POST':
            request = await client.postUrl(Uri.parse(url));
            request.headers.set('Content-Type', 'application/json');
            request.write(json.encode(body));
            break;
          case 'DELETE':
            request = await client.deleteUrl(Uri.parse(url));
            request.headers.set('Content-Type', 'application/json');
            request.write(json.encode(body));
            break;
          default:
            throw UnsupportedError('Unsupported HTTP method: $method');
        }

        HttpClientResponse response = await request.close();
        String responseBody = await response.transform(utf8.decoder).join();
        replyPort.send({responseBody, response.statusCode});
      } catch (e) {
        replyPort.send({e.toString(), 500});
      }
    }
  }

  // Initialize the isolate if not already done
  static Future<void> _initIsolate() async {
    if (_httpRequestHandlerSendPort == null) {
      final ReceivePort receivePort = ReceivePort();
      await Isolate.spawn(
        httpRequestHandler,
        receivePort.sendPort,
      );
      _httpRequestHandlerSendPort = await receivePort.first as SendPort;
    }
  }

  // Send HTTP request
  static Future<Set> send(String method, String url, [dynamic body]) async {
    await _initIsolate();

    final ReceivePort responsePort = ReceivePort();
    _httpRequestHandlerSendPort!
        .send([responsePort.sendPort, method, url, body]);
    return await responsePort.first as Set;
  }
}
