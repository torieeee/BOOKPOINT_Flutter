// import 'package:mysql1/mysql1.dart';

// class DatabaseHelper {
//   final String host;
//   final int port;
//   final String user;
//   final String password;
//   final String databaseName;

//   late MySqlConnection _connection;

//   DatabaseHelper({
//     required this.host,
//     required this.port,
//     required this.user,
//     required this.password,
//     required this.databaseName,
//   });

//   Future<void> openConnection() async {
//     final settings = ConnectionSettings(
//       host: host,
//       port: port,
//       user: user,
//       password: password,
//       db: databaseName,
//     );

//     _connection = await MySqlConnection.connect(settings);
//   }

//   Future<void> closeConnection() async {
//     await _connection.close();
//   }

//   Future<Map<String,dynamic>?> getUserData(String email) async{
//     try{
//       final results=await _connection.query(
//         'SELECT * FROM users WHERE email=?',
//       [email],);
//       if (results.isNotEmpty){
//         return results.first.fields;
//       }else{
//         return null;
//       }
//     }catch(e){
//       print('Error fetching user data:$e');
//       return null;
//     }
//   }

//   Future<bool> authService(String email, String password) async {
//     try {
//       final result = await _connection.query(
//         'SELECT * FROM users WHERE email = ? AND password = ?',
//         [email, password],
//       );
      
//       if (result.isNotEmpty) {
//         final userRow = result.first;
//         final storedPassword = userRow['password'];
//         if (password == storedPassword) {
//           print('Login successful');
//           return true;
//         }
//       }
//        return result.isNotEmpty;

//     } catch (e) {
//       print('Error during login: $e');
//     }
//     return false;
//   }

//   Future<bool> registerUser(String username, String email, String password) async {
//     try {
//       final result = await _connection.query(
//         'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
//         [username, email, password],
//       );
      
//       if (result.affectedRows! > 0) {
//         print('Registration successful');
//         return true;
//       }
//        return result.affectedRows! > 0;
//     } catch (e) {
//       print('Error during registration: $e');
//     }
//     return false;
//   }

//   // Other CRUD methods can be added here (update, delete, etc.)
// }
