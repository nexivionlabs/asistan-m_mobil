import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const GunlukAsistanimApp());
}

class GunlukAsistanimApp extends StatefulWidget {
  const GunlukAsistanimApp({super.key});

  @override
  State<GunlukAsistanimApp> createState() => _GunlukAsistanimAppState();
}

class _GunlukAsistanimAppState extends State<GunlukAsistanimApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Günlük Asistanım',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: AnaSayfa(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const AnaSayfa({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const GorevlerSayfasi(),
      const OdakSayfasi(),
      const SosyalSayfasi(),
      const ProfilSayfasi(),
      AyarlarSayfasi(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
    ];
  }

  @override
  void didUpdateWidget(AnaSayfa oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _pages[4] = AyarlarSayfasi(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      // DÜZELTME: NavigationBar yerine daha kontrollü BottomNavigationBar kullanıldı
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // KRİTİK AYAR: 3'ten fazla sekme olduğu için 'fixed' yapmalıyız.
        // Aksi takdirde ikonlar kaybolabilir veya beyazlaşabilir.
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            activeIcon: Icon(Icons.check_circle),
            label: 'Görevler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Odak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Sosyal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}

// --- 1. GÖREVLER SAYFASI ---
class GorevlerSayfasi extends StatefulWidget {
  const GorevlerSayfasi({super.key});

  @override
  State<GorevlerSayfasi> createState() => _GorevlerSayfasiState();
}

class Task {
  String id;
  String text;
  bool completed;
  String category;

  Task({required this.id, required this.text, this.completed = false, required this.category});
}

class _GorevlerSayfasiState extends State<GorevlerSayfasi> {
  final List<Task> _tasks = [
    Task(id: '1', text: 'Flutter Widgetlarını öğren', completed: false, category: 'İş'),
    Task(id: '2', text: 'Tasarımı incele', completed: true, category: 'Kişisel'),
  ];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().toString(),
        text: _controller.text,
        category: 'Kişisel',
      ));
      _controller.clear();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].completed = !_tasks[index].completed;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Asistanım', 'Bugünün Görevleri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Yeni görev ekle...',
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: _addTask,
                backgroundColor: Colors.indigo,
                mini: true,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        task.completed ? Icons.check_circle : Icons.circle_outlined,
                        color: task.completed ? Colors.green : Colors.grey,
                      ),
                      onPressed: () => _toggleTask(index),
                    ),
                    title: Text(
                      task.text,
                      style: TextStyle(
                        decoration: task.completed ? TextDecoration.lineThrough : null,
                        color: task.completed ? Colors.grey : null,
                      ),
                    ),
                    subtitle: Text(
                      task.category,
                      style: TextStyle(color: Colors.indigo[300], fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. ODAK (POMODORO) SAYFASI ---
class OdakSayfasi extends StatefulWidget {
  const OdakSayfasi({super.key});

  @override
  State<OdakSayfasi> createState() => _OdakSayfasiState();
}

class _OdakSayfasiState extends State<OdakSayfasi> {
  static const int _defaultTime = 25 * 60;
  int _seconds = _defaultTime;
  Timer? _timer;
  bool _isActive = false;

  void _toggleTimer() {
    if (_isActive) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          _timer?.cancel();
          setState(() => _isActive = false);
        }
      });
    }
    setState(() => _isActive = !_isActive);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = _defaultTime;
      _isActive = false;
    });
  }

  String _formatTime(int totalSeconds) {
    int min = totalSeconds ~/ 60;
    int sec = totalSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Odaklanma Zamanı', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Derin bir nefes al ve işine odaklan.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          Text(
            _formatTime(_seconds),
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()]),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _toggleTimer,
                icon: Icon(_isActive ? Icons.pause : Icons.play_arrow),
                label: Text(_isActive ? 'Duraklat' : 'Başlat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isActive ? Colors.amber : Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: _resetTimer,
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16), shape: const CircleBorder()),
                child: const Icon(Icons.refresh),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// --- 3. SOSYAL SAYFASI ---
class SosyalSayfasi extends StatelessWidget {
  const SosyalSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader('Sosyal Akış', 'Arkadaşların neler yapıyor?'),
        const SizedBox(height: 20),
        _buildPostCard(context, 'Ayşe Yılmaz', 'AY', '2 sa önce', 'Bugün 4 saatlik derin çalışma seansını tamamladım! 🚀', 12),
        _buildPostCard(context, 'Caner Erkin', 'CE', '5 sa önce', 'Pomodoro tekniği ile ödevler bitti. ☕', 45),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context, String user, String initials, String time, String content, int likes) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.shade100,
                  child: Text(initials, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                const SizedBox(width: 4),
                Text('$likes'),
                const SizedBox(width: 20),
                const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. PROFİL SAYFASI ---
class ProfilSayfasi extends StatelessWidget {
  const ProfilSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.indigo,
            child: Text('YA', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          const Text('Misafir Kullanıcı', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Üretken Birey', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Tamamlanan', value: '12', color: Colors.indigo),
                _StatItem(label: 'Bekleyen', value: '4', color: Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 5. AYARLAR SAYFASI (YENİ) ---
class AyarlarSayfasi extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const AyarlarSayfasi({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Ayarlar', 'Uygulama tercihleri'),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Karanlık Mod'),
                  subtitle: const Text('Göz yormayan tema'),
                  leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (val) => toggleTheme(),
                    activeColor: Colors.indigo,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Verileri Sıfırla'),
                  subtitle: const Text('Tüm verileri siler'),
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Veriler sıfırlandı (Simülasyon)')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Versiyon 2.0.0 (Flutter Edition)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

Widget _buildHeader(String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo)),
      Text(subtitle, style: const TextStyle(color: Colors.grey)),
    ],
  );
}


// bu uygulama eğitim amaçlı oluşturuldu.