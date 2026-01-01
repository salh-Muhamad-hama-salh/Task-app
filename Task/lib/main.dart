import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'services/api_service.dart';

// =============================================================================
// 1. TRANSLATIONS
// =============================================================================
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_name': 'Gold Tasker',
          'my_tasks': 'My Tasks',
          'search': 'Search tasks...',
          'add_task': 'Add New Task',
          'title_hint': 'Task Title',
          'note_hint': 'Description / Notes',
          'date': 'Due Date',
          'priority': 'Priority',
          'category': 'Category',
          'create_btn': 'Create Task',
          'settings': 'Settings',
          'language': 'Language',
          'theme': 'Theme',
          'dark': 'Dark',
          'light': 'Light',
          'new_cat': 'New Category',
          'cat_name': 'Category Name',
          'add': 'Add',
          'cancel': 'Cancel',
          'delete_title': 'Delete Task',
          'delete_msg': 'Are you sure you want to delete this?',
          'yes': 'Yes, Delete',
          'no': 'No',
          'details': 'Task Details',
          'completed': 'Completed',
          'mark_complete': 'Mark as Completed',
          'mark_incomplete': 'Mark as Incomplete',
          'delete': 'Delete Task',
          'empty_msg': 'No tasks found!\nTry adding a new one.',
          'stats': 'Statistics',
          'tasks_left': 'Tasks Left',
        },
        'ku_IQ': {
          'app_name': 'گۆڵد تاسکەر',
          'my_tasks': 'ئەرکەکانی من',
          'search': 'گەڕان بۆ ئەرک...',
          'add_task': 'زیادکردنی ئەرک',
          'title_hint': 'ناونیشانی ئەرک',
          'note_hint': 'تێبینی / وردەکاری',
          'date': 'بەروار',
          'priority': 'ئاستی گرنگی',
          'category': 'جۆر (Category)',
          'create_btn': 'دروستکردنی ئەرک',
          'settings': 'ڕێکخستنەکان',
          'language': 'زمان',
          'theme': 'ڕووکار',
          'dark': 'تاریک',
          'light': 'ڕووناک',
          'new_cat': 'جۆری نوێ',
          'cat_name': 'ناوی جۆر',
          'add': 'زیادکردن',
          'cancel': 'پەشیمانبوونەوە',
          'delete_title': 'سڕینەوەی ئەرک',
          'delete_msg': 'دڵنیایت دەتەوێت ئەم ئەرکە بسڕیتەوە؟',
          'yes': 'بەڵێ، بیسڕەوە',
          'no': 'نەخێر',
          'details': 'وردەکارییەکان',
          'completed': 'تەواوکراو',
          'mark_complete': 'تەواوکردنی ئەرک',
          'mark_incomplete': 'گەڕاندنەوە بۆ تەواونەکراو',
          'delete': 'سڕینەوە',
          'empty_msg': 'هیچ ئەرکێک نەدۆزرایەوە!\nهەوڵبدە دانەیەک زیاد بکەیت.',
          'stats': 'ئامارەکان',
          'tasks_left': 'ئەرکی ماوە',
        }
      };
}

// =============================================================================
// 2. MAIN & THEME
// =============================================================================
void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final bool isDark = box.read('isDark') ?? true;
    final String lang = box.read('lang') ?? 'en';

    return GetMaterialApp(
      title: 'Gold Task Manager',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale(lang, lang == 'en' ? 'US' : 'IQ'),
      fallbackLocale: const Locale('en', 'US'),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      // Light Theme
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor:
            Colors.transparent, // Important for Animated BG
        cardColor: Colors.white.withOpacity(0.9),
        colorScheme: const ColorScheme.light(
            primary: Color(0xFFFFD700), secondary: Colors.black),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),

      // Dark Theme
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor:
            Colors.transparent, // Important for Animated BG
        cardColor: const Color(0xFF1E1E1E).withOpacity(0.9),
        colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFD700), secondary: Colors.white),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFFFFD700)),
            titleTextStyle: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),

      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(
            name: '/home',
            page: () => HomeScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/add',
            page: () => AddTaskScreen(),
            transition: Transition.downToUp),
        GetPage(
            name: '/detail',
            page: () => const TaskDetailScreen(),
            transition: Transition.zoom),
      ],
    );
  }
}

