import 'package:flutter/material.dart';

class Task {
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task({required this.title, required this.dueDate, this.isCompleted = false});
}

class PasswordScreen extends StatefulWidget {
  final String defaultPassword;

  PasswordScreen({required this.defaultPassword});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _passwordController = TextEditingController();
  bool _isPasswordCorrect = true;

  void _checkPassword() {
    if (_passwordController.text != widget.defaultPassword) {
      setState(() {
        _isPasswordCorrect = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskManagerApp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senha'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                errorText: _isPasswordCorrect
                    ? null
                    : 'Senha incorreta. Tente novamente.',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _checkPassword,
              child: Text('Acessar'),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskManagerApp extends StatefulWidget {
  @override
  _TaskManagerAppState createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  List<Task> tasks = [];

  void addTask(String title, DateTime dueDate) {
    setState(() {
      tasks.add(Task(title: title, dueDate: dueDate));
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void editTask(int index, String newTitle, DateTime newDueDate) {
    setState(() {
      tasks[index].title = newTitle;
      tasks[index].dueDate = newDueDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0x7D8793A9),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xB7292626),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => TaskListScreen(
              tasks: tasks,
              toggleCompletion: toggleTaskCompletion,
              deleteTask: deleteTask,
              editTask: editTask,
            ),
        '/addTask': (context) => AddTaskScreen(
              addTask: addTask,
            ),
        '/editTask': (context) => EditTaskScreen(
              editTask: editTask,
            ),
      },
    );
  }
}

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(int) toggleCompletion;
  final Function(int) deleteTask;
  final Function(int, String, DateTime) editTask;

  TaskListScreen({
    required this.tasks,
    required this.toggleCompletion,
    required this.deleteTask,
    required this.editTask,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => toggleCompletion(index),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              'Data de Vencimento: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/editTask',
                      arguments: EditTaskArguments(index: index, task: task),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () => deleteTask(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTask');
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xB7292626),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  final Function(String, DateTime) addTask;

  AddTaskScreen({required this.addTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TimeOfDay _dueTime = TimeOfDay.now();

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );
    if (pickedTime != null) {
      setState(() {
        _dueTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Data de Vencimento:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: _showDatePicker,
                  child: Text(
                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Horário de Vencimento:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: _showTimePicker,
                  child: Text(
                    '${_dueTime.hour}:${_dueTime.minute}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  final dueDateTime = DateTime(
                    _dueDate.year,
                    _dueDate.month,
                    _dueDate.day,
                    _dueTime.hour,
                    _dueTime.minute,
                  );
                  widget.addTask(title, dueDateTime);
                  Navigator.pop(context);
                }
              },
              child: Text('Lista de Tarefas'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xB7292626),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskArguments {
  final int index;
  final Task task;

  EditTaskArguments({required this.index, required this.task});
}

class EditTaskScreen extends StatefulWidget {
  final Function(int, String, DateTime) editTask;

  EditTaskScreen({required this.editTask});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as EditTaskArguments;
    final task = arguments.task;
    _titleController = TextEditingController(text: task.title);
    _dueDate = task.dueDate;
    _dueTime = TimeOfDay.fromDateTime(task.dueDate);
  }

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );
    if (pickedTime != null) {
      setState(() {
        _dueTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Data de Vencimento:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: _showDatePicker,
                  child: Text(
                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Horário de Vencimento:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: _showTimePicker,
                  child: Text(
                    '${_dueTime.hour}:${_dueTime.minute}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  final dueDateTime = DateTime(
                    _dueDate.year,
                    _dueDate.month,
                    _dueDate.day,
                    _dueTime.hour,
                    _dueTime.minute,
                  );
                  final arguments = ModalRoute.of(context)!.settings.arguments
                      as EditTaskArguments;
                  widget.editTask(arguments.index, title, dueDateTime);
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xB7292626),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(PasswordApp());
}

class PasswordApp extends StatelessWidget {
  final String defaultPassword = 'Tentamos';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0x7D8793A9),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xB7292626),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: PasswordScreen(defaultPassword: defaultPassword),
    );
  }
}
