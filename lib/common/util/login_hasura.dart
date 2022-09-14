import 'package:dio/dio.dart';

Future<void> signInSocials(String _token) async {
  try {
    // MUST-CONFIG
    final response = await Dio()
        //Your link server webhook to
        .get<dynamic>('https://hidden-lowlands-88685.herokuapp.com/webhook',
            options: Options(headers: <String, dynamic>{
              'Authorization': '$_token',
              'content-type': 'application/json',
            }));
    print(response);
  } catch (e) {
    print(e);
  }
}