// =============================================================================
// 3. ANIMATED BACKGROUND WIDGET (NEW)
// =============================================================================
class AnimatedBG extends StatefulWidget {
  final Widget child;
  const AnimatedBG({super.key, required this.child});

  @override
  State<AnimatedBG> createState() => _AnimatedBGState();
}

class _AnimatedBGState extends State<AnimatedBG>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define colors based on theme
    final isDark = Get.isDarkMode;
    final List<Color> colors = isDark
        ? [
            const Color(0xFF000000),
            const Color(0xFF1C1C1C),
            const Color(0xFF2D2400)
          ]
        : [
            const Color(0xFFFFFFFF),
            const Color(0xFFF0F0F0),
            const Color(0xFFFFFAE0)
          ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

// =============================================================================
// 4. MODEL & CONTROLLER
// =============================================================================
class Task {
  String? id, title, note, date, priority, category;
  bool? isCompleted;
  Task(
      {this.id,
      this.title,
      this.note,
      this.date,
      this.priority,
      this.category,
      this.isCompleted = false});

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': note ?? '',
        'dueDate': date,
        'priority': priority?.toLowerCase() ?? 'medium',
        'category': category ?? 'Personal',
        'completed': isCompleted ?? false,
      };

  Map<String, dynamic> toJsonWithId() => {
        'id': id,
        'title': title,
        'note': note,
        'date': date,
        'priority': priority,
        'category': category,
        'isCompleted': isCompleted
      };

  Task.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    title = json['title'];
    note = json['description'] ?? json['note'];
    date = json['dueDate'] ?? json['date'];
    priority = json['priority'];
    category = json['category'];
    isCompleted = json['completed'] ?? json['isCompleted'];
  }
}

