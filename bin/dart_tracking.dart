import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
    body: json.encode({"name": username, "password": password}), // Changed to "name"
  );
  
  if (loginResponse.statusCode != 200) {
    print("Login failed: ${loginResponse.body}");
    return;
  }
  
  final loginData = json.decode(loginResponse.body) as Map<String, dynamic>;
  final int userId = loginData['user_id']; // Changed to 'user_id'
  final String userName = loginData['name']; // Changed to 'name'
  
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
      // Corrected URL
      final expensesUrl = Uri.parse('http://localhost:3000/expenses?user_id=$userId');
      final expensesResponse = await http.get(expensesUrl);
      
      if (expensesResponse.statusCode == 200) {
        final expenses = json.decode(expensesResponse.body) as List;
        int total = 0;
        
        print("------------- All expenses -----------");
        for (var expense in expenses) {
          // Changed to 'amount' and 'created_at'
          print("${expense['id']}. ${expense['item']} : ${expense['amount']}฿ : ${expense['created_at']}");
          total += (expense['amount'] as num).toInt(); // Changed to 'amount'
        }
        print("Total expenses = ${total}฿");
      } else {
        print("Error: ${expensesResponse.body}");
      }
      
    } else if (choice == "2") {
      // Corrected URL
      final todayExpensesUrl = Uri.parse('http://localhost:3000/expenses/today?user_id=$userId');
      final todayExpensesResponse = await http.get(todayExpensesUrl);
      
      if (todayExpensesResponse.statusCode == 200) {
        final expenses = json.decode(todayExpensesResponse.body) as List;
        int total = 0;
        
        print("------------- Today's expenses -----------");
        for (var expense in expenses) {
          // Changed to 'amount' and 'created_at'
          print("${expense['id']}. ${expense['item']} : ${expense['amount']}฿ : ${expense['created_at']}");
          total += (expense['amount'] as num).toInt(); // Changed to 'amount'
        }
        print("Total expenses = ${total}฿");
      } else {
        print("Error: ${todayExpensesResponse.body}");
      }
      
    } else if (choice == "3") {
      stdout.write("Item to search: ");
      String? searchTerm = stdin.readLineSync();
      
      if (searchTerm != null && searchTerm.isNotEmpty) {
        // Corrected URL and parameter name
        final searchUrl = Uri.parse('http://localhost:3000/expenses/search?user_id=$userId&q=$searchTerm');
        final searchResponse = await http.get(searchUrl);
        
        if (searchResponse.statusCode == 200) {
          final expenses = json.decode(searchResponse.body) as List;
          
          if (expenses.isNotEmpty) {
            for (var expense in expenses) {
              // Changed to 'amount' and 'created_at'
              print("${expense['id']}. ${expense['item']} : ${expense['amount']}฿ : ${expense['created_at']}");
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
      stdout.write("Amount: "); // Changed from "Paid" to "Amount"
      String? amountInput = stdin.readLineSync();
      
      if (item != null && amountInput != null && item.isNotEmpty && amountInput.isNotEmpty) {
        try {
          int amount = int.parse(amountInput);
          // Corrected URL and request body
          final addUrl = Uri.parse('http://localhost:3000/expenses');
          final addResponse = await http.post(
            addUrl,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "user_id": userId, // Added user_id
              "item": item, 
              "amount": amount // Changed from "paid" to "amount"
            }),
          );
          
          if (addResponse.statusCode == 201) { // Changed from 200 to 201
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
          // Corrected URL
          final deleteUrl = Uri.parse('http://localhost:3000/expenses/$id');
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