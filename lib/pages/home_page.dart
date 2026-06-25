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

  /// All supported money values
  /// Notes: 500, 200, 100, 50, 20, 10
  /// Coins: 20, 10, 5, 2, 1
  ///
  /// Since 20 and 10 exist in both note + coin form,
  /// we will show:
  /// - ₹20 Note
  /// - ₹10 Note
  /// - ₹20 Coin
  /// - ₹10 Coin
  ///
  /// To support both separately, we use unique keys internally:
  /// 500, 200, 100, 50, 20, 10 for notes
  /// 1020, 1010, 5, 2, 1 for coins
  ///
  /// Display labels are handled separately.

  Map<int, int> defaultMoney() => {
    // Notes
    500: 0,
    200: 0,
    100: 0,
    50: 0,
    20: 0,   // ₹20 Note
    10: 0,   // ₹10 Note

    // Coins
    1020: 0, // ₹20 Coin
    1010: 0, // ₹10 Coin
    5: 0,
    2: 0,
    1: 0,
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
        SavingsModel(
          name: "My Savings",
          moneyCounts: defaultMoney(),
        ),
      );
      await StorageService.saveAccounts(accounts);
    } else {
      // If old saved data exists (before coins were added),
      // make sure the new keys are inserted safely.
      for (final account in accounts) {
        final defaults = defaultMoney();
        defaults.forEach((key, value) {
          account.moneyCounts.putIfAbsent(key, () => value);
        });
      }
      await StorageService.saveAccounts(accounts);
    }

    setState(() {});
  }

  void saveData() {
    StorageService.saveAccounts(accounts);
  }

  int get totalBalance {
    int total = 0;
    final map = accounts[selectedIndex].moneyCounts;

    map.forEach((key, count) {
      total += getActualValue(key) * count;
    });

    return total;
  }

  int getActualValue(int key) {
    if (key == 1020) return 20; // ₹20 coin
    if (key == 1010) return 10; // ₹10 coin
    return key;
  }

  bool isCoin(int key) {
    return key == 1020 || key == 1010 || key == 5 || key == 2 || key == 1;
  }

  String getMoneyLabel(int key) {
    switch (key) {
      case 500:
        return "₹500 Note";
      case 200:
        return "₹200 Note";
      case 100:
        return "₹100 Note";
      case 50:
        return "₹50 Note";
      case 20:
        return "₹20 Note";
      case 10:
        return "₹10 Note";
      case 1020:
        return "₹20 Coin";
      case 1010:
        return "₹10 Coin";
      case 5:
        return "₹5 Coin";
      case 2:
        return "₹2 Coin";
      case 1:
        return "₹1 Coin";
      default:
        return "₹${getActualValue(key)}";
    }
  }

  void updateCount(int key, int change) {
    HapticFeedback.lightImpact();

    setState(() {
      final current = accounts[selectedIndex].moneyCounts[key]! + change;
      accounts[selectedIndex].moneyCounts[key] = current < 0 ? 0 : current;
    });

    saveData();
  }

  // ================= ACCOUNT MANAGEMENT =================

  void renameAccount(int index) {
    final controller =
    TextEditingController(text: accounts[index].name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Rename Window"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter new name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  accounts[index].name = controller.text.trim();
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
        const SnackBar(
          content: Text("At least one savings window is required."),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Delete Window?"),
        content: const Text(
          "This savings window will be permanently removed.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                accounts.removeAt(index);
                if (selectedIndex >= accounts.length) {
                  selectedIndex = accounts.length - 1;
                }
              });
              saveData();
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void createNewAccount() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("New Savings Window"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  accounts.add(
                    SavingsModel(
                      name: controller.text.trim(),
                      moneyCounts: defaultMoney(),
                    ),
                  );
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Savings Windows",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(accounts.length, (index) {
                return ListTile(
                  title: Text(accounts[index].name),
                  leading: selectedIndex == index
                      ? const Icon(Icons.check_circle, color: Colors.green)
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
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
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
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= COLORS =================

  /// Note colors tuned to look closer to Indian note colors
  Color getMoneyColor(int key) {
    switch (key) {
    // NOTES
      case 500:
      // greenish grey ₹500 note
        return const Color(0xFF6F8A7A);

      case 200:
      // mustard yellow ₹200 note
        return const Color(0xFFE5B93C);

      case 100:
      // lavender ₹100 note
        return const Color(0xFF8666B3);

      case 50:
      // blue ₹50 note
        return const Color(0xFF2EA3DB);

      case 20:
      // yellow-green ₹20 note
        return const Color(0xFF7FB833);

      case 10:
      // brown ₹10 note
        return const Color(0xFF8B4C22);

    // COINS
      case 1020:
      // ₹20 coin - warm golden brass look
        return const Color(0xFFC9A227);

      case 1010:
      // ₹10 coin - bi-metallic feel; using warm gold tone for card
        return const Color(0xFFB68D2C);

      case 5:
      // ₹5 coin - metallic silver
        return const Color(0xFFBFC5CE);

      case 2:
      // ₹2 coin - slightly darker steel silver
        return const Color(0xFFAEB6BF);

      case 1:
      // ₹1 coin - classic silver steel
        return const Color(0xFFD2D7DD);

      default:
        return Colors.white;
    }
  }

  Color getMoneyTextColor(int key) {
    // Dark text on light metallic coins, white on notes/gold coins where needed
    switch (key) {
      case 1020:
      case 1010:
        return Colors.white;

      case 5:
      case 2:
      case 1:
        return const Color(0xFF2D3748);

      default:
        return Colors.white;
    }
  }

  // ================= ORDER =================

  List<int> get displayOrder => [
    500,
    200,
    100,
    50,
    20,
    10,
    1020,
    1010,
    5,
    2,
    1,
  ];

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final moneyMap = accounts[selectedIndex].moneyCounts;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F9FB),
              Color(0xFFEDEFF3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              children: [
                GestureDetector(
                  onTap: showAccountsSheet,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          accounts[selectedIndex].name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.22),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Total Balance",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          "₹ $totalBalance",
                          key: ValueKey(totalBalance),
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08),

                const SizedBox(height: 22),

                Expanded(
                  child: ListView.builder(
                    itemCount: displayOrder.length,
                    itemBuilder: (context, index) {
                      final key = displayOrder[index];
                      final label = getMoneyLabel(key);
                      final count = moneyMap[key] ?? 0;
                      final cardColor = getMoneyColor(key);
                      final textColor = getMoneyTextColor(key);
                      final coin = isCoin(key);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: coin
                              ? Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.1,
                          )
                              : null,
                        ),
                        child: Row(
                          children: [
                            // Left side
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    coin ? "Coin" : "Note",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textColor.withOpacity(0.82),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right controls
                            Row(
                              children: [
                                _circleButton(
                                  icon: Icons.remove,
                                  onTap: () => updateCount(key, -1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.22),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      "$count",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                _circleButton(
                                  icon: Icons.add,
                                  onTap: () => updateCount(key, 1),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 250.ms)
                          .slideY(begin: 0.06);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.92),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }
}