class TaskController extends GetxController {
  final box = GetStorage();
  var taskList = <Task>[].obs;
  var filteredList = <Task>[].obs;
  var categories = <String>['All', 'Work', 'Personal', 'Study'].obs;
  var searchText = ''.obs;
  var selectedCategory = 'All'.obs;
  var isDarkMode = true.obs;
  var currentLang = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = box.read('isDark') ?? true;
    currentLang.value = box.read('lang') ?? 'en';
    if (box.read('categories') != null)
      categories.assignAll(List<String>.from(box.read('categories')));
    loadTasksFromAPI();
    everAll([taskList, searchText, selectedCategory], (_) => filterTasks());
    filterTasks();
  }

  Future<void> loadTasksFromAPI() async {
    try {
      final data = await ApiService.getAllTasks();
      taskList.assignAll(data.map((e) => Task.fromJson(e)).toList());
      saveDataLocally();
    } catch (e) {
      print('Error loading tasks from API: $e');
      // Fallback to local storage
      if (box.read('tasks') != null) {
        var list = box.read('tasks') as List;
        taskList.assignAll(list.map((e) => Task.fromJson(e)).toList());
      }
    }
  }

  void filterTasks() {
    List<Task> temp = List.from(taskList);

    if (selectedCategory.value != 'All') {
      temp = temp.where((t) => t.category == selectedCategory.value).toList();
    }

    if (searchText.value.isNotEmpty) {
      temp = temp
          .where((t) =>
              (t.title
                      ?.toLowerCase()
                      .contains(searchText.value.toLowerCase()) ??
                  false) ||
              (t.note?.toLowerCase().contains(searchText.value.toLowerCase()) ??
                  false))
          .toList();
    }
    temp.sort((a, b) =>
        (a.isCompleted == b.isCompleted) ? 0 : (a.isCompleted! ? 1 : -1));
    filteredList.assignAll(temp);
  }

  Future<void> addTask(Task task) async {
    try {
      final result = await ApiService.createTask(task.toJson());
      if (result != null) {
        taskList.add(Task.fromJson(result));
        saveDataLocally();
        Get.back();
        Get.snackbar("Success", "Task Added to Database",
            backgroundColor: const Color(0xFFFFD700), colorText: Colors.black);
      } else {
        Get.snackbar("Error", "Failed to add task",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error adding task: $e');
      Get.snackbar("Error", "Failed to add task: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      final success = await ApiService.deleteTask(task.id!);
      if (success) {
        taskList.remove(task);
        saveDataLocally();
        Get.back();
        Get.snackbar("Success", "Task Deleted",
            backgroundColor: const Color(0xFFFFD700), colorText: Colors.black);
      } else {
        Get.snackbar("Error", "Failed to delete task",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> toggleComplete(String id) async {
    try {
      final result = await ApiService.toggleCompletion(id);
      if (result != null) {
        var index = taskList.indexWhere((t) => t.id == id);
        if (index != -1) {
          taskList[index] = Task.fromJson(result);
          saveDataLocally();
        }
      }
    } catch (e) {
      print('Error toggling task: $e');
    }
  }

  void addCategory(String cat) {
    if (!categories.contains(cat)) {
      categories.add(cat);
      box.write('categories', categories.toList());
      update();
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    box.write('isDark', isDarkMode.value);
  }

  void toggleLanguage() {
    if (currentLang.value == 'en') {
      currentLang.value = 'ku';
      Get.updateLocale(const Locale('ku', 'IQ'));
    } else {
      currentLang.value = 'en';
      Get.updateLocale(const Locale('en', 'US'));
    }
    box.write('lang', currentLang.value);
  }

  void saveDataLocally() {
    box.write('tasks', taskList.map((e) => e.toJsonWithId()).toList());
  }
}

// =============================================================================
// 5. CUSTOM UI COMPONENTS
// =============================================================================
class AnimTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  const AnimTextField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.icon,
      this.maxLines = 1,
      this.readOnly = false,
      this.onTap});
  @override
  State<AnimTextField> createState() => _AnimTextFieldState();
}

class _AnimTextFieldState extends State<AnimTextField> {
  bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) => setState(() => _isFocused = focus),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: _isFocused
                      ? const Color(0xFFFFD700)
                      : Colors.grey.withOpacity(0.3),
                  width: _isFocused ? 2 : 1),
              boxShadow: _isFocused
                  ? [const BoxShadow(color: Color(0x33FFD700), blurRadius: 10)]
                  : []),
          child: TextField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
                icon: Icon(widget.icon,
                    color: _isFocused ? const Color(0xFFFFD700) : Colors.grey),
                hintText: widget.hint,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 6. NEW SPLASH SCREEN & APP SCREENS
// =============================================================================

// --- NEW ELEGANT SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _mainCtrl =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _mainCtrl, curve: Curves.elasticOut));
    _rotateAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainCtrl, curve: Curves.easeInOutCubic));

    _mainCtrl.forward();
    Future.delayed(const Duration(seconds: 4), () => Get.offNamed('/home'));
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBG(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo: Diamond Shape with Check
              AnimatedBuilder(
                  animation: _mainCtrl,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnim.value,
                      child: Transform.rotate(
                        angle: _rotateAnim.value *
                            math.pi /
                            4, // 45 degree tilt initially
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFFFFD700), width: 4),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFFFFD700)
                                        .withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 5)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    const Color(0xFF1E1E1E)
                                  ])),
                          child: Center(
                            child: Transform.rotate(
                              angle: -math.pi /
                                  4, // Counter rotate icon to keep it straight
                              child: const Icon(Icons.task_alt,
                                  size: 60, color: Color(0xFFFFD700)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 50),
              // Text
              FadeTransition(
                opacity: _scaleAnim,
                child: const Column(
                  children: [
                    Text("GOLD TASKER",
                        style: TextStyle(
                            fontFamily:
                                'Courier', // Or any monospaced/elegant font
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 6,
                            color: Color(0xFFFFD700))),
                    SizedBox(height: 10),
                    Text("Manage with Luxury",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            letterSpacing: 2)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- HOME SCREEN ---
class HomeScreen extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // For transparency
      appBar: AppBar(
        title: Text('app_name'.tr),
        centerTitle: true,
        leading: Builder(
            builder: (c) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(c).openDrawer())),
      ),
      drawer: _buildDrawer(context),
      body: AnimatedBG(
        // Wrapped in Animated Background
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildCategories(context),
              _buildStats(),
              Expanded(
                child: Obx(() {
                  if (controller.filteredList.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 80, color: Colors.grey.withOpacity(0.3)),
                        const SizedBox(height: 10),
                        Text('empty_msg'.tr,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.5)))
                      ],
                    ));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: controller.filteredList.length,
                    itemBuilder: (context, index) {
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        tween: Tween(begin: 0, end: 1),
                        builder: (ctx, val, child) => Transform.translate(
                            offset: Offset(0, 50 * (1 - val)),
                            child: Opacity(opacity: val, child: child)),
                        child: _buildTaskCard(
                            context, controller.filteredList[index]),
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add'),
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: TextField(
        onChanged: (v) => controller.searchText.value = v,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
            hintText: 'search'.tr,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFFFFD700)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final cat = controller.categories[index];
              return Obx(() {
                bool isSelected = controller.selectedCategory.value == cat;
                return GestureDetector(
                  onTap: () => controller.selectedCategory.value = cat,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFD700)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.3))),
                    child: Text(cat,
                        style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              });
            },
          )),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('stats'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Obx(() => Text(
            "${controller.filteredList.where((t) => !t.isCompleted!).length} ${'tasks_left'.tr}",
            style: const TextStyle(color: Color(0xFFFFD700))))
      ]),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail', arguments: task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border(
                left: BorderSide(
                    color: _getPriorityColor(task.priority), width: 5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2))
            ]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title ?? '',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted!
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted! ? Colors.grey : null)),
                  const SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.calendar_month,
                        size: 14, color: Colors.grey.withOpacity(0.7)),
                    const SizedBox(width: 5),
                    Text(task.date ?? '',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 10),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(task.category ?? '',
                            style: const TextStyle(fontSize: 10)))
                  ])
                ],
              ),
            ),
            Checkbox(
                value: task.isCompleted,
                activeColor: const Color(0xFFFFD700),
                checkColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onChanged: (val) => controller.toggleComplete(task.id!))
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF121212)),
            accountName: const Text("User Group",
                style: TextStyle(
                    color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
            accountEmail: const Text("Our project",
                style: TextStyle(color: Colors.white70)),
            currentAccountPicture: const CircleAvatar(
                backgroundColor: Color(0xFFFFD700),
                child: Icon(Icons.person, color: Colors.black)),
          ),
          ListTile(
              leading: const Icon(Icons.language),
              title: Text('language'.tr),
              trailing: Obx(() => Text(
                  controller.currentLang.value == 'en' ? 'English' : 'کوردی')),
              onTap: controller.toggleLanguage),
          ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text('theme'.tr),
              trailing: Obx(() => Icon(controller.isDarkMode.value
                  ? Icons.dark_mode
                  : Icons.light_mode)),
              onTap: controller.toggleTheme),
        ],
      ),
    );
  }

  Color _getPriorityColor(String? p) {
    if (p == 'High') return Colors.redAccent;
    if (p == 'Medium') return Colors.orangeAccent;
    return Colors.greenAccent;
  }
}

