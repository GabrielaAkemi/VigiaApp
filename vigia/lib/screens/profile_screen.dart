import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_manager.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeManager>();
    bool isDark = themeProvider.themeMode == ThemeMode.dark;
    Color primaryColor = AppColors.getPrimary(context);
    
    // Cor de texto adaptativa para não sumir no fundo claro
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subTextColor = isDark ? Colors.grey : Colors.black54;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent, // Permite ver a logo rosa de fundo
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: const SizedBox.shrink(), 
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
              // Foto de Perfil com Círculo Adaptativo
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(isDark ? 0.4 : 0.2),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: GestureDetector(
                        onTap: () => print("Editar foto"),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: isDark ? Colors.black : Colors.white,
                          child: Icon(Icons.edit, size: 14, color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              NeonCard(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  leading: Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny, 
                    color: primaryColor
                  ),
                  title: Text(
                    isDark ? "Modo Noturno" : "Modo Diurno",
                    style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  trailing: Switch(
                    activeColor: AppColors.lightRed,
                    value: !isDark,
                    onChanged: (value) => context.read<ThemeManager>().toggleTheme(),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              _buildProfileItem("Nome", "Burman Smith", context, canEdit: true),
              _buildProfileItem("Email", "infer@develominates.com", context),
              _buildProfileItem("Ambulância Atribuída", "Ambulância (Rvigo 11/32)", context, 
                  icon: Icons.emergency_outlined),
              
              const SizedBox(height: 10),
              
              NeonCard(
                child: Row(
                  children: [
                    Icon(Icons.airport_shuttle, color: primaryColor, size: 30),
                    const SizedBox(width: 15),
                    Text(
                      "Ambulância 120", 
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(child: _buildStatItem("Rotas Concluídas", "5", context)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildStatItem("Horas Registradas", "12.h", context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, BuildContext context, {bool canEdit = false, IconData? icon}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = AppColors.getPrimary(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              if (canEdit) Icon(Icons.edit_outlined, size: 14, color: primaryColor),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              if (icon != null) Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(icon, size: 18, color: primaryColor),
              ),
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
          Divider(color: primaryColor.withOpacity(0.2), thickness: 1),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return NeonCard(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}