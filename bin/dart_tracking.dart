import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();
  
  if (username == null || password == null) {
    print("Incomplete input");
    return;
  }
  
  final loginUrl = Uri.parse('http://localhost:3000/auth/login');
  final loginResponse = await http.post(
    loginUrl,
    headers: {'Content-Type': 'application/json'},
    body:json.encode( {"username": username, "password": password}),
  );
  
  if (loginResponse.statusCode != 200) {
    print("Login failed: ${loginResponse.body}");
    return;
  }
  
  final loginData = json.decode(loginResponse.body) as Map<String, dynamic>;
  final int userId = loginData['userId'] as int;
  final String userName = loginData['username'] as String;
  
  while (true) {
    print("\n========= Expense Tracking App =========");
    print("Welcome $userName");
    print("1. All expenses");
    print("2. Today's expense");
    print("3. Search expense");
    print("4. Add new expense");
    print("5. Delete an expense");
    print("6. Exit");
    stdout.write("Choose...");
    
    String? choice = stdin.readLineSync();
    
    if (choice == "1") {
      final expensesUrl = Uri.parse('http://localhost:3000/expenses/$userId');
      final expensesResponse = await http.get(expensesUrl);
      
      if (expensesResponse.statusCode == 200) {
        final expenses = json.decode(expensesResponse.body) as List;
        int total = 0;
        
        print("------------- All expenses -----------");
        for (var expense in expenses) {
          print("${expense['id']}. ${expense['item']} : ${expense['paid']}฿ : ${expense['date']}");
          total += (expense['paid'] as num).toInt();
        }
        print("Total expenses = ${total}฿");
      } else {
        print("Error: ${expensesResponse.body}");
      }
      
    } else if (choice == "2") {
      final todayExpensesUrl = Uri.parse('http://localhost:3000/expenses/$userId/today');
      final todayExpensesResponse = await http.get(todayExpensesUrl);
      
      if (todayExpensesResponse.statusCode == 200) {
        final expenses = json.decode(todayExpensesResponse.body) as List;
        int total = 0;
        
        print("------------- Today's expenses -----------");
        for (var expense in expenses) {
          print("${expense['id']}. ${expense['item']} : ${expense['paid']}฿ : ${expense['date']}");
          total += (expense['paid'] as num).toInt();
        }
        print("Total expenses = ${total}฿");
      } else {
        print("Error: ${todayExpensesResponse.body}");
      }
      
    } else if (choice == "3") {
      stdout.write("Item to search: ");
      String? searchTerm = stdin.readLineSync();
      
      if (searchTerm != null && searchTerm.isNotEmpty) {
        final searchUrl = Uri.parse('http://localhost:3000/expenses/$userId/search?term=$searchTerm');
        final searchResponse = await http.get(searchUrl);
        
        if (searchResponse.statusCode == 200) {
          final expenses = json.decode(searchResponse.body) as List;
          
          if (expenses.isNotEmpty) {
            for (var expense in expenses) {
              print("${expense['id']}. ${expense['item']} : ${expense['paid']}฿ : ${expense['date']}");
            }
          } else {
            print("No item: $searchTerm");
          }
        } else {
          print("Error: ${searchResponse.body}");
        }
      }
      
    } else if (choice == "4") {
      print("===== Add new item =====");
      stdout.write("Item: ");
      String? item = stdin.readLineSync();
      stdout.write("Paid: ");
      String? paidInput = stdin.readLineSync();
      
      if (item != null && paidInput != null && item.isNotEmpty && paidInput.isNotEmpty) {
        try {
          int paid = int.parse(paidInput);
          final addUrl = Uri.parse('http://localhost:3000/expenses/$userId');
          final addResponse = await http.post(
            addUrl,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({"item": item, "paid": paid}),
          );
          
          if (addResponse.statusCode == 200) {
            print("Inserted!");
          } else {
            print("Error: ${addResponse.body}");
          }
        } catch (e) {
          print("Invalid amount");
        }
      } else {
        print("Invalid input");
      }
      
    } else if (choice == "5") {
      print("==== Delete an item =====");
      stdout.write("Item id: ");
      String? idInput = stdin.readLineSync();
      
      if (idInput != null && idInput.isNotEmpty) {
        try {
          int id = int.parse(idInput);
          final deleteUrl = Uri.parse('http://localhost:3000/expenses/$userId/$id');
          final deleteResponse = await http.delete(deleteUrl);
          
          if (deleteResponse.statusCode == 200) {
            print("Deleted!");
          } else {
            print("Error: ${deleteResponse.body}");
          }
        } catch (e) {
          print("Invalid ID");
        }
      } else {
        print("Invalid input");
      }
      
    } else if (choice == "6") {
      print("------ Bye -------");
      break;
    } else {
      print("Invalid choice");
    }
  }
}