import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUiOverlayStyle style = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(style);
  runApp(const ZhiBianYangShengApp());
}

class ZhiBianYangShengApp extends StatelessWidget {
  const ZhiBianYangShengApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智辨养生',
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF4A4A4A),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePage(),
          DiagnosisPage(),
          HealthPage(),
          IngredientsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '首页'),
          NavigationDestination(icon: Icon(Icons.healing_outlined), selectedIcon: Icon(Icons.healing), label: '诊疗'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: '健康'),
          NavigationDestination(icon: Icon(Icons.kitchen_outlined), selectedIcon: Icon(Icons.kitchen), label: '食材'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('智辨养生')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSolarTermCard(context),
            const SizedBox(height: 16),
            _buildHealthSummaryCard(context),
            const SizedBox(height: 16),
            Text('快捷操作', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickAction(context, Icons.water_drop, '喝水', Colors.blue),
                _buildQuickAction(context, Icons.directions_run, '运动', Colors.green),
                _buildQuickAction(context, Icons.local_cafe, '茶饮', Colors.brown),
                _buildQuickAction(context, Icons.camera_alt, '舌诊', Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolarTermCard(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('惊蛰', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('春雷乍动，惊醒蛰虫', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.tips_and_updates, size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('宜养阳气，适当运动')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今日健康', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatItem(context, Icons.water_drop, '饮水', '0', 'ml', Colors.blue)),
                Expanded(child: _buildStatItem(context, Icons.directions_run, '运动', '0', '分钟', Colors.green)),
                Expanded(child: _buildStatItem(context, Icons.bedtime, '睡眠', '0', '小时', Colors.indigo)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value, String unit, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(width: 2),
            Text(unit, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class DiagnosisPage extends StatelessWidget {
  const DiagnosisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 舌面诊')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('图片采集', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildImagePicker(context, '舌相')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildImagePicker(context, '面相')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('症状选择', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['疲劳乏力', '气短懒言', '面色萎黄', '头晕目眩', '心悸失眠', '食欲不振']
                          .map((s) => FilterChip(label: Text(s), selected: false, onSelected: (_) {}))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.auto_awesome),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('开始 AI 分析'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 40, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('健康打卡'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text('💧'), text: '喝水'),
              Tab(icon: Text('🏃'), text: '运动'),
              Tab(icon: Text('🍵'), text: '茶饮'),
              Tab(icon: Text('😴'), text: '睡眠'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHealthTab(context, '喝水', 'ml', 2000, Colors.blue),
            _buildHealthTab(context, '运动', '分钟', 30, Colors.green),
            _buildHealthTab(context, '茶饮', '杯', 3, Colors.brown),
            _buildHealthTab(context, '睡眠', '小时', 8, Colors.indigo),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHealthTab(BuildContext context, String title, String unit, int goal, Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('今日$title', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('0', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
                  Text(unit, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                  const SizedBox(height: 8),
                  Text('目标 $goal$unit', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    const Text('暂无今日记录'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IngredientsPage extends StatelessWidget {
  const IngredientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('食材管理'),
          bottom: const TabBar(tabs: [Tab(text: '我的食材库'), Tab(text: '待购买清单')]),
        ),
        body: TabBarView(
          children: [
            _buildEmptyState(context, Icons.kitchen, '食材库为空'),
            _buildEmptyState(context, Icons.shopping_cart_outlined, '待购买清单为空'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
