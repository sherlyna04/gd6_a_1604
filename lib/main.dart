import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd6_a_1604/database/sql_helper.dart';
import 'inputPage.dart'; // Import InputPage for employees
import 'inputToko.dart'; // Import FoodInputPage


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'SQFLITE'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> toko = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    refreshEmployeeList();
    refreshTokoList();
  }

  void refreshEmployeeList() async {
    final data = await SQLHelper.getEmployee();
    setState(() {
      employees = data;
    });
  }

  void refreshTokoList() async {
    final data = await SQLHelper.getToko();
    setState(() {
      toko = data;
    });
  }

  Future<void> deleteEmployee(int id) async {
    await SQLHelper.deleteEmployee(id);
    refreshEmployeeList();
  }

  Future<void> deleteFood(int id) async {
    await SQLHelper.deleteToko(id);
    refreshTokoList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Employee List" : "Toko List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_selectedIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputPage(
                      title: 'Add Employee',
                      id: null,
                      name: null,
                      email: null,
                    ),
                  ),
                ).then((_) => refreshEmployeeList());
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputToko(
                      title: 'Add Toko',
                      id: null,
                      alamat: null,
                      tahunDibuka: null,
                    ),
                  ),
                ).then((_) => refreshTokoList());
              }
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(employees[index]['id']),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InputPage(
                                title: 'Edit Employee',
                                id: employees[index]['id'],
                                name: employees[index]['name'],
                                email: employees[index]['email'],
                              ),
                            ),
                          ).then((_) => refreshEmployeeList());
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.update,
                        label: 'Update',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await deleteEmployee(employees[index]['id']);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(employees[index]['name']),
                    subtitle: Text(employees[index]['email']),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: toko.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(toko[index]['id']),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InputToko(
                                title: 'Edit Food',
                                id: toko[index]['id'],
                                alamat: toko[index]['alamat'],
                                tahunDibuka:toko[index]['tahun_dibuka'],
                              ),
                            ),
                          ).then((_) => refreshTokoList());
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.update,
                        label: 'Update',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await deleteFood(toko[index]['id']);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(toko[index]['alamat']),
                    subtitle: Text(toko[index]['tahun_dibuka']),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Employee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Toko',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}