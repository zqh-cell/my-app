import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter_compass/flutter_compass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '万法归宗',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}

// ================= 全局数据：法脉大全 =================
class FaMaiData {
  static final List<Map<String, String>> allFaMai = [
    {
      'name': '元皇梅山',
      'category': '民间法教',
      'master': '翻坛祖师',
      'ancestor': '梅山三峒梅王',
      'desc': '元皇梅山法教，发源于湘中梅山地区，尊崇梅山张五郎。主要法门包括翻坛倒峒、收邪斩鬼、上刀山下火海等，以刚猛霸道著称，常用于驱邪、治病、猎神信仰。',
    },
    {
      'name': '六壬伏英馆',
      'category': '民间法教',
      'master': '六壬仙师',
      'ancestor': '伏英法主',
      'desc': '六壬法门流派众多，伏英馆是其中极具代表性的一支。供奉六壬仙师，讲究“神机妙算”，法门涵盖保命护身、和合招财、化解灾厄、神打等。',
    },
    {
      'name': '茅山法教',
      'category': '民间法教',
      'master': '茅山法主',
      'ancestor': '三茅真君',
      'desc': '广义茅山分为上清宗坛（正一道）与民间茅山法。民间茅山以符箓、驱邪、和合、招财见长，流传极广，门派众多。',
    },
    {
      'name': '西方雷诺曼',
      'category': '西方神秘学',
      'master': '玛丽·安妮·雷诺曼',
      'ancestor': '吉普赛占卜传统',
      'desc': '一套由36张牌组成的占卜系统，直指核心问题。非常适合问具体事件、寻找失物、感情发展等，与东方法脉结合，效果奇妙。',
    },
  ];
}

