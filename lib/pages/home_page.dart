import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/savings_model.dart';
import '../services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SavingsModel> accounts = [];
  int selectedIndex = 0;

  Map<int, int> defaultNotes() => {
    500: 0,
    200: 0,
    100: 0,
    50: 0,
    20: 0,
    10: 0,
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    accounts = await StorageService.loadAccounts();

    if (accounts.isEmpty) {
      accounts.add(
        SavingsModel(name: "My Savings", noteCounts: defaultNotes()),
      );
      await StorageService.saveAccounts(accounts);
    }

    setState(() {});
  }

  void saveData() {
    StorageService.saveAccounts(accounts);
  }

  int get totalBalance {
    int total = 0;
    accounts[selectedIndex].noteCounts.forEach((value, count) {
      total += value * count;
    });
    return total;
  }

  void updateCount(int value, int change) {
    HapticFeedback.lightImpact();

    setState(() {
      int current =
          accounts[selectedIndex].noteCounts[value]! + change;
      accounts[selectedIndex].noteCounts[value] =
      current < 0 ? 0 : current;
    });

    saveData();
  }

  // ================= ACCOUNT MANAGEMENT =================

  void renameAccount(int index) {
    TextEditingController controller =
    TextEditingController(text: accounts[index].name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Rename Window"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  accounts[index].name = controller.text;
                });
                saveData();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void deleteAccount(int index) {
    if (accounts.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("At least one window required")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Window?"),
        content: const Text(
            "This savings window will be permanently removed."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                accounts.removeAt(index);
                selectedIndex =
                selectedIndex >= accounts.length
                    ? accounts.length - 1
                    : selectedIndex;
              });
              saveData();
              Navigator.pop(context);
            },
            child:
            const Text("Delete", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  void createNewAccount() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("New Savings Window"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  accounts.add(SavingsModel(
                      name: controller.text,
                      noteCounts: defaultNotes()));
                  selectedIndex = accounts.length - 1;
                });
                saveData();
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }

  void showAccountsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Savings Windows",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              ...List.generate(accounts.length, (index) {
                return ListTile(
                  title: Text(accounts[index].name),
                  leading: selectedIndex == index
                      ? const Icon(Icons.check_circle,
                      color: Colors.green)
                      : const Icon(Icons.account_balance_wallet),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          Navigator.pop(context);
                          renameAccount(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                          deleteAccount(index);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() => selectedIndex = index);
                    Navigator.pop(context);
                  },
                );
              }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Create New"),
                onTap: () {
                  Navigator.pop(context);
                  createNewAccount();
                },
              )
            ],
          ),
        );
      },
    );
  }

  // ================= UI =================

  Color getNoteColor(int value) {
    switch (value) {
      case 500:
      // Stone grey with subtle green tint (real ₹500 note feel)
        return const Color(0xFF7A8F88);

      case 200:
      // Mustard yellow
        return const Color(0xFFE5B93C);

      case 100:
      // Lavender purple
        return const Color(0xFF8666B3);

      case 50:
      // Fluorescent blue
        return const Color(0xFF2EA3DB);

      case 20:
      // Greenish yellow
        return const Color(0xFF7FB833);

      case 10:
      // Earthy brown
        return const Color(0xFF8B4C22);

      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FB), Color(0xFFEDEFF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: showAccountsSheet,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(accounts[selectedIndex].name,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C853), Color(0xFF00BFA5)],
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text("Total Balance",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration:
                        const Duration(milliseconds: 300),
                        child: Text(
                          "₹ $totalBalance",
                          key: ValueKey(totalBalance),
                          style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ).animate().fadeIn(),

                const SizedBox(height: 25),

                Expanded(
                  child: ListView(
                    children: accounts[selectedIndex]
                        .noteCounts
                        .keys
                        .map((value) {
                      return Container(
                        margin:
                        const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: getNoteColor(value).withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                          borderRadius:
                          BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text("₹ $value",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.w600)),
                            Row(
                              children: [
                                _circleButton(Icons.remove,
                                        () => updateCount(value, -1)),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Text(
                                    "${accounts[selectedIndex].noteCounts[value]}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                ),
                                _circleButton(Icons.add,
                                        () => updateCount(value, 1)),
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton(
      IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}