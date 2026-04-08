import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_manager.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userEmail = "infer@develominates.com";

  void _editEmail(BuildContext context, Color primary, bool isDark) {
    TextEditingController controller = TextEditingController(text: userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        title: Text("Editar Email", style: TextStyle(color: primary, fontSize: 18)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            labelText: "Novo Email",
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            onPressed: () {
              setState(() {
                userEmail = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Salvar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeManager>();
    bool isDark = themeProvider.themeMode == ThemeMode.dark;
    Color primaryColor = AppColors.getPrimary(context);
    Color textColor = isDark ? Colors.white : Colors.black;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Perfil do Motorista",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO DE PERFIL
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              NeonCard(
                child: ListTile(
                  leading: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny, color: primaryColor),
                  title: Text(
                    isDark ? "Modo Noturno" : "Modo Diurno",
                    style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  trailing: Switch(
                    value: !isDark,
                    onChanged: (value) => context.read<ThemeManager>().toggleTheme(),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              _buildProfileItem("Nome", "Burman Smith", context, canEdit: false),

              _buildProfileItem(
                "Email",
                userEmail,
                context,
                canEdit: true,
                onEdit: () => _editEmail(context, primaryColor, isDark),
              ),

              _buildProfileItem("Ambulância Atribuída", "Ambulância (Rvigo 11/32)", context,
                  icon: Icons.emergency_outlined),

              const SizedBox(height: 10),

              NeonCard(
                child: Row(
                  children: [
                    Icon(Icons.airport_shuttle, color: primaryColor, size: 30),
                    const SizedBox(width: 15),
                    Text("Ambulância 120", style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(child: _buildStatItem("Rotas Concluídas", "5", context)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildStatItem("Horas Registradas", "12h", context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, BuildContext context,
      {bool canEdit = false, IconData? icon, VoidCallback? onEdit}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = AppColors.getPrimary(context);
    Color labelColor = isDark ? Colors.grey : Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w600)),
              if (canEdit)
                GestureDetector(
                  onTap: onEdit, // Chama a função de abrir o Dialog
                  child: Icon(Icons.edit, size: 20, color: primaryColor),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              if (icon != null) Icon(icon, size: 18, color: primaryColor),
              if (icon != null) const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Divider(color: primaryColor.withValues(alpha: 0.3), thickness: 1),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color labelColor = isDark ? Colors.grey : Colors.black54;
    return NeonCard(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: labelColor, fontSize: 11)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}