// ================= 主框架：底部导航栏 =================
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AiChatPage(),
    const DivinationPage(),
    const PanGuaPage(),
    const LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() { _currentIndex = index; });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'AI'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: '法脉'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: '盘卦'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: '书库'),
        ],
      ),
    );
  }
}
// ================= 页面一：AI 问答 =================
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'text': '你好，欢迎使用 App。我是您的法脉检索助手。AI仅解答基础常识，涉及秘传请咨询传度师父。'}
  ];

  final String _apiKey = 'sk-1f5127571a4843e3af5a2581a0342f40';

  void _sendMessage([String? presetText]) async {
    String textToSend = presetText ?? _controller.text;
    if (textToSend.isEmpty) return;
    
    setState(() { _messages.add({'role': 'user', 'text': textToSend}); });
    _controller.clear();
    setState(() { _messages.add({'role': 'ai', 'text': '正在查阅典籍...'}); });

    try {
      final response = await http.post(
        // ✅ 已经换成 DeepSeek 的接口
        Uri.parse('https://api.deepseek.com/chat/completions'),
        headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer $_apiKey' },
        body: jsonEncode({
          "model": "deepseek-chat", // ✅ 已经换成 DeepSeek 的模型
          "messages": [
            {"role": "system", "content": "你现在是一个严谨的道教法脉资料检索助手。你的核心原则是【宁可说不知道，也绝不胡编乱造】。基础常识客观回答；涉及秘传口诀、科仪步骤或不确定细节，直接回答：\"福生无量天尊。此法门属口传心授或内部秘传，查无公开典籍记载。为了传承的严谨性，不敢妄言，建议您请教您的传度师父。\"绝不允许自己发明法主或口诀。语气恭敬，称用户为善信。"},
            {"role": "user", "content": textToSend}
          ],
          "temperature": 0.3
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() { _messages.removeLast(); _messages.add({'role': 'ai', 'text': data['choices'][0]['message']['content']}); });
      } else {
        setState(() { _messages.removeLast(); _messages.add({'role': 'ai', 'text': '请求失败：${response.statusCode}'}); });
      }
    } catch (e) {
      setState(() { _messages.removeLast(); _messages.add({'role': 'ai', 'text': '网络连接失败。\n$e'}); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 万法问答'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: isUser ? Colors.deepPurple[100] : Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                    child: Text(msg['text']!, style: const TextStyle(fontSize: 15)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: '请输入问题...', border: OutlineInputBorder()),
                    onSubmitted: (val) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: () => _sendMessage(), icon: const Icon(Icons.send), style: IconButton.styleFrom(backgroundColor: Colors.deepPurple)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
// ================= 页面二：法脉 =================
class DivinationPage extends StatelessWidget {
  const DivinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['民间法教', '西方神秘学'];

    return Scaffold(
      appBar: AppBar(title: const Text('法脉库'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...categories.map((cat) {
            final items = FaMaiData.allFaMai.where((e) => e['category'] == cat).toList();
            if (items.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(cat, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: items.map((item) => _buildFaMaiCard(context, item)).toList(),
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFaMaiCard(BuildContext context, Map<String, String> item) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FaMaiDetailPage(faMaiInfo: item)));
        },
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome, size: 30, color: Colors.deepPurple),
                const SizedBox(height: 8),
                Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('点击查看详情', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= 法脉详情页 =================
class FaMaiDetailPage extends StatelessWidget {
  final Map<String, String> faMaiInfo;
  const FaMaiDetailPage({super.key, required this.faMaiInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(faMaiInfo['name']!), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple[200]!),
              ),
              child: Column(
                children: [
                  const Icon(Icons.masks, size: 50, color: Colors.deepPurple),
                  const SizedBox(height: 10),
                  Text(faMaiInfo['name']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(height: 5),
                  Text('分类：${faMaiInfo['category']}', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('法脉传承', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInfoRow('法主', faMaiInfo['master']!),
            _buildInfoRow('祖师', faMaiInfo['ancestor']!),
            const SizedBox(height: 30),
            const Text('法脉简介', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(faMaiInfo['desc']!, style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 60, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

// ================= 页面三：盘卦列表 =================
class PanGuaPage extends StatelessWidget {
  const PanGuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> panGuaTools = [
      {'title': '六爻起卦', 'desc': '铜钱摇卦，纳甲断吉凶', 'icon': Icons.monetization_on, 'color': Colors.amber},
      {'title': '梅花易数', 'desc': '时间/数字起卦，体用生克', 'icon': Icons.blur_on, 'color': Colors.blue},
      {'title': '八字四柱', 'desc': '排大运流年，看五行格局', 'icon': Icons.brightness_7, 'color': Colors.orange},
      {'title': '雷诺曼卡', 'desc': '直指问题核心，抽牌占卜', 'icon': Icons.style, 'color': Colors.purple},
      {'title': '风水罗盘', 'desc': '电子二十四山，实地勘测定向', 'icon': Icons.explore, 'color': Colors.green},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('盘卦系统'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: panGuaTools.length,
        itemBuilder: (context, index) {
          final tool = panGuaTools[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: tool['color'].withOpacity(0.2),
                child: Icon(tool['icon'], color: tool['color'], size: 28),
              ),
              title: Text(tool['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(tool['desc'], style: TextStyle(color: Colors.grey[600]))),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                if (tool['title'] == '风水罗盘') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CompassPage()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AiDivinationDetailPage(type: tool['title'])));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
// ================= 盘卦详情页（AI解析） =================
class AiDivinationDetailPage extends StatefulWidget {
  final String type; 
  const AiDivinationDetailPage({super.key, required this.type});

  @override
  State<AiDivinationDetailPage> createState() => _AiDivinationDetailPageState();
}

class _AiDivinationDetailPageState extends State<AiDivinationDetailPage> {
  final TextEditingController _inputController = TextEditingController();
  bool _isLoading = false;
  String _resultText = '';
  
  final String _apiKey = 'sk-1f5127571a4843e3af5a2581a0342f40';

  Future<void> _startDivination() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入信息'))); return; }
    
    setState(() { _isLoading = true; _resultText = ''; });

    try {
      final response = await http.post(
        // ✅ 已经换成 DeepSeek 的接口
        Uri.parse('https://api.deepseek.com/chat/completions'),
        headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer $_apiKey' },
        body: jsonEncode({
          "model": "deepseek-chat", // ✅ 已经换成 DeepSeek 的模型
          "messages": [
            {"role": "system", "content": "你是一个精通${widget.type}的玄学大师。请根据用户提供的信息，模拟排盘，并用通俗、专业且简短（200字以内）的语言给出解析和建议。不知道的不要瞎编。"},
            {"role": "user", "content": input}
          ],
          "temperature": 0.5
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() { _resultText = data['choices'][0]['message']['content']; });
      } else {
        setState(() { _resultText = '请求失败：${response.statusCode}'; });
      }
    } catch (e) {
      setState(() { _resultText = '网络连接失败：$e'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.type} 解析'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.type == '八字四柱' ? '请输入您的出生年月日时' : '请输入起卦信息，或想测的事情', style: const TextStyle(fontSize: 15, color: Colors.grey)),
            const SizedBox(height: 10),
            TextField(
              controller: _inputController, maxLines: 3,
              decoration: const InputDecoration(hintText: '在此输入信息...', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _startDivination,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('开始 AI 排盘', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
            if (_resultText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.deepPurple[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.deepPurple[200]!)),
                child: Text(_resultText, style: const TextStyle(fontSize: 16, height: 1.6)),
              ),
          ],
        ),
      ),
    );
  }
}

// ================= 页面四：书库 =================
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  final List<Map<String, String>> books = const [
    {'title': '梅花易数', 'author': '宋·邵雍', 'desc': '北宋易学大师邵雍所著，断事如神。', 'content': '【梅花易数·卷首】\n\n易中秘密穷天地，造化天机泄未然。\n中有神明司祸福，后来切莫教轻传。'},
    {'title': '增删卜易', 'author': '清·野鹤老人', 'desc': '六爻预测学的巅峰之作，实战性极强。', 'content': '【增删卜易·卷首】\n\n野鹤曰：卜易之道，乃伏羲、文王、周公、孔子四大圣人之心法也。'},
    {'title': '雷诺曼卡指南', 'author': '西方神秘学', 'desc': '直指现实生活中的具体问题。', 'content': '【雷诺曼卡·基础篇】\n\n1. 骑士 (Rider)：消息的到来。\n2. 四叶草 (Clover)：短期的好运。'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('术数书库'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookReaderPage(title: book['title']!, author: book['author']!, content: book['content']!))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60, height: 80,
                      decoration: BoxDecoration(color: Colors.deepPurple[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.deepPurple[200]!)),
                      child: const Icon(Icons.auto_stories, size: 35, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('作者：${book['author']}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          const SizedBox(height: 8),
                          Text(book['desc']!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================= 书籍阅读页面 =================
class BookReaderPage extends StatelessWidget {
  final String title; final String author; final String content;
  const BookReaderPage({super.key, required this.title, required this.author, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      backgroundColor: const Color(0xFFFDF6E3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2))),
            const SizedBox(height: 8),
            Center(child: Text('—— $author ——', style: TextStyle(fontSize: 14, color: Colors.grey[600]))),
            const Divider(height: 40, color: Colors.grey),
            Text(content, style: const TextStyle(fontSize: 17, height: 1.8, color: Color(0xFF333333), letterSpacing: 1.2)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ================= 新增：风水电子罗盘页面 =================
// ================= 风水电子罗盘页面（图片版） =================
class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double _heading = 0.0; 
  bool _isSensorAvailable = true;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        setState(() {
          _heading = event.heading!;
          _isSensorAvailable = true;
        });
      } else {
        setState(() {
          _isSensorAvailable = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rotateAngle = -_heading * (math.pi / 180);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('罗盘'), 
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 顶部度数显示区域
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_heading.toStringAsFixed(0)}°', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_drop_up, color: Colors.teal, size: 30),
                Text(_getDirectionName(_heading), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          if (!_isSensorAvailable)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text('未检测到磁力计，使用静态展示', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
            ),

          // 核心罗盘旋转区域
          Expanded(
            child: Center(
              child: Transform.rotate(
                angle: rotateAngle,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, 
                  height: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // ⚠️ 这里读取你的图片
                    image: DecorationImage(
                      image: AssetImage('assets/luopan.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 底部固定的十字准星
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: const Icon(Icons.add, color: Colors.redAccent, size: 50),
          )
        ],
      ),
    );
  }

  String _getDirectionName(double heading) {
    if (heading >= 337.5 || heading < 22.5) return '正北';
    if (heading >= 22.5 && heading < 67.5) return '东北';
    if (heading >= 67.5 && heading < 112.5) return '正东';
    if (heading >= 112.5 && heading < 157.5) return '东南';
    if (heading >= 157.5 && heading < 202.5) return '正南';
    if (heading >= 202.5 && heading < 247.5) return '西南';
    if (heading >= 247.5 && heading < 292.5) return '正西';
    if (heading >= 292.5 && heading < 337.5) return '西北';
    return '';
  }
}