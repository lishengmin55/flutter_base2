import 'package:flutter/material.dart';
//save1

void main() {
  runApp(MyApp());
}

class User {
  final int id;
  final String name;

  User(this.id, this.name);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnGenerateRoute Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      // 1. 定义固定的路由表
      routes: {
        '/': (context) => HomePage(),
        '/about': (context) => AboutPage(),
      },
      // 2. 定义高级的动态路由生成器
      onGenerateRoute: (RouteSettings settings) {
        // 解析路由名
        final path = settings.name;

        // 根据路径模式匹配，创建相应的页面
        if (path != null) {
          // 匹配 /user/123 或 /user/456 这样的动态路径
          if (path.startsWith('/user/')) {
            // 提取路径中的 ID 部分
            final uri = Uri.parse(path);
            final segments = uri.pathSegments;
            if (segments.length == 2 && segments[0] == 'user') {
              try {
                // 将字符串 ID 转换为整数
                final userId = int.parse(segments[1]);
                
                // 创建一个 User 对象作为模拟数据
                final user = User(userId, 'User $userId');

                // 返回一个 MaterialPageRoute，将数据传递给页面
                return MaterialPageRoute(
                  builder: (context) => UserProfilePage(user: user),
                  settings: settings, // 保留原始的设置，包括参数
                );
              } catch (e) {
                // 如果 ID 不是数字，可以跳转到错误页面
                print('Invalid user ID format: $segments[1]');
                return MaterialPageRoute(
                  builder: (context) => ErrorPage(message: 'Invalid User ID'),
                );
              }
            }
          }
          
          // 可以在这里添加更多的路径匹配规则
          // if (path.startsWith('/product/')) { ... }
        }

        // 如果没有任何匹配，返回一个错误页面
        return MaterialPageRoute(
          builder: (context) => ErrorPage(message: 'Route not found: $path'),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('主页')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: Text('去关于页 (固定路由)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/userrrr/114514'),
              child: Text('去用户页 (动态路由: /userrrr/114514)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/nonexistent'),
              child: Text('去不存在的页面'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('关于')),
      body: Center(child: Text('这是关于页面')),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户资料')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: ${user.id}', style: TextStyle(fontSize: 24)),
            Text('Name: ${user.name}', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('错误')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/屏幕截图 2026-01-09 170109.png', // 替换为你的图片路径
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}