import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio _dio = Dio(); // Tạo một đối tượng Dio để thực hiện các yêu cầu HTTP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dio Package Demo'),
      ),
      body: Center( // Căn giữa phần nội dung của trang
        child: Column( // Tạo một cột để chứa các nút
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
          children: [ // Danh sách các widget con của cột
            ElevatedButton( // Tạo một nút nhấn
              onPressed: _makeGetRequest, // Gán hàm _makeGetRequest cho sự kiện nhấn nút
              child: Text('Make GET Request'), // Hiển thị văn bản trên nút
            ),
            ElevatedButton(
              onPressed: _makePostRequest,
              child: Text('Make POST Request'),
            ),
            ElevatedButton(
              onPressed: _makePutRequest,
              child: Text('Make PUT Request'),
            ),
            ElevatedButton(
              onPressed: _makePatchRequest,
              child: Text('Make PATCH Request'),
            ),
            ElevatedButton(
              onPressed: _makeDeleteRequest,
              child: Text('Make DELETE Request'),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _makeGetRequest() async {
    try {
      // Thực hiện yêu cầu GET đến URL được cung cấp và chờ đợi cho đến khi có kết quả trả về
      Response response = await _dio.get('https://jsonplaceholder.typicode.com/posts/1');

      // Hiển thị kết quả trả về
      _showResponse(response);
    } catch (e) {
      // Xử lý lỗi nếu có
      _showError(e);
    }
  }

  Future<void> _makePostRequest() async {
    try {
      // Thực hiện yêu cầu POST đến URL được cung cấp và chờ đợi cho đến khi có kết quả trả về
      Response response = await _dio.post('https://jsonplaceholder.typicode.com/posts', data: {
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      });

      // Hiển thị kết quả trả về
      _showResponse(response);
    } catch (e) {
      // Xử lý lỗi nếu có
      _showError(e);
    }
  }

  Future<void> _makePutRequest() async {
    try {
      // Thực hiện yêu cầu PUT đến URL được cung cấp và chờ đợi cho đến khi có kết quả trả về
      Response response = await _dio.put('https://jsonplaceholder.typicode.com/posts/1', data: {
        'id': 1,
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      });

      // Hiển thị kết quả trả về
      _showResponse(response);
    } catch (e) {
      // Xử lý lỗi nếu có
      _showError(e);
    }
  }

  Future<void> _makePatchRequest() async {
    try {
      // Thực hiện yêu cầu PATCH đến URL được cung cấp và chờ đợi cho đến khi có kết quả trả về
      Response response = await _dio.patch('https://jsonplaceholder.typicode.com/posts/1', data: {
        'title': 'foo',
      });

      // Hiển thị kết quả trả về
      _showResponse(response);
    } catch (e) {
      // Xử lý lỗi nếu có
      _showError(e);
    }
  }

  Future<void> _makeDeleteRequest() async {
    try {
      // Thực hiện yêu cầu DELETE đến URL được cung cấp và chờ đợi cho đến khi có kết quả trả về
      Response response = await _dio.delete('https://jsonplaceholder.typicode.com/posts/1');

      // Hiển thị kết quả trả về
      _showResponse(response);
    } catch (e) {
      // Xử lý lỗi nếu có
      _showError(e);
    }
  }

  void _showResponse(Response response) {
    // In ra nội dung của kết quả trả về từ yêu cầu HTTP
    print(response.data);

    // Hiển thị hộp thoại với nội dung kết quả
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Response'), // Tiêu đề của hộp thoại
        content: Text(response.data.toString()), // Nội dung của hộp thoại là dữ liệu trả về
        actions: [ // Các action của hộp thoại
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn nút
            },
            child: Text('Close'), // Nút đóng
          ),
        ],
      ),
    );
  }

  void _showError(dynamic e) {
    // In ra lỗi ra console để debug
    print(e.toString());

    // Hiển thị hộp thoại lỗi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'), // Tiêu đề của hộp thoại
        content: Text('An error occurred: $e'), // Hiển thị thông báo lỗi
        actions: [ // Các action của hộp thoại
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn nút
            },
            child: Text('Close'), // Nút đóng
          ),
        ],
      ),
    );
  }
}