import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

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

// 全局数据存储
class AppData {
  static int waterMl = 0;
  static int exerciseMin = 0;
  static double sleepHours = 0;
  static int teaCups = 0;
  
  static List<String> symptoms = [];
  static String? tongueImagePath;
  static String? faceImagePath;
  
  static List<Map<String, dynamic>> ingredients = [];
  static List<Map<String, dynamic>> toBuyList = [];
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
        children: [
          HomePage(onRefresh: () => setState(() {})),
          const DiagnosisPage(),
          HealthPage(onRefresh: () => setState(() {})),
          const IngredientsPage(),
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
  final VoidCallback onRefresh;
  const HomePage({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智辨养生'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
          ),
        ],
      ),
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
                _buildQuickAction(context, Icons.water_drop, '喝水', Colors.blue, () => _quickAddWater(context)),
                _buildQuickAction(context, Icons.directions_run, '运动', Colors.green, () => _quickAddExercise(context)),
                _buildQuickAction(context, Icons.local_cafe, '茶饮', Colors.brown, () => _quickAddTea(context)),
                _buildQuickAction(context, Icons.camera_alt, '舌诊', Colors.purple, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _quickAddWater(BuildContext context) {
    AppData.waterMl += 200;
    onRefresh();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已记录喝水 200ml'), duration: Duration(seconds: 1)),
    );
  }

  void _quickAddExercise(BuildContext context) {
    AppData.exerciseMin += 30;
    onRefresh();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已记录运动 30分钟'), duration: Duration(seconds: 1)),
    );
  }

  void _quickAddTea(BuildContext context) {
    AppData.teaCups += 1;
    onRefresh();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已记录茶饮 1杯'), duration: Duration(seconds: 1)),
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
                Expanded(child: _buildStatItem(context, Icons.water_drop, '饮水', '${AppData.waterMl}', 'ml', Colors.blue, 2000)),
                Expanded(child: _buildStatItem(context, Icons.directions_run, '运动', '${AppData.exerciseMin}', '分钟', Colors.green, 30)),
                Expanded(child: _buildStatItem(context, Icons.bedtime, '睡眠', '${AppData.sleepHours.toStringAsFixed(1)}', '小时', Colors.indigo, 8)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value, String unit, Color color, int goal) {
    double progress = 0;
    if (goal > 0) {
      if (label == '睡眠') {
        progress = (AppData.sleepHours / goal).clamp(0.0, 1.0);
      } else if (label == '饮水') {
        progress = (AppData.waterMl / goal).clamp(0.0, 1.0);
      } else {
        progress = (AppData.exerciseMin / goal).clamp(0.0, 1.0);
      }
    }
    
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
        const SizedBox(height: 8),
        SizedBox(
          width: 50,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  final List<String> allSymptoms = ['疲劳乏力', '气短懒言', '面色萎黄', '头晕目眩', '心悸失眠', '食欲不振', '腰膝酸软', '畏寒肢冷'];
  bool isAnalyzing = false;
  Map<String, dynamic>? result;

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
                    const SizedBox(height: 8),
                    Text('点击下方按钮模拟拍照', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                AppData.tongueImagePath = 'tongue_demo.jpg';
                              });
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppData.tongueImagePath != null ? Colors.green.shade100 : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, color: AppData.tongueImagePath != null ? Colors.green : Colors.grey.shade600),
                                  const SizedBox(height: 4),
                                  Text(AppData.tongueImagePath != null ? '已选择' : '舌相', style: TextStyle(color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                AppData.faceImagePath = 'face_demo.jpg';
                              });
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppData.faceImagePath != null ? Colors.green.shade100 : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, color: AppData.faceImagePath != null ? Colors.green : Colors.grey.shade600),
                                  const SizedBox(height: 4),
                                  Text(AppData.faceImagePath != null ? '已选择' : '面相', style: TextStyle(color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                      children: allSymptoms.map((s) => FilterChip(
                        label: Text(s),
                        selected: AppData.symptoms.contains(s),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              AppData.symptoms.add(s);
                            } else {
                              AppData.symptoms.remove(s);
                            }
                          });
                        },
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isAnalyzing)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('AI 正在分析...'),
                    ],
                  ),
                ),
              )
            else if (result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                result!['constitution'] ?? '气虚质',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('体质辨识：${result!['constitution'] ?? '气虚质'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('健康评分：${result!['score'] ?? 72}分'),
                      const SizedBox(height: 8),
                      Text('分析：${result!['analysis'] ?? '根据分析，您的体质偏气虚，建议适当运动，调理脾胃。'}'),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (AppData.tongueImagePath != null || AppData.faceImagePath != null)
                      ? () async {
                          setState(() {
                            isAnalyzing = true;
                          });
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() {
                            isAnalyzing = false;
                            result = {
                              'constitution': '气虚质',
                              'score': 72,
                              'analysis': '根据舌象和面象分析，您的体质偏气虚。表现为容易疲劳、气短懒言等症状。建议适当进行有氧运动，配合补气养血的食疗方案。',
                            };
                          });
                        }
                      : null,
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
}

