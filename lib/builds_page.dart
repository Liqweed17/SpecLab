import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuildsPage extends StatefulWidget {
  const BuildsPage({super.key});

  @override
  _BuildsPageState createState() => _BuildsPageState();
}

class _BuildsPageState extends State<BuildsPage> {
  List<Map<String, dynamic>> builds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBuilds();
  }

  Future<void> fetchBuilds() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('https://crud-mryv.onrender.com/builds/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        builds = data.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch builds: ${response.body}')),
      );
    }
  }

  Future<void> updateBuild(int index, String newName) async {
    final build = builds[index];
    final id = build['id'];
    final response = await http.put(
      Uri.parse('https://crud-mryv.onrender.com/builds/$id/update/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': newName,
        'components': build['components'],
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        builds[index]['name'] = newName;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Build updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update build: ${response.body}')),
      );
    }
  }

  Future<void> deleteBuild(int index) async {
    final build = builds[index];
    final id = build['id'];
    final response = await http.delete(
      Uri.parse('https://crud-mryv.onrender.com/builds/$id/delete/'),
    );
    if (response.statusCode == 204) {
      setState(() {
        builds.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Build deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete build: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF381E72)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Your Builds',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF381E72),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : builds.isEmpty
                ? const Center(
                    child: Text(
                      'No builds saved yet!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF381E72),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: builds.length,
                    itemBuilder: (context, index) {
                      final build = builds[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          title: Text(
                            build['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF381E72),
                            ),
                          ),
                          subtitle: Text(
                            (build['components'] as Map)
                                .entries
                                .map((e) => '${e.key}: ${e.value}')
                                .join('\n'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Edit') {
                                _editBuild(context, index);
                              } else if (value == 'Delete') {
                                deleteBuild(index);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void _editBuild(BuildContext context, int index) {
    final TextEditingController nameController =
        TextEditingController(text: builds[index]['name']);
    final Map<String, dynamic> components =
        Map<String, dynamic>.from(builds[index]['components']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Build'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Build Name',
                  hintText: 'Enter a new name for your build',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Components:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...components.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updateBuild(index, nameController.text.trim());
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
