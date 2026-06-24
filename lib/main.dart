import 'package:alumni_association_app/app/app.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:alumni_association_app/app/bindings/app_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBinding.init();
  LoadingUtil.initStyle();
  runApp(const AlumniAssociationApp());
}