class HealthPage extends StatefulWidget {
  final VoidCallback onRefresh;
  const HealthPage({super.key, required this.onRefresh});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
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
            _buildHealthTab(context, '喝水', 'ml', 2000, Colors.blue, 'water'),
            _buildHealthTab(context, '运动', '分钟', 30, Colors.green, 'exercise'),
            _buildHealthTab(context, '茶饮', '杯', 3, Colors.brown, 'tea'),
            _buildHealthTab(context, '睡眠', '小时', 8, Colors.indigo, 'sleep'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHealthTab(BuildContext context, String title, String unit, int goal, Color color, String type) {
    int current = 0;
    if (type == 'water') current = AppData.waterMl;
    else if (type == 'exercise') current = AppData.exerciseMin;
    else if (type == 'tea') current = AppData.teaCups;
    else if (type == 'sleep') current = (AppData.sleepHours * 10).toInt();
    
    double displayValue = type == 'sleep' ? AppData.sleepHours : current.toDouble();
    double progress = (displayValue / goal).clamp(0.0, 1.0);

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
                  Text(
                    type == 'sleep' ? displayValue.toStringAsFixed(1) : '$current',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: color)
                  ),
                  Text(unit, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _getQuickAddButtons(type, color, context),
          ),
        ],
      ),
    );
  }

  List<Widget> _getQuickAddButtons(String type, Color color, BuildContext context) {
    List<int> values;
    if (type == 'water') values = [100, 200, 300, 500];
    else if (type == 'exercise') values = [15, 30, 45, 60];
    else if (type == 'tea') values = [1, 2, 3];
    else values = [1, 2, 3, 4, 5, 6, 7, 8];

    return values.map((v) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            if (type == 'water') AppData.waterMl += v;
            else if (type == 'exercise') AppData.exerciseMin += v;
            else if (type == 'tea') AppData.teaCups += v;
            else if (type == 'sleep') AppData.sleepHours = v.toDouble();
          });
          widget.onRefresh();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已记录 $v'), duration: const Duration(seconds: 1)),
          );
        },
        style: ElevatedButton.styleFrom(backgroundColor: color.withOpacity(0.1), foregroundColor: color),
        child: Text('$v'),
      );
    }).toList();
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置今日数据'),
        content: const Text('确定要重置今日所有健康数据吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                AppData.waterMl = 0;
                AppData.exerciseMin = 0;
                AppData.teaCups = 0;
                AppData.sleepHours = 0;
              });
              widget.onRefresh();
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final TextEditingController _nameController = TextEditingController();

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
            _buildIngredientList(context, true),
            _buildIngredientList(context, false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddIngredientDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildIngredientList(BuildContext context, bool inStock) {
    final items = inStock 
        ? AppData.ingredients 
        : AppData.toBuyList;
    
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(inStock ? Icons.kitchen : Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(inStock ? '食材库为空' : '待购买清单为空', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.restaurant),
            title: Text(item['name']),
            subtitle: Text(item['quantity'] > 0 ? '${item['quantity']} ${item['unit']}' : ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!inStock)
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        AppData.toBuyList.removeAt(index);
                        AppData.ingredients.add(item);
                      });
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      if (inStock) {
                        AppData.ingredients.removeAt(index);
                      } else {
                        AppData.toBuyList.removeAt(index);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddIngredientDialog(BuildContext context) {
    _nameController.clear();
    bool addToStock = true;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('添加食材', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '食材名称',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('直接加入库存'),
                value: addToStock,
                onChanged: (v) => setModalState(() => addToStock = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    setState(() {
                      final item = {
                        'name': _nameController.text,
                        'quantity': 1,
                        'unit': '份',
                      };
                      if (addToStock) {
                        AppData.ingredients.add(item);
                      } else {
                        AppData.toBuyList.add(item);
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('添加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
