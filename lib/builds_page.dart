import 'package:flutter/material.dart';

class BuildsPage extends StatefulWidget {
  final List<Map<String, dynamic>> savedBuilds;

  const BuildsPage({super.key, this.savedBuilds = const []}); // Default value for savedBuilds

  @override
  _BuildsPageState createState() => _BuildsPageState();
}

class _BuildsPageState extends State<BuildsPage> {
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
            image: AssetImage('assets/images/bg.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: widget.savedBuilds.isEmpty
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
                itemCount: widget.savedBuilds.length,
                itemBuilder: (context, index) {
                  final build = widget.savedBuilds[index];
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
                        build['components']
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
                            _deleteBuild(index);
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
        TextEditingController(text: widget.savedBuilds[index]['name']);
    final Map<String, String> components =
        Map<String, String>.from(widget.savedBuilds[index]['components']);

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
                  subtitle: Text(entry.value),
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
                setState(() {
                  widget.savedBuilds[index]['name'] = nameController.text.trim();
                });
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBuild(int index) {
    setState(() {
      widget.savedBuilds.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Build deleted successfully!'),
      ),
    );
  }
}