// --- ADD TASK SCREEN ---
class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.find();
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _priority = 'Low';
  late String _category;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize category with first non-'All' category
    _category = controller.categories.firstWhere(
      (c) => c != 'All',
      orElse: () => 'Personal',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('add_task'.tr)),
      body: AnimatedBG(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AnimTextField(
                    controller: _titleCtrl,
                    hint: 'title_hint'.tr,
                    icon: Icons.title),
                AnimTextField(
                    controller: _noteCtrl,
                    hint: 'note_hint'.tr,
                    icon: Icons.notes,
                    maxLines: 3),
                AnimTextField(
                  controller: TextEditingController(
                      text: DateFormat.yMd().format(_selectedDate)),
                  hint: 'date'.tr,
                  icon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (ctx, child) => Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                    primary: Color(0xFFFFD700),
                                    onPrimary: Colors.black)),
                            child: child!));
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: _buildDropdown(
                          label: 'priority'.tr,
                          value: _priority,
                          items: ['High', 'Medium', 'Low'],
                          icon: Icons.flag,
                          onChanged: (v) => setState(() => _priority = v!))),
                  const SizedBox(width: 15),
                  Expanded(child: Obx(() {
                    final availableCategories =
                        controller.categories.where((c) => c != 'All').toList();
                    final selectedValue =
                        availableCategories.contains(_category)
                            ? _category
                            : availableCategories.first;
                    return _buildDropdown(
                        label: 'category'.tr,
                        value: selectedValue,
                        items: availableCategories,
                        icon: Icons.category,
                        onChanged: (v) => setState(() => _category = v!),
                        isCategory: true);
                  })),
                ]),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 5),
                    onPressed: () {
                      if (_titleCtrl.text.isEmpty) {
                        Get.snackbar("Error", "Title is required",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                        return;
                      }
                      controller.addTask(Task(
                          title: _titleCtrl.text,
                          note: _noteCtrl.text,
                          date: DateFormat.yMd().format(_selectedDate),
                          priority: _priority,
                          category: _category));
                    },
                    child: Text('create_btn'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      {required String label,
      required String value,
      required List<String> items,
      required IconData icon,
      required Function(String?) onChanged,
      bool isCategory = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontWeight: FontWeight.bold)),
        if (isCategory)
          GestureDetector(
              onTap: _showAddCategoryDialog,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Color(0xFFFFD700), shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 16, color: Colors.black)))
      ]),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: value,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: Theme.of(context).primaryColor),
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                onChanged: onChanged)),
      ),
    ]);
  }

  void _showAddCategoryDialog() {
    final txtCtrl = TextEditingController();
    Get.defaultDialog(
        title: 'new_cat'.tr,
        content: AnimTextField(
            controller: txtCtrl, hint: 'cat_name'.tr, icon: Icons.category),
        confirm: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700)),
            onPressed: () {
              if (txtCtrl.text.isNotEmpty) {
                controller.addCategory(txtCtrl.text);
                setState(() => _category = txtCtrl.text);
                Get.back();
              }
            },
            child: Text('add'.tr, style: const TextStyle(color: Colors.black))),
        cancel: TextButton(
            onPressed: () => Get.back(),
            child:
                Text('cancel'.tr, style: const TextStyle(color: Colors.grey))));
  }
}

