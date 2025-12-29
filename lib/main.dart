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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
  String title;
  String description;
  DateTime date;
  String priority;
  String category;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    this.category = "Kişisel",
    this.isCompleted = false,
  });
}

class _GorevlerSayfasiState extends State<GorevlerSayfasi> {
  final List<Task> _tasks = [
    Task(
      id: '1', 
      title: 'Flutter Widgetlarını öğren', 
      isCompleted: false, 
      category: 'İş',
      priority: 'high',
      description: 'StatefulWidget ve StatelessWidget farklarını anla.',
      date: DateTime.now().add(const Duration(hours: 2)),
    ),
    Task(
      id: '2', 
      title: 'Tasarımı incele', 
      isCompleted: true, 
      category: 'Kişisel',
      priority: 'medium',
      description: 'Renk paletini kontrol et.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _showAddTaskDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    String selectedPriority = "medium";
    String selectedCategory = "Kişisel";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Yeni Görev Ekle"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Görev Başlığı"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: "Açıklama"),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                        TextButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              initialDate: selectedDate,
                            );
                            if (picked != null) {
                              setDialogState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: const Text("Tarih Seç"),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}"),
                        TextButton(
                          onPressed: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (time != null) {
                              setDialogState(() {
                                selectedTime = time;
                              });
                            }
                          },
                          child: const Text("Saat Seç"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedPriority,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: "low", child: Text("Düşük Öncelik")),
                        DropdownMenuItem(value: "medium", child: Text("Orta Öncelik")),
                        DropdownMenuItem(value: "high", child: Text("Yüksek Öncelik")),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: "İş", child: Text("İş")),
                        DropdownMenuItem(value: "Kişisel", child: Text("Kişisel")),
                        DropdownMenuItem(value: "Eğitim", child: Text("Eğitim")),
                        DropdownMenuItem(value: "Sağlık", child: Text("Sağlık")),
                        DropdownMenuItem(value: "Ev", child: Text("Ev")),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty) return;
                    
                    DateTime finalDate = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    setState(() {
                      _tasks.add(
                        Task(
                          id: DateTime.now().toString(),
                          title: titleController.text,
                          description: descController.text,
                          date: finalDate,
                          priority: selectedPriority,
                          category: selectedCategory,
                          isCompleted: false,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  // ignore: unused_element
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
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
          // ✅ BAŞLIK ALANI VE GÜNCELLENMİŞ BUTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader('Asistanım', 'Bugünün Görevleri'),
              
              // 4️⃣ BUTON BURAYA EKLENDİ
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompletedTasksPage(tasks: _tasks),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade50,
                  foregroundColor: Colors.indigo,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text("Tamamlanan Görevler"),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showAddTaskDialog,
              icon: const Icon(Icons.add),
              label: const Text("Yeni Görev Ekle"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
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
                    leading: Checkbox(
                      value: task.isCompleted,
                      activeColor: Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (value) {
                        setState(() {
                          task.isCompleted = value!;
                        });
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(task.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(task.description, style: const TextStyle(fontSize: 13)),
                          ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            // ignore: unnecessary_null_comparison
                            if(task.date != null) ...[ 
                              const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "📅 ${task.date.day}/${task.date.month}/${task.date.year}",
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                            ],

                            Text(
                              "🔥 ${task.priority}",
                              style: TextStyle(
                                fontSize: 12, 
                                color: task.priority == 'high' ? Colors.red : Colors.grey[700]
                              ),
                            ),
                            
                            const SizedBox(width: 10),
                            Text("📂 ${task.category}", style: const TextStyle(fontSize: 12, color: Colors.indigo)),
                          ],
                        ),
                      ],
                    ),
                    isThreeLine: true, 
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

// --- 5. AYARLAR SAYFASI ---
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

// ✅ YENİ SAYFA: TAMAMLANAN GÖREVLER
class CompletedTasksPage extends StatelessWidget {
  final List<Task> tasks; // TaskModel yerine Task kullanıyoruz

  const CompletedTasksPage({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((t) => t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tamamlanan Görevler", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: completed.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Henüz tamamlanan görev yok 🙂", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completed.length,
              itemBuilder: (context, index) {
                final task = completed[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(
                      task.title,
                      style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(task.description.isNotEmpty) Text(task.description),
                        const SizedBox(height: 4),
                        Text(
                          "Tamamlandı - ${task.date.day}/${task.date.month}/${task.date.year}",
                          style: const TextStyle(fontSize: 12, color: Colors.indigo),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}