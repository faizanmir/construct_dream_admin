import 'package:construct_dream_admin/services/firebase_service.dart';
import 'package:construct_dream_admin/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseService>(
            create: (_) => FirebaseService()),
      ],
      child: MaterialApp(home:Dashboard())));


