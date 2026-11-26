import 'package:flutter/material.dart';

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
      'name': '闾山法门',
      'category': '民间法教',
      'master': '闾山法主',
      'ancestor': '许真君',
      'desc': '流行于福建、台湾及东南亚地区。以法主公、三奶夫人信仰为核心，擅长驱邪、押煞、收惊、祈雨等，仪式感极强。',
    },
    {
      'name': '正一天师道',
      'category': '正统道教',
      'master': '张天师',
      'ancestor': '太上老君',
      'desc': '道教正统宗派，以符箓斋醮为主，讲究“正一盟威之道”，是法教法术的重要源头之一。',
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

// ================= 主框架：5个底部导航栏 =================
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // 5个核心页面
  final List<Widget> _pages = [
    const AiChatPage(),        // 1. AI 问答
    const DivinationPage(),    // 2. 法脉
    const PanGuaPage(),        // 3. 盘卦 (新增独立页面)
    const LibraryPage(),       // 4. 书库
    const ProfilePage(),       // 5. 我的
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'AI'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: '法脉'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: '盘卦'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: '书库'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '我的'),
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
    {'role': 'ai', 'text': '福生无量天尊。我是您的 AI 助手，精通各大法脉与术数，您想了解什么？'}
  ];

  void _sendMessage([String? presetText]) {
    String textToSend = presetText ?? _controller.text;
    if (textToSend.isEmpty) return;
    
    setState(() {
      _messages.add({'role': 'user', 'text': textToSend});
      _messages.add({'role': 'ai', 'text': '【AI模拟回复】收到您的提问：“$textToSend”。此乃法门奥妙，待接入真实大模型后，我将为您深度解答。'});
    });
    _controller.clear();
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
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                IconButton.filled(
                  onPressed: () => _sendMessage(),
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(backgroundColor: Colors.deepPurple),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
// ================= 页面二：法脉（只剩法脉大全了） =================
class DivinationPage extends StatelessWidget {
  const DivinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['民间法教', '正统道教', '西方神秘学'];

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FaMaiDetailPage(faMaiInfo: item),
            ),
          );
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

// ================= 页面三：独立盘卦系统 =================
class PanGuaPage extends StatelessWidget {
  const PanGuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 盘卦相关的功能数据
    final List<Map<String, dynamic>> panGuaTools = [
      {'title': '六爻起卦', 'desc': '铜钱摇卦，纳甲断吉凶', 'icon': Icons.monetization_on, 'color': Colors.amber},
      {'title': '梅花易数', 'desc': '时间/数字起卦，体用生克', 'icon': Icons.blur_on, 'color': Colors.blue},
      {'title': '八字四柱', 'desc': '排大运流年，看五行格局', 'icon': Icons.brightness_7, 'color': Colors.orange},
      {'title': '雷诺曼卡', 'desc': '直指问题核心，抽牌占卜', 'icon': Icons.style, 'color': Colors.purple},
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
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(tool['desc'], style: TextStyle(color: Colors.grey[600])),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                _showMockDialog(context, tool['title']);
              },
            ),
          );
        },
      ),
    );
  }

  void _showMockDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type 排盘'),
        content: Text('正在为您准备 $type 的起卦排盘界面...\n（此处未来接入具体算法）'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('确定'))],
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
      appBar: AppBar(
        title: Text(faMaiInfo['name']!),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('转交 AI 解析'),
                      content: Text('即将前往 AI 问答，自动为您提问关于【${faMaiInfo['name']}】的详细信息。'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: const Text('确定')
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: Text('让 AI 详细讲解【${faMaiInfo['name']}】'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
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
          SizedBox(
            width: 60,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

// ================= 页面四：书库 =================
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('书库'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: const Center(
        child: Text('书库内容正在整理中...\n敬请期待', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}

// ================= 页面五：我的/登录 =================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 50, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 60, color: Colors.white)),
              const SizedBox(height: 20),
              const Text('未登录', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('登录功能开发中...')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text('立即登录 / 注册', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}