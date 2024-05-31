import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List jsonList=[];
  String href='https://jsonplaceholder.typicode.com/posts';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configureDio();
    getData();
  }
  Dio dio=Dio();

  void configureDio() {//khởi tạo, setting connect
    //Cách 1
    dio.options.baseUrl = 'https://jsonplaceholder.typicode.com/posts';//set đường dẫn cơ bả
    dio.options.connectTimeout = 5000;//set thời gian kết nối nếu vượt quá sẽ trả về exception
    dio.options.receiveTimeout = 3000;//set thời gian nhận dữ liệu nếu vượt quá sẽ trả về exception
    //Cách 2
    // final options = BaseOptions(
    //   baseUrl: 'https://jsonplaceholder.typicode.com/posts',
    //   connectTimeout: 5000,
    //   receiveTimeout: 3000,
    // );
    // final anotherDio = Dio(options);
  }
  void getData() async {
    try{
      final response = await dio.get(dio.options.baseUrl);
      if(response.statusCode==200)
        {
          setState(() {
            jsonList=response.data as List;
          });
        }
      else print(response.statusCode);
    }
    catch(e){print(e);}
  }
  void getData_with_options() async {
      final response = await dio.get(href,
        options: Options(responseType: ResponseType.plain),
      );
      print('data: ${response.data}');
      print('statusCode: ${response.statusCode}');//mã trạng thái HTTP (HTTP status code) của phản hồi.
      // 200 OK: Yêu cầu đã thành công.
      // 201 Created: Yêu cầu đã thành công và một tài nguyên mới đã được tạo ra. Thường được gửi sau các yêu cầu POST hoặc một số yêu cầu PUT.
      // 204 No Content: Không có nội dung để gửi cho yêu cầu này, nhưng các tiêu đề có thể hữu ích. Trình duyệt người dùng có thể cập nhật các tiêu đề đã lưu trong bộ nhớ cache cho tài nguyên này với các tiêu đề mới.
      // 400 Bad Request: Yêu cầu không hợp lệ do lỗi từ phía máy khách.
      // 401 Unauthorized: Yêu cầu yêu cầu xác thực hoặc thông tin đăng nhập không hợp lệ.
      // 403 Forbidden: Máy chủ hiểu yêu cầu, nhưng từ chối thực hiện nó. Nguyên nhân có thể là quyền truy cập bị từ chối.
      // 404 Not Found: Tài nguyên yêu cầu không tồn tại trên máy chủ.
      // 500 Internal Server Error: Máy chủ gặp lỗi nội bộ khi xử lý yêu cầu.
      print('statusMessage: ${response.statusMessage}');//thông điệp liên quan đến mã trạng thái (status code). Thông điệp này thường được đặt trước khi ghi dữ liệu vào phản hồi.
      print('isRedirect: ${response.isRedirect}');//xác định xem phản hồi có phải là một chuyển hướng (redirect) hay không.
      print('redirects: ${response.redirects}');//Danh sách các chuyển hướng mà kết nối này đã trải qua. Danh sách này sẽ trống nếu không có chuyển hướng nào được thực hiện.
      print('extra: ${response.extra}');//Các trường tùy chỉnh chỉ dành cho phản hồi (response).
      print('headers: ${response.headers}');//Các tiêu đề (headers) của phản hồi.
  }
  void getData_with_request() async {
    final response = await dio.request(href,
      queryParameters: {'userId': 4},
      options: Options(
          method: 'GET',//xác định phương thức HTTP của yêu cầu (request).
          sendTimeout: 100,//xác định thời gian chờ khi gửi dữ liệu. Nếu thời gian chờ vượt quá, sẽ gây ra ngoại lệ
          receiveTimeout: 2000,//xác định thời gian chờ khi nhận dữ liệu. Nếu thời gian chờ vượt quá, sẽ gây ra ngoại lệ
          extra: {'Ha':1},//cho phép bạn đính kèm các trường tùy chỉnh vào yêu cầu (request), sau đó có thể truy xuất chúng trong [Interceptor], [Transformer] và đối tượng [Response.requestOptions].
          // headers: //xác định các tiêu đề (headers) của yêu cầu (request).
          responseType: ResponseType.json,//xác định loại dữ liệu mà Dio xử lý xuất ra bên ngoài
          contentType: 'Ha',// xác định kiểu nội dung của yêu cầu (request).
          validateStatus: (status) => true,//xác định xem yêu cầu (request) được coi là thành công dựa trên mã trạng thái (status code) đã cho. Yêu cầu sẽ được xem xét là thành công nếu hàm callback trả về true.
          receiveDataWhenStatusError: true,// xác định xem có lấy dữ liệu nếu mã trạng thái (status code) cho thấy yêu cầu thất bại hay không. Giá trị mặc định là true.
          followRedirects: true,//xác định xem có theo dõi chuyển hướng (redirect) hay không
          maxRedirects: 5,//xác định số lượng tối đa của chuyển hướng khi followRedirects là true. Nếu số lượng chuyển hướng vượt quá giới hạn, sẽ gây ra ngoại lệ
          // requestEncoder: (request, options) => [1,3,4],//cho phép bạn đặt bộ mã hóa tùy chỉnh cho yêu cầu (request).
          // responseDecoder: (responseBytes, options, responseBody) => 'ha',//cho phép bạn đặt bộ giải mã tùy chỉnh cho phản hồi (response), nó sẽ được sử dụng trong [Transformer].
          listFormat: ListFormat.multi,//xác định định dạng dữ liệu trong các tham số truy vấn của yêu cầu và dữ liệu
      ),
    );
    setState(() {
      jsonList=[];
      jsonList=response.data as List;
      print('Get success');
    });


  }
  void postData() async {
    try{
      // FormData formData = FormData.fromMap({
      //   'title': 'foo',
      //   'body': 'bar',
      //   'userId': 1,
      // });
      Response response = await dio.post(href, data: {
        'title': 'foo',
        'body': 'bar',
        'userId': 1,},
        onSendProgress: (count, total) {//bắt sự kiện trong quá trình gửi thì thực hiện hành động, truyền vào các tham số count: số lượng dữ liệu đã được gửi đi, total: số lượng dữ liệu cần gửi đi
          print('onSendProgress: $count $total');
        },
        onReceiveProgress: (count, total) {//bắt sự kiện trong quá trình nhận dữ liệu và thực hiện hàn động
          print('onReceiveProgress: $count $total');
        },

      );
      // Response response = await dio.post(href,data: formData);
      setState(() {
        jsonList.add(response.data);
        print('post success');
      });
    }
    catch(e){print(e);}
  }

  void getUserId() async {
    Response response;
    // response = await dio.get('$href?userId=1');
    response = await dio.get(
      href,
      queryParameters: {'userId': 1},
    );
    setState(() {
      jsonList=response.data as List;
    });
  }

  void reponseMultiple() async {
    List<Response> response;
    response = await Future.wait([dio.post(href,data: {'id':5,'title':'hello'}), dio.post(href,data: {'id':5,'title':'hi'})]);
    jsonList=[];
    setState(() {
      for(int i=0;i<response.length;i++)
        {
          jsonList.add(response[i].data);
        }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Dio"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 200,
              alignment: Alignment.center,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: postData, child: Text('Post Data'),style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.orangeAccent)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: getUserId, child: Text('Get User Id'),style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.orangeAccent)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: reponseMultiple, child: Text('Reponse Multiple'),style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.orangeAccent)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: getData_with_options, child: Text('Get Data with options'),style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.orangeAccent)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: getData_with_request, child: Text('Get Data with request'),style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.orangeAccent)),),
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(jsonList==null?0:jsonList.length, (index) {
                return Card(
                  child: ListTile(
                    title: Text(jsonList[index]['id'].toString()),
                    subtitle: Text(jsonList[index]['title']),
                  ),
                );
              },)
            ),
          ],
        ),
      ),
    );
  }
}