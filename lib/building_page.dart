import 'package:flutter/material.dart';
import 'builds_page.dart';

class BuildingPage extends StatefulWidget {
  final List<Map<String, dynamic>> savedBuilds;

  const BuildingPage({super.key, required this.savedBuilds});

  @override
  _BuildingPageState createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {
  final Map<String, String> _selectedItems = {}; // Store selected items for each component
  final Map<String, List<String>> _compatibilityMap = {
    'Intel i5': ['ASUS ROG', 'MSI Tomahawk'],
    'AMD Ryzen 5': ['Gigabyte Aorus', 'MSI Tomahawk'],
    'Intel i7': ['ASUS ROG', 'Gigabyte Aorus'],
    'AMD Ryzen 7': ['MSI Tomahawk', 'Gigabyte Aorus'],
  }; // Compatibility map for processors and motherboards

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF381E72)),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the Dashboard
          },
        ),
        title: const Text(
          'Start Crafting',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF381E72),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/Logo_Trsp.png'),
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Start Crafting',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF381E72),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Your Selections',
                    style: TextStyle(
                      fontFamily: 'Alexandria-Light',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildComponentCard(
                  context,
                  'Processor',
                  'assets/images/CPU.png',
                  ['Intel i5', 'AMD Ryzen 5', 'Intel i7', 'AMD Ryzen 7'],
                ),
                _buildComponentCard(
                  context,
                  'GPU',
                  'assets/images/GPU.png',
                  ['NVIDIA RTX 3060', 'NVIDIA RTX 3070', 'AMD RX 6700 XT'],
                ),
                _buildComponentCard(
                  context,
                  'MOBO',
                  'assets/images/MB.png',
                  _getCompatibleComponents('MOBO'),
                ),
                _buildComponentCard(
                  context,
                  'Memory',
                  'assets/images/RAM.png',
                  ['8GB DDR4', '16GB DDR4', '32GB DDR4'],
                ),
                _buildComponentCard(
                  context,
                  'Storage',
                  'assets/images/Storage.png',
                  ['1TB HDD', '512GB SSD', '1TB SSD'],
                ),
                _buildComponentCard(
                  context,
                  'PSU',
                  'assets/images/PSU.png',
                  ['500W', '650W', '750W'],
                ),
                _buildComponentCard(
                  context,
                  'Cooling',
                  'assets/images/FAN.png',
                  ['Air Cooler', 'Liquid Cooler'],
                ),
                _buildComponentCard(
                  context,
                  'Case',
                  'assets/images/Case.png',
                  ['Mid Tower', 'Full Tower'],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedItems.isNotEmpty) {
                        _showSaveDialog(context);
                      } else {
                        // Show a message if no components are selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select components before saving!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF381E72),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

void _showSaveDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Save Build'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Build Name',
            hintText: 'Enter a name for your build',
          ),
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
              final String buildName = nameController.text.trim();
              if (buildName.isNotEmpty) {
                // Save the selected items as a new build
                final newBuild = {
                  'name': buildName,
                  'components': Map<String, String>.from(_selectedItems),
                };
                widget.savedBuilds.add(newBuild);

                Navigator.pop(context); // Close the dialog

                // Navigate back to the DashboardPage
                Navigator.pop(context); // Close the BuildingPage
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your Build Has Been Saved'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // Show a message if the name is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a name for your build!'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

  Widget _buildComponentCard(BuildContext context, String title, String imagePath, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF381E72),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Available options:',
                  style: TextStyle(
                    fontFamily: 'Alexandria-Light',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                OutlinedButton(
                  onPressed: () {
                    _showOptions(context, title, options);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: _selectedItems[title] != null
                          ? const Color(0xFF381E72)
                          : const Color(0xFFD9D9D9),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _selectedItems[title] ?? 'Select',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      color: _selectedItems[title] != null
                          ? const Color(0xFF381E72)
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context, String title, List<String> options) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select $title',
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF381E72),
                ),
              ),
              const SizedBox(height: 10),
              ...options.map(
                (option) => ListTile(
                  title: Text(
                    option,
                    style: const TextStyle(fontFamily: 'Alexandria'),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedItems[title] = option;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _getCompatibleComponents(String componentType) {
    if (componentType == 'MOBO' && _selectedItems.containsKey('Processor')) {
      return _compatibilityMap[_selectedItems['Processor']] ?? [];
    }
    return ['None'];
  }
}