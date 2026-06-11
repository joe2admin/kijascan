import "package:flutter/material.dart";
import 'package:kijascan/core/events/pusher_service.dart';

import 'app.dart';

//put the api_client in http... and don't forget constants...to link laravel.
void main()async {
  await PusherService().init();
  runApp(const App());
}
