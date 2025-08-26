// ===== Project 1 Dart Client (Template) =====
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> main() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync();
  stdout.write("Password: ");
  String? password = stdin.readLineSync();

  if (username == null || password == null) {
    print("Incomplete input");
    return;
  }

 

  while (true) {
    print("\n========= Expense Manager =========");
    print("1. Show all expenses");
    print("2. Add expense");
    print("3. Delete expense");
    print("4. Exit");
    stdout.write("Choose: ");
    String? choice = stdin.readLineSync();

    if (choice == "1") {
      // TODO: call GET /expenses/:userId
    }
    else if (choice == "2") {
      // TODO: call POST /expenses
    }
    else if (choice == "3") {
      // TODO: call DELETE /expenses/:id
    }
    else if (choice == "4") {
      print("------ Bye -------");
      break;
    }
    else {
      print("Invalid choice");
    }
  }
}