// --- TASK DETAILS ---
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Task task = Get.arguments;
    final TaskController controller = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('details'.tr)),
      body: AnimatedBG(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Chip(
                      avatar: const Icon(Icons.category,
                          size: 16, color: Colors.black),
                      label: Text(task.category ?? ''),
                      backgroundColor: const Color(0xFFFFD700)),
                  const SizedBox(width: 10),
                  Chip(
                      label: Text(task.priority ?? ''),
                      backgroundColor: Colors.grey.withOpacity(0.2))
                ]),
                const SizedBox(height: 20),
                Text(task.title ?? '',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700))),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(task.date ?? '',
                      style: const TextStyle(color: Colors.grey))
                ]),
                const SizedBox(height: 30),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.1))),
                    child: Text(task.note ?? '',
                        style: const TextStyle(fontSize: 16, height: 1.5))),
                const Spacer(),
                Row(children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: task.isCompleted!
                                  ? Colors.grey
                                  : const Color(0xFFFFD700),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15)),
                          icon: Icon(
                              task.isCompleted! ? Icons.undo : Icons.check,
                              color: Colors.black),
                          label: Text(
                              task.isCompleted!
                                  ? 'mark_incomplete'.tr
                                  : 'mark_complete'.tr,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            controller.toggleComplete(task.id!);
                            Get.back();
                          }))
                ]),
                const SizedBox(height: 15),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent)),
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        label: Text('delete'.tr,
                            style: const TextStyle(color: Colors.redAccent)),
                        onPressed: () => Get.defaultDialog(
                            title: 'delete_title'.tr,
                            middleText: 'delete_msg'.tr,
                            textConfirm: 'yes'.tr,
                            textCancel: 'no'.tr,
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.red,
                            onConfirm: () => controller.deleteTask(task))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
