import 'dart:convert'; 
import 'package:http/http.dart' as http; 

void main() async { 
  try {
    var response = await http.get(Uri.parse('http://127.0.0.1:5000/api/jobs/explore')); 
    print('Status: \${response.statusCode}'); 
    print('Body: \${response.body}'); 
  } catch(e) {
    print('Error: \$e');
  }
}
